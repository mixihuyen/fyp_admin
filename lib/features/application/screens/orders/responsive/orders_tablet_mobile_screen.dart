import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/widgets/appbar/tabbar.dart';
import 'package:get/get.dart';
import '../../../../../common/styles/shadows.dart';
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

class OrdersTabletMobileScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController(orderRepository: OrderRepository()));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs: All, Today, Past
      child: Scaffold(
        appBar: AppBar(
          title: const TTabbar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Today\'s '),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (orderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildOrderList(context, orderController.orders, "No orders available."), // All Orders
                _buildOrderList(context, orderController.getTodayOrders(), "No orders available."), // Today's Orders
                _buildOrderList(context, orderController.getPastOrders(), "No orders available."), // Past Orders
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderModel> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      );
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          child: ListTile(
            title: Text(order.id),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getStationName(order.items.first.start?.startLocation)} - ${_getStationName(order.items.first.end?.endLocation)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('Customer: ${order.name} - ${order.phoneNumber}'),
                Text('Number of tickets: ${order.items.first.quantity}'),
                Text('Total: ${TFormatter.format(order.totalAmount)}'),
                Text('Departure Date: ${TFormatter.formatDate(order.items.first.date)}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                _showOrderDetailsPopup(context, order, order.items.first);
              },
            ),
          ),
        );
      },
    );
  }

  String _getStationName(String? stationId) {
    final station = Get.find<TripController>().stations.firstWhereOrNull(
          (station) => station.id == stationId,
    );
    return station?.name ?? 'Unknown';
  }

  void _showOrderDetailsPopup(BuildContext context, OrderModel order, CartItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen height
      builder: (BuildContext context) {
        final dark = THelperFunctions.isDarkMode(context);
        final startLocationName = LocationHelper.getStationName(item.start?.startLocation);
        final endLocationName = LocationHelper.getStationName(item.end?.endLocation);
        final startProvinceName = LocationHelper.getProvinceName(item.start?.startProvince);
        final endProvinceName = LocationHelper.getProvinceName(item.end?.endProvince);
        final category = LocationHelper.getCategoryName(item.category);

        return DraggableScrollableSheet( // Allows dragging to resize
          expand: false, // Expands only when dragged
          initialChildSize: 0.5, // Initial size as half the screen height
          minChildSize: 0.3, // Minimum size
          maxChildSize: 0.9, // Maximum size
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController, // Attach the scroll controller
              child: Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                decoration: BoxDecoration(
                  color: dark ? TColors.textPrimary : TColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- Title
                    Text('$startProvinceName - $endProvinceName', style: Theme.of(context).textTheme.titleLarge,),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(),

                    /// -- Ticket Details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -- Icon
                        const TicketDetailIcons(),
                        const SizedBox(width: TSizes.defaultSpace),

                        /// -- Details
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

                    /// -- Category
                    Row(
                      children: [
                        Text(
                          'Category:   $category',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Seats:   ', style: Theme.of(context).textTheme.bodySmall),
                        Text(item.selectedSeats.join(', '), style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),

                    /// -- Date
                    Row(children: [
                      Text('Departure Date:   ', style: Theme.of(context).textTheme.bodySmall),
                      Text(' ${TFormatter.formatDate(item.date)} ', style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                    Row(children: [
                      Text('Price Ticket:   ', style: Theme.of(context).textTheme.bodySmall),
                      Text(' ${TFormatter.format(item.price)} ', style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                    const Divider(),

                    Text('Customer Information ', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Row(children: [
                      Text('Full Name:   ', style: Theme.of(context).textTheme.bodySmall),
                      Text('${order.name} ', style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                    Row(children: [
                      Text('Phone Number:   ', style: Theme.of(context).textTheme.bodySmall),
                      Text('${order.phoneNumber} ', style: Theme.of(context).textTheme.bodyMedium),
                    ]),

                    const Divider(),
                    Row(children: [
                      Text('Payment Method:   ', style: Theme.of(context).textTheme.bodySmall),
                      Text('${order.paymentMethod} ', style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                    Row(children: [
                      Text('Order Date:   ', style: Theme.of(context).textTheme.bodySmall),
                      Text(TFormatter.formatDate(order.orderDate), style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                    const Divider(),

                    /// -- Price
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
            );
          },
        );
      },
    );
  }
}
