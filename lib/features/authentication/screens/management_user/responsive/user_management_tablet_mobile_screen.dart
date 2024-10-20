import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatter.dart';
import '../../../controllers/user_controller.dart';
import '../../../models/user_model.dart';

class UserManagementTabletMobileScreen extends StatelessWidget {
  UserManagementTabletMobileScreen({Key? key}) : super(key: key);

  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    final isTabletOrMobile = MediaQuery.of(context).size.width <= 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (userController.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = userController.users;

          if (users.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          return _buildUserList(users);
        }),
      ),
    );
  }

  // Method to build ListView for mobile screens
  Widget _buildUserList(List<UserModel> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text('Email: ${TFormatter.formatCellValue(user.email)}\nPhone: ${TFormatter.formatCellValue(user.phoneNumber)}\nUsername: ${TFormatter.formatCellValue(user.username)}\nRole: ${TFormatter.formatCellValue(user.role.name)}'),
            trailing:  SizedBox(
              width: 80, // Adjust width based on your layout
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
          ),
        );
      },
    );
  }

  // Edit User Dialog
  void _showEditUserDialog(BuildContext context, UserModel user) {
    final TextEditingController firstNameController = TextEditingController(text: user.firstName);
    final TextEditingController lastNameController = TextEditingController(text: user.lastName);
    final TextEditingController emailController = TextEditingController(text: user.email);

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
                user.firstName = firstNameController.text;
                user.lastName = lastNameController.text;
                user.email = emailController.text;

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

  // Delete Confirmation Dialog
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
}
