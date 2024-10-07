import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/styles/spacing_styles.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:fyp_admin_panel/utils/constants/colors.dart';
import 'package:fyp_admin_panel/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreenDesktopTablet extends StatelessWidget {
  const LoginScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const TLoginTemplate(
      child: Column(
        children: [
          //Header
          TLoginHeader(),

          //form
          TLoginFrom(),
        ],
      ),
    );
  }
}



