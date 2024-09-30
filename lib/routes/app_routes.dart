import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:fyp_admin_panel/routes/routes_middleware.dart';
import 'package:get/get.dart';

import '../app.dart';

class TAppRoute {
  static final List<GetPage> pages =[
    GetPage(name: TRoutes.home, page:() => const HomeScreen(), middlewares: [TRouteMiddleware()]),
  ];
}