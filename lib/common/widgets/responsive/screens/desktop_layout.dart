import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:fyp_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
   DesktopLayout({super.key, this.body});

  final Widget? body;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child:TSidebar()),
          Expanded(
            flex: 5,
              child: Column(
                children: [
                  //HEADER
                  const THeader(),
                  //BODY
                  Expanded(child: body ?? const SizedBox()),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
