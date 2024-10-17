import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class TripDesktopScreen extends StatelessWidget {
  const TripDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Heading
              Text('Trip', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: TSizes.spaceBtwItems),

            ],
          ),
        ),
      ),
    );
  }
}
