import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/app.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../widgets/reset_password_widget.dart';

class ResetPasswordDesktopTablet extends StatelessWidget {
  const ResetPasswordDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate
      (child: ResetPasswordWidget());
  }
}


