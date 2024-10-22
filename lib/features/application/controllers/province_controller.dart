import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/popups/loaders.dart';
import '../models/province_model.dart';

class ProvinceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var provinces = <ProvinceModel>[].obs; // List to store provinces
  var filteredProvinces = <ProvinceModel>[].obs; // List to store filtered provinces
  var searchQuery = ''.obs; // Search query

  @override
  void onInit() {
    super.onInit();
    fetchProvinces(); // Fetch provinces when the controller is initialized
    ever(searchQuery, (_) => filterProvinces()); // Trigger filtering whenever the search query changes
  }

  // Add a new province to Firestore
  Future<void> addProvince(String name) async {
    try {
      DocumentReference docRef = await _firestore.collection('Provinces').add({
        'name': name,
      });
      provinces.add(ProvinceModel(id: docRef.id, name: name));
      filterProvinces(); // Update filtered list after adding a province
      TLoaders.successSnackBar(title: 'Success', message: 'Province added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add province: ${e.toString()}');
    }
  }

  // Update province in Firestore
  Future<void> updateProvince(String id, String newName) async {
    try {
      await _firestore.collection('Provinces').doc(id).update({
        'name': newName,
      });
      int index = provinces.indexWhere((province) => province.id == id);
      if (index != -1) {
        provinces[index].name = newName;
        provinces.refresh(); // Notify UI about the change
        filterProvinces(); // Update filtered list after updating a province
        TLoaders.successSnackBar(title: 'Success', message: 'Province updated successfully');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update province: ${e.toString()}');
    }
  }

  // Delete province from Firestore
  Future<void> deleteProvince(String id) async {
    try {
      await _firestore.collection('Provinces').doc(id).delete();
      provinces.removeWhere((province) => province.id == id); // Remove from the local list
      filterProvinces(); // Update filtered list after deletion
      TLoaders.successSnackBar(title: 'Success', message: 'Province deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete province: ${e.toString()}');
    }
  }

  // Fetch provinces from Firestore
  void fetchProvinces() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Provinces').get();
      provinces.value = querySnapshot.docs.map((doc) {
        return ProvinceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      filterProvinces(); // Apply filtering once data is fetched
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }

  // Filter provinces based on the search query
  void filterProvinces() {
    if (searchQuery.value.isEmpty) {
      filteredProvinces.value = provinces;
    } else {
      filteredProvinces.value = provinces
          .where((province) => province.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Update search query
  void searchProvinces(String query) {
    searchQuery.value = query;
  }
}
