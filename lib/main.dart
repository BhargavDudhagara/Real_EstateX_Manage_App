// ==================== Flutter ====================

import 'package:app/pages/Welcome_page.dart';
import 'package:flutter/material.dart';

// ==================== Firebase ====================

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// ==================== Theme ====================

import 'package:app/theme/app_theme.dart';

// ==================== Routes ====================

import 'package:app/utils/routes.dart';

// ==================== Login & Authentication ====================

import 'package:app/Login/login_page.dart';
import 'package:app/Login/register_page.dart';
import 'package:app/Login/forgot_password_page.dart';
import 'package:app/Login/reset_password_page.dart';

// ==================== Broker Registration ====================

import 'package:app/Login/broker_verification_page.dart';
import 'package:app/Login/broker_pending_page.dart';
import 'package:app/Login/broker_payment_page.dart';

// ==================== Buyer ====================

import 'package:app/pages/Buyer_home_page.dart';
import 'package:app/pages/search_page.dart';
import 'package:app/pages/wishlist_page.dart';
import 'package:app/pages/visit_page.dart';
import 'package:app/pages/splash_screen.dart';

// ==================== Buyer Property & Features ====================

import 'package:app/pages/calculator_page.dart';
import 'package:app/pages/nearby_property_page.dart';
import 'package:app/pages/price_comparison.dart';

// ==================== Buyer Deal ====================

import 'package:app/pages/buyer_deal_request_page.dart';
import 'package:app/pages/buyer_deal_payment_page.dart';
import 'package:app/pages/buyer_deal_documents_page.dart';

// ==================== Buyer Profile ====================

import 'package:app/pages/Profile/profile_page.dart' as profile;
import 'package:app/pages/Profile/change_password_page.dart';
import 'package:app/pages/Profile/notification_page.dart';
import 'package:app/pages/Profile/help_support_page.dart';
import 'package:app/pages/Profile/privacy_policy_page.dart';
import 'package:app/pages/Profile/about_page.dart';

// ==================== Broker ====================

import 'package:app/Broker/Broker_home_page.dart';
import 'package:app/Broker/broker_profile_page.dart';

// ==================== Broker Properties ====================

import 'package:app/Broker/Properties/broker_properties_page.dart';
import 'package:app/Broker/Properties/add_property_page.dart';
import 'package:app/Broker/Properties/property_details_page.dart';

// ==================== Broker Buyers / Deals ====================

import 'package:app/Broker/Buyers/broker_buyers_page.dart';
import 'package:app/Broker/Buyers/broker_deal_requests_page.dart';
import 'package:app/Broker/Buyers/broker_deal_details_page.dart';
import 'package:app/Broker/Buyers/broker_document_verification_page.dart';

// ==================== Broker Visits ====================

import 'package:app/Broker/Visit/broker_visits_page.dart';
import 'package:app/Broker/Visit/visit_details_page.dart';
import 'package:app/Broker/Visit/broker_calendar_page.dart';

// ==================== Admin ====================

import 'package:app/admin/admin_home_page.dart';
import 'package:app/admin/admin_users_page.dart';
import 'package:app/admin/admin_brokers_page.dart';
import 'package:app/admin/admin_properties_page.dart';
import 'package:app/admin/admin_profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,

      // App ab Splash Screen se start hoga
      home: const SplashScreen(),

      routes: {
        MyRoutes.buyerHomeRoute: (context) => BuyerHomePage(),
        MyRoutes.brokerHomeRoute: (context) => const BrokerHomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.registerRoute: (context) => RegisterPage(),
        MyRoutes.forgotPasswordRoute: (context) => const ForgotPasswordPage(),
        MyRoutes.resetPasswordRoute: (context) => const ResetPasswordPage(),
        MyRoutes.searchRoute: (context) => const SearchPage(),
        MyRoutes.wishlistRoute: (context) => const WishlistPage(),
        MyRoutes.visitsRoute: (context) => const VisitsPage(),
        MyRoutes.profileRoute: (context) => const profile.ProfilePage(),
        MyRoutes.brokerVerificationRoute: (context) =>
            const BrokerVerificationPage(),
        MyRoutes.brokerPendingRoute: (context) => const BrokerPendingPage(),
        MyRoutes.brokerPaymentRoute: (context) => const BrokerPaymentPage(),
        MyRoutes.changePasswordRoute: (context) => const ChangePasswordPage(),
        MyRoutes.helpSupportRoute: (context) => const HelpSupportPage(),
        MyRoutes.aboutRoute: (context) => const AboutPage(),
        MyRoutes.privacyPolicyRoute: (context) => const PrivacyPolicyPage(),
        MyRoutes.notificationRoute: (context) => const NotificationPage(),
        MyRoutes.buyerDealRequestRoute: (context) =>
            const BuyerDealRequestPage(),
        MyRoutes.buyerDealDocumentsRoute: (context) =>
            const BuyerDealDocumentsPage(),
        MyRoutes.buyerDealPaymentRoute: (context) =>
            const BuyerDealPaymentPage(),
        MyRoutes.priceComparisonRoute: (context) => const PriceComparisonPage(),
        MyRoutes.nearbyPropertyRoute: (context) => const NearbyPropertyPage(),
        MyRoutes.calculatorRoute: (context) => const CalculatorPage(),
        MyRoutes.propertyDetailRoute: (context) => const PropertyDetailsPage(),
        MyRoutes.splashRoute: (context) => const SplashScreen(),
        MyRoutes.welcomeRoute: (context) => const WelcomePage(),

        // Admin
        MyRoutes.adminHomeRoute: (context) => const AdminHomePage(),
        MyRoutes.adminUsersRoute: (context) => const AdminUsersPage(),
        MyRoutes.adminBrokersRoute: (context) => const AdminBrokersPage(),
        MyRoutes.adminPropertiesRoute: (context) => const AdminPropertiesPage(),
        MyRoutes.adminProfileRoute: (context) => const AdminProfilePage(),

        // Broker
        MyRoutes.brokerPropertiesRoute: (context) =>
            const BrokerPropertiesPage(),
        MyRoutes.addPropertyRoute: (context) => const AddPropertyPage(),
        MyRoutes.propertyDetailsRoute: (context) => const PropertyDetailsPage(),

        // Visit
        MyRoutes.brokerVisitsRoute: (context) => const BrokerVisitsPage(),
        MyRoutes.visitDetailsRoute: (context) => const VisitDetailsPage(),
        MyRoutes.brokerCalendarRoute: (context) => const BrokerCalendarPage(),

        // Broker Buyer
        MyRoutes.brokerBuyersRoute: (context) => const BrokerBuyersPage(),
        MyRoutes.brokerDealRequestsRoute: (context) =>
            const BrokerDealRequestsPage(),
        MyRoutes.brokerDealDetailsRoute: (context) =>
            const BrokerDealDetailsPage(),
        MyRoutes.brokerDocumentVerificationRoute: (context) =>
            const BrokerDocumentVerificationPage(),
        MyRoutes.brokerProfileRoute: (context) => const BrokerProfilePage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<Widget> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginPage();
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();

        final role = data?['role'];

        if (role == 'Broker') {
          return const BrokerHomePage();
        }

        return BuyerHomePage();
      }

      return BuyerHomePage();
    } catch (e) {
      return BuyerHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return snapshot.data!;
        }

        return const LoginPage();
      },
    );
  }
}
