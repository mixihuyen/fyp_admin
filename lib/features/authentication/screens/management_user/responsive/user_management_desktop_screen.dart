import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/utils/formatters/formatter.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_model.dart';

class UserManagementDesktopScreen extends StatelessWidget {
  UserManagementDesktopScreen({Key? key}) : super(key: key);

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(32.0),
      child: Obx(() {
        if (userController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final users =
            userController.filteredUsers; // Lấy danh sách người dùng từ controller

        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        return LayoutBuilder(builder: (context, constraints) {
          // Adjust font size and column spacing based on screen width
          double fontSize = constraints.maxWidth < 500 ? 10 : 12;
          double columnSpacing = constraints.maxWidth < 500 ? 10 : 20;
          double dataRowHeight = constraints.maxWidth < 500 ? 30 : 35;
          double headingRowHeight = constraints.maxWidth < 500 ? 35 : 40;

          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'User Management',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
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
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Username')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows:
                      users.map((user) => _buildDataRow(user, context)).toList(),
                ),
              ),
            ),
          ]);
        });
      }),
    ));
  }

  DataRow _buildDataRow(UserModel user, BuildContext context) {
    const textStyle = TextStyle(fontSize: 14); // Reduce the font size

    return DataRow(
      cells: [
        DataCell(
            Text(TFormatter.formatCellValue(user.firstName), style: textStyle)),
        DataCell(
            Text(TFormatter.formatCellValue(user.lastName), style: textStyle)),
        DataCell(
            Text(TFormatter.formatCellValue(user.username), style: textStyle)),
        DataCell(
            Text(TFormatter.formatCellValue(user.email), style: textStyle)),
        DataCell(Text(TFormatter.formatCellValue(user.phoneNumber),
            style: textStyle)),
        DataCell(
            Text(TFormatter.formatCellValue(user.role.name), style: textStyle)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showEditUserDialog(context, user);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmation(context, user);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Hiển thị popup để xác nhận xóa người dùng
  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                userController.deleteUser(user.id!);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Define the _showEditUserDialog method
  void _showEditUserDialog(BuildContext context, UserModel user) {
    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    final TextEditingController emailController =
        TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update the user details in the controller
                user.firstName = firstNameController.text;
                user.lastName = lastNameController.text;
                user.email = emailController.text;

                // Call controller to update user
                userController.updateUser(user);
                Navigator.of(context).pop(); // Close the dialog after saving
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
