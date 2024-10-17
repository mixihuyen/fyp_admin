import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/station_controller.dart';

class StationScreenMobile extends StatelessWidget {
  const StationScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StationController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stations Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // Padding nhỏ hơn cho mobile
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Đặt TextField bên trong Expanded để chiếm khoảng trống còn lại
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Station Name',
                      border: OutlineInputBorder(), // Thêm border cho TextField
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Khoảng cách nhỏ hơn giữa TextField và nút
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // Điều chỉnh padding cho nút
                    minimumSize: const Size(50, 48), // Điều chỉnh kích thước tối thiểu của nút
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      controller.addStation(nameController.text); // Add station
                      nameController.clear();
                    } else {
                      Get.snackbar('Error', 'Please enter a station name');
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Station List:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Hiển thị danh sách các trạm đã thêm
            Expanded(
              child: Obx(() {
                if (controller.stations.isEmpty) {
                  return const Center(child: Text('No stations found.'));
                }
                return ListView.builder(
                  itemCount: controller.stations.length,
                  itemBuilder: (context, index) {
                    final station = controller.stations[index];
                    return ListTile(
                      title: Text(station.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Gọi Popup chỉnh sửa ở đây
                              _showEditDialog(context, controller, station);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, controller, station);
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
    );
  }

  // Popup để chỉnh sửa trạm
  void _showEditDialog(BuildContext context, StationController controller, station) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController editController = TextEditingController(text: station.name);
        return AlertDialog(
          title: const Text('Edit Station'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Station Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  controller.updateStation(station.id, editController.text); // Cập nhật trạm
                  Navigator.pop(context);
                } else {
                  Get.snackbar('Error', 'Station name cannot be empty');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Popup xác nhận xóa trạm
  void _showDeleteConfirmationDialog(BuildContext context, StationController controller, station) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete "${station.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteStation(station.id); // Xóa trạm
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
