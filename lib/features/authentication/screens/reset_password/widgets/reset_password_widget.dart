import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final email = Get.parameters ['email'] ?? '';
    return Column(
      children: [
        Row(
          children:[ IconButton(
              onPressed: () => Get.offAllNamed(TRoutes.login),
              icon: const Icon(CupertinoIcons.clear)),
  ]),
        const SizedBox(height: TSizes.spaceBtwItems),

        const Image(
          image: AssetImage(TImages.deliveredEmailIllustration),
          width: 300, height: 300,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        Text(TTexts.changeYourPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(email, textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: TSizes.spaceBtwItems),
        Text(TTexts.changeYourPasswordSubTitle,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: TSizes.spaceBtwSections),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () => Get.offAllNamed(TRoutes.login) , child: const Text(TTexts.done)),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: TextButton(
              onPressed: () {}, child: const Text(TTexts.resendEmail)),
        ),
      ],
    );
  }
}