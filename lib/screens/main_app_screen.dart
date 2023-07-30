import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/navigation_drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chart.dart';

class MainAppScreen extends StatefulWidget {
  static const String routeName = '/mainpage';

  @override
  MainAppScreenState createState() => MainAppScreenState();
}

class MainAppScreenState extends State<MainAppScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late DatabaseReference _ref;
  late String emailPath;
  String? userName;

  List<String> last7Days = [
    DateFormat.yMMMd().format(DateTime.now()),
    DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 1))),
    DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 2))),
    DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 3))),
    DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 4))),
    DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 5))),
    DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: 6))),
  ];

  List<int> last7DaysTime = [0,0,0,0,0,0,0];
  List<int> last7DaysGoal = [1,1,1,1,1,1,1];


  @override
  void initState() {
    super.initState();
    String fullEmail = auth.currentUser?.email as String;
    int idx = fullEmail.indexOf('@');
    emailPath = fullEmail.substring(0, idx).trim();

    getUsername();
    initializeTimeList();
  }

  @override
  Widget build(BuildContext context) {
    print(last7DaysTime);

    return Scaffold(
      drawer: NavigationDrawer(0),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(children: [
            Text('Welcome $userName'),
            SizedBox(
              height: 20,
            ),
            Chart(last7DaysTime),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text('\nThis app will allow you to learn English in a completely new and unique way. The first feature is the English timer that allows you to log your the amount of time you want to speak English every day. '
                  'After speaking English for any amount of time, go back to the app and log your time so the app can keep track of how much time speaking you have left for the day.'),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: 370,
              height: 180,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text('\nAfter taking a look at the overall app information in the home screen, you can navigate to the second feature in the app, that being the journaling feature. Record your English speaking to keep track of your speaking skills and better yourself. '
                  'The app keeps important information about when your journals were recorded, as well as editable information such as what you want to call each audio journal.'),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: 370,
              height: 180,
            )
          ]),
        ),
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

  void initializeTimeList() async {
    List<int> tempList = [0,0,0,0,0,0,0];
    for(int i = 0; i< 7;i++){
      String timePath = last7Days[i];
      String? userID = auth.currentUser?.uid;
     // print('timers/$userID/$timePath/total');
      final snapshotTime = await FirebaseDatabase.instance.ref('timers/$userID/$timePath/total').get();
      final snapshotGoal = await FirebaseDatabase.instance.ref('timers/$userID/$timePath/goal').get();

      if(snapshotTime.exists && snapshotGoal.exists){
        tempList[i] = snapshotTime.value as int;
        last7DaysTime[i] = snapshotTime.value as int;
        last7DaysGoal[i] = snapshotGoal.value as int;


      }
    }
    //last7DaysTime = tempList;
    setState(() {

    });
  }
}
