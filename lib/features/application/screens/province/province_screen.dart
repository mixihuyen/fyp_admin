import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:fyp_admin_panel/features/application/screens/province/responsive/province_desktop_screen.dart';
import 'package:fyp_admin_panel/features/application/screens/province/responsive/province_mobile_screen.dart';
import 'package:fyp_admin_panel/features/application/screens/province/responsive/province_tablet_screen.dart';

class ProvinceScreen extends StatelessWidget {
  const ProvinceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(
      desktop: ProvinceScreenDesktop(),
      tablet: ProvinceScreenTablet(),
      mobile: ProvinceScreenMobile(),
    );
  }
}
