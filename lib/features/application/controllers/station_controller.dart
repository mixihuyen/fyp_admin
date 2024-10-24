import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/popups/loaders.dart';
import '../models/station_model.dart';

class StationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var stations = <StationModel>[].obs; // List to store stations
  var filteredStations = <StationModel>[].obs; // List to store filtered stations for search
  var searchQuery = ''.obs; // Observable for the search query

  @override
  void onInit() {
    super.onInit();
    fetchStations(); // Fetch stations when the controller is initialized
    ever(searchQuery, (_) => filterStations()); // Listen to search query changes and filter stations
  }

  // // Add a new station to Firestore
  // Future<void> addStation(String name) async {
  //   try {
  //     DocumentReference docRef = await _firestore.collection('Station').add({
  //       'name': name,
  //     });
  //     stations.add(StationModel(id: docRef.id, name: name));
  //     filteredStations.value = stations; // Update filtered list after adding
  //     TLoaders.successSnackBar(title: 'Success', message: 'Station added successfully');
  //   } catch (e) {
  //     TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add station: ${e.toString()}');
  //   }
  // }

  // Update station in Firestore
  Future<void> updateStation(String id, String newName) async {
    try {
      await _firestore.collection('Station').doc(id).update({
        'name': newName,
      });
      // Update the local list
      int index = stations.indexWhere((station) => station.id == id);
      if (index != -1) {
        stations[index].name = newName;
        stations.refresh(); // Notify UI about the change
        filteredStations.value = stations; // Update filtered list after updating
        TLoaders.successSnackBar(title: 'Success', message: 'Station updated successfully');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update station: ${e.toString()}');
    }
  }

  // Delete station from Firestore
  Future<void> deleteStation(String id) async {
    try {
      await _firestore.collection('Station').doc(id).delete();
      stations.removeWhere((station) => station.id == id); // Remove from the local list
      filteredStations.value = stations; // Update filtered list after deleting
      TLoaders.successSnackBar(title: 'Success', message: 'Station deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete station: ${e.toString()}');
    }
  }

  // Fetch stations from Firestore
  void fetchStations() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Station').get();
      stations.value = querySnapshot.docs.map((doc) {
        return StationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      filteredStations.value = stations; // Set initial filtered list to all stations
    } catch (e) {
      print('Error fetching stations: $e');
    }
  }

  // Search stations based on the search query
  void searchStations(String query) {
    searchQuery.value = query; // Update search query
  }

  // Filter stations based on the search query
  void filterStations() {
    if (searchQuery.isEmpty) {
      filteredStations.value = stations; // Show all stations if search query is empty
    } else {
      filteredStations.value = stations.where((station) {
        return station.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }
  // Add a new station with a selected province
  Future<void> addStation(String name, String provinceId) async {
    try {
      DocumentReference docRef = await _firestore.collection('Station').add({
        'name': name,
        'provinceId': provinceId,
      });
      stations.add(StationModel(id: docRef.id, name: name, provinceId: provinceId));
      filteredStations.value = stations; // Update filtered list after adding
      TLoaders.successSnackBar(title: 'Success', message: 'Station added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add station: ${e.toString()}');
    }
  }

}
