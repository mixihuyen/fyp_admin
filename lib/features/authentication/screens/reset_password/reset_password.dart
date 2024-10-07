import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/features/authentication/screens/reset_password/responsive_screens/reset_password_desktop_tablet.dart';
import 'package:fyp_admin_panel/features/authentication/screens/reset_password/responsive_screens/reset_password_mobile.dart';

import '../../../../common/widgets/layouts/templates/site_layout.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(useLayout: false,desktop: ResetPasswordDesktopTablet(),mobile: ResetPasswordMobile());
  }
}
