import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/formatters/formatter.dart';

class UserModel{
  final String? id;
  String email;
  String firstName;
  String lastName;
  String username;
  String phoneNumber;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updateAt;

  UserModel({
  this.id,
     this.firstName ='',
     this.lastName ='',
     this.username ='',
     this.phoneNumber ='',
    required this.email,
    this.profilePicture ='',
    this.role = AppRole.user,
    this.createdAt,
    this.updateAt,
  });

  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedDate => TFormatter.formatDate(updateAt);

  static List<String> nameParts(fullName) => fullName.split(" ");

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1? nameParts[1].toLowerCase() : "";
    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "us_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }
  static UserModel empty() => UserModel( email: '');


  /// Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Role' : role.name.toString(),
      'CreatedAt' : createdAt,
      'UpdatedAt' : updateAt = DateTime.now(),
    };
  }

  /// Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data.containsKey('FirstName') ?  data['FirstName'] ?? '' : '',
        lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
        username: data.containsKey('UserName') ? data['Username'] ?? '' : '',
        email: data.containsKey('Email') ? data['Email'] ?? '' : '',
        phoneNumber: data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
        profilePicture: data.containsKey('ProfilePicture') ? data['ProfilePicture'] ?? '' : '',
        role: data.containsKey('Role') ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString() ? AppRole.admin : AppRole.user : AppRole.user,
        createdAt: data.containsKey('CreateAt') ? data['CreateAt']?.toDate() ?? DateTime.now() : DateTime.now(),
        updateAt: data.containsKey('UpdateAt') ? data['UpdateAt']?.toDate() ?? DateTime.now() : DateTime.now(),
      );
    } else {
      return empty();
    }
  }
}