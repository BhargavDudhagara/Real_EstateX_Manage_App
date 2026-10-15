import 'package:app/utils/routes.dart';
import 'package:app/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool changeButton = false;
  bool isPasswordHidden = true;

  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    setState(() {
      changeButton = true;
    });

    try {
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      // Fixed Admin Login
      if (email == "admin@gmail.com" && password == "admin") {
        if (!mounted) return;

        setState(() {
          changeButton = false;
        });

        Navigator.pushReplacementNamed(context, MyRoutes.adminHomeRoute);

        return;
      }

      // Firebase Login for Buyer / Broker
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: "user-not-found",
          message: "Unable to login.",
        );
      }

      // Get registered user data
      final userDocument = await _firestore
          .collection("users")
          .doc(user.uid)
          .get();

      if (!mounted) return;

      setState(() {
        changeButton = false;
      });

      if (!userDocument.exists) {
        await _auth.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User information not found.")),
        );

        return;
      }

      final data = userDocument.data();

      final role = data?["role"]?.toString() ?? "Buyer";

      // Buyer Login
      if (role == "Buyer") {
        Navigator.pushReplacementNamed(
          context,
          MyRoutes.buyerHomeRoute,
          arguments: email,
        );
      }
      // Broker Login
      else if (role == "Broker") {
        final verification = data?["verification"]?.toString() ?? "Approved";
        final account = data?["account"]?.toString() ?? "Active";
        final adminNote = data?["adminNote"]?.toString() ?? "";

        // Rejected ya Blocked broker login nahi kar sakta
        if (verification == "Rejected" || account == "Blocked") {
          await _auth.signOut();

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                verification == "Rejected"
                    ? "Your broker application was rejected."
                    : "Your account has been blocked.",
              ),
            ),
          );

          return;
        }

        // Approved -> Broker Home
        if (verification == "Approved") {
          Navigator.pushReplacementNamed(
            context,
            MyRoutes.brokerHomeRoute,
            arguments: email,
          );
        }
        // Register hua par verification/payment baaki
        else if (verification == "Incomplete") {
          Navigator.pushReplacementNamed(
            context,
            MyRoutes.brokerVerificationRoute,
          );
        }
        // Admin ne correction maangi
        else if (verification == "Changes Requested") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                adminNote.isEmpty
                    ? "Admin requested changes. Please update your details."
                    : "Admin requested changes: $adminNote",
              ),
            ),
          );

          Navigator.pushReplacementNamed(
            context,
            MyRoutes.brokerVerificationRoute,
          );
        }
        // Needs Review -> Pending page
        else {
          Navigator.pushReplacementNamed(context, MyRoutes.brokerPendingRoute);
        }
      }
      // Invalid Role
      else {
        await _auth.signOut();

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid user role.")));
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        changeButton = false;
      });

      String message = "Login failed.";

      if (e.code == "user-not-found") {
        message = "No account found with this email.";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password.";
      } else if (e.code == "invalid-credential") {
        message = "Incorrect email or password.";
      } else if (e.code == "invalid-email") {
        message = "Please enter a valid email.";
      } else if (e.code == "user-disabled") {
        message = "This account has been disabled.";
      } else if (e.code == "network-request-failed") {
        message = "Please check your internet connection.";
      } else if (e.message != null && e.message!.isNotEmpty) {
        message = e.message!;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      setState(() {
        changeButton = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 270,
                  child: Image.asset("assets/login.png", fit: BoxFit.cover),
                ),

                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Login to continue exploring your dream property.",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.primary,
                          ),
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.border,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your email";
                          }

                          if (!value.contains("@") || !value.contains(".")) {
                            return "Please enter a valid email";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 25),

                      TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.primary,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                            icon: Icon(
                              isPasswordHidden
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.border,
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              MyRoutes.forgotPasswordRoute,
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Align(
                        alignment: Alignment.center,
                        child: Material(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            changeButton ? 28 : 12,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              changeButton ? 28 : 12,
                            ),
                            splashColor: AppColors.white.withValues(
                              alpha: 0.25,
                            ),
                            onTap: changeButton ? null : loginUser,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 700),
                              alignment: Alignment.center,
                              width: changeButton
                                  ? 54
                                  : MediaQuery.of(context).size.width - 56,
                              height: 54,
                              child: changeButton
                                  ? const Icon(
                                      Icons.done,
                                      color: AppColors.white,
                                      size: 25,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                MyRoutes.registerRoute,
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
