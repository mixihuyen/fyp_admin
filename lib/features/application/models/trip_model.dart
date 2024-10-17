class TripModel {
  String? id;
  String from;
  String to;
  String startTime;
  String endTime;
  double price;
  String busType;

  TripModel({
    this.id,
    required this.from,
    required this.to,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.busType,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'startTime': startTime,
      'endTime': endTime,
      'price': price,
      'busType': busType,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map, String id) {
    return TripModel(
      id: id,
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      price: map['price'].toDouble(),
      busType: map['busType'] ?? '',
    );
  }
}
