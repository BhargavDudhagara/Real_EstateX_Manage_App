import 'package:flutter/material.dart';
import 'package:app/theme/app_colors.dart';
import 'package:app/utils/routes.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final descriptionController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final floorsController = TextEditingController();
  final parkingController = TextEditingController();
  final yearController = TextEditingController();

  String propertyType = "House";
  String listingType = "For Sale";
  String furnishing = "Unfurnished";

  final List<String> selectedAmenities = [];

  final List<String> amenities = [
    "Parking",
    "Garden",
    "Security",
    "Lift",
    "Gym",
    "Swimming Pool",
    "Power Backup",
    "Water Supply",
    "Electricity",
    "Club House",
  ];

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    addressController.dispose();
    cityController.dispose();
    areaController.dispose();
    descriptionController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    floorsController.dispose();
    parkingController.dispose();
    yearController.dispose();
    super.dispose();
  }

  void saveProperty() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Property added successfully"),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacementNamed(context, MyRoutes.brokerPropertiesRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Add Property",
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            _sectionTitle(
              "Basic Information",
              "Enter the main details of your property",
            ),
            _field(
              controller: titleController,
              label: "Property Title",
              hint: "e.g. Modern Family House",
              icon: Icons.home_work_outlined,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    label: "Property Type",
                    value: propertyType,
                    items: ["House", "Apartment", "Villa", "Plot", "Farm"],
                    onChanged: (value) {
                      setState(() {
                        propertyType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dropdown(
                    label: "Listing Type",
                    value: listingType,
                    items: ["For Sale", "For Rent"],
                    onChanged: (value) {
                      setState(() {
                        listingType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _field(
              controller: priceController,
              label: "Price",
              hint: "e.g. ₹85 Lakh",
              icon: Icons.currency_rupee_rounded,
            ),
            const SizedBox(height: 28),
            _sectionTitle(
              "Location Details",
              "Provide accurate property location",
            ),
            _field(
              controller: addressController,
              label: "Full Address",
              hint: "Enter complete property address",
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            _field(
              controller: cityController,
              label: "City",
              hint: "e.g. Rajkot",
              icon: Icons.location_city_outlined,
            ),
            const SizedBox(height: 14),
            _field(
              controller: areaController,
              label: "Property Area",
              hint: "e.g. 1850 sq.ft",
              icon: Icons.square_foot_outlined,
            ),
            const SizedBox(height: 28),
            _sectionTitle(
              "Property Specifications",
              "Add detailed property information",
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: bedroomsController,
                    label: "Bedrooms",
                    hint: "3",
                    icon: Icons.bed_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                    controller: bathroomsController,
                    label: "Bathrooms",
                    hint: "2",
                    icon: Icons.bathtub_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: floorsController,
                    label: "Floors",
                    hint: "2",
                    icon: Icons.layers_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                    controller: parkingController,
                    label: "Parking",
                    hint: "2 Cars",
                    icon: Icons.directions_car_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _dropdown(
              label: "Furnishing",
              value: furnishing,
              items: ["Unfurnished", "Semi Furnished", "Fully Furnished"],
              onChanged: (value) {
                setState(() {
                  furnishing = value!;
                });
              },
            ),
            const SizedBox(height: 14),
            _field(
              controller: yearController,
              label: "Construction Year",
              hint: "e.g. 2022",
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 28),
            _sectionTitle(
              "Amenities",
              "Select facilities available with this property",
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: amenities.map((amenity) {
                final selected = selectedAmenities.contains(amenity);

                return FilterChip(
                  label: Text(amenity),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedAmenities.add(amenity);
                      } else {
                        selectedAmenities.remove(amenity);
                      }
                    });
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.12),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            _sectionTitle(
              "Property Description",
              "Describe your property clearly",
            ),
            _field(
              controller: descriptionController,
              label: "Description",
              hint:
                  "Enter property details, nearby facilities, connectivity and other important information...",
              icon: Icons.description_outlined,
              maxLines: 6,
            ),
            const SizedBox(height: 28),
            _sectionTitle(
              "Property Images",
              "Add clear photos of your property",
            ),
            _imageUploadBox(),
            const SizedBox(height: 28),
            _verificationBox(),
            const SizedBox(height: 30),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: saveProperty,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Publish Property",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
    );
  }

  Widget _imageUploadBox() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
                size: 25,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Add Property Photos",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Upload clear images of the property",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verificationBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_outlined, color: AppColors.primary, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Property Verification",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Property documents will be reviewed before the listing receives a verified badge.",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
