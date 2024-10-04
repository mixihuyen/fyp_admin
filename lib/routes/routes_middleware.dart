import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:get/get.dart';

class TRouteMiddleware extends GetMiddleware {


  @override
  RouteSettings? redirect(String? route) {
    print('Middleware called');
    final isAuthenticated = true;
    return isAuthenticated ? null : const RouteSettings(name: TRoutes.responsiveDesign);
  }
}