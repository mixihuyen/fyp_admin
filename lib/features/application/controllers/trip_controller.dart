import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/repositories/trip/trip_responsitory.dart';
import '../../../utils/formatters/formatter.dart';
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
  var filteredTrips = <TripModel>[].obs; // List to store filtered trips
  var searchQuery = ''.obs; // Search query

  final TripRepository _tripRepository = Get.put(TripRepository());

  @override
  void onInit() {
    super.onInit();
    fetchStations();
    fetchCategories();
    fetchProvinces();
    fetchTrips();

    // Trigger filtering whenever the search query changes
    ever(searchQuery, (_) => filterTrips());
  }

  // Helper method to get the province for a given station
  ProvinceModel? getProvinceForStation(String? stationId) {
    if (stationId == null) return null;

    final station = stations.firstWhereOrNull((station) => station.id == stationId);
    if (station != null) {
      return provinces.firstWhereOrNull((province) => province.id == station.provinceId);
    }
    return null;
  }

  // Fetch stations
  Future<void> fetchStations() async {
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
  Future<void> fetchCategories() async {
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
  Future<void> fetchProvinces() async {
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

      // Refresh data after adding a trip
      await fetchStations();
      await fetchProvinces();
      fetchTrips(); // Reload trips after adding a new one
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add trip: ${e.toString()}');
    }
  }

  // Update an existing trip
  Future<void> updateTrip(TripModel trip) async {
    try {
      await _tripRepository.updateTrip(trip);
      TLoaders.successSnackBar(title: 'Success', message: 'Trip updated successfully');

      // Refresh data after updating a trip
      await fetchStations();
      await fetchProvinces();
      fetchTrips(); // Reload trips after updating
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update trip: ${e.toString()}');
    }
  }

  // Delete a trip
  Future<void> deleteTrip(TripModel trip) async {
    try {
      await _firestore.collection('Trips').doc(trip.id).delete();
      TLoaders.successSnackBar(title: 'Success', message: 'Trip deleted successfully');

      // Refresh data after deleting a trip
      await fetchStations();
      await fetchProvinces();
      fetchTrips(); // Reload trips after deleting
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete trip: ${e.toString()}');
    }
  }

  // Fetch trips from Firestore
  Future<void> fetchTrips() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('Trips').get();
      trips.value = querySnapshot.docs.map((doc) {
        return TripModel.fromSnapshot(doc);
      }).toList();
      filteredTrips.assignAll(trips); // Initially show all trips
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Error fetching trips: ${e.toString()}');
    }
  }

  // Filter trips based on search query
  void filterTrips() {
    if (searchQuery.isEmpty) {
      filteredTrips.assignAll(trips); // If no search query, show all trips
    } else {
      final query = searchQuery.value.toLowerCase();

      filteredTrips.value = trips.where((trip) {
        // Match against various trip fields
        final matchesStartProvince = _getProvinceName(trip.start?.startProvince).toLowerCase().contains(query);
        final matchesEndProvince = _getProvinceName(trip.end?.endProvince).toLowerCase().contains(query);
        final matchesStartStation = _getStationName(trip.start?.startLocation).toLowerCase().contains(query);
        final matchesEndStation = _getStationName(trip.end?.endLocation).toLowerCase().contains(query);
        final matchesCategory = _getCategoryName(trip.categoryId).toLowerCase().contains(query);

        // Match departure and arrival times
        final matchesDepartureTime = (trip.start?.departureTime ?? '').toLowerCase().contains(query);
        final matchesArrivalTime = (trip.end?.arrivalTime ?? '').toLowerCase().contains(query);

        // Match trip price
        final matchesPrice = TFormatter.format(trip.price).toLowerCase().contains(query);

        // Return true if any of the fields match the query
        return matchesStartProvince || matchesEndProvince || matchesStartStation || matchesEndStation ||
            matchesCategory || matchesDepartureTime || matchesArrivalTime || matchesPrice;
      }).toList();
    }
  }

  // Helper methods to get names from IDs
  String _getCategoryName(String? categoryId) {
    final category = categories.firstWhereOrNull((category) => category.id == categoryId);
    return category?.name ?? 'Unknown';
  }

  String _getProvinceName(String? provinceId) {
    final province = provinces.firstWhereOrNull((province) => province.id == provinceId);
    return province?.name ?? 'Unknown';
  }

  String _getStationName(String? stationId) {
    final station = stations.firstWhereOrNull((station) => station.id == stationId);
    return station?.name ?? 'Unknown';
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
