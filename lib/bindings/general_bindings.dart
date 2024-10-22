
import 'package:get/get.dart';

import '../features/application/controllers/trip_controller.dart';
import '../features/authentication/controllers/user_controller.dart';
import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.put(TripController());
    Get.put(UserController());

  }
}