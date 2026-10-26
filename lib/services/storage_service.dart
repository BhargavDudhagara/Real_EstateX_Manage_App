import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Images are stored inside the Firestore property document as a base64
/// data URL, so Firebase Storage (paid Blaze plan) is not required.
class StorageService {
  final ImagePicker _picker = ImagePicker();

  // Firestore documents are limited to 1 MB, so keep the image small.
  static const int _maxEncodedLength = 700000;

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
        maxWidth: 1000,
        maxHeight: 1000,
      );
      return image?.path;
    } catch (e) {
      debugPrint('pickImageFromGallery error: $e');
      return null;
    }
  }

  /// Same name and signature as before, so no other file needs to change.
  /// Returns a data URL (data:image/jpeg;base64,...) instead of a Storage URL.
  Future<String?> uploadPropertyImage(
    String filePath,
    String propertyId,
  ) async {
    final Uint8List bytes;
    try {
      bytes = await File(filePath).readAsBytes();
    } catch (e) {
      debugPrint('uploadPropertyImage read error: $e');
      throw Exception('Could not read the selected image.');
    }
    return _toDataUrl(bytes);
  }

  Future<String?> uploadPropertyImageFromBytes(
    Uint8List bytes,
    String propertyId,
  ) async {
    return _toDataUrl(bytes);
  }

  String _toDataUrl(Uint8List bytes) {
    final encoded = base64Encode(bytes);
    if (encoded.length > _maxEncodedLength) {
      throw Exception('Image is too large. Please choose a smaller image.');
    }
    return 'data:image/jpeg;base64,$encoded';
  }
}