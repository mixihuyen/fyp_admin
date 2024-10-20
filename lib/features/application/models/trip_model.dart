import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_admin_panel/features/application/models/start_model.dart';

import 'end_model.dart';

class TripModel {
  String id;
  double price;
  String? categoryId;
  StartModel? start;
  EndModel? end;

  TripModel({
    required this.id,
    required this.price,
    this.categoryId,
    this.start,
    this.end,
  });

  static TripModel empty() => TripModel(id: '', price: 0);

  Map<String, dynamic> toJson() {
    return {
      'Price': price,
      'CategoryId': categoryId,
      'Start': start?.toJson(),
      'End': end?.toJson(),
    };
  }

  factory TripModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    // Kiểm tra và chuyển đổi giá trị price
    final dynamic priceValue = data['Price'];
    double price = 0;

    // Nếu giá trị là chuỗi, chuyển nó thành double
    if (priceValue is String) {
      price = double.tryParse(priceValue) ?? 0;
    }
    // Nếu giá trị là số, giữ nguyên
    else if (priceValue is num) {
      price = priceValue.toDouble();
    }

    return TripModel(
      id: document.id,
      price: price,
      categoryId: data['CategoryId'],
      start: StartModel.fromJson(data['Start']),
      end: EndModel.fromJson(data['End']),
    );
  }
}
