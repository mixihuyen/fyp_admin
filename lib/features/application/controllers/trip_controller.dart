import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/repositories/trip/trip_responsitory.dart';
import '../../../utils/popups/loaders.dart';
import '../models/trip_model.dart';
import '../models/station_model.dart';
import '../models/category_model.dart';
import '../models/province_model.dart';

class TripController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var stations = <StationModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var provinces = <ProvinceModel>[].obs;
  var trips = <TripModel>[].obs;
  final TripRepository _tripRepository = Get.put(TripRepository());

  @override
  void onInit() {
    super.onInit();
    fetchStations();
    fetchCategories();
    fetchProvinces();
    fetchTrips();
  }

  // Fetch stations
  void fetchStations() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Station').get();
      stations.value = querySnapshot.docs.map((doc) {
        return StationModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching stations: $e');
    }
  }

  // Fetch categories
  void fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Categories').get();
      categories.value = querySnapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Fetch provinces
  void fetchProvinces() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Provinces').get();
      provinces.value = querySnapshot.docs.map((doc) {
        return ProvinceModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  // Add a new trip and reload the trip list
  Future<void> addTrip(TripModel trip) async {
    try {
      await _tripRepository.addTripAndLinkToCategory(trip);
      TLoaders.successSnackBar(title: 'Success', message: 'Trip added successfully');

      // Fetch trips again to reload the trip list with the new trip
      fetchTrips();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add trip: ${e.toString()}');
    }
  }

  // Update an existing trip
  Future<void> updateTrip(TripModel trip) async {
    try {
      await _tripRepository.updateTrip(trip);
      TLoaders.successSnackBar(title: 'Success', message: 'Trip updated successfully');
      fetchTrips(); // Reload trips after update
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update trip: ${e.toString()}');
    }
  }

  // Delete a trip
  Future<void> deleteTrip(TripModel trip) async {
    try {
      // Delete the trip from Firestore based on its ID
      await _firestore.collection('Trips').doc(trip.id).delete();
      TLoaders.successSnackBar(title: 'Success', message: 'Trip deleted successfully');

      // Fetch trips again to reload the updated list
      fetchTrips();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete trip: ${e.toString()}');
    }
  }

  // Fetch trips from Firestore
  void fetchTrips() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Trips').get();
      trips.value = querySnapshot.docs.map((doc) {
        return TripModel.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      print('Error fetching trips: $e');
    }
  }
}
