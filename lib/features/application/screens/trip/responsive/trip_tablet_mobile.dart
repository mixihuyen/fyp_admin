import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/features/application/screens/trip/widgets/add_trip_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/icons/t_ticket_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/helpers/location_helper.dart';
import '../../../controllers/trip_controller.dart';
import '../../../models/trip_model.dart';
import '../widgets/add_trip_popup.dart';
import '../widgets/search_trip.dart';
import '../widgets/t_ticket_time_location.dart';

class TripScreenTabletMobile extends StatelessWidget {
  TripScreenTabletMobile({super.key});

  final TripController controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.layers, color: Colors.red), // Set the icon color
                      label: const Text('Filter', style: TextStyle(color: Colors.red)), // Set the text color
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const SearchTrip(),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red, // Button text and icon color
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trips List',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await controller.fetchStations();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Để cho phép điều chỉnh chiều cao của bottom sheet
                          builder: (BuildContext dialogContext) {
                            return const AddTripBottomSheet(); // Sử dụng bottom sheet để thêm chuyến đi mới
                          },
                        );
                      },
                    ),

                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildTripCards(context),
                ),
              ],
            );
          },
        ),
      ),
    );

  }

  // Bố cục thẻ (Card) cho các chuyến đi
  Widget _buildTripCards(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(() {
      final trips = controller.filteredTrips;

      if (trips.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or Image
              const Icon(
                Icons.search_off,
                size: 80,
                color: Colors.grey, // You can change this to suit your theme
              ),
              const SizedBox(height: 16),

              // Text for no trips found
              Text(
                'No trips match.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Suggestion text
              Text(
                'Can you try turning off the filter and searching again?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
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
                  Text('${LocationHelper.getProvinceName(trip.start?.startProvince)} → ${LocationHelper.getProvinceName(trip.end?.endProvince)}',
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
                              location: LocationHelper.getStationName(trip.start?.startLocation) ?? '',
                              province: LocationHelper.getProvinceName(trip.start?.startProvince)  ?? '',
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            TicketTimeLocation(
                              time: trip.end != null ? trip.end!.arrivalTime : '',
                              location: LocationHelper.getStationName(trip.end?.endLocation) ?? '',
                              province: LocationHelper.getProvinceName(trip.end?.endProvince) ?? '',
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
                          Text('Category: ${LocationHelper.getCategoryName(trip.categoryId)}' ?? 'Unknown Category'),
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
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true, // Để cho phép điều chỉnh chiều cao của bottom sheet
                                builder: (BuildContext dialogContext) {
                                  return AddTripBottomSheet(trip: trip); // Sử dụng bottom sheet để chỉnh sửa chuyến đi
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
