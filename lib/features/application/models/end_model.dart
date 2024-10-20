import 'package:cloud_firestore/cloud_firestore.dart';

class EndModel {
  String id;
  String endLocation;
  String arrivalTime;
  String endProvince;

  EndModel({
    required this.id,
    required this.endLocation,
    required this.arrivalTime,
    required this.endProvince,
  });

  static EndModel empty() => EndModel(id: '', endLocation: '', arrivalTime: '', endProvince: '');

  Map<String, dynamic> toJson() {
    return {
      'EndLocation': endLocation,
      'ArrivalTime': arrivalTime,
      'EndProvince': endProvince,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'endLocation': endLocation,
      'arrivalTime': arrivalTime,
      'endProvince': endProvince,
    };
  }


  factory EndModel.fromJson(Map<String, dynamic> json) {
    return EndModel(
      id: json['Id'] ?? '',
      endLocation: json['EndLocation'] ?? '',
      arrivalTime: json['ArrivalTime'] ?? '',
      endProvince: json['EndProvince'] ?? '',
    );
  }
}
