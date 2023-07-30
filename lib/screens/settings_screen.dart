import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/navigation_drawer.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(4),
      appBar: AppBar(),
      body:
      Center(child: Text("Settings")),
    );
  }
}
