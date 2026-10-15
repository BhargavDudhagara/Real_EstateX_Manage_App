import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/broker_bottom_navbar.dart';

class BrokerPropertiesPage extends StatefulWidget {
  const BrokerPropertiesPage({super.key});

  @override
  State<BrokerPropertiesPage> createState() => _BrokerPropertiesPageState();
}

class _BrokerPropertiesPageState extends State<BrokerPropertiesPage> {
  String selectedFilter = "All";

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> properties = [
    {
      "id": "EST001",
      "image": "assets/House.png",
      "title": "Modern Family House",
      "propertyType": "House",
      "listingType": "For Sale",
      "price": "₹85 Lakh",
      "location": "Rajkot, Gujarat",
      "address": "150 Feet Ring Road, Rajkot",
      "area": "1850 sq.ft",
      "bedrooms": "3",
      "bathrooms": "2",
      "floors": "2",
      "parking": "2 Cars",
      "furnishing": "Semi Furnished",
      "year": "2022",
      "status": "Active",
      "verification": "Verified",
      "views": "128",
      "inquiries": "12",
      "visits": "5",
      "description":
          "A modern family house located in a peaceful residential area with excellent connectivity to schools, hospitals and markets.",
      "amenities": [
        "Parking",
        "Garden",
        "Security",
        "Water Supply",
        "Power Backup",
      ],
    },
    {
      "id": "EST002",
      "image": "assets/Apartment.png",
      "title": "Premium City Apartment",
      "propertyType": "Apartment",
      "listingType": "For Sale",
      "price": "₹72 Lakh",
      "location": "Ahmedabad, Gujarat",
      "address": "SG Highway, Ahmedabad",
      "area": "1450 sq.ft",
      "bedrooms": "3",
      "bathrooms": "2",
      "floors": "1",
      "parking": "1 Car",
      "furnishing": "Fully Furnished",
      "year": "2023",
      "status": "Pending",
      "verification": "Under Review",
      "views": "96",
      "inquiries": "8",
      "visits": "3",
      "description":
          "Premium apartment with modern interiors, excellent amenities and convenient access to major city locations.",
      "amenities": ["Lift", "Gym", "Security", "Parking", "Club House"],
    },
    {
      "id": "EST003",
      "image": "assets/Vila.png",
      "title": "Premium Garden Villa",
      "propertyType": "Villa",
      "listingType": "For Sale",
      "price": "₹1.25 Cr",
      "location": "Gandhinagar, Gujarat",
      "address": "Kudasan, Gandhinagar",
      "area": "2800 sq.ft",
      "bedrooms": "4",
      "bathrooms": "3",
      "floors": "2",
      "parking": "2 Cars",
      "furnishing": "Fully Furnished",
      "year": "2021",
      "status": "Active",
      "verification": "Verified",
      "views": "214",
      "inquiries": "18",
      "visits": "7",
      "description":
          "Spacious luxury villa with a private garden, modern interiors and premium residential surroundings.",
      "amenities": [
        "Garden",
        "Parking",
        "Security",
        "Swimming Pool",
        "Power Backup",
      ],
    },
    {
      "id": "EST004",
      "image": "assets/farm.png",
      "title": "Green Valley Farm",
      "propertyType": "Farm",
      "listingType": "For Sale",
      "price": "₹95 Lakh",
      "location": "Rajkot, Gujarat",
      "address": "Gondal Road, Rajkot",
      "area": "2 Acre",
      "bedrooms": "2",
      "bathrooms": "2",
      "floors": "1",
      "parking": "Open Parking",
      "furnishing": "Unfurnished",
      "year": "2020",
      "status": "Inactive",
      "verification": "Verified",
      "views": "74",
      "inquiries": "4",
      "visits": "1",
      "description":
          "Green agricultural farm property suitable for farming, weekend living and long-term investment.",
      "amenities": [
        "Water Supply",
        "Electricity",
        "Farm House",
        "Open Parking",
      ],
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredProperties {
    final query = searchController.text.toLowerCase().trim();

    return properties.where((property) {
      final matchesFilter =
          selectedFilter == "All" ||
          property["status"].toString().toLowerCase() ==
              selectedFilter.toLowerCase();

      final matchesSearch =
          property["title"].toString().toLowerCase().contains(query) ||
          property["location"].toString().toLowerCase().contains(query) ||
          property["propertyType"].toString().toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void openProperty(Map<String, dynamic> property) {
    Navigator.pushNamed(
      context,
      MyRoutes.propertyDetailsRoute,
      arguments: property,
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = properties.where((e) => e["status"] == "Active").length;

    final pending = properties.where((e) => e["status"] == "Pending").length;

    final inactive = properties.where((e) => e["status"] == "Inactive").length;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Properties",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Manage your property listings",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),

      body: Column(
        children: [
          _buildHeader(active: active, pending: pending, inactive: inactive),

          Expanded(
            child: filteredProperties.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      return _buildPropertyCard(filteredProperties[index]);
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.addPropertyRoute);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          "Add Property",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBar: const BrokerBottomNavbar(selectedIndex: 1),
    );
  }

  Widget _buildHeader({
    required int active,
    required int pending,
    required int inactive,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: "Search property...",
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _summaryCard(
                "Total",
                properties.length,
                Icons.home_work_outlined,
              ),
              const SizedBox(width: 8),
              _summaryCard(
                "Active",
                active,
                Icons.check_circle_outline_rounded,
              ),
              const SizedBox(width: 8),
              _summaryCard("Pending", pending, Icons.access_time_rounded),
              const SizedBox(width: 8),
              _summaryCard("Inactive", inactive, Icons.pause_circle_outline),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip("All"),
                const SizedBox(width: 8),
                _filterChip("Active"),
                const SizedBox(width: 8),
                _filterChip("Pending"),
                const SizedBox(width: 8),
                _filterChip("Inactive"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, int value, IconData icon) {
    return Expanded(
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String text) {
    final selected = selectedFilter == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final status = property["status"].toString();

    Color statusColor = AppColors.textSecondary;

    if (status == "Active") {
      statusColor = AppColors.success;
    } else if (status == "Pending") {
      statusColor = AppColors.warning;
    }

    return GestureDetector(
      onTap: () => openProperty(property),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.asset(
                    property["image"],
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 190,
                        color: AppColors.background,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: _badge(
                    property["propertyType"],
                    AppColors.surface,
                    AppColors.textPrimary,
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: _badge(status, statusColor, Colors.white),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property["title"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        property["price"],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property["location"],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(height: 1, color: AppColors.divider),

                  const SizedBox(height: 13),

                  Row(
                    children: [
                      _smallInfo(Icons.square_foot_outlined, property["area"]),
                      const SizedBox(width: 14),
                      _smallInfo(
                        Icons.bed_outlined,
                        "${property["bedrooms"]} Beds",
                      ),
                      const SizedBox(width: 14),
                      _smallInfo(
                        Icons.bathtub_outlined,
                        "${property["bathrooms"]} Baths",
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.primary,
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
  }

  Widget _badge(String text, Color background, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 60,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14),
          Text(
            "No Properties Found",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Try another search or filter.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
