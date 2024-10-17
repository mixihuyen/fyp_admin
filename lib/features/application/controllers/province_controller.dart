import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/province_model.dart';

class ProvinceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var provinces = <ProvinceModel>[].obs; // List to store provinces

  @override
  void onInit() {
    super.onInit();
    fetchProvinces(); // Fetch provinces when the controller is initialized
  }

  // Add a new province to Firestore
  Future<void> addProvince(String name) async {
    try {
      DocumentReference docRef = await _firestore.collection('Provinces').add({
        'name': name,
      });
      provinces.add(ProvinceModel(id: docRef.id, name: name));
    } catch (e) {
      print('Error adding province: $e');
    }
  }

  // Update province in Firestore
  Future<void> updateProvince(String id, String newName) async {
    try {
      await _firestore.collection('Provinces').doc(id).update({
        'name': newName,
      });
      // Update in the local list
      int index = provinces.indexWhere((province) => province.id == id);
      if (index != -1) {
        provinces[index].name = newName;
        provinces.refresh(); // Notify UI about the change
      }
    } catch (e) {
      print('Error updating province: $e');
    }
  }

  // Delete province from Firestore
  Future<void> deleteProvince(String id) async {
    try {
      await _firestore.collection('Provinces').doc(id).delete();
      provinces.removeWhere((province) => province.id == id); // Remove from the local list
    } catch (e) {
      print('Error deleting province: $e');
    }
  }

  // Fetch provinces from Firestore
  void fetchProvinces() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Provinces').get();
      provinces.value = querySnapshot.docs.map((doc) {
        return ProvinceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching provinces: $e');
    }
  }
}
