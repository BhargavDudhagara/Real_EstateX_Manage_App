import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';

class PropertyDetailsPage extends StatefulWidget {
  const PropertyDetailsPage({super.key});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  Map<String, dynamic> property = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is Map<String, dynamic>) {
      property = arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (property.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text("Property Details")),
        body: const Center(child: Text("Property details not available")),
      );
    }

    final status = property["status"] ?? "Active";
    final verification = property["verification"] ?? "Verified";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Property Details",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showMoreOptions,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 35),
        children: [
          _propertyImage(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property["title"] ?? "Property",
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _statusBadge(status),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        property["location"] ?? "",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  property["price"] ?? "",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                _verificationCard(verification),
                const SizedBox(height: 22),
                _sectionCard(
                  title: "Property Overview",
                  icon: Icons.home_work_outlined,
                  child: Column(
                    children: [
                      _detailRow("Property ID", property["id"] ?? "-"),
                      _detailRow(
                        "Property Type",
                        property["propertyType"] ?? "-",
                      ),
                      _detailRow(
                        "Listing Type",
                        property["listingType"] ?? "-",
                      ),
                      _detailRow("Area", property["area"] ?? "-"),
                      _detailRow("Construction Year", property["year"] ?? "-"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: "Property Specifications",
                  icon: Icons.dashboard_outlined,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.7,
                    children: [
                      _specItem(
                        Icons.bed_outlined,
                        "Bedrooms",
                        property["bedrooms"] ?? "-",
                      ),
                      _specItem(
                        Icons.bathtub_outlined,
                        "Bathrooms",
                        property["bathrooms"] ?? "-",
                      ),
                      _specItem(
                        Icons.layers_outlined,
                        "Floors",
                        property["floors"] ?? "-",
                      ),
                      _specItem(
                        Icons.directions_car_outlined,
                        "Parking",
                        property["parking"] ?? "-",
                      ),
                      _specItem(
                        Icons.chair_outlined,
                        "Furnishing",
                        property["furnishing"] ?? "-",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: "Location",
                  icon: Icons.location_on_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locationRow(
                        Icons.location_city_outlined,
                        "City",
                        property["location"] ?? "-",
                      ),
                      const SizedBox(height: 14),
                      _locationRow(
                        Icons.place_outlined,
                        "Address",
                        property["address"] ?? "-",
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 130,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: AppColors.primary,
                              size: 35,
                            ),
                            SizedBox(height: 7),
                            Text(
                              "Property Location",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Map integration can be connected here",
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
                const SizedBox(height: 16),
                _sectionCard(
                  title: "Amenities",
                  icon: Icons.star_border_rounded,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (property["amenities"] as List<dynamic>? ?? [])
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              item.toString(),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: "Description",
                  icon: Icons.description_outlined,
                  child: Text(
                    property["description"] ?? "No description available.",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: "Listing Performance",
                  icon: Icons.insights_outlined,
                  child: Row(
                    children: [
                      _performanceItem(
                        Icons.visibility_outlined,
                        property["views"] ?? "0",
                        "Views",
                      ),
                      _performanceItem(
                        Icons.chat_bubble_outline_rounded,
                        property["inquiries"] ?? "0",
                        "Inquiries",
                      ),
                      _performanceItem(
                        Icons.calendar_today_outlined,
                        property["visits"] ?? "0",
                        "Visits",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _editProperty,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text("Edit Property"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _changeStatus,
                        icon: const Icon(Icons.sync_alt_rounded, size: 18),
                        label: const Text("Change Status"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
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
    );
  }

  Widget _propertyImage() {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.asset(
        property["image"] ?? "assets/House.png",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.background,
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 50,
                color: AppColors.textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.textSecondary;

    if (status == "Active") {
      color = AppColors.success;
    } else if (status == "Pending") {
      color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _verificationCard(String verification) {
    final verified = verification == "Verified";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: verified
            ? AppColors.success.withValues(alpha: 0.07)
            : AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: verified
              ? AppColors.success.withValues(alpha: 0.20)
              : AppColors.warning.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.pending_outlined,
            color: verified ? AppColors.success : AppColors.warning,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verified ? "Property Verified" : "Verification In Progress",
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  verified
                      ? "Documents have been verified."
                      : "Documents are currently being reviewed.",
                  style: const TextStyle(
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

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _performanceItem(IconData icon, String value, String title) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _editProperty() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Edit property option selected"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _changeStatus() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Change Property Status",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              _statusOption("Active", AppColors.success),
              _statusOption("Inactive", AppColors.textSecondary),
              _statusOption("Pending", AppColors.warning),
            ],
          ),
        );
      },
    );
  }

  Widget _statusOption(String status, Color color) {
    return ListTile(
      onTap: () {
        setState(() {
          property["status"] = status;
        });
        Navigator.pop(context);
      },
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.10),
        child: Icon(Icons.circle, color: color, size: 10),
      ),
      title: Text(
        status,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: AppColors.textSecondary,
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                ),
                title: const Text("Edit Property"),
                onTap: () {
                  Navigator.pop(context);
                  _editProperty();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share_outlined,
                  color: AppColors.primary,
                ),
                title: const Text("Share Property"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                title: const Text(
                  "Delete Property",
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteProperty();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProperty() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Property?"),
          content: const Text("Are you sure you want to delete this property?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  MyRoutes.brokerPropertiesRoute,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
