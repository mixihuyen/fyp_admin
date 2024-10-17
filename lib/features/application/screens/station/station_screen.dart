import 'package:flutter/cupertino.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:fyp_admin_panel/features/application/screens/station/responsive/station_desktop.dart';
import 'package:fyp_admin_panel/features/application/screens/station/responsive/station_mobile.dart';
import 'package:fyp_admin_panel/features/application/screens/station/responsive/station_tablet.dart';

class StationScreen extends StatelessWidget {
  const StationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TSiteTemplate(desktop: StationScreenDesktop(), tablet: StationScreenTablet(), mobile: StationScreenMobile(),);
  }
}
