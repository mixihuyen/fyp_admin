import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:fyp_admin_panel/features/application/screens/trip/responsive/trip_desktop.dart';
import 'package:fyp_admin_panel/features/application/screens/trip/responsive/trip_tablet_mobile.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TSiteTemplate(desktop: TripScreenDesktop(), tablet:  TripScreenTabletMobile(), mobile: TripScreenTabletMobile());
  }
}
