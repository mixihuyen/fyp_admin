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

  Future<void> updateTrip(TripModel trip) async {
    try {
      // Cập nhật chuyến đi trong 'Trips'
      await _db.collection('Trips').doc(trip.id).update(trip.toJson());

      // Kiểm tra xem categoryId có thay đổi không
      DocumentSnapshot tripCategorySnapshot = await _db
          .collection('TripCategory')
          .where('tripId', isEqualTo: trip.id)
          .limit(1) // Giả sử mỗi trip chỉ có một category
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      String currentCategoryId = tripCategorySnapshot['categoryId'];

      if (trip.categoryId != currentCategoryId) {
        // Nếu categoryId thay đổi, cập nhật liên kết trong 'TripCategory'

        // Xóa liên kết cũ
        await _db.collection('TripCategory').doc(tripCategorySnapshot.id).delete();

        // Thêm liên kết mới
        if (trip.categoryId != null && trip.categoryId!.isNotEmpty) {
          await _db.collection('TripCategory').add({
            'tripId': trip.id,
            'categoryId': trip.categoryId,
          });
        }
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating the trip and category: $e';
    }
  }
}
