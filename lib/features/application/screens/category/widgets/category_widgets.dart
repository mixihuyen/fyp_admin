import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/category_model.dart';

class CategoryWidgets extends StatelessWidget {
  const CategoryWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side for adding categories
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Category:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // TextField to enter category name
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Enter Category Name'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            controller.addCategory(nameController.text); // Add category
                            nameController.clear();
                          } else {
                            Get.snackbar('Error', 'Please enter a category name');
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  const Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Expanded(child: Image(image: AssetImage(TImages.lightAppLogo), height: 300, width: 300))])
                ],
              ),
            ),
            const VerticalDivider(
              width: 40,
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(width: 20),

            // Right side to show the category list
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      if (controller.filteredCategories.isEmpty) {
                        return const Text('No categories found.');
                      }
                      return ListView.builder(
                        itemCount: controller.filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = controller.filteredCategories[index];
                          return ListTile(
                            title: Text(category.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, controller, category);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, controller, category);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Popup to edit category
  void _showEditDialog(BuildContext context, CategoryController controller, CategoryModel category) {
    final TextEditingController editController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                controller.updateCategory(category.id, editController.text); // Update category
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Popup to confirm delete
  void _showDeleteConfirmationDialog(BuildContext context, CategoryController controller, CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete "${category.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog if user selects "Cancel"
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteCategory(category.id); // Perform deletion
                Navigator.of(context).pop(); // Close dialog after deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
