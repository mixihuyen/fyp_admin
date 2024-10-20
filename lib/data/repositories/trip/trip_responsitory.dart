import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../features/application/models/trip_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class TripRepository extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm chuyến đi và tạo liên kết với category
  Future<void> addTripAndLinkToCategory(TripModel trip) async {
    try {
      // Thêm chuyến đi vào collection 'Trips'
      DocumentReference tripDoc = await _db.collection('Trips').add(trip.toJson());

      // Tạo liên kết giữa chuyến đi và category trong 'TripCategory'
      if (trip.categoryId != null && trip.categoryId!.isNotEmpty) {
        await _db.collection('TripCategory').add({
          'tripId': tripDoc.id,
          'categoryId': trip.categoryId,
        });
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while adding the trip and linking to category: $e';
    }
  }

  // Update an existing trip in Firestore
  Future<void> updateTrip(TripModel trip) async {
    try {
      // Use the trip id to update the trip in Firestore
      await _db.collection('Trips').doc(trip.id).update(trip.toJson());
      Get.snackbar('Success', 'Trip updated successfully');
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating the trip: $e';
    }
  }
}
