import 'package:app/theme/app_colors.dart';
import 'package:app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // ==================== STATIC NOTIFICATIONS ====================

  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.calendar_month_rounded,
      'title': 'Visit Confirmed',
      'message':
          'Your visit for Luxury Family Home has been confirmed by the broker.',
      'time': '10 min ago',
      'type': 'visit',
      'isRead': false,
    },
    {
      'icon': Icons.home_work_outlined,
      'title': 'New Property Available',
      'message':
          'A new property matching your preferences is now available in Rajkot.',
      'time': '1 hour ago',
      'type': 'property',
      'isRead': false,
    },
    {
      'icon': Icons.favorite_rounded,
      'title': 'Wishlist Update',
      'message': 'The price of Modern Family House has recently been updated.',
      'time': '3 hours ago',
      'type': 'wishlist',
      'isRead': true,
    },
    {
      'icon': Icons.person_outline_rounded,
      'title': 'Broker Message',
      'message':
          'Rajesh Patel sent you an update regarding your property visit.',
      'time': 'Yesterday',
      'type': 'broker',
      'isRead': true,
    },
    {
      'icon': Icons.price_change_outlined,
      'title': 'Price Update',
      'message': 'A property in your wishlist has received a new price update.',
      'time': 'Yesterday',
      'type': 'price',
      'isRead': true,
    },
    {
      'icon': Icons.verified_outlined,
      'title': 'Profile Verified',
      'message': 'Your EstateX profile has been successfully verified.',
      'time': '2 days ago',
      'type': 'account',
      'isRead': true,
    },
  ];

  // ==================== UNREAD COUNT ====================

  int get unreadCount {
    return notifications.where((item) => item['isRead'] == false).length;
  }

  // ==================== MARK ALL AS READ ====================

  void markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }

  // ==================== MARK SINGLE NOTIFICATION ====================

  void markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  // ==================== DELETE NOTIFICATION ====================

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  // ==================== ICON COLOR ====================

  Color _getIconColor(String type) {
    switch (type) {
      case 'visit':
        return AppColors.primary;

      case 'property':
        return AppColors.accent;

      case 'wishlist':
        return AppColors.error;

      case 'broker':
        return const Color(0xFF6366F1);

      case 'price':
        return AppColors.success;

      case 'account':
        return AppColors.primary;

      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==================== APP BAR ====================
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 18,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // ==================== MARK ALL READ ====================

          /*
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          */
          const SizedBox(width: 5),
        ],
      ),

      // ==================== BODY ====================
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          // ==================== NEW ====================
          // _buildSectionTitle('New'),

          // const SizedBox(height: 10),

          // _buildNotificationCard(notifications[0]),
          // _buildNotificationCard(notifications[1]),
          const SizedBox(height: 20),

          // ==================== EARLIER ====================
          _buildSectionTitle('Earlier'),

          const SizedBox(height: 10),

          _buildNotificationCard(notifications[2]),
          _buildNotificationCard(notifications[3]),
          _buildNotificationCard(notifications[4]),
          _buildNotificationCard(notifications[5]),
        ],
      ),

      // ==================== BOTTOM NAVBAR ====================
      bottomNavigationBar: const BottomNavbar(),
    );
  }

  // ==================== SECTION TITLE ====================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ==================== NOTIFICATION CARD ====================

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'];
    final Color iconColor = _getIconColor(notification['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== ICON ====================
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(notification['icon'], color: iconColor, size: 22),
          ),

          const SizedBox(width: 12),

          // ==================== CONTENT ====================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: isRead
                              ? FontWeight.w600
                              : FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      notification['time'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  notification['message'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),

                // ==================== UNREAD ====================
                if (!isRead) ...[
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 5),

                      const Text(
                        'Unread',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== EMPTY STATE ====================

  // ignore: unused_element
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 45,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'No Notifications',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You are all caught up! New property updates, visit confirmations and other important notifications will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
