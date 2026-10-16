import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/bottom_navbar.dart' as bottom_nav;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Last saved values (used to restore fields if user closes without saving)
  String _savedName = '';
  String _savedPhone = '';
  String _savedLocation = '';

  bool _isSaving = false;
  String? _editError;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();

        if (mounted) {
          setState(() {
            nameController.text = data?['name'] ?? '';
            emailController.text = data?['email'] ?? '';
            phoneController.text = data?['phone'] ?? '';
            locationController.text = data?['location'] ?? '';

            _savedName = nameController.text;
            _savedPhone = phoneController.text;
            _savedLocation = locationController.text;
          });
        }
      }
    } catch (e) {
      // Profile data fetch functionality is kept as it is.
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  // ==================== SAVE PROFILE ====================

  Future<void> _saveProfile(
    BuildContext sheetContext,
    void Function(void Function()) setSheetState,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      setSheetState(() {
        _editError = 'Session expired. Please login again.';
      });
      return;
    }

    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();
    final String location = locationController.text.trim();

    if (name.isEmpty) {
      setSheetState(() {
        _editError = 'Full name cannot be empty.';
      });
      return;
    }

    if (phone.isNotEmpty && phone.length < 10) {
      setSheetState(() {
        _editError = 'Please enter a valid phone number.';
      });
      return;
    }

    setSheetState(() {
      _isSaving = true;
      _editError = null;
    });

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'location': location,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _savedName = name;
      _savedPhone = phone;
      _savedLocation = location;
      _isSaving = false;

      if (!mounted) return;

      // Refresh profile header with the new values
      setState(() {});

      if (sheetContext.mounted) {
        Navigator.pop(sheetContext);
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setSheetState(() {
        _isSaving = false;
        _editError = 'Could not update profile. Please try again.';
      });
    }
  }

  void _restoreSavedValues() {
    nameController.text = _savedName;
    phoneController.text = _savedPhone;
    locationController.text = _savedLocation;
    _isSaving = false;
    _editError = null;
  }

  // ==================== EDIT PROFILE ====================

  void showEditProfileDialog() {
    _restoreSavedValues();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.78,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      children: [
                        Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Profile Details',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: _isSaving
                                  ? null
                                  : () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded),
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),

                                // ==================== PROFILE IMAGE ====================
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 92,
                                      height: 92,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.08,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.15,
                                          ),
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/Bhargav.png',
                                          width: 76,
                                          height: 76,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 28),

                                // ==================== NAME ====================
                                _buildEditField(
                                  controller: nameController,
                                  label: 'Full Name',
                                  icon: Icons.person_outline_rounded,
                                  keyboardType: TextInputType.name,
                                ),

                                const SizedBox(height: 18),

                                // ==================== EMAIL (READ ONLY) ====================
                                _buildEditField(
                                  controller: emailController,
                                  label: 'Email Address',
                                  icon: Icons.email_outlined,
                                  readOnly: true,
                                ),

                                const SizedBox(height: 6),

                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email cannot be changed here.',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // ==================== PHONE ====================
                                _buildEditField(
                                  controller: phoneController,
                                  label: 'Phone Number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),

                                const SizedBox(height: 18),

                                // ==================== LOCATION ====================
                                _buildEditField(
                                  controller: locationController,
                                  label: 'Location',
                                  icon: Icons.location_on_outlined,
                                  keyboardType: TextInputType.streetAddress,
                                ),

                                const SizedBox(height: 22),

                                if (_editError != null) ...[
                                  Text(
                                    _editError!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],

                                // ==================== SAVE BUTTON ====================
                                SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _isSaving
                                        ? null
                                        : () => _saveProfile(
                                            sheetContext,
                                            setSheetState,
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: AppColors.border,
                                      disabledForegroundColor:
                                          AppColors.textSecondary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: _isSaving
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : const Text(
                                            'Save Changes',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      // If the sheet was closed without saving, bring back the saved values
      if (!mounted) return;
      setState(() {
        _restoreSavedValues();
      });
    });
  }

  // ==================== PROFILE FIELD ====================

  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: TextStyle(
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: readOnly ? AppColors.border : AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== LOGOUT ====================

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Are you sure you want to logout from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();

                        Navigator.pop(context);

                        Navigator.pushReplacementNamed(
                          context,
                          MyRoutes.loginRoute,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          // ==================== CALCULATOR BUTTON ====================

          /*
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                MyRoutes.calculatorRoute,
              );
            },
            icon: const Icon(
              Icons.calculate_outlined,
              color: AppColors.textPrimary,
            ),
          ),
          */

          // ==================== NOTIFICATION BUTTON ====================
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutes.notificationRoute);
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 6),
        ],
      ),

      // ==================== BODY ====================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),

            const SizedBox(height: 22),

            _buildStats(),

            const SizedBox(height: 28),

            _buildSectionTitle('Account'),

            const SizedBox(height: 10),

            _buildMenuCard(
              icon: Icons.person_outline_rounded,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: showEditProfileDialog,
            ),

            _buildMenuCard(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.changePasswordRoute);
              },
            ),

            _buildMenuCard(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.notificationRoute);
              },
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Support & Information'),

            const SizedBox(height: 10),

            _buildMenuCard(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'Get help with your EstateX account',
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.helpSupportRoute);
              },
            ),

            _buildMenuCard(
              icon: Icons.info_outline_rounded,
              title: 'About EstateX',
              subtitle: 'Learn more about EstateX',
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.aboutRoute);
              },
            ),

            _buildMenuCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Understand how your data is used',
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.privacyPolicyRoute);
              },
            ),

            const SizedBox(height: 24),

            _buildLogoutButton(),
          ],
        ),
      ),

      bottomNavigationBar: const bottom_nav.BottomNavbar(),
    );
  }

  // ==================== PROFILE HEADER ====================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Bhargav.png',
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 3),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  emailController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 9),

                const Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 15,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Verified Buyer',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: showEditProfileDialog,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  // ==================== STATS ====================

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              value: '4',
              label: 'Wishlist',
              icon: Icons.favorite_border_rounded,
            ),
          ),

          _buildStatDivider(),

          Expanded(
            child: _buildStatItem(
              value: '1',
              label: 'Visits',
              icon: Icons.calendar_month_outlined,
            ),
          ),

          _buildStatDivider(),

          Expanded(
            child: _buildStatItem(
              value: '12',
              label: 'Viewed',
              icon: Icons.visibility_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 21),

        const SizedBox(height: 7),

        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 42, color: AppColors.border);
  }

  // ==================== SECTION TITLE ====================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ==================== MENU CARD ====================

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 21),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
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
        ),
      ),
    );
  }

  // ==================== LOGOUT BUTTON ====================

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: showLogoutDialog,
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.25)),
          backgroundColor: AppColors.error.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
