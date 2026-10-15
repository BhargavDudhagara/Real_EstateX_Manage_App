import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';

class BuyerDealPaymentPage extends StatefulWidget {
  const BuyerDealPaymentPage({super.key});

  @override
  State<BuyerDealPaymentPage> createState() => _BuyerDealPaymentPageState();
}

class _BuyerDealPaymentPageState extends State<BuyerDealPaymentPage> {
  Map<String, dynamic> deal = {};

  String selectedInterest = "High";
  String selectedPaymentMethod = "Bank Transfer";

  final TextEditingController advanceController = TextEditingController();

  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    advanceController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      deal = arguments;
    }

    final String property = deal["property"] ?? "Modern Family House";

    final String price = deal["price"] ?? "₹85 Lakh";

    final String broker = deal["broker"] ?? "Bhargav Patel";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          "Payment & Interest",
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
            _buildPropertyCard(property, price, broker),

            const SizedBox(height: 22),

            const Text(
              "Your Interest",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Tell the broker how serious you are about this property.",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 12),

            _buildInterestSelector(),

            const SizedBox(height: 22),

            const Text(
              "Payment Details",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            _buildDropdown(),

            const SizedBox(height: 14),

            TextField(
              controller: advanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Expected Advance Amount",
                hintText: "Enter amount",
                prefixText: "₹ ",
                prefixIcon: const Icon(
                  Icons.payments_outlined,
                  color: AppColors.primary,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Payment Note",
                hintText: "Add any payment related information...",
                alignLabelWithHint: true,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.18),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This information will be shared with the broker for further negotiation and payment planning.",
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
                onPressed: submitPaymentDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  "Submit Details",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(String property, String price, String broker) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Broker: $broker",
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Listed Price",
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestSelector() {
    return Row(
      children: [
        _buildInterestOption("High", AppColors.success),
        const SizedBox(width: 8),
        _buildInterestOption("Medium", AppColors.warning),
        const SizedBox(width: 8),
        _buildInterestOption("Low", AppColors.error),
      ],
    );
  }

  Widget _buildInterestOption(String value, Color color) {
    final bool selected = selectedInterest == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedInterest = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.10) : AppColors.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? color : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? color : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: selectedPaymentMethod,
      decoration: InputDecoration(
        labelText: "Payment Method",
        prefixIcon: const Icon(
          Icons.account_balance_wallet_outlined,
          color: AppColors.primary,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
        ),
      ),
      items: const [
        DropdownMenuItem(value: "Bank Transfer", child: Text("Bank Transfer")),
        DropdownMenuItem(value: "Loan", child: Text("Home Loan")),
        DropdownMenuItem(value: "Cash", child: Text("Cash")),
        DropdownMenuItem(value: "Other", child: Text("Other")),
      ],
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          selectedPaymentMethod = value;
        });
      },
    );
  }

  void submitPaymentDetails() {
    if (advanceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter expected advance amount")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment details submitted successfully")),
    );
  }
}
