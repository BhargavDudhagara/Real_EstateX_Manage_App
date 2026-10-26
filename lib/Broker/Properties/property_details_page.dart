import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/services/property_service.dart';
import 'package:app/models/property_model.dart';

class PropertyDetailsPage extends StatefulWidget {
  const PropertyDetailsPage({super.key});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  Map<String, dynamic> property = {};
  final PropertyService _propertyService = PropertyService();

  String get _propertyId {
    return (property['id'] ??
            property['propertyId'] ??
            property['documentId'] ??
            '')
        .toString()
        .trim();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is PropertyModel) {
      property = {...arguments.toMap(), 'id': arguments.id};
    } else if (arguments is Map) {
      property = Map<String, dynamic>.from(arguments);

      // Support a Firestore DocumentSnapshot passed as an argument.
      final snapshot = property['documentSnapshot'];
      if (_propertyId.isEmpty && snapshot is DocumentSnapshot) {
        property['id'] = snapshot.id;
      }
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

    final approval = _approvalState();
    final status = approval;
    final verification = approval == "Approved" ? "Verified" : approval;

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
                const SizedBox(height: 16),
                _highlightsRow(),
                const SizedBox(height: 20),
                _verificationCard(verification),
                const SizedBox(height: 22),
                _sectionCard(
                  title: "Property Overview",
                  icon: Icons.home_work_outlined,
                  child: Column(
                    children: [
                      _detailRow(
                        "Property ID",
                        _propertyId.isEmpty ? "-" : _propertyId,
                      ),
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
                  child: (property["amenities"] as List<dynamic>? ?? []).isEmpty
                      ? const Text(
                          "No amenities added.",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              (property["amenities"] as List<dynamic>? ?? [])
                                  .map(
                                    (item) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
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
                  title: "Listing Information",
                  icon: Icons.info_outline_rounded,
                  child: Column(
                    children: [
                      _detailRow("Approval Status", approval),
                      _detailRow(
                        "Listed On",
                        _formatDate(property["createdAt"]),
                      ),
                      _detailRow(
                        "Last Updated",
                        _formatDate(property["updatedAt"]),
                      ),
                      _detailRow("Furnishing", property["furnishing"] ?? "-"),
                    ],
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
                        "${property["views"] ?? "0"}",
                        "Views",
                      ),
                      _performanceItem(
                        Icons.chat_bubble_outline_rounded,
                        "${property["inquiries"] ?? "0"}",
                        "Inquiries",
                      ),
                      _performanceItem(
                        Icons.calendar_today_outlined,
                        "${property["visits"] ?? "0"}",
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _lower(dynamic value) => (value ?? "").toString().trim().toLowerCase();

  bool _isTrue(dynamic value) => value == true || _lower(value) == "true";

  String _approvalState() {
    final status = _lower(property["status"]);
    final verification = _lower(property["verification"]);
    final verificationStatus = _lower(property["verificationStatus"]);

    if (status == "rejected" ||
        verification == "rejected" ||
        verificationStatus == "rejected") {
      return "Rejected";
    }

    if (_isTrue(property["isApproved"]) ||
        _isTrue(property["isVerified"]) ||
        _isTrue(property["verified"]) ||
        const ["approved", "active", "verified"].contains(status) ||
        const ["approved", "verified"].contains(verification) ||
        const ["approved", "verified"].contains(verificationStatus)) {
      return "Approved";
    }

    return "Pending";
  }

  String _formatDate(dynamic value) {
    DateTime? date;

    try {
      if (value is DateTime) {
        date = value;
      } else if (value is Timestamp) {
        date = value.toDate();
      } else if (value is String) {
        date = DateTime.tryParse(value);
      } else if (value is int) {
        date = DateTime.fromMillisecondsSinceEpoch(value);
      }
    } catch (_) {
      date = null;
    }

    if (date == null) return "-";

    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final local = date.toLocal();
    return "${local.day} ${months[local.month - 1]} ${local.year}";
  }

  Widget _highlightsRow() {
    return Row(
      children: [
        _highlightChip(
          Icons.bed_outlined,
          "${property["bedrooms"] ?? "-"} Beds",
        ),
        const SizedBox(width: 8),
        _highlightChip(
          Icons.bathtub_outlined,
          "${property["bathrooms"] ?? "-"} Baths",
        ),
        const SizedBox(width: 8),
        _highlightChip(
          Icons.square_foot_outlined,
          "${property["area"] ?? "-"}",
        ),
      ],
    );
  }

  Widget _highlightChip(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 16),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _propertyImage() {
    final imageUrl = (property["image"] ?? "").toString();

    if (imageUrl.isEmpty) {
      return _imagePlaceholder();
    }

    if (imageUrl.startsWith('http')) {
      return SizedBox(
        height: 250,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _imagePlaceholder(),
        ),
      );
    }

    if (imageUrl.startsWith('data:image')) {
      try {
        return SizedBox(
          height: 250,
          width: double.infinity,
          child: Image.memory(
            base64Decode(imageUrl.split(',').last),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => _imagePlaceholder(),
          ),
        );
      } catch (_) {
        return _imagePlaceholder();
      }
    }

    final localFile = File(imageUrl);
    if (localFile.existsSync()) {
      return SizedBox(
        height: 250,
        width: double.infinity,
        child: Image.file(
          localFile,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _imagePlaceholder(),
        ),
      );
    }

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 250,
      width: double.infinity,
      color: AppColors.background,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.textSecondary;

    if (status == "Approved" || status == "Active") {
      color = AppColors.success;
    } else if (status == "Pending") {
      color = AppColors.warning;
    } else if (status == "Rejected") {
      color = AppColors.error;
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
    final rejected = verification == "Rejected";
    final Color color = verified
        ? AppColors.success
        : rejected
        ? AppColors.error
        : AppColors.warning;
    final IconData icon = verified
        ? Icons.verified_rounded
        : rejected
        ? Icons.cancel_outlined
        : Icons.pending_outlined;
    final String title = verified
        ? "Property Verified"
        : rejected
        ? "Verification Rejected"
        : "Verification In Progress";
    final String message = verified
        ? "Documents have been verified."
        : rejected
        ? "Admin rejected this listing. Edit the property and submit again."
        : "Documents are currently being reviewed.";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
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
    Navigator.pushNamed(
      context,
      MyRoutes.addPropertyRoute,
      arguments: property,
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
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
                  Navigator.pop(sheetContext);
                  _editProperty();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share_outlined,
                  color: AppColors.primary,
                ),
                title: const Text("Share Property"),
                onTap: () => Navigator.pop(sheetContext),
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
                  Navigator.pop(sheetContext);
                  _deleteProperty();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteProperty() async {
    final propertyId = _propertyId;

    if (propertyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Property ID not found. Open the property from your Broker Properties list.",
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Property?"),
        content: const Text("Are you sure you want to delete this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _propertyService.deleteProperty(propertyId);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Property deleted successfully"),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(
        context,
      ).pushReplacementNamed(MyRoutes.brokerPropertiesRoute);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting property: $e"),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }
}
