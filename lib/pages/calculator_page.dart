import 'package:app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // ==================== VARIABLES ====================

  int selectedCalculator = 0;

  final TextEditingController loanController = TextEditingController(
    text: "5000000",
  );

  final TextEditingController interestController = TextEditingController(
    text: "8.5",
  );

  final TextEditingController tenureController = TextEditingController(
    text: "20",
  );

  double monthlyEmi = 0;
  double totalInterest = 0;
  double totalPayment = 0;

  // ==================== CALCULATE EMI ====================

  void calculateEMI() {
    double principal = double.tryParse(loanController.text) ?? 0;
    double annualInterest = double.tryParse(interestController.text) ?? 0;
    int years = int.tryParse(tenureController.text) ?? 0;

    if (principal <= 0 || annualInterest < 0 || years <= 0) {
      setState(() {
        monthlyEmi = 0;
        totalInterest = 0;
        totalPayment = 0;
      });
      return;
    }

    double monthlyRate = annualInterest / 12 / 100;
    int months = years * 12;

    if (monthlyRate == 0) {
      monthlyEmi = principal / months;
    } else {
      monthlyEmi =
          principal *
          monthlyRate *
          _power(1 + monthlyRate, months) /
          (_power(1 + monthlyRate, months) - 1);
    }

    totalPayment = monthlyEmi * months;
    totalInterest = totalPayment - principal;

    setState(() {});
  }

  // ==================== POWER CALCULATION ====================

  double _power(double base, int exponent) {
    double result = 1;

    for (int i = 0; i < exponent; i++) {
      result *= base;
    }

    return result;
  }

  // ==================== FORMAT AMOUNT ====================

  String formatAmount(double amount) {
    if (amount >= 10000000) {
      return "₹${(amount / 10000000).toStringAsFixed(2)} Cr";
    }

    if (amount >= 100000) {
      return "₹${(amount / 100000).toStringAsFixed(2)} L";
    }

    return "₹${amount.toStringAsFixed(0)}";
  }

  // ==================== DISPOSE ====================

  @override
  void dispose() {
    loanController.dispose();
    interestController.dispose();
    tenureController.dispose();
    super.dispose();
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==================== APP BAR ====================
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),

        title: const Text(
          "Financial Calculator",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ==================== BODY ====================
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== CALCULATOR SELECTOR ====================
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _calculatorTab(
                      title: "EMI Calculator",
                      icon: Icons.calculate_outlined,
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: _calculatorTab(
                      title: "Mortgage",
                      icon: Icons.account_balance_outlined,
                      index: 1,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ==================== INTRO SECTION ====================
            const Text(
              "Calculate Your Loan",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              selectedCalculator == 0
                  ? "Estimate your monthly EMI and total loan cost."
                  : "Calculate your mortgage payment based on your property loan.",
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 22),

            // ==================== INPUT CARD ====================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== LOAN AMOUNT ====================
                  const Text(
                    "Loan Amount",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: loanController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      calculateEMI();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.currency_rupee,
                        color: AppColors.primary,
                      ),
                      hintText: "Enter loan amount",
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
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================== INTEREST RATE ====================
                  const Text(
                    "Interest Rate (% per year)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: interestController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) {
                      calculateEMI();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.percent,
                        color: AppColors.primary,
                      ),
                      hintText: "Enter interest rate",
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
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================== LOAN TENURE ====================
                  const Text(
                    "Loan Tenure (Years)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: tenureController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      calculateEMI();
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                      ),
                      hintText: "Enter loan tenure",
                      suffixText: "Years",
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
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ==================== CALCULATE BUTTON ====================
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: calculateEMI,
                      icon: const Icon(Icons.calculate_outlined),
                      label: Text(
                        selectedCalculator == 0
                            ? "Calculate EMI"
                            : "Calculate Mortgage",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ==================== RESULT SECTION ====================
            const Text(
              "Calculation Result",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            // ==================== EMI RESULT ====================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 15,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Monthly EMI",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    formatAmount(monthlyEmi),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(height: 1, color: Colors.white24),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _resultItem(
                          title: "Principal",
                          value: formatAmount(
                            double.tryParse(loanController.text) ?? 0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _resultItem(
                          title: "Interest",
                          value: formatAmount(totalInterest),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _resultItem(
                    title: "Total Payment",
                    value: formatAmount(totalPayment),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ==================== INFORMATION CARD ====================
            Container(
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
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "This calculation is an estimate. Actual loan EMI may vary depending on the bank, interest rate, processing fees and other charges.",
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
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
    );
  }

  // ==================== CALCULATOR TAB ====================

  Widget _calculatorTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final bool isSelected = selectedCalculator == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCalculator = index;
        });

        calculateEMI();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== RESULT ITEM ====================

  Widget _resultItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
