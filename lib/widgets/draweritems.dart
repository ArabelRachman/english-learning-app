import 'package:flutter/material.dart';
import 'package:internal_assessment/screens/login_screen.dart';
import 'package:internal_assessment/screens/main_app_screen.dart';

import '../screens/game_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/timer_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

Widget buildHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
  );
}

Widget buildMenuItems(BuildContext context, int selection) {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  return Container(
      padding: const EdgeInsets.all((16)),
      child: Wrap(
    children: [
      ListTile(
        tileColor: (selection==0) ? Colors.blue: Colors.white,
        leading: const Icon(Icons.home_outlined),
        title: const Text("Home"),
        onTap: () {
          Navigator.pushReplacementNamed(context, MainAppScreen.routeName);

        },
      ),
      ListTile(
        tileColor: (selection==1) ? Colors.blue: Colors.white,
        leading: const Icon(Icons.watch_later_outlined),
        title: const Text("Timer"),
        onTap: () {
          Navigator.pushReplacementNamed(context, TimerScreen.routeName);
        },
      ),
      ListTile(
        tileColor: (selection==2) ? Colors.blue: Colors.white,
        leading: const Icon(Icons.book_outlined),
        title: const Text("Journal"),
        onTap: () {
          Navigator.pushReplacementNamed(context, JournalScreen.routeName);

        },
      ),
      ListTile(
        tileColor: (selection==3) ? Colors.blue: Colors.white,
        leading: const Icon(Icons.settings),
        title: const Text("Settings"),
        onTap: () {
          Navigator.pushReplacementNamed(context, GameScreen.routeName);

        },
      ),
      ListTile(
        tileColor: (selection==4) ? Colors.blue: Colors.white,
        leading: const Icon(Icons.logout),
        title: const Text("Log Out"),

        onTap: () async {
          await _firebaseAuth.signOut();


          Navigator.pushReplacementNamed(context, LoginScreen.routeName);

        },
      )
    ],
  ));
}
