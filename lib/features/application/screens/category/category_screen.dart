import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:fyp_admin_panel/features/application/screens/category/responsive/category_desktop_screen.dart';
import 'package:fyp_admin_panel/features/application/screens/category/responsive/category_mobile_screen.dart';
import 'package:fyp_admin_panel/features/application/screens/category/responsive/category_tablet_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: CategoryScreenDesktop(),
      tablet: CategoryScreenTablet(),
      mobile: CategoryScreenMobile(),
    );
  }
}
