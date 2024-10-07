import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/features/authentication/screens/forget_password/widgets/header_form.dart';

import '../../../../../utils/constants/sizes.dart';

class ForgetPasswordMobile extends StatelessWidget {
  const ForgetPasswordMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
              child: HeaderAndForm())),
    );
  }
}
