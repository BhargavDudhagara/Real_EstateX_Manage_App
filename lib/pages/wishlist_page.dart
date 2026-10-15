import 'package:app/pages/visit_page.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';
import 'package:app/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class WishlistProperty {
  final String image;
  final String name;
  final String location;
  final String price;
  final String type;
  final String brokerName;
  final String brokerImage;
  final String brokerPhone;
  final String brokerEmail;
  final String brokerRating;

  const WishlistProperty({
    required this.image,
    required this.name,
    required this.location,
    required this.price,
    required this.type,
    required this.brokerName,
    required this.brokerImage,
    required this.brokerPhone,
    required this.brokerEmail,
    required this.brokerRating,
  });
}

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final List<WishlistProperty> wishlist = [
    const WishlistProperty(
      image: 'assets/House.png',
      name: 'Modern Family House',
      location: 'Rajkot, Gujarat',
      price: '₹85 Lakh',
      type: 'House',
      brokerName: 'Hiren Makvana',
      brokerImage: 'assets/Hiren_Broker.png',
      brokerPhone: '+91 98765 43210',
      brokerEmail: 'Hiren@estatex.com',
      brokerRating: '4.9',
    ),
    const WishlistProperty(
      image: 'assets/Apartment.png',
      name: 'Premium City Apartment',
      location: 'Ahmedabad, Gujarat',
      price: '₹72 Lakh',
      type: 'Apartment',
      brokerName: ' Dhruval',
      brokerImage: 'assets/Dhruval_Broker.png',
      brokerPhone: '+91 98765 12345',
      brokerEmail: 'dhruval@estatex.com',
      brokerRating: '4.8',
    ),
    const WishlistProperty(
      image: 'assets/Vila.png',
      name: 'Premium Garden Villa',
      location: 'Gandhinagar, Gujarat',
      price: '₹1.25 Cr',
      type: 'Villa',
      brokerName: 'Bhargav',
      brokerImage: 'assets/Bhargav.png',
      brokerPhone: '+91 98765 67890',
      brokerEmail: 'bhargav@estatex.com',
      brokerRating: '4.7',
    ),
    const WishlistProperty(
      image: 'assets/Plot.png',
      name: 'Residential Plot',
      location: 'Rajkot, Gujarat',
      price: '₹38 Lakh',
      type: 'Plot',
      brokerName: 'Hiren Makvana',
      brokerImage: 'assets/Hiren_Broker.png',
      brokerPhone: '+91 98765 24680',
      brokerEmail: 'Hiren@estatex.com',
      brokerRating: '4.9',
    ),
  ];

  void removeProperty(int index) {
    setState(() {
      wishlist.removeAt(index);
    });
  }

  void openBookingForm(WishlistProperty property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return VisitBookingFormPage(property: property);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Wishlist',
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
      body: wishlist.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 70,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 14),
                  Text(
                    'No properties in wishlist',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Saved properties will appear here',
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
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final property = wishlist[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                property.image,
                                width: 105,
                                height: 105,
                                fit: BoxFit.cover,
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
                                          property.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          removeProperty(index);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
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
                                          property.location,
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    property.price,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    property.type,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(property.brokerImage),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.brokerName,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 13,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 3),
                                      const Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.star_rounded,
                                        size: 13,
                                        color: AppColors.accent,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        property.brokerRating,
                                        style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              openBookingForm(property);
                            },
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 19,
                            ),
                            label: const Text(
                              'Book Property Visit',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
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
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}

class VisitBookingFormPage extends StatefulWidget {
  final WishlistProperty property;

  const VisitBookingFormPage({super.key, required this.property});

  @override
  State<VisitBookingFormPage> createState() => _VisitBookingFormPageState();
}

class _VisitBookingFormPageState extends State<VisitBookingFormPage> {
  final formKey = GlobalKey<FormState>();

  final visitorNameController = TextEditingController();
  final mobileController = TextEditingController();
  final messageController = TextEditingController();

  DateTime? selectedDate;

  String? selectedTime;
  String selectedPurpose = 'Buying';
  String selectedContactMethod = 'App';
  int numberOfVisitors = 1;
  bool termsAccepted = false;

  final List<String> timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void dispose() {
    visitorNameController.dispose();
    mobileController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      initialDate: selectedDate ?? now,
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        selectedTime = null;
      });
    }
  }

  bool isSlotBooked(String time) {
    if (selectedDate == null) {
      return false;
    }

    return VisitStore.isSlotBooked(
      brokerName: widget.property.brokerName,
      date: selectedDate!,
      time: time,
    );
  }

  void confirmBooking() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a visit date')),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a visit time')),
      );
      return;
    }

    if (!termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and confirmation'),
        ),
      );
      return;
    }

    if (isSlotBooked(selectedTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This time slot is already booked. Please select another time.',
          ),
        ),
      );

      setState(() {
        selectedTime = null;
      });

      return;
    }

    final booking = VisitBooking(
      image: widget.property.image,
      propertyName: widget.property.name,
      location: widget.property.location,
      price: widget.property.price,
      brokerName: widget.property.brokerName,
      brokerImage: widget.property.brokerImage,
      brokerPhone: widget.property.brokerPhone,
      brokerEmail: widget.property.brokerEmail,
      brokerRating: widget.property.brokerRating,
      visitorName: visitorNameController.text.trim(),
      mobileNumber: mobileController.text.trim(),
      date: selectedDate!,
      time: selectedTime!,
      numberOfVisitors: numberOfVisitors,
      purpose: selectedPurpose,
      message: messageController.text.trim(),
      contactMethod: selectedContactMethod,
      status: 'Pending',
    );

    VisitStore.bookings.add(booking);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 28,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Visit Requested',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Your property visit request has been submitted successfully. The broker will confirm your visit.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: AppColors.surface,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
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
          'Book Property Visit',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.property.image,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.property.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
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
                                widget.property.location,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.property.price,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(widget.property.brokerImage),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.property.brokerName,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Row(
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Verified Broker',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    widget.property.brokerRating,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle('Visitor Details'),

            TextFormField(
              controller: visitorNameController,
              textInputAction: TextInputAction.next,
              decoration: inputDecoration(
                label: 'Visitor Name',
                icon: Icons.person_outline_rounded,
                hint: 'Enter your name',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              maxLength: 10,
              decoration: inputDecoration(
                label: 'Mobile Number',
                icon: Icons.phone_outlined,
                hint: 'Enter 10 digit mobile number',
              ).copyWith(counterText: ''),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your mobile number';
                }

                if (value.trim().length != 10) {
                  return 'Enter a valid 10 digit mobile number';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            sectionTitle('Visit Schedule'),

            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'Select Visit Date'
                            : '${selectedDate!.day.toString().padLeft(2, '0')}/'
                                  '${selectedDate!.month.toString().padLeft(2, '0')}/'
                                  '${selectedDate!.year}',
                        style: TextStyle(
                          color: selectedDate == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: selectedDate == null
                              ? FontWeight.w400
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Available Time',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            if (selectedDate == null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Select a date to see available slots',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: timeSlots.map((time) {
                  final booked = isSlotBooked(time);
                  final selected = selectedTime == time;

                  return ChoiceChip(
                    label: Text(booked ? '$time (Booked)' : time),
                    selected: selected,
                    onSelected: booked
                        ? null
                        : (value) {
                            setState(() {
                              selectedTime = value ? time : null;
                            });
                          },
                    selectedColor: AppColors.primary,
                    disabledColor: AppColors.border.withValues(alpha: 0.55),
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: booked
                          ? AppColors.textSecondary
                          : selected
                          ? Colors.white
                          : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    side: const BorderSide(color: AppColors.border),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            sectionTitle('Number of Visitors'),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.groups_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Number of Visitors',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: numberOfVisitors > 1
                        ? () {
                            setState(() {
                              numberOfVisitors--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                  ),
                  Text(
                    '$numberOfVisitors',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: numberOfVisitors < 10
                        ? () {
                            setState(() {
                              numberOfVisitors++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle('Purpose of Visit'),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Buying', 'Investment', 'Other'].map((purpose) {
                return ChoiceChip(
                  label: Text(purpose),
                  selected: selectedPurpose == purpose,
                  onSelected: (value) {
                    if (value) {
                      setState(() {
                        selectedPurpose = purpose;
                      });
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: selectedPurpose == purpose
                        ? Colors.white
                        : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: selectedPurpose == purpose
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  side: const BorderSide(color: AppColors.border),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            sectionTitle('Message / Note'),

            TextFormField(
              controller: messageController,
              maxLines: 4,
              decoration: inputDecoration(
                label: 'Message / Note',
                icon: Icons.notes_outlined,
                hint: 'Write any additional request...',
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle('Preferred Contact Method'),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Call', 'WhatsApp', 'App'].map((method) {
                IconData icon;

                if (method == 'Call') {
                  icon = Icons.phone_outlined;
                } else if (method == 'WhatsApp') {
                  icon = Icons.chat_outlined;
                } else {
                  icon = Icons.notifications_none_rounded;
                }

                return ChoiceChip(
                  avatar: Icon(
                    icon,
                    size: 17,
                    color: selectedContactMethod == method
                        ? Colors.white
                        : AppColors.primary,
                  ),
                  label: Text(method),
                  selected: selectedContactMethod == method,
                  onSelected: (value) {
                    if (value) {
                      setState(() {
                        selectedContactMethod = method;
                      });
                    }
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: selectedContactMethod == method
                        ? Colors.white
                        : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: selectedContactMethod == method
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  side: const BorderSide(color: AppColors.border),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            sectionTitle('Terms & Confirmation'),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: termsAccepted,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        termsAccepted = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 4),
                      child: Text(
                        'I confirm that the information provided is correct and I agree to the property visit terms. I understand that the visit is subject to broker confirmation.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Confirm Visit Booking',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
