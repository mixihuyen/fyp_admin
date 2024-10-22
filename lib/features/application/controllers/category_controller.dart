import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/popups/loaders.dart';
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
      TLoaders.successSnackBar(title: 'Success', message: 'Category added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to adding category: ${e.toString()}');
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
        TLoaders.successSnackBar(title: 'Success', message: 'Category updated successfully');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to updating category: ${e.toString()}');
    }
  }

  // Delete category from Firestore
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('Categories').doc(id).delete();
      categories.removeWhere((category) => category.id == id); // Remove from the local list
      TLoaders.successSnackBar(title: 'Success', message: 'Category deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete category: ${e.toString()}');
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
      TLoaders.errorSnackBar(title: 'Error', message: 'Error fetching categories: ${e.toString()}');
    }
  }
}
