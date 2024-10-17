import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var categories = <CategoryModel>[].obs; // List to store categories

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // Fetch categories when the controller is initialized
  }

  // Add a new category to Firestore
  Future<void> addCategory(String name) async {
    try {
      DocumentReference docRef = await _firestore.collection('Categories').add({
        'name': name,
      });
      categories.add(CategoryModel(id: docRef.id, name: name));
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  // Update category in Firestore
  Future<void> updateCategory(String id, String newName) async {
    try {
      await _firestore.collection('Categories').doc(id).update({
        'name': newName,
      });
      // Update in the local list
      int index = categories.indexWhere((category) => category.id == id);
      if (index != -1) {
        categories[index].name = newName;
        categories.refresh(); // Notify UI about the change
      }
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  // Delete category from Firestore
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('Categories').doc(id).delete();
      categories.removeWhere((category) => category.id == id); // Remove from the local list
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  // Fetch categories from Firestore
  void fetchCategories() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Categories').get();
      categories.value = querySnapshot.docs.map((doc) {
        return CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
}
