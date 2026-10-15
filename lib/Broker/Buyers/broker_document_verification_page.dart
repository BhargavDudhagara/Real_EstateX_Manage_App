import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';

class BrokerDocumentVerificationPage extends StatefulWidget {
  const BrokerDocumentVerificationPage({super.key});

  @override
  State<BrokerDocumentVerificationPage> createState() =>
      _BrokerDocumentVerificationPageState();
}

class _BrokerDocumentVerificationPageState
    extends State<BrokerDocumentVerificationPage> {
  final Map<String, String> documentStatus = {
    'Identity Proof': 'Pending',
    'Address Proof': 'Pending',
    'Income Proof': 'Pending',
    'Other Document': 'Pending',
  };

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    final Map<String, dynamic> deal = arguments is Map<String, dynamic>
        ? arguments
        : {};

    final String property = deal['property'] ?? 'Modern Family House';

    final String buyer = deal['name'] ?? 'Bhargav Patel';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Document Verification',
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
            _buildBuyerCard(buyer, property),

            const SizedBox(height: 22),

            const Text(
              'Buyer Documents',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Review the documents submitted by the buyer.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),

            const SizedBox(height: 18),

            _buildDocumentCard(
              title: 'Identity Proof',
              subtitle: 'Aadhaar Card / PAN Card / Passport',
              icon: Icons.badge_outlined,
              documentKey: 'Identity Proof',
            ),

            const SizedBox(height: 12),

            _buildDocumentCard(
              title: 'Address Proof',
              subtitle: 'Aadhaar / Electricity Bill / Driving License',
              icon: Icons.home_outlined,
              documentKey: 'Address Proof',
            ),

            const SizedBox(height: 12),

            _buildDocumentCard(
              title: 'Income Proof',
              subtitle: 'Salary Slip / Bank Statement / ITR',
              icon: Icons.account_balance_outlined,
              documentKey: 'Income Proof',
            ),

            const SizedBox(height: 12),

            _buildDocumentCard(
              title: 'Other Document',
              subtitle: 'Additional document submitted by buyer',
              icon: Icons.description_outlined,
              documentKey: 'Other Document',
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _verifyAllDocuments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Verify Documents',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerCard(String buyer, String property) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buyer,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
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
    final String status = documentStatus[documentKey] ?? 'Pending';

    final bool verified = status == 'Verified';
    final bool rejected = status == 'Rejected';

    final Color statusColor = verified
        ? AppColors.success
        : rejected
        ? AppColors.error
        : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: verified
              ? AppColors.success.withValues(alpha: 0.30)
              : rejected
              ? AppColors.error.withValues(alpha: 0.30)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  verified
                      ? Icons.verified_outlined
                      : rejected
                      ? Icons.cancel_outlined
                      : icon,
                  color: statusColor,
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
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _rejectDocument(documentKey);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _verifyDocument(documentKey);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _verifyDocument(String documentKey) {
    setState(() {
      documentStatus[documentKey] = 'Verified';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$documentKey verified successfully')),
    );
  }

  void _rejectDocument(String documentKey) {
    setState(() {
      documentStatus[documentKey] = 'Rejected';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$documentKey rejected')));
  }

  void _verifyAllDocuments() {
    final rejected = documentStatus.values.contains('Rejected');

    if (rejected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please resolve rejected documents before final verification.',
          ),
        ),
      );
      return;
    }

    setState(() {
      documentStatus.updateAll((key, value) => 'Verified');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All documents verified successfully')),
    );
  }
}
