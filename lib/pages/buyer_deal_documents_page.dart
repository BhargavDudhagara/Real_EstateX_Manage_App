import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';

class BuyerDealDocumentsPage extends StatefulWidget {
  const BuyerDealDocumentsPage({super.key});

  @override
  State<BuyerDealDocumentsPage> createState() => _BuyerDealDocumentsPageState();
}

class _BuyerDealDocumentsPageState extends State<BuyerDealDocumentsPage> {
  Map<String, dynamic> deal = {};

  final Map<String, String> documentStatus = {
    "Identity Proof": "Pending",
    "Address Proof": "Pending",
    "Income Proof": "Pending",
    "Other Document": "Pending",
  };

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      deal = arguments;
    }

    final String property = deal["property"] ?? "Modern Family House";
    final String price = deal["price"] ?? "₹85 Lakh";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          "Documents",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(property, price),

            const SizedBox(height: 22),

            const Text(
              "Upload Documents",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Upload the required documents for broker verification.",
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 18),

            _buildDocumentCard(
              title: "Identity Proof",
              subtitle: "Aadhaar Card / PAN Card / Passport",
              icon: Icons.badge_outlined,
              documentKey: "Identity Proof",
            ),

            const SizedBox(height: 12),

            _buildDocumentCard(
              title: "Address Proof",
              subtitle: "Aadhaar / Electricity Bill / Driving License",
              icon: Icons.home_outlined,
              documentKey: "Address Proof",
            ),

            const SizedBox(height: 12),

            _buildDocumentCard(
              title: "Income Proof",
              subtitle: "Salary Slip / Bank Statement / ITR",
              icon: Icons.account_balance_outlined,
              documentKey: "Income Proof",
            ),

            const SizedBox(height: 12),

            _buildDocumentCard(
              title: "Other Document",
              subtitle: "Upload any additional required document",
              icon: Icons.description_outlined,
              documentKey: "Other Document",
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.security_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your documents will be reviewed by the broker and used only for the property deal verification process.",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: submitDocuments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  "Submit Documents",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(String property, String price) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Deal Accepted",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String documentKey,
  }) {
    final status = documentStatus[documentKey] ?? "Pending";
    final bool uploaded = status == "Uploaded";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: uploaded
              ? AppColors.success.withValues(alpha: 0.35)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: uploaded
                      ? AppColors.success.withValues(alpha: 0.08)
                      : AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  uploaded ? Icons.check_circle_outline : icon,
                  color: uploaded ? AppColors.success : AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: uploaded ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {
                uploadDocument(documentKey);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: Text(
                uploaded ? "Change Document" : "Upload Document",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void uploadDocument(String documentKey) {
    setState(() {
      documentStatus[documentKey] = "Uploaded";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$documentKey uploaded successfully")),
    );
  }

  void submitDocuments() {
    final uploadedCount = documentStatus.values
        .where((status) => status == "Uploaded")
        .length;

    if (uploadedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload at least one document")),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      MyRoutes.buyerDealPaymentRoute,
      arguments: {...deal, "documents": documentStatus},
    );
  }
}
