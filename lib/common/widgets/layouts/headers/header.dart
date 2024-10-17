import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:fyp_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:fyp_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:fyp_admin_panel/utils/constants/enums.dart';
import 'package:fyp_admin_panel/utils/device/device_utility.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        //Mobile Menu
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon: const Icon(Iconsax.menu))
            : null,

        // Search Field
        title: TDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search anything...'),
                ),
              )
            : null,

        actions: [
          //Search
          if (!TDeviceUtils.isDesktopScreen(context))
            IconButton(
                onPressed: () {}, icon: const Icon(Iconsax.search_normal)),

          //Notification
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.notification)),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          //User data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // image
              Obx(
                () => TRoundedImage(
                    width: 40,
                    padding: 2,
                    height: 40,
                    imageType: controller.user.value.profilePicture.isNotEmpty ? ImageType.network : ImageType.asset,
                    image: controller.user.value.profilePicture.isNotEmpty ? controller.user.value.profilePicture : TImages.user,
                ),
              ),
              const SizedBox(width: TSizes.sm),
              //Name and email
              if (!TDeviceUtils.isMobileScreen(context))
                Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const TShimmerEffect(width: 50, height: 13)
                          : Text(controller.user.value.fullName, style: Theme.of(context).textTheme.titleLarge),
                      controller.loading.value
                          ? const TShimmerEffect(width: 50, height: 13)
                          : Text(controller.user.value.email, style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);
}
