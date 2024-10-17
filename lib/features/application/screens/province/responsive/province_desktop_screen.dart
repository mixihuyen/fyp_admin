import 'package:flutter/material.dart';
import '../widgets/province_widgets.dart'; // Reuse province widget

class ProvinceScreenDesktop extends StatelessWidget {
  const ProvinceScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ProvinceWidgets(), // Reuse the widget
            ),
          ],
        ),
      ),
    );
  }
}
