import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../controllers/trip_controller.dart';
import '../../../models/trip_model.dart';
import '../widgets/add_trip_popup.dart';

class TripScreenDesktop extends StatelessWidget {
  TripScreenDesktop({super.key});

  final TripController controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.stations.isEmpty ||
              controller.categories.isEmpty ||
              controller.provinces.isEmpty ||
              controller.trips.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Trips List',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddTripPopup();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildTripTable(constraints.maxWidth),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildTripTable(double maxWidth) {
    return Obx(() {
      final trips = controller.trips;

      if (trips.isEmpty) {
        return const Center(child: Text('No trips found.'));
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: maxWidth < 500 ? 600 : maxWidth,
          ),
          child: DataTable(
            columnSpacing: maxWidth < 500 ? 10 : 20,
            headingRowHeight: 40,
            dataRowHeight: 35,
            columns: const [
              DataColumn(label: Text('Start Prov.')),
              DataColumn(label: Text('Start Station')),
              DataColumn(label: Text('End Prov.')),
              DataColumn(label: Text('End Station')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Departure')),
              DataColumn(label: Text('Arrival')),
              DataColumn(label: Text('Price')),
              DataColumn(label: Text('Actions')), // New column for Edit/Delete buttons
            ],
            rows: trips.map((trip) {
              return DataRow(
                cells: [
                  DataCell(Text(_getProvinceName(trip.start?.startProvince))),
                  DataCell(Text(_getStationName(trip.start?.startLocation))),
                  DataCell(Text(_getProvinceName(trip.end?.endProvince))),
                  DataCell(Text(_getStationName(trip.end?.endLocation))),
                  DataCell(Text(_getCategoryName(trip.categoryId))),
                  DataCell(Text(trip.start?.departureTime ?? 'Unknown')),
                  DataCell(Text(trip.end?.arrivalTime ?? 'Unknown')),
                  DataCell(Text(TFormatter.format(trip.price))),
                  DataCell(
                    Builder(
                      builder: (BuildContext newContext) {
                        return Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: newContext,
                                  builder: (BuildContext dialogContext) {
                                    return AddTripPopup(trip: trip); // Truyền chuyến đi cần chỉnh sửa
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmation(newContext, trip); // Hiển thị xác nhận xóa
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  String _getCategoryName(String? categoryId) {
    final category = controller.categories.firstWhereOrNull(
          (category) => category.id == categoryId,
    );
    return category?.name ?? 'Unknown';
  }

  String _getProvinceName(String? provinceId) {
    final province = controller.provinces.firstWhereOrNull(
          (province) => province.id == provinceId,
    );
    return province?.name ?? 'Unknown';
  }

  String _getStationName(String? stationId) {
    final station = controller.stations.firstWhereOrNull(
          (station) => station.id == stationId,
    );
    return station?.name ?? 'Unknown';
  }

  void _showDeleteConfirmation(BuildContext context, TripModel trip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Trip'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteTrip(trip); // Xóa chuyến đi
                Navigator.of(context).pop(); // Đóng dialog sau khi xóa
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


}
