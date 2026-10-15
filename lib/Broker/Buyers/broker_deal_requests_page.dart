import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';

class BrokerDealRequestsPage extends StatefulWidget {
  const BrokerDealRequestsPage({super.key});

  @override
  State<BrokerDealRequestsPage> createState() => _BrokerDealRequestsPageState();
}

class _BrokerDealRequestsPageState extends State<BrokerDealRequestsPage> {
  final List<Map<String, dynamic>> dealRequests = [
    {
      'name': 'Bhargav Patel',
      'property': 'Modern Family House',
      'location': 'Rajkot, Gujarat',
      'price': '₹85 Lakh',
      'date': '26 Sep 2026',
      'status': 'Pending',
      'image': 'assets/House.png',
    },
    {
      'name': 'Rahul Shah',
      'property': 'Premium City Apartment',
      'location': 'Ahmedabad, Gujarat',
      'price': '₹72 Lakh',
      'date': '25 Sep 2026',
      'status': 'Pending',
      'image': 'assets/Apartment.png',
    },
    {
      'name': 'Amit Joshi',
      'property': 'Premium Garden Villa',
      'location': 'Gandhinagar, Gujarat',
      'price': '₹1.25 Cr',
      'date': '24 Sep 2026',
      'status': 'Accepted',
      'image': 'assets/Vila.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Deal Requests',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
        itemCount: dealRequests.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildDealCard(dealRequests[index]);
        },
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> deal) {
    final bool pending = deal['status'] == 'Pending';
    final bool accepted = deal['status'] == 'Accepted';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  deal['image'],
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal['property'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      deal['name'],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deal['price'],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(deal['status'], pending, accepted),
            ],
          ),

          const SizedBox(height: 12),

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
                  deal['location'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                deal['date'],
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (pending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _rejectDeal(deal);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _acceptDeal(deal);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MyRoutes.brokerDealDetailsRoute,
                    arguments: deal,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View Deal Details',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, bool pending, bool accepted) {
    final Color color = pending
        ? AppColors.warning
        : accepted
        ? AppColors.success
        : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _acceptDeal(Map<String, dynamic> deal) {
    setState(() {
      deal['status'] = 'Accepted';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Deal request accepted')));
  }

  void _rejectDeal(Map<String, dynamic> deal) {
    setState(() {
      deal['status'] = 'Rejected';
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Deal request rejected')));
  }
}
