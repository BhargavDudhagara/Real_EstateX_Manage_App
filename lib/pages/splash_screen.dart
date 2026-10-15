import 'dart:async';

import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Golden accent (#D4A72C)
  static const Color _gold = Color(0xFFD4A72C);

  // Intro animations (logo, name, tagline etc.) ka time
  static const int _introMs = 2550;

  // Loading line ka total time = 1 sec (thodi aage) + 3 sec (puri) = 4 sec
  static const int _totalMs = 4000;

  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;

  late final Animation<double> _bgFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _nameFade;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _underline;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _bottomFade;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    // Intro animation
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _introMs),
    );

    // Logo ke peeche halka pulse ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Loading line controller (4 second)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );

    _bgFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.50, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
    );

    _nameFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.30, 0.55, curve: Curves.easeOut),
    );

    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.30, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _underline = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.50, 0.72, curve: Curves.easeOutCubic),
    );

    _taglineFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.45, 0.70, curve: Curves.easeOut),
    );

    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.45, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _bottomFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.60, 0.85, curve: Curves.easeOut),
    );

    // Loading line:
    // pehle 1 sec me sirf 15% aage, phir agle 3 sec me puri (100%)
    _progress = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 25, // 1 second
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 75, // 3 second
      ),
    ]).animate(_progressController);

    _introController.forward();
    _startApp();
  }

  // ==================== NAVIGATION ====================

  Future<void> _startApp() async {
    final nextRoute = _getNextRoute();

    // Line puri hone (4 sec) aur route ready hone dono ka wait
    await Future.wait<dynamic>([_progressController.forward(), nextRoute]);

    if (!mounted) return;

    final route = await nextRoute;

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, route);
  }

  /// Splash ke baad kaunsa page khulega ye decide karta hai
  Future<String> _getNextRoute() async {
    final user = FirebaseAuth.instance.currentUser;

    // Login nahi hai -> Login page
    if (user == null) {
      return MyRoutes.loginRoute;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = userDoc.data();
      final role = (data?['role'] ?? '').toString().toLowerCase();

      if (role == 'broker') {
        final verification = (data?['verification'] ?? 'Approved').toString();
        final account = (data?['account'] ?? 'Active').toString();

        if (verification == 'Rejected' || account == 'Blocked') {
          await FirebaseAuth.instance.signOut();
          return MyRoutes.loginRoute;
        }

        if (verification == 'Approved') {
          return MyRoutes.brokerHomeRoute;
        }

        if (verification == 'Needs Review') {
          return MyRoutes.brokerPendingRoute;
        }

        // Incomplete ya Changes Requested
        return MyRoutes.brokerVerificationRoute;
      }

      return MyRoutes.buyerHomeRoute;
    } catch (_) {
      // Purane AuthCheck jaisa behavior: error pe Buyer Home
      return MyRoutes.buyerHomeRoute;
    }
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ==================== BACKGROUND SHAPES ====================
          Positioned(
            top: -80,
            right: -70,
            child: FadeTransition(opacity: _bgFade, child: _circle(220, 0.06)),
          ),
          Positioned(
            top: 140,
            left: -90,
            child: FadeTransition(opacity: _bgFade, child: _circle(160, 0.05)),
          ),
          Positioned(
            bottom: -90,
            left: -50,
            child: FadeTransition(opacity: _bgFade, child: _circle(240, 0.06)),
          ),
          Positioned(
            bottom: 120,
            right: -60,
            child: FadeTransition(opacity: _bgFade, child: _circle(130, 0.05)),
          ),

          // ==================== MAIN CONTENT ====================
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ==================== LOGO ====================
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse ring
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final t = _pulseController.value;
                            return Opacity(
                              opacity: (1 - t) * 0.35,
                              child: Container(
                                width: 110 + (60 * t),
                                height: 110 + (60 * t),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Logo circle
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Image.asset(
                                  'assets/Estate.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================== APP NAME ====================
                  FadeTransition(
                    opacity: _nameFade,
                    child: SlideTransition(
                      position: _nameSlide,
                      child: const Text(
                        "EstateX",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ==================== GOLDEN UNDERLINE ====================
                  AnimatedBuilder(
                    animation: _underline,
                    builder: (context, child) {
                      return Container(
                        width: 56 * _underline.value,
                        height: 3,
                        decoration: BoxDecoration(
                          color: _gold,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // ==================== TAGLINE ====================
                  FadeTransition(
                    opacity: _taglineFade,
                    child: SlideTransition(
                      position: _taglineSlide,
                      child: const Text(
                        "Find Your Dream Property",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ==================== LOADING LINE ====================
                  FadeTransition(
                    opacity: _taglineFade,
                    child: SizedBox(
                      width: 120,
                      child: AnimatedBuilder(
                        animation: _progress,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _progress.value,
                              minHeight: 4,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ==================== BOTTOM TEXT ====================
      bottomNavigationBar: FadeTransition(
        opacity: _bottomFade,
        child: const Padding(
          padding: EdgeInsets.only(bottom: 24),
          child: Text(
            "Real Estate Made Simple",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // Halka teal background circle
  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: opacity),
      ),
    );
  }
}
