import 'package:flutter/material.dart';
import '../widgets/category_widgets.dart'; // Reuse category widget

class CategoryScreenTablet extends StatelessWidget {
  const CategoryScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.0), // Slightly smaller padding for tablet
        child: CategoryWidgets(), // Reuse the widget
      ),
    );
  }
}
