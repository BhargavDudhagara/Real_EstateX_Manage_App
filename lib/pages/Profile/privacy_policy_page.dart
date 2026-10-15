import 'package:app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.privacy_tip_rounded,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Last Updated: January 2024',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              icon: Icons.info_rounded,
              title: 'Introduction',
              content:
                  'EstateX ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information when you use our mobile application.',
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.data_usage_rounded,
              title: 'Information We Collect',
              content:
                  'We collect the following types of information:\n\n• Personal Information: Name, email address, phone number, and location\n• Account Information: Username, password, and profile details\n• Usage Data: App usage patterns, features accessed, and time spent\n• Device Information: Device type, operating system, and unique identifiers\n• Communication Data: Messages sent to brokers and support team',
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.settings_rounded,
              title: 'How We Use Your Information',
              content:
                  'We use your information to:\n\n• Provide and improve our services\n• Process property visit bookings\n• Connect you with verified brokers\n• Send important notifications and updates\n• Respond to your inquiries and support requests\n• Analyze usage patterns to enhance user experience\n• Prevent fraud and ensure platform security',
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.share_rounded,
              title: 'Information Sharing',
              content:
                  'We may share your information with:\n\n• Verified Brokers: To facilitate property visits and communications\n• Service Providers: For app maintenance and analytics\n• Legal Authorities: When required by law or to protect our rights\n\nWe do not sell your personal information to third parties.',
              color: AppColors.warning,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.security_rounded,
              title: 'Data Security',
              content:
                  'We implement industry-standard security measures to protect your data:\n\n• Encryption of sensitive data in transit and at rest\n• Secure authentication and access controls\n• Regular security audits and updates\n• Limited access to personal information',
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.gavel_rounded,
              title: 'Your Rights',
              content:
                  'You have the right to:\n\n• Access your personal information\n• Update or correct your information\n• Delete your account and associated data\n• Opt-out of marketing communications\n• Request a copy of your data',
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.cookie_rounded,
              title: 'Cookies and Tracking',
              content:
                  'We use cookies and similar technologies to:\n\n• Remember your preferences\n• Analyze app performance\n• Provide personalized content\n\nYou can manage cookie settings through your device preferences.',
              color: AppColors.success,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.extension_rounded,
              title: 'Third-Party Services',
              content:
                  'Our app may integrate with third-party services for:\n\n• Analytics and performance monitoring\n• Push notifications\n• Maps and location services\n\nThese services have their own privacy policies.',
              color: AppColors.warning,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.child_care_rounded,
              title: 'Children\'s Privacy',
              content:
                  'Our services are not intended for children under 13. We do not knowingly collect personal information from children. If we become aware of such collection, we will take steps to delete it.',
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.update_rounded,
              title: 'Changes to This Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of significant changes by:\n\n• In-app notifications\n• Email communications\n• Updated policy date',
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            _buildSection(
              icon: Icons.contact_mail_rounded,
              title: 'Contact Us',
              content:
                  'If you have questions about this Privacy Policy or your personal information, please contact us at:\n\n• Email: privacy@estatex.com\n• Phone: +91 98765 43210\n• Address: Rajkot, Gujarat, India',
              color: AppColors.success,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primary.withValues(alpha: 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'By using EstateX, you agree to the terms of this Privacy Policy.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.15),
                      color.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
