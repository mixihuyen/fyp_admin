import 'package:get/get.dart';

import '../../../data/repositories/orders/order_repository.dart';
import '../models/orders_model.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <OrderModel>[].obs;

  final OrderRepository orderRepository;

  OrderController({required this.orderRepository});

  @override
  void onInit() {
    super.onInit();
    loadAllOrdersFromAllUsers();
  }

  // Load all orders from Firestore
  Future<void> loadAllOrdersFromAllUsers() async {
    try {
      isLoading(true);
      final fetchedOrders = await orderRepository.fetchAllOrdersFromAllUsers();

      // Sort the orders based on item.date, in ascending order
      fetchedOrders.sort((a, b) {
        // Assuming each order has multiple items, sort by the earliest item date
        final aMinDate = a.items.map((item) => item.date).whereType<DateTime>().reduce((a, b) => a.isBefore(b) ? a : b);
        final bMinDate = b.items.map((item) => item.date).whereType<DateTime>().reduce((a, b) => a.isBefore(b) ? a : b);
        return aMinDate.compareTo(bMinDate);
      });

      // Update the orders list after sorting
      orders.value = fetchedOrders;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e');
    } finally {
      isLoading(false);
    }
  }

  List<OrderModel> getTodayOrders() {
    final today = DateTime.now();
    return orders.where((order) {
      return order.items.any((item) => isSameDay(item.date, today));
    }).toList();
  }

  List<OrderModel> getPastOrders() {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day); // Ensure time component is excluded

    return orders.where((order) {
      // Check if any item in the order has a date before today
      return order.items.any((item) =>
      item.date != null &&
          item.date!.isBefore(startOfToday) // Compare only the date, excluding time
      );
    }).toList();
  }


  bool isSameDay(DateTime? date1, DateTime date2) {
    if (date1 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
