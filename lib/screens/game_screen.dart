import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = '/game-screen';

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late DatabaseReference _ref;
  TextEditingController usernameController = TextEditingController();
  late String emailPath;
  String? userName;

  @override
  void initState() {
    super.initState();
    super.initState();
    String fullEmail = auth.currentUser?.email as String;
    int idx = fullEmail.indexOf('@');
    emailPath = fullEmail.substring(0, idx).trim();

    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(3),
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 50),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text('Username: $userName'),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) {
                          return AlertDialog(
                            title: TextField(
                              decoration: new InputDecoration(
                                  hintText: 'Update Username'),
                              controller: usernameController,
                            ),
                            content: TextButton(onPressed: () async {
                              await FirebaseDatabase.instance.ref('usernames/$emailPath').set(usernameController.text);

                              getUsername();
                              setState(() {

                              });
                              Navigator.pop(context);

                            },
                            child: Text('save'),),
                          );
                        });
                  },
                  icon: Icon(Icons.edit))
            ],
          ),
        ],
      ),
    );
  }

  void getUsername() async {
    final snapshotUsername =
        await FirebaseDatabase.instance.ref('usernames/$emailPath').get();
    print(snapshotUsername.exists);
    if (snapshotUsername.exists) {
      print(snapshotUsername.value);
      userName = snapshotUsername.value as String;
      setState(() {});
    }
  }
}
