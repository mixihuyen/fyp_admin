import 'package:get/get.dart';
import '../../../data/repositories/orders/order_repository.dart';
import '../../../utils/formatters/formatter.dart';
import '../../../utils/helpers/location_helper.dart';
import '../../../utils/popups/loaders.dart';
import '../models/orders_model.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <OrderModel>[].obs;
  var filteredOrders = <OrderModel>[].obs;
  var searchQuery = ''.obs;

  final OrderRepository orderRepository;

  OrderController({required this.orderRepository});

  @override
  void onInit() {
    super.onInit();
    loadAllOrdersFromAllUsers();
    // Listen to changes in search query and trigger filtering
    ever(searchQuery, (_) => filterOrders());
  }

  // Load all orders from Firestore
  Future<void> loadAllOrdersFromAllUsers() async {
    try {
      isLoading(true);
      final fetchedOrders = await orderRepository.fetchAllOrdersFromAllUsers();

      if (fetchedOrders.isNotEmpty) {
        // Sort the orders based on item.date, in ascending order
        fetchedOrders.sort((a, b) {
          final aMinDate = a.items.map((item) => item.date).whereType<DateTime>().reduce((a, b) => a.isBefore(b) ? a : b);
          final bMinDate = b.items.map((item) => item.date).whereType<DateTime>().reduce((a, b) => a.isBefore(b) ? a : b);
          return aMinDate.compareTo(bMinDate);
        });

        // Update both orders and filteredOrders lists
        orders.assignAll(fetchedOrders); // Set fetched orders to the main list
        filteredOrders.assignAll(fetchedOrders); // Initially show all orders in filteredOrders
      } else {
        orders.clear();
        filteredOrders.clear();
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to load orders: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  // Filter orders based on the search query
  void filterOrders() {
    if (searchQuery.isEmpty) {
      filteredOrders.assignAll(orders); // Show all orders if search query is empty
    } else {
      final query = searchQuery.value.toLowerCase();

      filteredOrders.value = orders.where((order) {
        // Search across all relevant fields
        final matchesOrderId = order.id.toLowerCase().contains(query);
        final matchesName = order.name.toLowerCase().contains(query);
        final matchesPhoneNumber = order.phoneNumber.toLowerCase().contains(query);
        final matchesTotalAmount = TFormatter.format(order.totalAmount).toLowerCase().contains(query);

        // Check items in the order
        final matchesItems = order.items.any((item) {
          // Get the station names using LocationHelper
          final startLocationName = LocationHelper.getStationName(item.start?.startLocation);
          final endLocationName = LocationHelper.getStationName(item.end?.endLocation);

          final quantity = item.quantity.toString();
          final departureDate = TFormatter.formatDate(item.date).toLowerCase();

          return startLocationName.toLowerCase().contains(query) ||
              endLocationName.toLowerCase().contains(query) ||
              quantity.contains(query) ||
              departureDate.contains(query);
        });

        // Return true if any of the fields match
        return matchesOrderId || matchesName || matchesPhoneNumber || matchesTotalAmount || matchesItems;
      }).toList();
    }
  }



  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterOrders();
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
