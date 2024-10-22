import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/trip_controller.dart';
import '../../../models/trip_model.dart';
import '../../../models/start_model.dart';
import '../../../models/end_model.dart';

class AddTripPopup extends StatefulWidget {
  final TripModel? trip; // Thêm tham số chuyến đi để chỉnh sửa

  const AddTripPopup({super.key, this.trip}); // Nhận tham số trip nếu có

  @override
  _AddTripPopupState createState() => _AddTripPopupState();
}

class _AddTripPopupState extends State<AddTripPopup> {
  final TripController controller = Get.put(TripController());
  final TextEditingController priceController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? selectedStartLocation;
  String? selectedEndLocation;
  String? selectedCategory;
  String? selectedStartProvince;
  String? selectedEndProvince;
  TimeOfDay? selectedDepartureTime;
  TimeOfDay? selectedArrivalTime;

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      // Điền trước dữ liệu nếu chỉnh sửa chuyến đi
      priceController.text = widget.trip!.price.toString();
      selectedStartLocation = widget.trip!.start?.startLocation;
      selectedEndLocation = widget.trip!.end?.endLocation;
      selectedCategory = widget.trip!.categoryId;
      selectedStartProvince = widget.trip!.start?.startProvince;
      selectedEndProvince = widget.trip!.end?.endProvince;
      departureTimeController.text = widget.trip!.start?.departureTime ?? '';
      arrivalTimeController.text = widget.trip!.end?.arrivalTime ?? '';
    }
  }

  // Function to select time
  Future<void> _selectTime(BuildContext context, bool isDeparture) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          selectedDepartureTime = picked;
          departureTimeController.text = selectedDepartureTime!.format(context);
        } else {
          selectedArrivalTime = picked;
          arrivalTimeController.text = selectedArrivalTime!.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle smallTextStyle = const TextStyle(fontSize: 12);

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
                  Text(
                    widget.trip != null ? 'Edit Trip' : 'Add Trip',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start Province and End Province Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (controller.provinces.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Start Province',
                              labelStyle: smallTextStyle,
                            ),
                            value: selectedStartProvince,
                            items: controller.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province.id,
                                child: Text(province.name, style: smallTextStyle),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select a start province'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                selectedStartProvince = value;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(() {
                          if (controller.provinces.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'End Province',
                              labelStyle: smallTextStyle,
                            ),
                            value: selectedEndProvince,
                            items: controller.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province.id,
                                child: Text(province.name, style: smallTextStyle),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select an end province'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                selectedEndProvince = value;
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Start Station and End Station Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (controller.stations.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Start Station',
                              labelStyle: smallTextStyle,
                            ),
                            value: selectedStartLocation,
                            items: controller.stations.map((station) {
                              return DropdownMenuItem(
                                value: station.id,
                                child: Text(station.name, style: smallTextStyle),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select a start station'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                selectedStartLocation = value;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(() {
                          if (controller.stations.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'End Station',
                              labelStyle: smallTextStyle,
                            ),
                            value: selectedEndLocation,
                            items: controller.stations.map((station) {
                              return DropdownMenuItem(
                                value: station.id,
                                child: Text(station.name, style: smallTextStyle),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select an end station'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                selectedEndLocation = value;
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Departure and Arrival Time
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: departureTimeController,
                          readOnly: true,
                          onTap: () => _selectTime(context, true),
                          decoration: InputDecoration(
                            labelText: 'Departure',
                            labelStyle: smallTextStyle,
                            hintText: 'Select Time',
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please select a departure time'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: arrivalTimeController,
                          readOnly: true,
                          onTap: () => _selectTime(context, false),
                          decoration: InputDecoration(
                            labelText: 'Arrival',
                            labelStyle: smallTextStyle,
                            hintText: 'Select Time',
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please select an arrival time'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Dropdown and Price Field
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          if (controller.categories.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Category',
                              labelStyle: smallTextStyle,
                            ),
                            value: selectedCategory,
                            items: controller.categories.map((category) {
                              return DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name, style: smallTextStyle),
                              );
                            }).toList(),
                            validator: (value) => value == null
                                ? 'Please select a category'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: smallTextStyle,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho phép nhập số
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 20),

                  // Submit and Cancel Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final trip = TripModel(
                              id: widget.trip?.id ?? '', // Use ID if editing
                              price: double.parse(priceController.text),
                              categoryId: selectedCategory,
                              start: StartModel(
                                id: selectedStartLocation ?? '',
                                startLocation: selectedStartLocation ?? '',
                                departureTime: selectedDepartureTime?.format(context) ??
                                    departureTimeController.text,
                                startProvince: selectedStartProvince ?? '',
                              ),
                              end: EndModel(
                                id: selectedEndLocation ?? '',
                                endLocation: selectedEndLocation ?? '',
                                arrivalTime: selectedArrivalTime?.format(context) ??
                                    arrivalTimeController.text,
                                endProvince: selectedEndProvince ?? '',
                              ),
                            );

                            if (widget.trip != null) {
                              // Update trip
                              controller.updateTrip(trip);
                            } else {
                              // Add new trip
                              controller.addTrip(trip);
                            }

                            Navigator.of(context).pop(); // Close the popup
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
                        child: Text(
                          widget.trip != null ? 'Save' : 'Add',
                          style: const TextStyle(fontSize: 12),
                        ),
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
  }
}
