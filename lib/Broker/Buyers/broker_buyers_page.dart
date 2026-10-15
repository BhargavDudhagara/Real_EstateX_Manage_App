import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/broker_bottom_navbar.dart';

class BrokerBuyersPage extends StatefulWidget {
  const BrokerBuyersPage({super.key});

  @override
  State<BrokerBuyersPage> createState() => _BrokerBuyersPageState();
}

class _BrokerBuyersPageState extends State<BrokerBuyersPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";

  final List<Map<String, dynamic>> buyers = [
    {
      "id": "BUY001",
      "name": "Bhargav Patel",
      "phone": "+91 98765 43210",
      "email": "bhargav@example.com",
      "location": "Rajkot, Gujarat",
      "status": "Active",
      "interest": "High",
      "property": "Modern Family House",
      "propertyType": "House",
      "budget": "₹70 Lakh - ₹1 Cr",
      "lastContact": "27 Sep 2026",
      "visits": 3,
      "inquiries": 5,
      "image": "assets/House.png",
      "note": "Looking for a family house in Rajkot.",
    },
    {
      "id": "BUY002",
      "name": "Rahul Shah",
      "phone": "+91 98765 11223",
      "email": "rahul@example.com",
      "location": "Ahmedabad, Gujarat",
      "status": "Active",
      "interest": "High",
      "property": "Premium City Apartment",
      "propertyType": "Apartment",
      "budget": "₹60 Lakh - ₹90 Lakh",
      "lastContact": "26 Sep 2026",
      "visits": 2,
      "inquiries": 4,
      "image": "assets/Apartment.png",
      "note": "Interested in a furnished apartment.",
    },
    {
      "id": "BUY003",
      "name": "Amit Joshi",
      "phone": "+91 98765 77889",
      "email": "amit@example.com",
      "location": "Gandhinagar, Gujarat",
      "status": "Active",
      "interest": "Medium",
      "property": "Premium Garden Villa",
      "propertyType": "Villa",
      "budget": "₹1 Cr - ₹1.5 Cr",
      "lastContact": "24 Sep 2026",
      "visits": 1,
      "inquiries": 3,
      "image": "assets/Vila.png",
      "note": "Looking for a premium villa.",
    },
    {
      "id": "BUY004",
      "name": "Neha Mehta",
      "phone": "+91 98765 33445",
      "email": "neha@example.com",
      "location": "Rajkot, Gujarat",
      "status": "Inactive",
      "interest": "Low",
      "property": "Green Valley Farm",
      "propertyType": "Farm",
      "budget": "₹80 Lakh - ₹1.2 Cr",
      "lastContact": "18 Sep 2026",
      "visits": 1,
      "inquiries": 2,
      "image": "assets/farm.png",
      "note": "Looking for a farm property.",
    },
    {
      "id": "BUY005",
      "name": "Karan Desai",
      "phone": "+91 98765 55667",
      "email": "karan@example.com",
      "location": "Rajkot, Gujarat",
      "status": "Active",
      "interest": "Medium",
      "property": "Modern Family House",
      "propertyType": "House",
      "budget": "₹50 Lakh - ₹80 Lakh",
      "lastContact": "22 Sep 2026",
      "visits": 2,
      "inquiries": 2,
      "image": "assets/House1.png",
      "note": "Looking for an affordable family home.",
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredBuyers {
    final query = searchController.text.trim().toLowerCase();

    return buyers.where((buyer) {
      final matchesSearch =
          buyer["name"].toString().toLowerCase().contains(query) ||
          buyer["property"].toString().toLowerCase().contains(query) ||
          buyer["location"].toString().toLowerCase().contains(query);

      bool matchesFilter = true;

      if (selectedFilter == "Active") {
        matchesFilter = buyer["status"] == "Active";
      } else if (selectedFilter == "Inactive") {
        matchesFilter = buyer["status"] == "Inactive";
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
                      CircleAvatar(
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
                        Icons.phone_outlined,
                        "Phone",
                        buyer["phone"],
                      ),
                      _buildDetailRow(
                        Icons.email_outlined,
                        "Email",
                        buyer["email"],
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
                    title: "Requirement",
                    children: [
                      _buildDetailRow(
                        Icons.home_work_outlined,
                        "Property",
                        buyer["property"],
                      ),
                      _buildDetailRow(
                        Icons.category_outlined,
                        "Property Type",
                        buyer["propertyType"],
                      ),
                      _buildDetailRow(
                        Icons.currency_rupee_rounded,
                        "Budget",
                        buyer["budget"],
                      ),
                      _buildDetailRow(
                        Icons.star_outline_rounded,
                        "Interest",
                        buyer["interest"],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildDetailSection(
                    title: "Activity",
                    children: [
                      _buildDetailRow(
                        Icons.calendar_month_outlined,
                        "Last Contact",
                        buyer["lastContact"],
                      ),
                      _buildDetailRow(
                        Icons.visibility_outlined,
                        "Visits",
                        buyer["visits"].toString(),
                      ),
                      _buildDetailRow(
                        Icons.question_answer_outlined,
                        "Inquiries",
                        buyer["inquiries"].toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildDetailSection(
                    title: "Broker Note",
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          buyer["note"],
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone_outlined, size: 19),
                          label: const Text("Call"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.email_outlined, size: 19),
                          label: const Text("Email"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
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
    final bool active = status == "Active";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 9 : 11,
        vertical: isSmall ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: active
            ? AppColors.success.withValues(alpha: 0.10)
            : AppColors.textSecondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: isSmall ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: active ? AppColors.success : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInterestBadge(String interest) {
    Color color;

    if (interest == "High") {
      color = AppColors.error;
    } else if (interest == "Medium") {
      color = AppColors.warning;
    } else {
      color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$interest Interest",
        style: TextStyle(
          fontSize: 10,
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
                CircleAvatar(
                  radius: 27,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                  child: Text(
                    buyer["name"].toString().substring(0, 1).toUpperCase(),
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
                      const SizedBox(height: 7),
                      _buildInterestBadge(buyer["interest"]),
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
              child: Row(
                children: [
                  const Icon(
                    Icons.home_work_outlined,
                    size: 19,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buyer["property"],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          buyer["budget"],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                    Icons.calendar_month_outlined,
                    "${buyer["visits"]}",
                    "Visits",
                  ),
                ),
                Expanded(
                  child: _buildMiniStat(
                    Icons.question_answer_outlined,
                    "${buyer["inquiries"]}",
                    "Inquiries",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
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
    final activeBuyers = buyers
        .where((buyer) => buyer["status"] == "Active")
        .length;

    final highInterestBuyers = buyers
        .where((buyer) => buyer["interest"] == "High")
        .length;

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
                  hintText: "Search buyer, property or location",
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
                _buildFilterChip("Inactive"),
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
                    value: "${buyers.length}",
                    icon: Icons.people_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    title: "Active",
                    value: "$activeBuyers",
                    icon: Icons.person_outline_rounded,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    title: "High Interest",
                    value: "$highInterestBuyers",
                    icon: Icons.star_outline_rounded,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: filteredBuyers.isEmpty
                ? const Center(
                    child: Text(
                      "No buyers found",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: filteredBuyers.length,
                    itemBuilder: (context, index) {
                      return _buildBuyerCard(filteredBuyers[index]);
                    },
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
