import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/application/models/orders_model.dart';

class OrderRepository {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

  // Fetch all orders from all users
  Future<List<OrderModel>> fetchAllOrdersFromAllUsers() async {
    List<OrderModel> allOrders = [];

    try {
      // Step 1: Get all users
      QuerySnapshot userSnapshot = await usersCollection.get();
      List<QueryDocumentSnapshot> users = userSnapshot.docs;

      // Step 2: Iterate through each user and get their orders
      for (QueryDocumentSnapshot userDoc in users) {
        CollectionReference ordersCollection = usersCollection.doc(userDoc.id).collection('Orders');

        QuerySnapshot orderSnapshot = await ordersCollection.get();
        List<OrderModel> userOrders = orderSnapshot.docs
            .map((orderDoc) => OrderModel.fromSnapshot(orderDoc))
            .toList();

        // Add all the user's orders to the main list
        allOrders.addAll(userOrders);
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }

    return allOrders;
  }
}
