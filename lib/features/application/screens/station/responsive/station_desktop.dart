import 'package:flutter/material.dart';
import '../widgets/station_widgets.dart'; // Import widget đã tái sử dụng

class StationScreenDesktop extends StatelessWidget {
  const StationScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32.0), // Padding lớn hơn cho desktop
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: StationsWidgets(), // Sử dụng lại widget
            ),
          ],
        ),
      ),
    );
  }
}
