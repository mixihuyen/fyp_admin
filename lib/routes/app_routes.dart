
import 'package:fyp_admin_panel/features/application/screens/province/province_screen.dart';
import 'package:fyp_admin_panel/features/application/screens/trip/trip.dart';
import 'package:fyp_admin_panel/features/authentication/screens/forget_password/forget_password.dart';
import 'package:fyp_admin_panel/features/authentication/screens/management_user/management_user_screen.dart';
import 'package:fyp_admin_panel/features/authentication/screens/reset_password/reset_password.dart';
import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:fyp_admin_panel/routes/routes_middleware.dart';
import 'package:get/get.dart';

import '../app.dart';
import '../features/application/screens/category/category_screen.dart';
import '../features/application/screens/station/station_screen.dart';
import '../features/authentication/screens/login/login.dart';

class TAppRoute {
  static final List<GetPage> pages =[
    GetPage(name: TRoutes.login, page:() => const LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page:() => const ForgetPasswordScreen()),
    GetPage(name: TRoutes.resetPassword, page:() => const ResetPasswordScreen()),
    GetPage(name: TRoutes.trip, page:() => const TripScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.station, page:() => const StationScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.categories, page:() => const CategoryScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.province, page:() => const ProvinceScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.userManagement, page:() =>  UserManagementScreen(), middlewares: [TRouteMiddleware()]),
    GetPage(name: TRoutes.responsiveDesign, page:() => const ResponsiveDesignScreen(), middlewares: [TRouteMiddleware()]),
  ];
}