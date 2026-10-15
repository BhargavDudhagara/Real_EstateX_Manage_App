import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  bool changeButton = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void sendResetLink() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      changeButton = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    await Navigator.pushNamed(
      context,
      MyRoutes.resetPasswordRoute,
      arguments: emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      changeButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Forgot Password"),
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
                      Icons.lock_reset,
                      size: 45,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter your email address and we will help you reset your password.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

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

                    String email = value.trim();

                    bool validEmail = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(email);

                    if (!validEmail) {
                      return "Please enter a valid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 35),

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
                        sendResetLink();
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
                                "Continue",
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

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MyRoutes.loginRoute,
                      );
                    },

                    child: const Text(
                      "Back to Login",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
