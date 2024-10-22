import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:fyp_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:fyp_admin_panel/features/application/controllers/category_controller.dart';
import 'package:fyp_admin_panel/features/application/controllers/station_controller.dart';
import 'package:fyp_admin_panel/features/authentication/controllers/user_controller.dart';
import 'package:fyp_admin_panel/utils/constants/enums.dart';
import 'package:fyp_admin_panel/utils/device/device_utility.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/application/controllers/province_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class THeader extends StatefulWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});

  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 15);

  @override
  _THeaderState createState() => _THeaderState();
}

class _THeaderState extends State<THeader> {
  final UserController controller = UserController.instance;
  final StationController stationController = Get.put(StationController());
  final ProvinceController provinceController = Get.put(ProvinceController());
  final CategoryController categoryController = Get.put(CategoryController());
  bool isSearchExpanded = false; // State to manage the expanded search bar
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        // Mobile Menu Icon
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
          onPressed: () => widget.scaffoldKey?.currentState?.openDrawer(),
          icon: const Icon(Iconsax.menu),
        )
            : null,

        // Search Field for Desktop
        title: TDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
          width: 400,
          child: TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.search_normal),
              hintText: 'Search anything...',
            ),
            onChanged: (value) {
              stationController.searchStations(value);
              provinceController.searchProvinces(value);
              categoryController.searchCategories(value);
            },
          ),
        )
            : null,

        actions: [
          // Search Icon for Mobile
          if (!TDeviceUtils.isDesktopScreen(context))
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSearchExpanded ? 220 : 40, // Expand or contract based on state
              child: Row(
                children: [
                  if (isSearchExpanded)
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          stationController.searchStations(value);
                          provinceController.searchProvinces(value);
                          categoryController.searchCategories(value);

                        },
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Iconsax.search_normal),
                    onPressed: () {
                      setState(() {
                        isSearchExpanded = !isSearchExpanded; // Toggle search expansion
                        if (!isSearchExpanded) {
                          searchController.clear(); // Clear search when closing
                          stationController.searchStations(''); // Reset search results
                          provinceController.searchProvinces('');
                          categoryController.searchCategories('');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),

          // Notification Icon
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.notification),
          ),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          // User Data Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User Profile Image
              Obx(
                    () => TRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  imageType: controller.user.value.profilePicture.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : TImages.user,
                ),
              ),
              const SizedBox(width: TSizes.sm),
              // User Name and Email for Desktop
              if (!TDeviceUtils.isMobileScreen(context))
                Obx(
                      () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.loading.value
                          ? const TShimmerEffect(width: 50, height: 13)
                          : Text(
                        controller.user.value.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      controller.loading.value
                          ? const TShimmerEffect(width: 50, height: 13)
                          : Text(
                        controller.user.value.email,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
