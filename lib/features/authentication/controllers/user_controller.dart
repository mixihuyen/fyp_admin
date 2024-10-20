import 'package:get/get.dart';
import '../models/user_model.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  RxBool loading = false.obs; // Controls the loading state
  RxList<UserModel> users = <UserModel>[].obs; // List of all users
  Rx<UserModel> user = UserModel.empty().obs;

  final UserRepository userRepository = Get.put(UserRepository()); // Instance of UserRepository

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
    fetchAllUsers(); // Fetch all users when the controller is initialized
  }

  // Fetch all users from Firestore through the repository
  Future<void> fetchAllUsers() async {
    try {
      loading.value = true; // Start loading
      final allUsers = await userRepository.fetchAllUsers(); // Fetch data from repository
      users.value = allUsers; // Update the observable list
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString()); // Show error message
    } finally {
      loading.value = false; // Stop loading
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      loading.value = true;
      final user = await userRepository.fetchAdminDetails();
      this.user.value = user;
      loading.value = false;
      return user;
    } catch (e) {
      loading.value = false;
      TLoaders.errorSnackBar(title: 'Something went wrong!', message: e.toString());
      return UserModel.empty();
    }
  }

// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await userRepository.deleteUser(userId); // Call delete method in repository
      users.removeWhere((user) => user.id == userId); // Update the local list of users
      TLoaders.successSnackBar(title: 'Success', message: 'User deleted successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to delete user');
    }
  }

  // Create or update a user
  Future<void> createUser(UserModel user) async {
    try {
      loading.value = true;
      await userRepository.createUser(user); // Save user through repository
      fetchAllUsers(); // Refresh the user list
      TLoaders.successSnackBar(title: 'Success', message: 'User saved successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to save user');
    } finally {
      loading.value = false;
    }
  }

  // Update a user
  Future<void> updateUser(UserModel user) async {
    try {
      loading.value = true;
      await userRepository.updateUser(user); // Call update method in repository
      fetchAllUsers(); // Refresh the user list
      TLoaders.successSnackBar(title: 'Success', message: 'User updated successfully');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Failed to update user');
    } finally {
      loading.value = false;
    }
  }
}
