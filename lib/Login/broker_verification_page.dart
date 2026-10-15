import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BrokerVerificationPage extends StatefulWidget {
  const BrokerVerificationPage({super.key});

  @override
  State<BrokerVerificationPage> createState() => _BrokerVerificationPageState();
}

class _BrokerVerificationPageState extends State<BrokerVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  final companyController = TextEditingController();
  final experienceController = TextEditingController();
  final cityController = TextEditingController();
  final licenseController = TextEditingController();

  bool governmentIdUploaded = false;
  bool addressProofUploaded = false;
  bool companyProofUploaded = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    companyController.dispose();
    experienceController.dispose();
    cityController.dispose();
    licenseController.dispose();
    super.dispose();
  }

  // Register me bhara hua data yahan pehle se dikhao
  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snap.data();

      if (data == null || !mounted) return;

      companyController.text = (data['agency'] ?? '').toString();
      experienceController.text = (data['experience'] ?? '').toString();
      cityController.text = (data['city'] ?? data['location'] ?? '').toString();
      licenseController.text = (data['licenseNumber'] ?? '').toString();
    } catch (_) {
      // Prefill fail ho to koi dikkat nahi, user khud bhar lega
    }
  }

  String _today() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');

    return '$day ${months[now.month - 1]} ${now.year}';
  }

  InputDecoration fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: AppColors.surface,
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  Widget documentBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool uploaded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: uploaded ? AppColors.success : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    uploaded ? "Document uploaded" : subtitle,
                    style: TextStyle(
                      color: uploaded
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              uploaded ? Icons.check_circle : Icons.upload_file_outlined,
              color: uploaded ? AppColors.success : AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void uploadDocument(String documentType) {
    setState(() {
      if (documentType == "Government ID") {
        governmentIdUploaded = true;
      } else if (documentType == "Address Proof") {
        addressProofUploaded = true;
      } else if (documentType == "Company Proof") {
        companyProofUploaded = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$documentType uploaded successfully")),
    );
  }

  Future<void> continueToPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!governmentIdUploaded ||
        !addressProofUploaded ||
        !companyProofUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session expired. Please login again.")),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        MyRoutes.loginRoute,
        (route) => false,
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final today = _today();
      final license = licenseController.text.trim();

      // Dummy documents (real file upload baad me Firebase Storage se hoga)
      final List<Map<String, dynamic>> documents = [
        {
          'name': 'Government ID Proof',
          'status': 'Uploaded',
          'date': today,
          'file': 'government_id.pdf',
        },
        {
          'name': 'Address Proof',
          'status': 'Uploaded',
          'date': today,
          'file': 'address_proof.pdf',
        },
        {
          'name': 'Business / Agency Proof',
          'status': 'Uploaded',
          'date': today,
          'file': 'business_proof.pdf',
        },
      ];

      if (license.isNotEmpty) {
        documents.insert(0, {
          'name': 'Broker Registration / License',
          'status': 'Uploaded',
          'date': today,
          'file': 'broker_license.pdf',
        });
      }

      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);

      final snap = await ref.get();
      final alreadyPaid = (snap.data()?['paymentStatus'] ?? '') == 'Paid';

      await ref.update({
        'agency': companyController.text.trim(),
        'experience': experienceController.text.trim(),
        'city': cityController.text.trim(),
        'licenseNumber': license,
        'documents': documents,
        'verificationSubmittedAt': FieldValue.serverTimestamp(),
        // Agar payment pehle ho chuka hai (Changes Requested ke baad), to seedha review
        if (alreadyPaid) 'verification': 'Needs Review',
      });

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      if (alreadyPaid) {
        Navigator.pushReplacementNamed(context, MyRoutes.brokerPendingRoute);
      } else {
        Navigator.pushNamed(context, MyRoutes.brokerPaymentRoute);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to save details. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Broker Verification",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.border.withValues(alpha: 0.7),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Complete Broker Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Provide your professional details and required documents for verification.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Professional Details",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: companyController,
                decoration: fieldDecoration(
                  label: "Agency / Company Name",
                  icon: Icons.business_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter company name";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: fieldDecoration(
                  label: "Experience (Years)",
                  icon: Icons.work_history_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your experience";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: cityController,
                decoration: fieldDecoration(
                  label: "City / Area",
                  icon: Icons.location_on_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your city or area";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: licenseController,
                decoration: fieldDecoration(
                  label: "License Number (Optional)",
                  icon: Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                "Required Documents",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Upload the required documents for verification.",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              documentBox(
                title: "Government ID",
                subtitle: "Aadhaar, Passport, Driving License",
                icon: Icons.badge_outlined,
                uploaded: governmentIdUploaded,
                onTap: () {
                  uploadDocument("Government ID");
                },
              ),
              const SizedBox(height: 12),
              documentBox(
                title: "Address Proof",
                subtitle: "Upload your address proof",
                icon: Icons.home_work_outlined,
                uploaded: addressProofUploaded,
                onTap: () {
                  uploadDocument("Address Proof");
                },
              ),
              const SizedBox(height: 12),
              documentBox(
                title: "Company / Agency Proof",
                subtitle: "License or company registration proof",
                icon: Icons.business_center_outlined,
                uploaded: companyProofUploaded,
                onTap: () {
                  uploadDocument("Company Proof");
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Your documents will only be used for broker verification and will not be displayed publicly.",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSaving ? null : continueToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.6,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Continue to Payment",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
