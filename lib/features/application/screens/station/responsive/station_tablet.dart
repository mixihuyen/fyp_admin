import 'package:flutter/material.dart';
import '../widgets/station_widgets.dart'; // Import widget đã tái sử dụng

class StationScreenTablet extends StatelessWidget {
  const StationScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0), // Padding lớn hơn cho tablet
        child: StationsWidgets(), // Sử dụng lại widget
      ),
    );
  }
}
