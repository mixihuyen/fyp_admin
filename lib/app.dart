import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:fyp_admin_panel/common/widgets/responsive/responsive_deisgn.dart';
import 'package:fyp_admin_panel/routes/app_routes.dart';
import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:get/get.dart';

import 'utils/constants/colors.dart';
import 'utils/constants/text_strings.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      getPages: TAppRoute.pages,
      initialRoute: TRoutes.login,
      unknownRoute: GetPage(name: '/page-not-found', page: () => const Scaffold(body: Center(child: Text('Page Not Found')))),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: TColors.light,
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}

class ResponsiveDesignScreen extends StatelessWidget {
  const ResponsiveDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: Desktop(), tablet: Tablet(), mobile: Mobile()
    );
  }
}

class Desktop extends StatelessWidget {
  const Desktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 1')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 2')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 3')),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
class Tablet extends StatelessWidget {
  const Tablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 1')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 2')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 3')),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
class Mobile extends StatelessWidget {
  const Mobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 1')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 2')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TRoundedContainer(
                height: 450,
                backgroundColor: Colors.blue.withOpacity(0.2),
                child: const Center(child: Text('BOX 3')),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}


