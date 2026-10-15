import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/widgets/broker_bottom_navbar.dart';
import 'package:app/utils/routes.dart';

class BrokerProfilePage extends StatefulWidget {
  const BrokerProfilePage({super.key});

  @override
  State<BrokerProfilePage> createState() => _BrokerProfilePageState();
}

class _BrokerProfilePageState extends State<BrokerProfilePage> {
  // Ye sab Firebase se aayega
  String brokerName = "-";
  String email = "-";
  String phone = "-";
  String company = "-";
  String experience = "-";
  String city = "-";
  String license = "-";
  String verification = "-";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ==================== FIREBASE ====================

  // Firebase se broker ka data lao
  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();

      if (data == null || !mounted) return;

      final exp = (data['experience'] ?? '').toString();
      final licenseNumber = (data['licenseNumber'] ?? '').toString();

      setState(() {
        brokerName = (data['name'] ?? '-').toString();
        email = (data['email'] ?? user.email ?? '-').toString();
        phone = (data['phone'] ?? '-').toString();
        company = (data['agency'] ?? '-').toString();
        city = (data['city'] ?? data['location'] ?? '-').toString();
        verification = (data['verification'] ?? 'Approved').toString();

        // Experience me sirf number hai to "Years" laga do
        experience = exp.isEmpty ? '-' : '$exp Years';

        // License number nahi diya to Broker ID dikhao
        license = licenseNumber.isNotEmpty
            ? licenseNumber
            : (data['brokerId'] ?? '-').toString();
      });
    } catch (_) {
      // Error aaye to "-" hi dikhega
    }
  }

  // Edit Profile ka data Firebase me save karo
  Future<void> _saveProfile({
    required String name,
    required String newPhone,
    required String newCompany,
    required String newCity,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          'name': name,
          'phone': newPhone,
          'agency': newCompany,
          'city': newCity,
        },
      );

      if (!mounted) return;

      setState(() {
        brokerName = name;
        phone = newPhone;
        company = newCompany;
        city = newCity;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Unable to update profile")));
    }
  }

  // Naam se initials banao (Bhargav Patel -> BP)
  String get initials {
    final parts = brokerName.trim().split(' ');

    if (brokerName == '-' || parts.isEmpty || parts[0].isEmpty) {
      return "B";
    }

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Professional Information"),
                    const SizedBox(height: 10),
                    _buildProfessionalCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Account"),
                    const SizedBox(height: 10),
                    _buildAccountCard(),
                    const SizedBox(height: 20),
                    _buildSectionTitle("Support"),
                    const SizedBox(height: 10),
                    _buildSupportCard(),
                    const SizedBox(height: 20),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BrokerBottomNavbar(selectedIndex: 4),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Manage your broker account",
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 76,
                width: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              brokerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Icon(
                            Icons.verified,
                            color: AppColors.success,
                            size: 19,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Professional Broker",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: AppColors.success,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Verified Broker",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),
          _buildContactRow(Icons.email_outlined, email),
          const SizedBox(height: 12),
          _buildContactRow(Icons.phone_outlined, phone),
          const SizedBox(height: 12),
          _buildContactRow(Icons.location_on_outlined, city),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildProfessionalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.business_outlined, "Company", company),
          _buildDivider(),
          _buildInfoRow(Icons.work_outline_rounded, "Experience", experience),
          _buildDivider(),
          _buildInfoRow(Icons.location_city_outlined, "City", city),
          _buildDivider(),
          _buildInfoRow(Icons.badge_outlined, "Broker License", license),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 19, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.divider);
  }

  Widget _buildAccountCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.edit_outlined,
            title: "Edit Profile",
            subtitle: "Update your personal information",
            onTap: showEditProfile,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.verified_user_outlined,
            title: "Verification Details",
            subtitle: "View your broker verification information",
            iconColor: AppColors.success,
            onTap: showVerificationDetails,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.lock_outline_rounded,
            title: "Change Password",
            subtitle: "Update your account password",
            onTap: showChangePassword,
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Manage notification preferences",
            onTap: showNotifications,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            title: "Help & Support",
            subtitle: "Get help with your account",
            onTap: showHelpSupport,
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.info_outline_rounded,
            title: "About EstateX",
            subtitle: "App information and version",
            onTap: showAboutEstateX,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: showLogoutDialog,
        icon: const Icon(
          Icons.logout_rounded,
          size: 19,
          color: AppColors.error,
        ),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  void showEditProfile() {
    final nameController = TextEditingController(text: brokerName);
    final phoneController = TextEditingController(text: phone);
    final companyController = TextEditingController(text: company);
    final cityController = TextEditingController(text: city);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHandle(),
                  const SizedBox(height: 18),
                  const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    controller: phoneController,
                    label: "Phone",
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    controller: companyController,
                    label: "Company",
                    icon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    controller: cityController,
                    label: "City",
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Firebase me save karo
                        _saveProfile(
                          name: nameController.text.trim(),
                          newPhone: phoneController.text.trim(),
                          newCompany: companyController.text.trim(),
                          newCity: cityController.text.trim(),
                        );

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );
  }

  void showVerificationDetails() {
    final isApproved = verification == "Approved";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHandle(),
                  const SizedBox(height: 20),
                  const Text(
                    "Verification Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildInfoRow(
                    Icons.verified_outlined,
                    "Verification Status",
                    isApproved ? "Verified" : verification,
                    valueColor: isApproved
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  _buildInfoRow(
                    Icons.badge_outlined,
                    "Broker License",
                    license,
                  ),
                  _buildInfoRow(Icons.business_outlined, "Company", company),
                  _buildInfoRow(
                    Icons.work_outline_rounded,
                    "Experience",
                    experience,
                  ),
                  _buildInfoRow(Icons.location_on_outlined, "City", city),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.success,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Your broker account and submitted documents have been verified.",
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showChangePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSheetHandle(),
                  const SizedBox(height: 18),
                  const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: currentPasswordController,
                    label: "Current Password",
                    icon: Icons.lock_outline_rounded,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    controller: newPasswordController,
                    label: "New Password",
                    icon: Icons.lock_reset_outlined,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    icon: Icons.lock_reset_outlined,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (newPasswordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter all password fields"),
                            ),
                          );
                          return;
                        }

                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context);

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text("Password updated successfully"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Update Password",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 18),
                const Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildSwitchTile(
                  "Visit Requests",
                  "Get notified about new visit requests",
                  true,
                ),
                _buildSwitchTile(
                  "Buyer Messages",
                  "Get notified when buyers contact you",
                  true,
                ),
                _buildSwitchTile(
                  "Follow-up Reminders",
                  "Receive reminders for pending follow-ups",
                  true,
                ),
                _buildSwitchTile(
                  "Deal Updates",
                  "Get updates about your active deals",
                  true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool enabled = value;

        return StatefulBuilder(
          builder: (context, innerSetState) {
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              value: enabled,
              activeThumbColor: AppColors.primary,
              onChanged: (newValue) {
                innerSetState(() {
                  enabled = newValue;
                });
              },
            );
          },
        );
      },
    );
  }

  void showHelpSupport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSheetHandle(),
                const SizedBox(height: 18),
                const Text(
                  "Help & Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                _buildSupportOption(
                  Icons.help_outline_rounded,
                  "Frequently Asked Questions",
                  "Find answers to common questions",
                ),
                _buildSupportOption(
                  Icons.chat_bubble_outline_rounded,
                  "Contact Support",
                  "Talk to EstateX support team",
                ),
                _buildSupportOption(
                  Icons.report_problem_outlined,
                  "Report a Problem",
                  "Tell us about an issue",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSupportOption(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$title selected")));
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: AppColors.primary, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void showAboutEstateX() {
    showAboutDialog(
      context: context,
      applicationName: "EstateX",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.home_work_outlined, color: AppColors.primary),
      ),
      children: const [
        Text(
          "EstateX is a real-estate platform designed to help brokers manage properties, buyers, visits and deals from one place.",
        ),
      ],
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            "Are you sure you want to logout from your broker account?",
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                // Firebase se sign out
                await FirebaseAuth.instance.signOut();

                navigator.pushNamedAndRemoveUntil(
                  MyRoutes.loginRoute,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
