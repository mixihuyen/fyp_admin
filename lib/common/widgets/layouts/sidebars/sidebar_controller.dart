import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:fyp_admin_panel/utils/device/device_utility.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  final activeItem = TRoutes.responsiveDesign.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value = route;

  void changeHoverItem(String route) {
    if(!isActive(route)) hoverItem.value = route;
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if(!isActive(route)){
      changeActiveItem(route);

      if(TDeviceUtils.isMobileScreen(Get.context!)) {
        Get.back();  // Đóng sidebar nếu trên thiết bị di động
      }

      // Điều hướng và reload trang
      Get.offAllNamed(route); // Sử dụng offAllNamed để xóa route cũ và reload trang
    }
  }
}
