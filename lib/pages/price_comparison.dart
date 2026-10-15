import 'package:app/theme/app_colors.dart';
import 'package:app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class PriceComparisonPage extends StatefulWidget {
  const PriceComparisonPage({super.key});

  @override
  State<PriceComparisonPage> createState() => _PriceComparisonPageState();
}

class _PriceComparisonPageState extends State<PriceComparisonPage> {
  final List<Map<String, String>> properties = [
    {
      "image": "assets/House.png",
      "name": "Modern Family House",
      "location": "Rajkot, Gujarat",
      "price": "₹85 Lakh",
      "type": "House",
      "area": "1800 sq.ft",
    },
    {
      "image": "assets/House1.png",
      "name": "Luxury Family Home",
      "location": "Ahmedabad, Gujarat",
      "price": "₹92 Lakh",
      "type": "House",
      "area": "2100 sq.ft",
    },
    {
      "image": "assets/House2.png",
      "name": "Elegant City House",
      "location": "Gandhinagar, Gujarat",
      "price": "₹78 Lakh",
      "type": "House",
      "area": "1650 sq.ft",
    },
    {
      "image": "assets/Apartment.png",
      "name": "Premium City Apartment",
      "location": "Ahmedabad, Gujarat",
      "price": "₹72 Lakh",
      "type": "Apartment",
      "area": "1450 sq.ft",
    },
    {
      "image": "assets/Apartment1.png",
      "name": "Modern Luxury Apartment",
      "location": "Rajkot, Gujarat",
      "price": "₹68 Lakh",
      "type": "Apartment",
      "area": "1350 sq.ft",
    },
    {
      "image": "assets/Vila.png",
      "name": "Premium Garden Villa",
      "location": "Gandhinagar, Gujarat",
      "price": "₹1.25 Cr",
      "type": "Villa",
      "area": "2800 sq.ft",
    },
    {
      "image": "assets/Vila1.png",
      "name": "Luxury Private Villa",
      "location": "Vadodara, Gujarat",
      "price": "₹1.45 Cr",
      "type": "Villa",
      "area": "3200 sq.ft",
    },
    {
      "image": "assets/Plot.png",
      "name": "Residential Plot",
      "location": "Rajkot, Gujarat",
      "price": "₹38 Lakh",
      "type": "Plot",
      "area": "1500 sq.ft",
    },
    {
      "image": "assets/Plot1.png",
      "name": "Prime Location Plot",
      "location": "Ahmedabad, Gujarat",
      "price": "₹52 Lakh",
      "type": "Plot",
      "area": "1800 sq.ft",
    },
    {
      "image": "assets/Plot2.png",
      "name": "Developing Area Plot",
      "location": "Gandhinagar, Gujarat",
      "price": "₹45 Lakh",
      "type": "Plot",
      "area": "1700 sq.ft",
    },
    {
      "image": "assets/Farm.png",
      "name": "Green Farm Land",
      "location": "Gondal, Gujarat",
      "price": "₹45 Lakh",
      "type": "Farm",
      "area": "2 Acre",
    },
    {
      "image": "assets/Farm1.png",
      "name": "Peaceful Agricultural Farm",
      "location": "Rajkot, Gujarat",
      "price": "₹58 Lakh",
      "type": "Farm",
      "area": "3 Acre",
    },
    {
      "image": "assets/Farm2.png",
      "name": "Large Green Farm",
      "location": "Junagadh, Gujarat",
      "price": "₹75 Lakh",
      "type": "Farm",
      "area": "5 Acre",
    },
  ];

  final List<int?> selectedIndexes = [null, null, null];

  double getPrice(String price) {
    String value = price.replaceAll("₹", "").replaceAll(",", "").trim();

    if (value.contains("Cr")) {
      return double.parse(value.replaceAll("Cr", "").trim()) * 100;
    }

    if (value.contains("Lakh")) {
      return double.parse(value.replaceAll("Lakh", "").trim());
    }

    return 0;
  }

  String formatDifference(double difference) {
    if (difference >= 100) {
      return "₹${(difference / 100).toStringAsFixed(2)} Cr";
    }

    return "₹${difference.toStringAsFixed(0)} Lakh";
  }

  List<Map<String, String>> get selectedProperties {
    return selectedIndexes
        .where((index) => index != null)
        .map((index) => properties[index!])
        .toList();
  }

  void showPropertySelector(int position) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: Column(
              children: [
                const SizedBox(height: 14),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Select Property",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Choose a property to compare",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];

                      final alreadySelected = selectedIndexes.contains(index);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: alreadySelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              property["image"]!,
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            property["name"]!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "${property["location"]} • ${property["price"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          trailing: alreadySelected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                )
                              : const Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: AppColors.textSecondary,
                                ),
                          onTap: () {
                            setState(() {
                              selectedIndexes[position] = index;
                            });

                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPropertyCard(int index) {
    final property = properties[index];

    return Container(
      width: 175,
      height: 185,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              property["image"]!,
              width: double.infinity,
              height: 95,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property["name"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  property["price"]!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  property["location"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildComparisonRow(String title, String icon, List<String> values) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Row(
              children: [
                Icon(_getIcon(icon), size: 17, color: AppColors.textSecondary),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(values.length, (index) {
                return Expanded(
                  child: Text(
                    values[index],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "location":
        return Icons.location_on_outlined;
      case "price":
        return Icons.currency_rupee_rounded;
      case "type":
        return Icons.home_work_outlined;
      case "area":
        return Icons.square_foot_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Widget buildComparisonSection() {
    final selected = selectedProperties;

    if (selected.length < 2) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.compare_arrows_rounded,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add at least 2 properties",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Select properties above to see a detailed comparison.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final prices = selected
        .map((property) => getPrice(property["price"]!))
        .toList();

    final lowestPrice = prices.reduce((a, b) => a < b ? a : b);
    final highestPrice = prices.reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 17, 16, 12),
            child: Text(
              "Property Comparison",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          buildComparisonRow(
            "Price",
            "price",
            selected.map((property) => property["price"]!).toList(),
          ),
          buildComparisonRow(
            "Type",
            "type",
            selected.map((property) => property["type"]!).toList(),
          ),
          buildComparisonRow(
            "Location",
            "location",
            selected.map((property) => property["location"]!).toList(),
          ),
          buildComparisonRow(
            "Area",
            "area",
            selected.map((property) => property["area"]!).toList(),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Lowest Price",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDifference(lowestPrice),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Highest Price",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDifference(highestPrice),
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (highestPrice != lowestPrice)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  "Price difference: ${formatDifference(highestPrice - lowestPrice)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
          "Price Comparison",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.compare_arrows_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Compare Properties",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Compare prices, locations and property details.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                "Select Properties",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Choose 2 or 3 properties to compare",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 185,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return buildPropertyCard(index);
                  },
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.compare_arrows_rounded,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price Comparison",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Property comparison feature will be available soon.",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
