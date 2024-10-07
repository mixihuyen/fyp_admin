import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:get/get.dart';

class TRouteMiddleware extends GetMiddleware {


  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated ? null : const RouteSettings(name: TRoutes.login);
  }
}