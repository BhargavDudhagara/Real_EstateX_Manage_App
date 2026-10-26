import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/broker_bottom_navbar.dart';
import 'package:app/services/property_service.dart';
import 'package:app/models/property_model.dart';

class BrokerPropertiesPage extends StatefulWidget {
  const BrokerPropertiesPage({super.key});

  @override
  State<BrokerPropertiesPage> createState() => _BrokerPropertiesPageState();
}

class _BrokerPropertiesPageState extends State<BrokerPropertiesPage> {
  String selectedFilter = "All";

  final TextEditingController searchController = TextEditingController();
  final PropertyService _propertyService = PropertyService();

  List<PropertyModel> properties = [];

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadProperties() {
    _propertyService.getBrokerProperties().listen((data) {
      if (!mounted) return;

      setState(() {
        properties = data;
      });
    });
  }

  List<PropertyModel> get filteredProperties {
    final query = searchController.text.toLowerCase().trim();

    return properties.where((property) {
      final matchesFilter =
          selectedFilter == "All" ||
          property.status.toLowerCase() == selectedFilter.toLowerCase();

      final matchesSearch =
          property.title.toLowerCase().contains(query) ||
          property.location.toLowerCase().contains(query) ||
          property.propertyType.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void openProperty(PropertyModel property) {
    Navigator.pushNamed(
      context,
      MyRoutes.propertyDetailsRoute,
      arguments: {...property.toMap(), 'id': property.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = properties.where((e) => e.status == "Approved").length;
    final pending = properties.where((e) => e.status == "Pending").length;
    final rejected = properties.where((e) => e.status == "Rejected").length;

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
          _buildHeader(active: active, pending: pending, rejected: rejected),
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
    required int rejected,
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
                "Approved",
                active,
                Icons.check_circle_outline_rounded,
              ),
              const SizedBox(width: 8),
              _summaryCard("Pending", pending, Icons.access_time_rounded),
              const SizedBox(width: 8),
              _summaryCard("Rejected", rejected, Icons.cancel_outlined),
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
                _filterChip("Approved"),
                const SizedBox(width: 8),
                _filterChip("Pending"),
                const SizedBox(width: 8),
                _filterChip("Rejected"),
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

  Widget _buildPropertyCard(PropertyModel property) {
    final status = property.status;

    Color statusColor = AppColors.textSecondary;

    if (status == "Approved") {
      statusColor = AppColors.success;
    } else if (status == "Pending") {
      statusColor = AppColors.warning;
    } else if (status == "Rejected") {
      statusColor = AppColors.error;
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
                  child: _buildPropertyImage(property.image, 190),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _badge(
                    property.propertyType,
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
                          property.title,
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
                        property.price,
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
                          property.location,
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
                      _smallInfo(Icons.square_foot_outlined, property.area),
                      const SizedBox(width: 14),
                      _smallInfo(
                        Icons.bed_outlined,
                        "${property.bedrooms} Beds",
                      ),
                      const SizedBox(width: 14),
                      _smallInfo(
                        Icons.bathtub_outlined,
                        "${property.bathrooms} Baths",
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

  Widget _buildPropertyImage(String imageUrl, double height) {
    if (imageUrl.isEmpty) {
      return _imagePlaceholder(height);
    }

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder(height);
        },
      );
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        return Image.memory(
          base64Decode(imageUrl.split(',').last),
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            return _imagePlaceholder(height);
          },
        );
      } catch (_) {
        return _imagePlaceholder(height);
      }
    }

    final localFile = File(imageUrl);

    if (localFile.existsSync()) {
      return Image.file(
        localFile,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder(height);
        },
      );
    }

    return Image.asset(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder(height);
      },
    );
  }

  Widget _imagePlaceholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.background,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: AppColors.textSecondary,
        ),
      ),
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
