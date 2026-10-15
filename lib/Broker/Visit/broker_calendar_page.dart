import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';

class BrokerCalendarPage extends StatefulWidget {
  const BrokerCalendarPage({super.key});

  @override
  State<BrokerCalendarPage> createState() => _BrokerCalendarPageState();
}

class _BrokerCalendarPageState extends State<BrokerCalendarPage> {
  late DateTime selectedDate;
  late DateTime displayedMonth;

  List<Map<String, dynamic>> visits = [];

  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      selectedDate = DateTime.now();
      displayedMonth = DateTime(selectedDate.year, selectedDate.month);

      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is List) {
        visits = args
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      } else {
        visits = [
          {
            "id": "VIS001",
            "buyer": "Bhargav Patel",
            "property": "Modern Family House",
            "date": "28 Sep 2026",
            "time": "11:00 AM",
            "status": "Pending",
            "image": "assets/House.png",
          },
          {
            "id": "VIS002",
            "buyer": "Rahul Shah",
            "property": "Premium City Apartment",
            "date": "29 Sep 2026",
            "time": "02:00 PM",
            "status": "Approved",
            "image": "assets/Apartment.png",
          },
          {
            "id": "VIS003",
            "buyer": "Amit Joshi",
            "property": "Premium Garden Villa",
            "date": "30 Sep 2026",
            "time": "10:30 AM",
            "status": "Completed",
            "image": "assets/Vila.png",
          },
        ];
      }

      initialized = true;
    }
  }

  DateTime? parseVisitDate(String date) {
    final parts = date.split(" ");

    if (parts.length < 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);

    final months = {
      "Jan": 1,
      "Feb": 2,
      "Mar": 3,
      "Apr": 4,
      "May": 5,
      "Jun": 6,
      "Jul": 7,
      "Aug": 8,
      "Sep": 9,
      "Oct": 10,
      "Nov": 11,
      "Dec": 12,
    };

    final month = months[parts[1]];
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  List<Map<String, dynamic>> get selectedDayVisits {
    return visits.where((visit) {
      final date = parseVisitDate(visit["date"]);

      if (date == null) {
        return false;
      }

      return date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
    }).toList();
  }

  bool hasVisit(DateTime date) {
    return visits.any((visit) {
      final visitDate = parseVisitDate(visit["date"]);

      if (visitDate == null) {
        return false;
      }

      return visitDate.year == date.year &&
          visitDate.month == date.month &&
          visitDate.day == date.day;
    });
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

  void changeMonth(int value) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _monthName(displayedMonth.month);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Calendar",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Manage your visit schedule",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => changeMonth(-1),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "$monthName ${displayedMonth.year}",
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => changeMonth(1),
                      icon: const Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(child: _WeekDay(text: "Mon")),
                    Expanded(child: _WeekDay(text: "Tue")),
                    Expanded(child: _WeekDay(text: "Wed")),
                    Expanded(child: _WeekDay(text: "Thu")),
                    Expanded(child: _WeekDay(text: "Fri")),
                    Expanded(child: _WeekDay(text: "Sat")),
                    Expanded(child: _WeekDay(text: "Sun")),
                  ],
                ),
                const SizedBox(height: 8),
                _buildCalendarGrid(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Visits on ${selectedDate.day} ${_monthName(selectedDate.month)}",
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (selectedDayVisits.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 38,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "No visits scheduled",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "There are no property visits for this date.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ...selectedDayVisits.map((visit) => _visitCard(visit)),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    int startingWeekday = firstDay.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 42,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - startingWeekday + 2;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox();
        }

        final date = DateTime(
          displayedMonth.year,
          displayedMonth.month,
          dayNumber,
        );

        final isSelected =
            date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

        final isToday =
            date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

        final visitExists = hasVisit(date);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "$dayNumber",
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isToday
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.w500,
                  ),
                ),
                if (visitExists)
                  Positioned(
                    bottom: 5,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _visitCard(Map<String, dynamic> visit) {
    final status = visit["status"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              visit["image"],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit["property"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  visit["buyer"],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      visit["time"],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor(status),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return months[month - 1];
  }
}

class _WeekDay extends StatelessWidget {
  final String text;

  const _WeekDay({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
