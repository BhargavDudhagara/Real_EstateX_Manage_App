import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class VisitBooking {
  final String image;
  final String propertyName;
  final String location;
  final String price;

  final String brokerName;
  final String brokerImage;
  final String brokerPhone;
  final String brokerEmail;
  final String brokerRating;

  final String visitorName;
  final String mobileNumber;

  final DateTime date;
  final String time;

  final int numberOfVisitors;
  final String purpose;
  final String message;
  final String contactMethod;

  String status;

  VisitBooking({
    required this.image,
    required this.propertyName,
    required this.location,
    required this.price,
    required this.brokerName,
    required this.brokerImage,
    required this.brokerPhone,
    required this.brokerEmail,
    required this.brokerRating,
    required this.visitorName,
    required this.mobileNumber,
    required this.date,
    required this.time,
    required this.numberOfVisitors,
    required this.purpose,
    required this.message,
    required this.contactMethod,
    required this.status,
  });
}

class VisitStore {
  static final List<VisitBooking> bookings = [
    VisitBooking(
      image: 'assets/House1.png',
      propertyName: 'Luxury Family Home',
      location: 'Ahmedabad, Gujarat',
      price: '₹92 Lakh',
      brokerName: 'Dhruval',
      brokerImage: 'assets/Dhruval_Broker.png',
      brokerPhone: '+91 98765 43210',
      brokerEmail: 'dhruval@estatex.com',
      brokerRating: '4.9',
      visitorName: 'Bhargav',
      mobileNumber: '9876543210',
      date: DateTime.now().add(const Duration(days: 2)),
      time: '11:00 AM',
      numberOfVisitors: 2,
      purpose: 'Buying',
      message: '',
      contactMethod: 'App',
      status: 'Completed',
    ),
  ];

  static bool isSlotBooked({
    required String brokerName,
    required DateTime date,
    required String time,
  }) {
    for (final booking in bookings) {
      if (booking.brokerName == brokerName &&
          booking.date.year == date.year &&
          booking.date.month == date.month &&
          booking.date.day == date.day &&
          booking.time == time &&
          booking.status != 'Cancelled') {
        return true;
      }
    }

    return false;
  }
}

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color statusColor(String status) {
    if (status == 'Confirmed') {
      return AppColors.success;
    }

    if (status == 'Cancelled') {
      return AppColors.error;
    }

    if (status == 'Completed') {
      return AppColors.primary;
    }

    return AppColors.warning;
  }

  void showBrokerDetails(VisitBooking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(booking.brokerImage),
                ),
                const SizedBox(height: 10),
                Text(
                  booking.brokerName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Verified Broker',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.brokerRating,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                brokerInfoRow(Icons.phone_outlined, booking.brokerPhone),
                const SizedBox(height: 10),
                brokerInfoRow(Icons.email_outlined, booking.brokerEmail),
                const SizedBox(height: 10),
                brokerInfoRow(Icons.home_outlined, booking.propertyName),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Call feature coming soon'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone_outlined),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Message feature coming soon'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget brokerInfoRow(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void cancelVisit(VisitBooking booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Visit?'),
          content: const Text(
            'Are you sure you want to cancel this property visit?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  booking.status = 'Cancelled';
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Visit cancelled successfully')),
                );
              },
              child: const Text(
                'Cancel Visit',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void rescheduleVisit(VisitBooking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reschedule feature will be added next')),
    );
  }

  void startDeal(VisitBooking booking) {
    Navigator.pushNamed(
      context,
      MyRoutes.buyerDealRequestRoute,
      arguments: {
        'property': booking.propertyName,
        'price': booking.price,
        'location': booking.location,
        'broker': booking.brokerName,
        'image': booking.image,
        'brokerPhone': booking.brokerPhone,
        'brokerEmail': booking.brokerEmail,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'My Visits',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // ==================== CALCULATOR BUTTON ====================
          // IconButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, MyRoutes.calculatorRoute);
          //   },
          //   icon: const Icon(
          //     Icons.calculate_outlined,
          //     color: AppColors.textPrimary,
          //   ),
          // ),

          // ==================== NOTIFICATION BUTTON ====================
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
      body: VisitStore.bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 70,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'No property visits',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your booked visits will appear here',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              itemCount: VisitStore.bookings.length,
              itemBuilder: (context, index) {
                final booking = VisitStore.bookings[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              booking.image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking.propertyName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
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
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        booking.location,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  booking.price,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor(
                                      booking.status,
                                    ).withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    booking.status,
                                    style: TextStyle(
                                      color: statusColor(booking.status),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.primary,
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatDate(booking.date),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 18),
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppColors.primary,
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              booking.time,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(booking.brokerImage),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Broker',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  booking.brokerName,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${booking.numberOfVisitors} Visitor'
                            '${booking.numberOfVisitors > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showBrokerDetails(booking);
                          },
                          icon: const Icon(
                            Icons.person_outline_rounded,
                            size: 19,
                          ),
                          label: const Text(
                            'Broker Details',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                        ),
                      ),

                      if (booking.status != 'Cancelled') ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  rescheduleVisit(booking);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                                child: const Text('Reschedule'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  cancelVisit(booking);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(
                                    color: AppColors.error,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                                child: const Text('Cancel Visit'),
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (booking.status == 'Completed') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              startDeal(booking);
                            },
                            icon: const Icon(
                              Icons.handshake_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              'Start Deal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (booking.status == 'Pending') ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.warning,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Waiting for broker confirmation',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
