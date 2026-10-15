import 'dart:async';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/bottom_navbar.dart';
import 'package:app/pages/property_detail.dart';

class BuyerHomePage extends StatefulWidget {
  const BuyerHomePage({super.key});

  @override
  State<BuyerHomePage> createState() => _BuyerHomePageState();
}

class _BuyerHomePageState extends State<BuyerHomePage> {
  int selectedCategory = 0;
  int currentBanner = 0;

  // ==================== COMPARE STATE ====================

  static const int maxCompare = 3;
  bool compareMode = false;
  final List<Map<String, String>> selectedForCompare = [];
  final GlobalKey _recommendedKey = GlobalKey();

  final PageController _pageController = PageController();
  Timer? _bannerTimer;

  final List<String> categories = [
    "All",
    "House",
    "Apartment",
    "Villa",
    "Plot",
    "Farm",
  ];

  final List<String> bannerImages = [
    'assets/House.png',
    'assets/Apartment.png',
    'assets/Vila.png',
    'assets/Farm1.png',
  ];

  final List<Map<String, String>> properties = [
    {
      "image": "assets/House.png",
      "name": "Modern Family House",
      "location": "Rajkot, Gujarat",
      "price": "₹85 Lakh",
      "type": "House",
    },
    {
      "image": "assets/House1.png",
      "name": "Luxury Family Home",
      "location": "Ahmedabad, Gujarat",
      "price": "₹92 Lakh",
      "type": "House",
    },
    {
      "image": "assets/House2.png",
      "name": "Elegant City House",
      "location": "Gandhinagar, Gujarat",
      "price": "₹78 Lakh",
      "type": "House",
    },
    {
      "image": "assets/Apartment.png",
      "name": "Premium City Apartment",
      "location": "Ahmedabad, Gujarat",
      "price": "₹72 Lakh",
      "type": "Apartment",
    },
    {
      "image": "assets/Apartment1.png",
      "name": "Modern Luxury Apartment",
      "location": "Rajkot, Gujarat",
      "price": "₹68 Lakh",
      "type": "Apartment",
    },
    {
      "image": "assets/Vila.png",
      "name": "Premium Garden Villa",
      "location": "Gandhinagar, Gujarat",
      "price": "₹1.25 Cr",
      "type": "Villa",
    },
    {
      "image": "assets/Vila1.png",
      "name": "Luxury Private Villa",
      "location": "Vadodara, Gujarat",
      "price": "₹1.45 Cr",
      "type": "Villa",
    },
    {
      "image": "assets/Plot.png",
      "name": "Residential Plot",
      "location": "Rajkot, Gujarat",
      "price": "₹38 Lakh",
      "type": "Plot",
    },
    {
      "image": "assets/Plot1.png",
      "name": "Prime Location Plot",
      "location": "Ahmedabad, Gujarat",
      "price": "₹52 Lakh",
      "type": "Plot",
    },
    {
      "image": "assets/Plot2.png",
      "name": "Developing Area Plot",
      "location": "Gandhinagar, Gujarat",
      "price": "₹45 Lakh",
      "type": "Plot",
    },
    {
      "image": "assets/Farm.png",
      "name": "Green Farm Land",
      "location": "Gondal, Gujarat",
      "price": "₹45 Lakh",
      "type": "Farm",
    },
    {
      "image": "assets/Farm1.png",
      "name": "Peaceful Agricultural Farm",
      "location": "Rajkot, Gujarat",
      "price": "₹58 Lakh",
      "type": "Farm",
    },
    {
      "image": "assets/Farm2.png",
      "name": "Large Green Farm",
      "location": "Junagadh, Gujarat",
      "price": "₹75 Lakh",
      "type": "Farm",
    },
  ];

  final List<Map<String, String>> brokers = [
    {
      "image": "assets/Hiren_Broker.png",
      "name": "Hiren Makvana",
      "rating": "4.9",
    },
    {
      "image": "assets/Dhruval_Broker.png",
      "name": "Dhruval Limbad",
      "rating": "4.8",
    },
    {"image": "assets/Bhargav.png", "name": "Bhargav Patel", "rating": "4.7"},
    {
      "image": "assets/Hiren_Broker.png",
      "name": "Hiren Makvana",
      "rating": "4.9",
    },
  ];

  final List<Map<String, dynamic>> services = [
    {
      "icon": Icons.verified_user_outlined,
      "title": "Property Verification",
      "subtitle": "Verify property & documents",
    },
    {
      "icon": Icons.calendar_month_outlined,
      "title": "Property Visit",
      "subtitle": "Book a property visit",
    },
    {
      "icon": Icons.description_outlined,
      "title": "Legal Assistance",
      "subtitle": "Get document support",
    },
    {
      "icon": Icons.price_check_rounded,
      "title": "Price Estimation",
      "subtitle": "Estimate property value",
    },
    {
      "icon": Icons.agriculture_outlined,
      "title": "Farm Analyzer",
      "subtitle": "Analyze farm properties",
    },
    {
      "icon": Icons.location_on_outlined,
      "title": "Location Insights",
      "subtitle": "Explore nearby places",
    },
  ];

  final List<Map<String, dynamic>> upcomingFeatures = [
    {
      "icon": Icons.chat_bubble_outline_rounded,
      "title": "Live Chat",
      "subtitle": "Chat directly with brokers",
    },
    {
      "icon": Icons.videocam_outlined,
      "title": "Video Property Tour",
      "subtitle": "Explore properties virtually",
    },
    {
      "icon": Icons.notifications_none_rounded,
      "title": "Smart Notifications",
      "subtitle": "Get important property updates",
    },
    {
      "icon": Icons.event_note_outlined,
      "title": "Meetings & Reminders",
      "subtitle": "Manage broker meetings",
    },
    {
      "icon": Icons.compare_arrows_rounded,
      "title": "Price Comparison",
      "subtitle": "Compare multiple properties",
    },
    {
      "icon": Icons.favorite_border_rounded,
      "title": "Smart Wishlist",
      "subtitle": "Track saved properties",
    },
  ];

  List<Map<String, String>> get filteredProperties {
    if (selectedCategory == 0) {
      return properties;
    }

    final selectedType = categories[selectedCategory];

    return properties
        .where((property) => property["type"] == selectedType)
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        currentBanner++;

        if (currentBanner >= bannerImages.length) {
          currentBanner = 0;
        }

        _pageController.animateToPage(
          currentBanner,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _openPropertyDetails(Map<String, String> property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsPage(property: property),
      ),
    );
  }

  // ==================== COMPARE HELPERS ====================

  // Converts "₹85 Lakh" / "₹1.25 Cr" into a value in Lakh.
  double _priceInLakh(Map<String, String> property) {
    final String raw = (property["price"] ?? "").replaceAll("₹", "").trim();
    final List<String> parts = raw.split(" ");
    final double value = double.tryParse(parts.first) ?? 0;

    if (parts.length > 1 && parts[1].toLowerCase() == "cr") {
      return value * 100;
    }

    return value;
  }

  String _formatLakh(double lakh) {
    if (lakh >= 100) {
      return "₹${(lakh / 100).toStringAsFixed(2)} Cr";
    }

    final String text = lakh % 1 == 0
        ? lakh.toStringAsFixed(0)
        : lakh.toStringAsFixed(1);

    return "₹$text Lakh";
  }

  void _startCompare() {
    setState(() {
      compareMode = true;
    });

    final BuildContext? target = _recommendedKey.currentContext;

    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Select 2 to 3 properties to compare"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _cancelCompare() {
    setState(() {
      compareMode = false;
      selectedForCompare.clear();
    });
  }

  void _toggleCompareSelection(Map<String, String> property) {
    final bool alreadySelected = selectedForCompare.contains(property);

    if (!alreadySelected && selectedForCompare.length >= maxCompare) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can compare up to $maxCompare properties"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      if (alreadySelected) {
        selectedForCompare.remove(property);
      } else {
        selectedForCompare.add(property);
      }
    });
  }

  void _showComparison() {
    if (selectedForCompare.length < 2) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select at least 2 properties"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final List<Map<String, String>> items = List<Map<String, String>>.from(
      selectedForCompare,
    );

    final List<double> prices = items.map(_priceInLakh).toList();
    final double lowest = prices.reduce((a, b) => a < b ? a : b);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Compare Properties",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(items.length, (index) {
                        final property = items[index];
                        final double price = prices[index];
                        final bool isLowest = price == lowest;

                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: index == items.length - 1 ? 0 : 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isLowest
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(13),
                                  ),
                                  child: Image.asset(
                                    property["image"]!,
                                    width: double.infinity,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        property["name"]!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _compareRow(
                                        "Price",
                                        property["price"]!,
                                        highlight: true,
                                      ),
                                      _compareRow("Type", property["type"]!),
                                      _compareRow(
                                        "Location",
                                        property["location"]!,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isLowest
                                              ? AppColors.primary
                                              : AppColors.surface,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          isLowest
                                              ? "Lowest price"
                                              : "+${_formatLakh(price - lowest)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: isLowest
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
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
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _compareRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: highlight ? AppColors.primary : AppColors.textPrimary,
              fontSize: highlight ? 14 : 12,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compareBar() {
    final int count = selectedForCompare.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _cancelCompare,
            icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              "$count of $maxCompare selected",
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: count >= 2 ? _showComparison : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.border,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Compare",
              style: TextStyle(fontWeight: FontWeight.w700),
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
        titleSpacing: 16,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: ClipOval(
              child: Image.asset('assets/Estate.png', fit: BoxFit.cover),
            ),
          ),
        ),
        title: const Text(
          "EstateX",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutes.calculatorRoute);
            },
            icon: const Icon(
              Icons.calculate_outlined,
              color: AppColors.textPrimary,
            ),
          ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Container(
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: bannerImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentBanner = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            bannerImages[index],
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withValues(alpha: 0.65),
                                Colors.black.withValues(alpha: 0.08),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 18,
                        top: 28,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Find Your",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Dream Property",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Houses, Farms & Plots",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(bannerImages.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: currentBanner == index ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: currentBanner == index
                                    ? Colors.white
                                    : Colors.white54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedCategory == index;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(categories[index]),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = index;
                          });
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 22),

              Padding(
                key: _recommendedKey,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      compareMode
                          ? "Select to Compare"
                          : "Recommended Properties",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: compareMode ? _cancelCompare : () {},
                      child: Text(
                        compareMode ? "Cancel" : "See All",
                        style: TextStyle(
                          color: compareMode
                              ? AppColors.error
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredProperties.length,
                  itemBuilder: (context, index) {
                    final property = filteredProperties[index];
                    final bool isPicked = selectedForCompare.contains(property);

                    return GestureDetector(
                      onTap: () {
                        if (compareMode) {
                          _toggleCompareSelection(property);
                        } else {
                          _openPropertyDetails(property);
                        }
                      },
                      child: Container(
                        width: 210,
                        margin: const EdgeInsets.only(right: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isPicked
                                ? AppColors.primary
                                : AppColors.border,
                            width: isPicked ? 2 : 1,
                          ),
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
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(14),
                                  ),
                                  child: Image.asset(
                                    property["image"]!,
                                    width: double.infinity,
                                    height: 135,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (compareMode)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: isPicked
                                            ? AppColors.primary
                                            : Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isPicked
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 17,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property["name"]!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 15,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          property["location"]!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        property["price"]!,
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                        child: Text(
                                          property["type"]!,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(height: 1, color: AppColors.divider),
              ),

              const SizedBox(height: 22),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Top Brokers",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: brokers.length,
                  itemBuilder: (context, index) {
                    final broker = brokers[index];

                    return Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    broker["image"]!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "Verified",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  broker["name"]!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.accent,
                                      size: 19,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      broker["rating"]!,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.textSecondary,
                            size: 17,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 26),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "EstateX Services",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 125,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return Container(
                      width: 165,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              service["icon"] as IconData,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            service["title"] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            service["subtitle"] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Property Price Comparison",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: _startCompare,
                      child: const Text(
                        "Compare",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: _startCompare,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.compare_arrows_rounded,
                          color: AppColors.primary,
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Compare Property Prices",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Compare properties by price, location and type.",
                              maxLines: 2,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nearby Property Finder",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          MyRoutes.nearbyPropertyRoute,
                        );
                      },
                      child: const Text(
                        "Explore",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.nearbyPropertyRoute);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Find Properties Near You",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Discover nearby houses, apartments, villas, plots and farms.",
                              maxLines: 2,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upcoming Features",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Coming Soon",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 125,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: upcomingFeatures.length,
                  itemBuilder: (context, index) {
                    final feature = upcomingFeatures[index];

                    return Container(
                      width: 175,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  feature["icon"] as IconData,
                                  color: AppColors.accent,
                                  size: 22,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "Soon",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          Text(
                            feature["title"] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            feature["subtitle"] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [if (compareMode) _compareBar(), const BottomNavbar()],
      ),
    );
  }
}
