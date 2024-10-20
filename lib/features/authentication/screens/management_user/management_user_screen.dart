import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/features/authentication/screens/management_user/responsive/user_management_desktop_screen.dart';
import 'package:fyp_admin_panel/features/authentication/screens/management_user/responsive/user_management_tablet_mobile_screen.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: UserManagementDesktopScreen(),
      tablet:  UserManagementTabletMobileScreen(),
      mobile: UserManagementTabletMobileScreen(),
    );
  }
}