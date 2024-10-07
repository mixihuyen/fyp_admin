import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/features/authentication/screens/reset_password/widgets/reset_password_widget.dart';

import '../../../../../utils/constants/sizes.dart';

class ResetPasswordMobile extends StatelessWidget {
  const ResetPasswordMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: ResetPasswordWidget())),
    );
  }
}
