import 'package:flutter/material.dart';
import '../widgets/province_widgets.dart'; // Reuse province widget

class ProvinceScreenTablet extends StatelessWidget {
  const ProvinceScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0), // Slightly smaller padding for tablet
        child: ProvinceWidgets(), // Reuse the widget
      ),
    );
  }
}
