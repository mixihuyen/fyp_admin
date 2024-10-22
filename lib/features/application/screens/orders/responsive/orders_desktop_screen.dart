import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/appbar/tabbar.dart';
import '../../../../../common/widgets/icons/t_ticket_icon.dart';
import '../../../../../data/repositories/orders/order_repository.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/helpers/location_helper.dart';
import '../../../controllers/order_controller.dart';
import '../../../controllers/trip_controller.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/orders_model.dart';
import '../../trip/widgets/t_ticket_time_location.dart';

class OrdersDesktopScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController(orderRepository: OrderRepository()));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs: All, Today, Past
      child: Scaffold(
        appBar: AppBar(
          title: const TTabbar(
            tabs: [
              Tab(text: 'All '),
              Tab(text: 'Today\'s '),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Obx(() {
            if (orderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (orderController.filteredOrders.isEmpty) {
              return const Center(child: Text('No orders available.'));
            }

            return TabBarView(
              children: [
                _buildOrderTable(context, orderController.filteredOrders), // All Orders
                _buildOrderTable(context, orderController.getTodayOrders()), // Today's Orders
                _buildOrderTable(context, orderController.getPastOrders()), // Past Orders
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOrderTable(BuildContext context, List<OrderModel> orders) {
    return LayoutBuilder(
        builder: (context, constraints) {
          // Adjust font size and column spacing based on screen width
          double fontSize = constraints.maxWidth < 800 ? 10 : 12;
          double columnSpacing = constraints.maxWidth < 800 ? 10 : 20;
          double dataRowHeight = constraints.maxWidth < 800 ? 30 : 35;
          double headingRowHeight = constraints.maxWidth < 800 ? 35 : 40;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // Enable horizontal scrolling if necessary
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth, // Make the table responsive
              ),
              child: DataTable(
                columnSpacing: columnSpacing,
                // Adjust column spacing based on screen width
                headingRowHeight: headingRowHeight,
                dataRowHeight: dataRowHeight,
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Start Station')),
                  DataColumn(label: Text('End Station')),
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Total Amount')),
                  DataColumn(label: Text('Departure Date')),
                  DataColumn(label: Text('Actions')), // New action column
                ],
                rows: orders.map((order) {
                  return order.items.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(order.id)),
                        DataCell(
                            Text(_getStationName(item.start?.startLocation))),
                        DataCell(Text(_getStationName(item.end?.endLocation))),
                        DataCell(Text(order.name)),
                        DataCell(Text(order.phoneNumber)),
                        DataCell(Text(item.quantity.toString())),
                        DataCell(Text(TFormatter.format(order.totalAmount))),
                        DataCell(Text(TFormatter.formatDate(item.date))),

                        // Action button to open details in a popup
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.info),
                            onPressed: () {
                              _showOrderDetailsPopup(context, order, item);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList();
                }).expand((element) => element).toList(),
              ),
            ),
          );
        });
  }

  String _getStationName(String? stationId) {
    final station = Get.find<TripController>().stations.firstWhereOrNull(
          (station) => station.id == stationId,
    );
    return station?.name ?? 'Unknown';
  }

  void _showOrderDetailsPopup(BuildContext context, OrderModel order, CartItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final dark = THelperFunctions.isDarkMode(context);
        final startLocationName = LocationHelper.getStationName(item.start?.startLocation);
        final endLocationName = LocationHelper.getStationName(item.end?.endLocation);
        final startProvinceName = LocationHelper.getProvinceName(item.start?.startProvince);
        final endProvinceName = LocationHelper.getProvinceName(item.end?.endProvince);
        final category = LocationHelper.getCategoryName(item.category);

        return AlertDialog(
          title: Text('Order Details: ${order.id}'),
          content: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: dark ? TColors.textPrimary : TColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$startProvinceName - $endProvinceName'),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TicketDetailIcons(),
                      const SizedBox(width: TSizes.defaultSpace),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TicketTimeLocation(
                            time: item.start?.departureTime ?? '',
                            location: startLocationName ?? '',
                            province: startProvinceName ?? '',
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          TicketTimeLocation(
                            time: item.end?.arrivalTime ?? '',
                            location: endLocationName ?? '',
                            province: endProvinceName ?? '',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    children: [
                      Text('Category: $category', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Seats: ', style: Theme.of(context).textTheme.bodySmall),
                      Text(item.selectedSeats.join(', '), style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Departure Date: ', style: Theme.of(context).textTheme.bodySmall),
                      Text(' ${TFormatter.formatDate(item.date)} ', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Price Ticket: ', style: Theme.of(context).textTheme.bodySmall),
                      Text(' ${TFormatter.format(item.price)} ', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const Divider(),
                  Text('Customer Information ', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      Text('Full Name: ', style: Theme.of(context).textTheme.bodySmall),
                      Text('${order.name} ', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Phone Number: ', style: Theme.of(context).textTheme.bodySmall),
                      Text('${order.phoneNumber} ', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text('Payment Method: ', style: Theme.of(context).textTheme.bodySmall),
                      Text('${order.paymentMethod} ', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Order Date: ', style: Theme.of(context).textTheme.bodySmall),
                      Text(TFormatter.formatDate(order.orderDate), style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total amount: ', style: Theme.of(context).textTheme.titleMedium),
                      Text(TFormatter.format(order.totalAmount), style: const TextStyle(color: TColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
