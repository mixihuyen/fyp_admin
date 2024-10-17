import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_admin_panel/data/repositories/user/user_repository.dart';
import 'package:fyp_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:fyp_admin_panel/features/authentication/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();

  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    // Lấy giá trị đã lưu từ GetStorage và gán lại cho rememberMe
    rememberMe.value = localStorage.read('REMEMBER_ME_CHECKED') ?? false;

    if (rememberMe.value) {
      email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
      password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    }

    // In ra để kiểm tra khi khởi động lại ứng dụng
    print('Remember Me Checked on App Start: ${localStorage.read('REMEMBER_ME_CHECKED')}');
    print('Email on App Start: ${localStorage.read('REMEMBER_ME_EMAIL')}');
    print('Password on App Start: ${localStorage.read('REMEMBER_ME_PASSWORD')}');

    super.onInit();
  }




  Future<void> emailAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Logging you in...', TImages.animation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
        localStorage.write('REMEMBER_ME_CHECKED', true);

        // In ra để kiểm tra
        print('Stored Email: ${localStorage.read('REMEMBER_ME_EMAIL')}');
        print('Stored Password: ${localStorage.read('REMEMBER_ME_PASSWORD')}');
        print('Remember Me Checked: ${localStorage.read('REMEMBER_ME_CHECKED')}');
      } else {
        localStorage.remove('REMEMBER_ME_EMAIL');
        localStorage.remove('REMEMBER_ME_PASSWORD');
        localStorage.write('REMEMBER_ME_CHECKED', false);

        // In ra để kiểm tra sau khi xóa
        print('Email after remove: ${localStorage.read('REMEMBER_ME_EMAIL')}');
        print('Password after remove: ${localStorage.read('REMEMBER_ME_PASSWORD')}');
        print('Remember Me Checked after remove: ${localStorage.read('REMEMBER_ME_CHECKED')}');
      }


      //Login user using Email & Password Authentication
      await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      final user = await UserController.instance.fetchUserDetails();

      //Remove Loader
      TFullScreenLoader.stopLoading();

      if(user.role != AppRole.admin) {
        await AuthenticationRepository.instance.logout();
        TLoaders.errorSnackBar(title: 'Not Authorized', message: 'You are not authorized or do have access. Contact Admin');
      } else {
        TFullScreenLoader.stopLoading();
        AuthenticationRepository.instance.screenRedirect();
      }


    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> registerAdmin() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Registering Admin Account...', TImages.animation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      //register user using Email & Password Authentication
      await AuthenticationRepository.instance
          .registerWithEmailAndPassword('admin@gmail.com', 'Admin@123');

      //Create admin record in the Firestore
      final userRepository = Get.put(UserRepository());
      await userRepository.createUser(UserModel(
        id: AuthenticationRepository.instance.authUser!.uid,
        firstName: 'Mixi Huyen',
        lastName: 'Admin',
        email: 'admin@gmail.com',
        role: AppRole.admin,
        createdAt: DateTime.now(),
      ));
      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
