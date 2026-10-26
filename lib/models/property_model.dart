import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String id;
  final String brokerId;
  final String title;
  final String propertyType;
  final String listingType;
  final String price;
  final String location;
  final String address;
  final String area;
  final String bedrooms;
  final String bathrooms;
  final String floors;
  final String parking;
  final String furnishing;
  final String year;
  final String description;
  final List<String> amenities;
  final String image;
  final String status;
  final bool isApproved;
  final String? verification;
  final DateTime createdAt;
  final DateTime updatedAt;

  PropertyModel({
    required this.id,
    required this.brokerId,
    required this.title,
    required this.propertyType,
    required this.listingType,
    required this.price,
    required this.location,
    required this.address,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.floors,
    required this.parking,
    required this.furnishing,
    required this.year,
    required this.description,
    required this.amenities,
    required this.image,
    this.status = "Pending",
    this.isApproved = false,
    this.verification,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyModel.fromMap(Map<String, dynamic> data, String documentId) {
    return PropertyModel(
      id: documentId,
      brokerId: data['brokerId'] ?? '',
      title: data['title'] ?? '',
      propertyType: data['propertyType'] ?? '',
      listingType: data['listingType'] ?? '',
      price: data['price'] ?? '',
      location: data['location'] ?? '',
      address: data['address'] ?? '',
      area: data['area'] ?? '',
      bedrooms: data['bedrooms'] ?? '',
      bathrooms: data['bathrooms'] ?? '',
      floors: data['floors'] ?? '',
      parking: data['parking'] ?? '',
      furnishing: data['furnishing'] ?? '',
      year: data['year'] ?? '',
      description: data['description'] ?? '',
      amenities: List<String>.from(data['amenities'] ?? []),
      image: data['image'] ?? 'assets/House.png',
      status: data['status'] ?? 'Pending',
      isApproved: data['isApproved'] ?? false,
      verification: data['verification'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brokerId': brokerId,
      'title': title,
      'propertyType': propertyType,
      'listingType': listingType,
      'price': price,
      'location': location,
      'address': address,
      'area': area,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floors': floors,
      'parking': parking,
      'furnishing': furnishing,
      'year': year,
      'description': description,
      'amenities': amenities,
      'image': image,
      'status': status,
      'isApproved': isApproved,
      'verification': verification,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  PropertyModel copyWith({
    String? id,
    String? brokerId,
    String? title,
    String? propertyType,
    String? listingType,
    String? price,
    String? location,
    String? address,
    String? area,
    String? bedrooms,
    String? bathrooms,
    String? floors,
    String? parking,
    String? furnishing,
    String? year,
    String? description,
    List<String>? amenities,
    String? image,
    String? status,
    bool? isApproved,
    String? verification,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PropertyModel(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      title: title ?? this.title,
      propertyType: propertyType ?? this.propertyType,
      listingType: listingType ?? this.listingType,
      price: price ?? this.price,
      location: location ?? this.location,
      address: address ?? this.address,
      area: area ?? this.area,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      floors: floors ?? this.floors,
      parking: parking ?? this.parking,
      furnishing: furnishing ?? this.furnishing,
      year: year ?? this.year,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      image: image ?? this.image,
      status: status ?? this.status,
      isApproved: isApproved ?? this.isApproved,
      verification: verification ?? this.verification,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
