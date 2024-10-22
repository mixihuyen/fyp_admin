import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/province_controller.dart';

class ProvinceScreenMobile extends StatelessWidget {
  const ProvinceScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProvinceController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
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
                      labelText: 'Enter Province Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      controller.addProvince(nameController.text);
                      nameController.clear();
                    } else {
                      Get.snackbar('Error', 'Please enter a province name');
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Province List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (controller.filteredProvinces.isEmpty) {
                  return const Center(child: Text('No provinces found.'));
                }
                return ListView.builder(
                  itemCount: controller.filteredProvinces.length,
                  itemBuilder: (context, index) {
                    final province = controller.filteredProvinces[index];
                    return ListTile(
                      title: Text(province.name),
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
