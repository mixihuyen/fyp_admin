import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/icons/t_ticket_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/trip_controller.dart';
import '../../../models/trip_model.dart';
import '../widgets/add_trip_popup.dart';
import '../widgets/t_ticket_time_location.dart';

class TripScreenTabletMobile extends StatelessWidget {
  TripScreenTabletMobile({super.key});

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

          // Hiển thị danh sách chuyến đi dưới dạng thẻ
          return _buildTripCards(context);
        }),
      ),
    );
  }

  // Bố cục thẻ (Card) cho các chuyến đi
  Widget _buildTripCards(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(() {
      final trips = controller.trips;

      if (trips.isEmpty) {
        return const Center(child: Text('No trips found.'));
      }

      return ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];

          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 350,
              margin: const EdgeInsets.only(
                top: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: dark ? TColors.textPrimary : TColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Title
                  Text('${_getProvinceName(trip.start?.startProvince)} → ${_getProvinceName(trip.end?.endProvince)}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// -- Divider
                  const Divider(),

                  /// -- Ticket Details
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// -- Icon
                      const TicketDetailIcons(),
                      const SizedBox(width: TSizes.spaceBtwItems * 2),

                      /// -- Details
                      Expanded( // Sử dụng Expanded để điều chỉnh chiều rộng
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TicketTimeLocation(
                              time: trip.start != null
                                  ? trip.start!.departureTime
                                  : '',
                              location: _getStationName(trip.start?.startLocation) ?? '',
                              province: _getProvinceName(trip.start?.startProvince)  ?? '',
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            TicketTimeLocation(
                              time: trip.end != null ? trip.end!.arrivalTime : '',
                              location: _getStationName(trip.end?.endLocation) ?? '',
                              province: _getProvinceName(trip.end?.endProvince) ?? '',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// -- Divider
                  const Divider(),

                  /// -- Price and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category: ${_getCategoryName(trip.categoryId)}' ?? 'Unknown Category'),
                          Text('Price:  ${TFormatter.format(trip.price)}'),
                        ],
                      ),

                      // Điều chỉnh các nút bằng Wrap để tránh tràn
                      Wrap(
                        spacing: 8.0, // Khoảng cách giữa các nút
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AddTripPopup(trip: trip); // Chỉnh sửa chuyến đi
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmation(context, trip); // Xóa chuyến đi
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
