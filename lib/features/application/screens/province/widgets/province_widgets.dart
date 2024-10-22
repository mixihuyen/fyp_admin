import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../controllers/province_controller.dart';
import '../../../models/province_model.dart';

class ProvinceWidgets extends StatelessWidget {
  const ProvinceWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProvinceController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side for adding provinces
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Province:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Enter Province Name'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            controller.addProvince(nameController.text); // Add province
                            nameController.clear();
                          } else {
                            Get.snackbar('Error', 'Please enter a province name');
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

            // Right side to show the province list
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Provinces:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() {
                      if (controller.filteredProvinces.isEmpty) {
                        return const Text('No provinces found.');
                      }
                      return ListView.builder(
                        itemCount: controller.filteredProvinces.length,
                        itemBuilder: (context, index) {
                          final province = controller.filteredProvinces[index];
                          return ListTile(
                            title: Text(province.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(context, controller, province);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, controller, province);
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

  // Popup to edit province
  void _showEditDialog(BuildContext context, ProvinceController controller, ProvinceModel province) {
    final TextEditingController editController = TextEditingController(text: province.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Province'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Province Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                controller.updateProvince(province.id, editController.text); // Update province
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
  void _showDeleteConfirmationDialog(BuildContext context, ProvinceController controller, ProvinceModel province) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete "${province.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog if user selects "Cancel"
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteProvince(province.id); // Perform deletion
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
