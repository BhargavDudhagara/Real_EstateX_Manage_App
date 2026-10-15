import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  bool changeButton = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      changeButton = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset successfully")),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      MyRoutes.loginRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Reset Password"),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 45),

                Center(
                  child: Container(
                    height: 90,
                    width: 90,

                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.password,
                      size: 45,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Create a new password for your account.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                // New Password
                TextFormField(
                  controller: passwordController,

                  obscureText: isPasswordHidden,

                  decoration: InputDecoration(
                    labelText: "New Password",
                    hintText: "Enter new password",

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

                    contentPadding: const EdgeInsets.symmetric(vertical: 15),

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

                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // Confirm Password
                TextFormField(
                  controller: confirmPasswordController,

                  obscureText: isConfirmPasswordHidden,

                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Re-enter your password",

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordHidden = !isConfirmPasswordHidden;
                        });
                      },

                      icon: Icon(
                        isConfirmPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 15),

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
                      return "Please confirm your password";
                    }

                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // Reset Password Button
                Align(
                  alignment: Alignment.center,

                  child: Material(
                    color: AppColors.primary,

                    borderRadius: BorderRadius.circular(changeButton ? 28 : 12),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        changeButton ? 28 : 12,
                      ),

                      splashColor: AppColors.white.withValues(alpha: 0.25),

                      onTap: () {
                        resetPassword();
                      },

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),

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
                                "Reset Password",
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

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
