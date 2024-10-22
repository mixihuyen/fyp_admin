
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class TTabbar extends StatelessWidget implements PreferredSizeWidget {
  const TTabbar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark? TColors.dark : TColors.light,
      child: TabBar(
        tabs: tabs,
        isScrollable: false,
        indicatorColor: TColors.primary,
        unselectedLabelColor: TColors.darkerGrey,
        labelColor: dark ? TColors.white : TColors.primary,
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(48);
}
