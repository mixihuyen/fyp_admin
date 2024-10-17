import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import '../../../controllers/station_controller.dart';
import '../../../models/station_model.dart';

class StationsWidgets extends StatelessWidget {
  const StationsWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StationController());
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Phần bên trái để thêm địa điểm
            Expanded(
              flex: 2, // Chia không gian: 1 phần cho phần này
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Station:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Đặt TextField bên trong Expanded để chiếm khoảng trống còn lại
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Enter Station Name'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
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
                  const SizedBox(height: 50),
                  const Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Image(image: AssetImage(TImages.lightAppLogo), height: 500, width: 500)])
                ],
              ),
            ),
            const VerticalDivider(
              width: 40, // Độ rộng của đường gạch
              thickness: 1, // Độ dày của đường gạch
              color: Colors.grey, // Màu của đường gạch
            ),
            const SizedBox(width: 20), // Khoảng cách giữa 2 phần

            // Phần bên phải để hiển thị danh sách địa điểm
            Expanded(
              flex: 1, // Chia không gian: 2 phần cho phần danh sách
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stations:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Hiển thị danh sách các địa điểm đã thêm
                  Expanded(
                    child: Obx(() {
                      if (controller.stations.isEmpty) {
                        return const Text('No stations found.');
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
          ],
        ),
      ),
    );
  }

  // Popup để chỉnh sửa trạm
  void _showEditDialog(BuildContext context, StationController controller, StationModel station) {
    final TextEditingController editController = TextEditingController(text: station.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Station'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Station Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                controller.updateStation(station.id, editController.text); // Update station
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

  // Popup xác nhận xóa trạm
  void _showDeleteConfirmationDialog(BuildContext context, StationController controller, StationModel station) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete "${station.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng popup nếu người dùng chọn "Cancel"
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteStation(station.id); // Thực hiện xóa trạm
                Navigator.of(context).pop(); // Đóng popup sau khi xóa
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
