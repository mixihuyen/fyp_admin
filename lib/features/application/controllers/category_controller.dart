import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../utils/popups/loaders.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var categories = <CategoryModel>[].obs; // List to store categories
  var filteredCategories = <CategoryModel>[].obs; // List to store filtered categories
  var searchQuery = ''.obs; // Observable search query

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // Fetch categories when the controller is initialized
    ever(searchQuery, (_) => filterCategories()); // Trigger filtering whenever the search query changes
  }

  // Add a new category to Firestore
  Future<void> addCategory(String name) async {
    try {
      DocumentReference docRef = await _firestore.collection('Categories').add({
        'name': name,
      });
      categories.add(CategoryModel(id: docRef.id, name: name));
      filterCategories(); // Update filtered list after adding a category
      TLoaders.successSnackBar(title: 'Success', message: 'Category added successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to add category: ${e.toString()}');
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
        filterCategories(); // Update filtered list after updating a category
        TLoaders.successSnackBar(title: 'Success', message: 'Category updated successfully');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update category: ${e.toString()}');
    }
  }

  // Delete category from Firestore
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('Categories').doc(id).delete();
      categories.removeWhere((category) => category.id == id); // Remove from the local list
      filterCategories(); // Update filtered list after deletion
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
      filterCategories(); // Apply filtering once data is fetched
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Error fetching categories: ${e.toString()}');
    }
  }

  // Filter categories based on the search query
  void filterCategories() {
    if (searchQuery.value.isEmpty) {
      filteredCategories.value = categories;
    } else {
      filteredCategories.value = categories
          .where((category) => category.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }
  }

  // Update search query
  void searchCategories(String query) {
    searchQuery.value = query;
  }
}
