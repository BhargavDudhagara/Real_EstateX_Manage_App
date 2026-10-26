import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/property_model.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collection = 'properties';

  Stream<List<PropertyModel>> getBrokerProperties() {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_collection)
        .where('brokerId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PropertyModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<PropertyModel>> getApprovedProperties() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'Approved')
        .where('isApproved', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PropertyModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<PropertyModel>> getPendingProperties() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'Pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PropertyModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<PropertyModel>> getAllPropertiesForAdmin() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PropertyModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<PropertyModel?> getPropertyById(String propertyId) async {
    final id = propertyId.trim();

    if (id.isEmpty) {
      return null;
    }

    final doc = await _firestore.collection(_collection).doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return PropertyModel.fromMap(doc.data() ?? {}, doc.id);
  }

  Future<String> addProperty(PropertyModel property) async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('Please log in before adding a property.');
    }

    final docRef = await _firestore.collection(_collection).add({
      ...property.toMap(),
      'brokerId': userId,
      'status': 'Pending',
      'isApproved': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  Future<void> updateProperty(PropertyModel property) async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('Please log in before editing a property.');
    }

    if (property.id.trim().isEmpty) {
      throw Exception('Property ID is missing.');
    }

    final docRef = _firestore.collection(_collection).doc(property.id);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Property not found in Firestore.');
    }

    final data = snapshot.data()!;
    final brokerId = data['brokerId']?.toString();

    if (brokerId != userId) {
      throw Exception('You can only edit your own properties.');
    }

    await docRef.update({
      ...property.toMap(),
      'brokerId': userId,
      'status': 'Pending',
      'isApproved': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProperty(String propertyId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in before deleting a property.');
    }

    final id = propertyId.trim();

    if (id.isEmpty) {
      throw Exception('Property document ID is missing.');
    }

    final docRef = _firestore.collection(_collection).doc(id);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('Property not found. Check the Firestore document ID.');
    }

    final data = snapshot.data()!;
    final brokerId = data['brokerId']?.toString();

    if (brokerId != user.uid) {
      throw Exception('You can only delete properties added by your account.');
    }

    await docRef.delete();

    final deletedSnapshot = await docRef.get();

    if (deletedSnapshot.exists) {
      throw Exception('Property could not be deleted. Please try again.');
    }
  }

  Future<void> approveProperty(String propertyId) async {
    await _firestore.collection(_collection).doc(propertyId).update({
      'status': 'Approved',
      'isApproved': true,
      'verification': 'Approved',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectProperty(String propertyId) async {
    await _firestore.collection(_collection).doc(propertyId).update({
      'status': 'Rejected',
      'isApproved': false,
      'verification': 'Rejected',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> resetToPending(String propertyId) async {
    await _firestore.collection(_collection).doc(propertyId).update({
      'status': 'Pending',
      'isApproved': false,
      'verification': 'Under Review',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> requestCorrection(String propertyId) async {
    await _firestore.collection(_collection).doc(propertyId).update({
      'verification': 'Changes Requested',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
