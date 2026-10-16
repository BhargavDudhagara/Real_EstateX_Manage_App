import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/broker_bottom_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrokerBuyersPage extends StatefulWidget {
  const BrokerBuyersPage({super.key});

  @override
  State<BrokerBuyersPage> createState() => _BrokerBuyersPageState();
}

class _BrokerBuyersPageState extends State<BrokerBuyersPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> buyers = [];
  bool isLoading = true;
  StreamSubscription<QuerySnapshot>? _buyersSubscription;

  @override
  void initState() {
    super.initState();
    _setupBuyersListener();
  }

  void _setupBuyersListener() {
    setState(() {
      isLoading = true;
    });

    _buyersSubscription = _firestore
        .collection('users')
        .where('role', isEqualTo: 'Buyer')
        .snapshots(includeMetadataChanges: false)
        .listen(
          (snapshot) {
            if (mounted) {
              setState(() {
                buyers = snapshot.docs.map((doc) {
                  final data = doc.data();
                  final createdAt = data['createdAt'] as Timestamp?;

                  String lastContact = 'N/A';
                  if (createdAt != null) {
                    final date = createdAt.toDate();
                    lastContact =
                        '${date.day} ${_getMonthName(date.month)} ${date.year}';
                  }

                  return {
                    "id": data['uid'] ?? doc.id,
                    "name": data['name'] ?? 'Unknown',
                    "phone": data['phone'] ?? 'No phone',
                    "email": data['email'] ?? 'No email',
                    "location": data['location'] ?? 'Unknown',
                    "status": data['status'] ?? 'Active',
                    "interest": _mapActivityToInterest(data),
                    "property": data['interestedProperty'] ?? 'Not specified',
                    "propertyType": data['propertyType'] ?? 'Not specified',
                    "budget": data['budget'] ?? 'Not specified',
                    "lastContact": lastContact,
                    "visits": data['visitsBooked'] ?? 0,
                    "inquiries": data['propertiesViewed'] ?? 0,
                    "image": data['profileImage'] ?? '',
                    "note": _generateNote(data),
                    "purchasedProperties": data['purchasedProperties'] ?? [],
                  };
                }).toList();
                isLoading = false;
              });
            }
          },
          onError: (e) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading buyers: $e'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _mapActivityToInterest(Map<String, dynamic> data) {
    final visits = data['visitsBooked'] ?? 0;
    final viewed = data['propertiesViewed'] ?? 0;
    final wishlist = data['wishlist'] ?? 0;

    final totalActivity = visits + viewed + wishlist;
    if (totalActivity >= 10) return 'High';
    if (totalActivity >= 5) return 'Medium';
    return 'Low';
  }

  String _generateNote(Map<String, dynamic> data) {
    final location = data['location'] ?? 'Unknown location';
    final joined = data['createdAt'] as Timestamp?;
    if (joined != null) {
      final date = joined.toDate();
      return 'User from $location, joined in ${date.year}';
    }
    return 'User from $location';
  }

  Future<void> _refreshBuyers() async {
    _buyersSubscription?.cancel();
    buyers.clear();
    setState(() {
      isLoading = true;
    });
    _setupBuyersListener();
  }

  @override
  void dispose() {
    searchController.dispose();
    _buyersSubscription?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredBuyers {
    final query = searchController.text.trim().toLowerCase();

    return buyers.where((buyer) {
      final matchesSearch =
          buyer["name"].toString().toLowerCase().contains(query) ||
          buyer["email"].toString().toLowerCase().contains(query) ||
          buyer["location"].toString().toLowerCase().contains(query);

      bool matchesFilter = true;

      if (selectedFilter == "Active") {
        matchesFilter = buyer["status"] == "Active";
      } else if (selectedFilter == "Inactive/Blocked") {
        matchesFilter =
            buyer["status"] == "Inactive" || buyer["status"] == "Blocked";
      } else if (selectedFilter == "High") {
        matchesFilter = buyer["interest"] == "High";
      } else if (selectedFilter == "Medium") {
        matchesFilter = buyer["interest"] == "Medium";
      } else if (selectedFilter == "Low") {
        matchesFilter = buyer["interest"] == "Low";
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void showBuyerDetails(Map<String, dynamic> buyer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      buyer["image"] != null &&
                              buyer["image"].toString().isNotEmpty
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(buyer["image"]),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.10,
                              ),
                              child: Text(
                                buyer["name"]
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buyer["name"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              buyer["id"],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(buyer["status"], isSmall: false),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildDetailSection(
                    title: "Contact Information",
                    children: [
                      _buildDetailRow(
                        Icons.email_outlined,
                        "Email",
                        buyer["email"],
                      ),
                      _buildDetailRow(
                        Icons.phone_outlined,
                        "Phone",
                        buyer["phone"],
                      ),
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        "Location",
                        buyer["location"],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildDetailSection(
                    title: "Property Interest",
                    children: [
                      _buildDetailRow(
                        Icons.home_work_outlined,
                        "Property Type",
                        buyer["propertyType"],
                      ),
                      _buildDetailRow(
                        Icons.description_outlined,
                        "Interested Property",
                        buyer["property"],
                      ),
                      _buildDetailRow(
                        Icons.currency_rupee_rounded,
                        "Budget",
                        buyer["budget"],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildDetailSection(
                    title: "Purchased Properties",
                    children: [
                      if (buyer["purchasedProperties"] != null &&
                          (buyer["purchasedProperties"] as List).isNotEmpty)
                        ...((buyer["purchasedProperties"] as List)
                            .map<Widget>(
                              (property) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 18,
                                      color: AppColors.success,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        property.toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList())
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "No properties purchased yet",
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildDetailSection(
                    title: "Account Details",
                    children: [
                      _buildDetailRow(
                        Icons.badge_outlined,
                        "User ID",
                        buyer["id"],
                      ),
                      _buildDetailRow(Icons.person_outline, "Role", "Buyer"),
                      _buildDetailRow(
                        Icons.calendar_today_outlined,
                        "Joined",
                        buyer["lastContact"],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 95,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, {bool isSmall = true}) {
    Color color;
    Color bgColor;

    if (status == "Active") {
      color = AppColors.success;
      bgColor = AppColors.success.withValues(alpha: 0.10);
    } else if (status == "Blocked") {
      color = AppColors.error;
      bgColor = AppColors.error.withValues(alpha: 0.10);
    } else {
      color = AppColors.textSecondary;
      bgColor = AppColors.textSecondary.withValues(alpha: 0.10);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 9 : 11,
        vertical: isSmall ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: isSmall ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBuyerCard(Map<String, dynamic> buyer) {
    return GestureDetector(
      onTap: () {
        showBuyerDetails(buyer);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buyer["image"] != null && buyer["image"].toString().isNotEmpty
                    ? CircleAvatar(
                        radius: 27,
                        backgroundImage: NetworkImage(buyer["image"]),
                      )
                    : CircleAvatar(
                        radius: 27,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.10,
                        ),
                        child: Text(
                          buyer["name"]
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              buyer["name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _buildStatusBadge(buyer["status"]),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              buyer["email"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              buyer["location"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
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

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.home_work_outlined,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Interested in:",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    buyer["propertyType"],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Purchased Properties:",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (buyer["purchasedProperties"] != null &&
                      (buyer["purchasedProperties"] as List).isNotEmpty)
                    ...((buyer["purchasedProperties"] as List)
                        .take(3)
                        .map<Widget>(
                          (property) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "• ${property.toString()}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        )
                        .toList())
                  else
                    const Text(
                      "No properties purchased yet",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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

  Widget _buildFilterChip(String label) {
    final bool selected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildDealRequestsChip() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyRoutes.brokerDealRequestsRoute);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.handshake_outlined,
              size: 15,
              color: AppColors.accent,
            ),
            const SizedBox(width: 6),
            const Text(
              "Deal Requests",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeBuyers = isLoading
        ? 0
        : buyers.where((buyer) => buyer["status"] == "Active").length;

    final highInterestBuyers = isLoading
        ? 0
        : buyers.where((buyer) => buyer["interest"] == "High").length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Buyers",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Manage your buyer relationships",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: "Search buyer by name or email",
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 21,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 38,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("Active"),
                _buildFilterChip("Inactive/Blocked"),
                _buildFilterChip("High"),
                _buildFilterChip("Medium"),
                _buildFilterChip("Low"),
                _buildDealRequestsChip(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: "Total Buyers",
                    value: isLoading ? "-" : "${buyers.length}",
                    icon: Icons.people_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    title: "Active",
                    value: isLoading ? "-" : "$activeBuyers",
                    icon: Icons.person_outline_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    title: "High Interest",
                    value: isLoading ? "-" : "$highInterestBuyers",
                    icon: Icons.star_outline_rounded,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredBuyers.isEmpty
                ? const Center(
                    child: Text(
                      "No buyers found",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshBuyers,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: filteredBuyers.length,
                      itemBuilder: (context, index) {
                        return _buildBuyerCard(filteredBuyers[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BrokerBottomNavbar(selectedIndex: 3),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
