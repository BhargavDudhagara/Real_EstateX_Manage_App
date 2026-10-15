import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/broker_bottom_navbar.dart';

class BrokerVisitsPage extends StatefulWidget {
  const BrokerVisitsPage({super.key});

  @override
  State<BrokerVisitsPage> createState() => _BrokerVisitsPageState();
}

class _BrokerVisitsPageState extends State<BrokerVisitsPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";

  final List<Map<String, dynamic>> visits = [
    {
      "id": "VIS001",
      "buyer": "Bhargav Patel",
      "phone": "+91 98765 43210",
      "property": "Modern Family House",
      "image": "assets/House.png",
      "location": "Rajkot, Gujarat",
      "date": "28 Sep 2026",
      "time": "11:00 AM",
      "type": "Property Visit",
      "status": "Pending",
      "message": "I would like to visit the property with my family.",
      "notes": "Buyer is interested in the property.",
    },
    {
      "id": "VIS002",
      "buyer": "Rahul Shah",
      "phone": "+91 98252 12345",
      "property": "Premium City Apartment",
      "image": "assets/Apartment.png",
      "location": "Ahmedabad, Gujarat",
      "date": "29 Sep 2026",
      "time": "02:00 PM",
      "type": "Property Visit",
      "status": "Approved",
      "message": "Please arrange the visit in the afternoon.",
      "notes": "Bring apartment documents.",
    },
    {
      "id": "VIS003",
      "buyer": "Amit Joshi",
      "phone": "+91 98790 45678",
      "property": "Premium Garden Villa",
      "image": "assets/Vila.png",
      "location": "Gandhinagar, Gujarat",
      "date": "30 Sep 2026",
      "time": "10:30 AM",
      "type": "Property Visit",
      "status": "Completed",
      "message": "Interested in the villa.",
      "notes": "Visit completed successfully.",
    },
    {
      "id": "VIS004",
      "buyer": "Neha Mehta",
      "phone": "+91 99090 11223",
      "property": "Green Valley Farm",
      "image": "assets/farm.png",
      "location": "Rajkot, Gujarat",
      "date": "02 Oct 2026",
      "time": "04:00 PM",
      "type": "Property Visit",
      "status": "Cancelled",
      "message": "Unable to attend on the requested date.",
      "notes": "Buyer cancelled the visit.",
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredVisits {
    final search = searchController.text.toLowerCase().trim();

    return visits.where((visit) {
      final matchesSearch =
          visit["buyer"].toString().toLowerCase().contains(search) ||
          visit["property"].toString().toLowerCase().contains(search) ||
          visit["location"].toString().toLowerCase().contains(search);

      final matchesFilter =
          selectedFilter == "All" || visit["status"] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Color statusColor(String status) {
    switch (status) {
      case "Approved":
        return AppColors.success;
      case "Completed":
        return AppColors.primary;
      case "Cancelled":
        return AppColors.error;
      case "Pending":
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  void openVisitDetails(Map<String, dynamic> visit) {
    Navigator.pushNamed(context, MyRoutes.visitDetailsRoute, arguments: visit);
  }

  void updateStatus(int index, String status) {
    setState(() {
      visits[index]["status"] = status;
    });
  }

  void showRejectDialog(int index) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject Visit"),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter rejection reason",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  visits[index]["status"] = "Cancelled";
                  visits[index]["notes"] = controller.text.trim().isEmpty
                      ? "Visit rejected by broker."
                      : controller.text.trim();
                });

                controller.dispose();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Visits",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Manage property visits",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MyRoutes.brokerCalendarRoute,
                  arguments: visits,
                );
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primary,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search buyer or property",
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
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
          ),

          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: ["All", "Pending", "Approved", "Completed", "Cancelled"]
                  .map((filter) {
                    final selected = selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredVisits.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy_outlined,
                          size: 52,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "No visits found",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Try another search or filter.",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                    itemCount: filteredVisits.length,
                    itemBuilder: (context, index) {
                      final visit = filteredVisits[index];

                      final originalIndex = visits.indexOf(visit);

                      final status = visit["status"].toString();

                      final color = statusColor(status);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            openVisitDetails(visit);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        visit["image"],
                                        width: 78,
                                        height: 78,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 78,
                                                height: 78,
                                                color: AppColors.background,
                                                child: const Icon(
                                                  Icons.home_outlined,
                                                  color: AppColors.primary,
                                                ),
                                              );
                                            },
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  visit["property"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 9,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: color.withValues(
                                                    alpha: 0.1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  status,
                                                  style: TextStyle(
                                                    color: color,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 7),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.person_outline_rounded,
                                                size: 16,
                                                color: AppColors.textSecondary,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  visit["buyer"],
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 4),

                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                                color: AppColors.textSecondary,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  visit["location"],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 12,
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
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 17,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        child: Text(
                                          visit["date"],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.access_time_outlined,
                                        size: 17,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        visit["time"],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                if (status == "Pending") ...[
                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            showRejectDialog(originalIndex);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.error,
                                            side: const BorderSide(
                                              color: AppColors.error,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text("Reject"),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            updateStatus(
                                              originalIndex,
                                              "Approved",
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text("Approve"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Common Broker Navbar
      bottomNavigationBar: const BrokerBottomNavbar(selectedIndex: 2),
    );
  }
}
