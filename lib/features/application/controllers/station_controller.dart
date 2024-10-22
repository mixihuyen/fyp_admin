import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/popups/loaders.dart';
import '../models/station_model.dart';

class StationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var stations = <StationModel>[].obs; // List to store stations

  @override
  void onInit() {
    super.onInit();
    fetchStations(); // Fetch stations when the controller is initialized
  }

  // Add a new station to Firestore
  Future<void> addStation(String name) async {
    try {
      DocumentReference docRef = await _firestore.collection('Station').add({
        'name': name,
      });
      stations.add(StationModel(id: docRef.id, name: name));
      TLoaders.successSnackBar(title: 'Success', message: 'Station added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add station: ${e.toString()}');
    }
  }

  // Update station in Firestore
  Future<void> updateStation(String id, String newName) async {
    try {
      await _firestore.collection('Station').doc(id).update({
        'name': newName,
      });
      // Update in the local list
      int index = stations.indexWhere((station) => station.id == id);
      if (index != -1) {
        stations[index].name = newName;
        stations.refresh(); // Notify UI about the change
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
      TLoaders.successSnackBar(title: 'Success', message: 'Station deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete station: ${e.toString()}');
    }
  }

  // Fetch station from Firestore
  void fetchStations() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Station').get();
      stations.value = querySnapshot.docs.map((doc) {
        return StationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching stations: $e');
    }
  }
}
