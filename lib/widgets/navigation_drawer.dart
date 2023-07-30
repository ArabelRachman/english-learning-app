import 'package:flutter/material.dart';

import 'draweritems.dart';

class NavigationDrawer extends StatelessWidget {
  int currentOption;

  NavigationDrawer(this.currentOption);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context, currentOption)
          ],
        )
      ),

    );
  }

}