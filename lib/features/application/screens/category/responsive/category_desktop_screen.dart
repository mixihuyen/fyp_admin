import 'package:flutter/material.dart';
import '../widgets/category_widgets.dart'; // Reuse category widget

class CategoryScreenDesktop extends StatelessWidget {
  const CategoryScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CategoryWidgets(), // Reuse the widget
            ),
          ],
        ),
      ),
    );
  }
}
