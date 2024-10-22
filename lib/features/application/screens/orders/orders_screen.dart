import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:fyp_admin_panel/features/application/screens/orders/responsive/orders_desktop_screen.dart';
import 'package:fyp_admin_panel/features/application/screens/orders/responsive/orders_tablet_mobile_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(
      desktop: OrdersDesktopScreen(),
      tablet: OrdersTabletMobileScreen(),
      mobile: OrdersTabletMobileScreen(),
    );
  }
}
