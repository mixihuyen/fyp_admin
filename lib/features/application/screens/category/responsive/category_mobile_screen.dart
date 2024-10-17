import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/category_controller.dart';

class CategoryScreenMobile extends StatelessWidget {
  const CategoryScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Category Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      controller.addCategory(nameController.text);
                      nameController.clear();
                    } else {
                      Get.snackbar('Error', 'Please enter a category name');
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Category List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.categories.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }
                return ListView.builder(
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return ListTile(
                      title: Text(category.name),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
