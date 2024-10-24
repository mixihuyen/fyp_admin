import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../controllers/province_controller.dart';
import '../../../controllers/station_controller.dart';
import '../../../models/province_model.dart';
import '../../../models/station_model.dart';

class StationsWidgets extends StatefulWidget {
  const StationsWidgets({
    super.key,
  });

  @override
  _StationsWidgetsState createState() => _StationsWidgetsState();
}

class _StationsWidgetsState extends State<StationsWidgets> {
  final stationController = Get.put(StationController());
  final provinceController = Get.put(ProvinceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Stations'),
        backgroundColor: Colors.transparent, // Make the background transparent
        elevation: 0, // Remove the shadow
        actions: [
          IconButton(
            onPressed: () {
              _showAddStationPopup(
                  context, stationController, provinceController);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Station',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (provinceController.provinces.isEmpty ||
              stationController.stations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Group stations by province
          Map<String, List<StationModel>> provinceStationMap = {};
          for (var station in stationController.stations) {
            if (!provinceStationMap.containsKey(station.provinceId)) {
              provinceStationMap[station.provinceId] = [];
            }
            provinceStationMap[station.provinceId]!.add(station);
          }

          return ListView.builder(
            itemCount: provinceController.provinces.length,
            itemBuilder: (context, index) {
              final province = provinceController.provinces[index];
              final stations = provinceStationMap[province.id] ?? [];

              return ExpansionTile(
                title: Text(province.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                children: stations.isEmpty
                    ? [const ListTile(title: Text('No stations available'))]
                    : stations.map((station) {
                        return ListTile(
                          title: Text(station.name,
                              style: const TextStyle(fontSize: 14)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(
                                      context, stationController, station);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, stationController, station);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
              );
            },
          );
        }),
      ),
    );
  }

  // Popup to add a new station with province selection
  void _showAddStationPopup(
      BuildContext context,
      StationController stationController,
      ProvinceController provinceController) {
    final TextEditingController nameController = TextEditingController();
    String? selectedProvinceId;
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double dialogWidth = constraints.maxWidth < 600
                ? constraints.maxWidth * 0.9
                : constraints.maxWidth < 1000
                    ? constraints.maxWidth * 0.6
                    : 600;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(16.0),
              content: Container(
                width: dialogWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Add Station',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Province Dropdown
                      Obx(() {
                        if (provinceController.provinces.isEmpty) {
                          return const CircularProgressIndicator();
                        }
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Province',
                          ),
                          value: selectedProvinceId,
                          items: provinceController.provinces.map((province) {
                            return DropdownMenuItem(
                              value: province.id,
                              child: Text(province.name),
                            );
                          }).toList(),
                          validator: (value) =>
                              value == null ? 'Please select a province' : null,
                          onChanged: (value) {
                            setState(() {
                              selectedProvinceId = value!;
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 16),
                      // Station Name Input
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Station Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a station name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Buttons for submitting or cancelling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                stationController.addStation(
                                    nameController.text, selectedProvinceId!);
                                nameController.clear();
                                Navigator.of(context).pop();
                              } else {
                                Get.snackbar(
                                  'Form Incomplete',
                                  'Please fill out all fields correctly before submitting.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Popup to edit an existing station
  void _showEditDialog(BuildContext context, StationController controller,
      StationModel station) {
    final TextEditingController editController =
        TextEditingController(text: station.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Station'),
          content: TextFormField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Station Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                controller.updateStation(station.id, editController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Popup to confirm station deletion
  void _showDeleteConfirmationDialog(BuildContext context,
      StationController controller, StationModel station) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: Text(
              'Are you sure you want to delete "${station.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.deleteStation(station.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
