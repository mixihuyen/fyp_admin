import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/widgets/images/t_circular_image.dart';
import 'package:fyp_admin_panel/routes/routes.dart';
import 'package:fyp_admin_panel/utils/constants/image_strings.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'menu/menu_item.dart';

class TSidebar extends StatelessWidget {
  const TSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const BeveledRectangleBorder(),
      child: Container(
        decoration: const BoxDecoration(
          color: TColors.white,
          border: Border(right: BorderSide(color: TColors.grey, width: 1))
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(image: AssetImage(TImages.shortlightAppLogo), width: 100,height: 100,),
              const SizedBox(height: TSizes.spaceBtwSections),
              Padding(
                padding: const EdgeInsets.all(TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('MENU', style: Theme.of(context).textTheme.bodySmall!.apply(letterSpacingDelta: 1.2)),
                    const TMenuItem(route: TRoutes.trip,icon: Iconsax.ticket, itemName: 'Trips'),
                    const TMenuItem(route: TRoutes.station,icon: Iconsax.location, itemName: 'Stations'),
                    const TMenuItem(route: TRoutes.province,icon: Iconsax.home, itemName: 'Provinces'),
                    const TMenuItem(route: TRoutes.categories,icon: Iconsax.category, itemName: 'Categories'),
                    const TMenuItem(route: TRoutes.userManagement,icon: Iconsax.user, itemName: 'User Management'),
                    const TMenuItem(route: TRoutes.orders,icon: Iconsax.card_tick, itemName: 'Order Management'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


