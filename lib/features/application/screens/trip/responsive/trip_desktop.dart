import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/location_helper.dart';
import '../../../controllers/trip_controller.dart';
import '../../../models/trip_model.dart';
import '../widgets/add_trip_popup.dart';

class TripScreenDesktop extends StatefulWidget {
  TripScreenDesktop({super.key});

  @override
  _TripScreenDesktopState createState() => _TripScreenDesktopState();
}

class _TripScreenDesktopState extends State<TripScreenDesktop> {
  final TripController controller = Get.put(TripController());
  String? selectedStartStation;
  String? selectedEndStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: LayoutBuilder(
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
                      onPressed: () async {
                        await controller.fetchStations();
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

                // Filter Section
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        if (controller.stations.isEmpty) {
                          return const CircularProgressIndicator();
                        }
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Start Station'),
                          value: selectedStartStation,
                          items: controller.stations.map((station) {
                            return DropdownMenuItem(
                              value: station.id,
                              child: Text(
                                  '${LocationHelper.getStationName(station.id)} (${LocationHelper.getProvinceName(station.provinceId)})'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStartStation = value;
                              // Call the new filter method
                              controller.filter(selectedStartStation: selectedStartStation, selectedEndStation: selectedEndStation);
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Obx(() {
                        if (controller.stations.isEmpty) {
                          return const CircularProgressIndicator();
                        }
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'End Station'),
                          value: selectedEndStation,
                          items: controller.stations.map((station) {
                            return DropdownMenuItem(
                              value: station.id,
                              child: Text(
                                  '${LocationHelper.getStationName(station.id)} (${LocationHelper.getProvinceName(station.provinceId)})'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedEndStation = value;
                              // Call the new filter method
                              controller.filter(selectedStartStation: selectedStartStation, selectedEndStation: selectedEndStation);
                            });
                          },
                        );
                      }),
                    ),

                    // Clear Filter Button
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Reset filters
                        setState(() {
                          selectedStartStation = null;
                          selectedEndStation = null;
                        });
                        // Call the filter method with no filters
                        controller.filter(selectedStartStation: null, selectedEndStation: null);
                      },
                      child: const Text('Clear'),
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
        ),
      ),
    );
  }


  Widget _buildTripTable(double maxWidth) {
    return Obx(() {
      final trips = controller.filteredTrips;

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
              DataColumn(label: Text('Actions')),
            ],
            rows: trips.map((trip) {
              return DataRow(
                cells: [
                  DataCell(Text(LocationHelper.getProvinceName(trip.start?.startProvince))),
                  DataCell(Text(LocationHelper.getStationName(trip.start?.startLocation))),
                  DataCell(Text(LocationHelper.getProvinceName(trip.end?.endProvince))),
                  DataCell(Text(LocationHelper.getStationName(trip.end?.endLocation))),
                  DataCell(Text(LocationHelper.getCategoryName(trip.categoryId))),
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
                                    return AddTripPopup(trip: trip); // Pass trip for editing
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmation(newContext, trip);
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
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteTrip(trip); // Delete trip
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
