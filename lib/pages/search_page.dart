import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class Property {
  final String image;
  final String name;
  final String location;
  final String type;
  final double price;

  const Property({
    required this.image,
    required this.name,
    required this.location,
    required this.type,
    required this.price,
  });

  String get priceText {
    if (price >= 100) {
      return "₹${(price / 100).toStringAsFixed(2)} Cr";
    }

    return "₹${price.toStringAsFixed(0)} Lakh";
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ==================== SEARCH CONTROLLER ====================

  final TextEditingController searchController = TextEditingController();

  // ==================== FILTER VALUES ====================

  String selectedType = "All";
  String selectedLocation = "All Locations";
  String selectedSort = "Recommended";

  RangeValues priceRange = const RangeValues(20, 150);

  // ==================== PROPERTY TYPES ====================

  final List<String> propertyTypes = const [
    "All",
    "House",
    "Apartment",
    "Villa",
    "Plot",
    "Farm",
  ];

  // ==================== LOCATIONS ====================

  final List<String> locations = const [
    "All Locations",
    "Ahmedabad",
    "Rajkot",
    "Gandhinagar",
    "Vadodara",
    "Gondal",
    "Junagadh",
  ];

  // ==================== PROPERTY DATA ====================

  final List<Property> properties = const [
    Property(
      image: "assets/House.png",
      name: "Modern Family House",
      location: "Rajkot",
      type: "House",
      price: 85,
    ),
    Property(
      image: "assets/House1.png",
      name: "Luxury Family Home",
      location: "Ahmedabad",
      type: "House",
      price: 92,
    ),
    Property(
      image: "assets/House2.png",
      name: "Elegant City House",
      location: "Gandhinagar",
      type: "House",
      price: 78,
    ),
    Property(
      image: "assets/Apartment.png",
      name: "Premium City Apartment",
      location: "Ahmedabad",
      type: "Apartment",
      price: 72,
    ),
    Property(
      image: "assets/Apartment1.png",
      name: "Modern Luxury Apartment",
      location: "Rajkot",
      type: "Apartment",
      price: 68,
    ),
    Property(
      image: "assets/Vila.png",
      name: "Premium Garden Villa",
      location: "Gandhinagar",
      type: "Villa",
      price: 125,
    ),
    Property(
      image: "assets/Vila1.png",
      name: "Luxury Private Villa",
      location: "Vadodara",
      type: "Villa",
      price: 145,
    ),
    Property(
      image: "assets/Plot.png",
      name: "Residential Plot",
      location: "Rajkot",
      type: "Plot",
      price: 38,
    ),
    Property(
      image: "assets/Plot1.png",
      name: "Prime Location Plot",
      location: "Ahmedabad",
      type: "Plot",
      price: 52,
    ),
    Property(
      image: "assets/Plot2.png",
      name: "Developing Area Plot",
      location: "Gandhinagar",
      type: "Plot",
      price: 45,
    ),
    Property(
      image: "assets/Farm.png",
      name: "Green Farm Land",
      location: "Gondal",
      type: "Farm",
      price: 45,
    ),
    Property(
      image: "assets/Farm1.png",
      name: "Peaceful Agricultural Farm",
      location: "Rajkot",
      type: "Farm",
      price: 58,
    ),
    Property(
      image: "assets/Farm2.png",
      name: "Large Green Farm",
      location: "Junagadh",
      type: "Farm",
      price: 75,
    ),
  ];

  // ==================== SEARCH FUNCTIONALITY ====================

  List<Property> get filteredProperties {
    final String query = searchController.text.trim().toLowerCase();

    final List<Property> result = properties.where((property) {
      final bool matchesSearch =
          query.isEmpty ||
          property.name.toLowerCase().contains(query) ||
          property.location.toLowerCase().contains(query) ||
          property.type.toLowerCase().contains(query);

      final bool matchesType =
          selectedType == "All" || property.type == selectedType;

      final bool matchesLocation =
          selectedLocation == "All Locations" ||
          property.location == selectedLocation;

      final bool matchesPrice =
          property.price >= priceRange.start &&
          property.price <= priceRange.end;

      return matchesSearch && matchesType && matchesLocation && matchesPrice;
    }).toList();

    if (selectedSort == "Price: Low to High") {
      result.sort((a, b) => a.price.compareTo(b.price));
    }

    if (selectedSort == "Price: High to Low") {
      result.sort((a, b) => b.price.compareTo(a.price));
    }

    return result;
  }

  // ==================== DISPOSE ====================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ==================== RESET FILTERS ====================

  void resetFilters() {
    setState(() {
      selectedType = "All";
      selectedLocation = "All Locations";
      priceRange = const RangeValues(20, 150);
    });
  }

  // ==================== FILTER SHEET ====================

  void showFilterSheet() {
    String tempType = selectedType;
    String tempLocation = selectedLocation;
    RangeValues tempPrice = priceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Filter Properties",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              tempType = "All";
                              tempLocation = "All Locations";
                              tempPrice = const RangeValues(20, 150);
                            });
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Property Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: propertyTypes.map((String type) {
                        final bool isSelected = tempType == type;

                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setSheetState(() {
                              tempType = type;
                            });
                          },
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.background,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Location",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tempLocation,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: locations.map((String location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Text(location),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value == null) return;

                            setSheetState(() {
                              tempLocation = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Text(
                          "Price Range",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "₹${tempPrice.start.round()}L - ₹${tempPrice.end.round()}L",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: tempPrice,
                      min: 20,
                      max: 150,
                      divisions: 13,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.border,
                      labels: RangeLabels(
                        "₹${tempPrice.start.round()}L",
                        "₹${tempPrice.end.round()}L",
                      ),
                      onChanged: (RangeValues value) {
                        setSheetState(() {
                          tempPrice = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedType = tempType;
                            selectedLocation = tempLocation;
                            priceRange = tempPrice;
                          });

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==================== SORT SHEET ====================

  void showSortSheet() {
    const List<String> options = [
      "Recommended",
      "Price: Low to High",
      "Price: High to Low",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sort Properties",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 15),
              ...options.map((String option) {
                final bool selected = selectedSort == option;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      selectedSort = option;
                    });

                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ==================== RESULTS ====================

    final List<Property> results = filteredProperties;

    // ==================== FILTER STATUS ====================

    final bool hasFilter =
        selectedType != "All" ||
        selectedLocation != "All Locations" ||
        priceRange.start != 20 ||
        priceRange.end != 150;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ==================== APP BAR ====================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Find Your Property",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // ==================== CALCULATOR BUTTON ====================
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutes.calculatorRoute);
            },
            icon: const Icon(
              Icons.calculate_outlined,
              color: AppColors.textPrimary,
            ),
          ),

          // ==================== NOTIFICATION BUTTON ====================
          IconButton(
            onPressed: () {
              // Notification functionality can be added later.
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
      body: Column(
        children: [
          // ==================== SEARCH BAR ====================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (String value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        hintText: "Search property or location",
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // ==================== FILTER BUTTON ====================
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    onPressed: showFilterSheet,
                    icon: const Icon(Icons.tune_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // ==================== PROPERTY COUNT + SORT ====================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
            child: Row(
              children: [
                Text(
                  "${results.length} Properties Found",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const Spacer(),

                InkWell(
                  onTap: showSortSheet,
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.swap_vert_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 3),
                        Text(
                          "Sort",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==================== FILTER TAGS ====================
          if (hasFilter)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  if (selectedType != "All")
                    _filterTag(selectedType, () {
                      setState(() {
                        selectedType = "All";
                      });
                    }),
                  if (selectedLocation != "All Locations")
                    _filterTag(selectedLocation, () {
                      setState(() {
                        selectedLocation = "All Locations";
                      });
                    }),
                  if (priceRange.start != 20 || priceRange.end != 150)
                    _filterTag(
                      "₹${priceRange.start.round()}L - ₹${priceRange.end.round()}L",
                      () {
                        setState(() {
                          priceRange = const RangeValues(20, 150);
                        });
                      },
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: resetFilters,
                    child: const Text(
                      "Clear All",
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ==================== PROPERTY GRID ====================
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                return _propertyCard(results[index]);
              },
            ),
          ),
        ],
      ),

      // ==================== BOTTOM NAVBAR ====================
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  // ==================== FILTER TAG ====================

  Widget _filterTag(String text, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 7),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== PROPERTY CARD ====================

  Widget _propertyCard(Property property) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(17),
                ),
                child: Image.asset(
                  property.image,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // ==================== FAVORITE ICON ====================
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              // ==================== PROPERTY TYPE ====================
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    property.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ==================== PROPERTY DETAILS ====================
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        "${property.location}, Gujarat",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  property.priceText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
