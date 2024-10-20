import 'package:cloud_firestore/cloud_firestore.dart';

class StartModel {
  String id;
  String startLocation;
  String departureTime;
  String startProvince;

  StartModel({
    required this.id,
    required this.startLocation,
    required this.departureTime,
    required this.startProvince,
  });

  static StartModel empty() => StartModel(id: '', startLocation: '', departureTime: '', startProvince: '');

  Map<String, dynamic> toJson() {
    return {
      'StartLocation': startLocation,
      'DepartureTime': departureTime,
      'StartProvince': startProvince,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startLocation': startLocation,
      'departureTime': departureTime,
      'startProvince': startProvince,
    };
  }

  factory StartModel.fromJson(Map<String, dynamic> json) {
    return StartModel(
      id: json['Id'] ?? '',
      startLocation: json['StartLocation'] ?? '',
      departureTime: json['DepartureTime'] ?? '',
      startProvince: json['StartProvince'] ?? '',
    );
  }
}
