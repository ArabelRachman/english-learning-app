import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/navigation_drawer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';


class TimerScreen extends StatefulWidget {
  static const String routeName = '/timer-screen';

  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  double percent = 0.0;
  late DatabaseReference _ref;
  bool todayDateEmpty = false;
  int hour = 0;
  int minute = 0;
  late int totalminsdata;
  late int databaseHours;
  late int databaseMins;
  late String? timerString = null;
  bool timerDone = false;
  late int timeTotal;
  double timerPercentage = 0;




  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance.ref('timers/${FirebaseAuth.instance.currentUser!.uid}/${DateFormat.yMMMd().format(DateTime.now())}');

    rootFileExists(_ref).then((value) {
      setState(()  {
         todayDateEmpty = !value;
      });
    });
    checkTimerDone();
    getTimerPercentage();


  }

  @override
  Widget build(BuildContext context) {

    if(!todayDateEmpty) {
      updateFromDatabase();
      checkTimerDone();
      getTimerPercentage();
    }

    if(todayDateEmpty){
      Future.delayed(Duration.zero, () {
        showDialog(context: context, builder: (builder) {
          return AlertDialog(
            title: Text('Enter today\'s speaking goal'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Hour'),
                    onChanged: (value) {
                      hour = int.parse(value);
                    },
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Minute'),
                    onChanged: (value) {
                      minute = int.parse(value);
                    },
                  ),

                ],

              ),

            ),
            actions: [
              TextButton(onPressed: () async {
                Map<String, dynamic> timer = {
                  'total minutes': hour * 60 + minute
                };
                await _ref.child('goal').set(minute + hour * 60);
                await _ref.child('total').set(0);
                await rootFileExists(_ref).then((value) {
                  todayDateEmpty = !value;
                });
                timerDone = false;
                setState(() {

                });
                Navigator.pop(context);
                Navigator.pop(context);


              }, child: Text('Save'))

            ],

          );
        });
      });
    }

    return Scaffold(
        drawer: NavigationDrawer(1),
        appBar: AppBar(
            title: Text(
          "Timer",
        )),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                percent: timerDone ? 100/100 : timerPercentage,
                animation: true,
                animateFromLastPercent: true,
                radius: 155,
                lineWidth: 15,
                progressColor: Colors.blue,
                center: Text(
                  timerDone? "all done":
                  timerString == null ? "00:00" : timerString as String,
                  style: TextStyle(color: Colors.blue, fontSize: 80),
                ),
              )),
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Column(
                  children: [
                    const SizedBox(height: 75,),
                    ButtonTheme(
                        buttonColor: Colors.white,
                        height: 100,
                        minWidth: 200,
                        child: ElevatedButton(
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(

                                  context: context,
                                  initialTime: TimeOfDay(hour: 0, minute: 0),
                              );

                              if(newTime == null){
                                return;
                              }
                              else {
                                updateDatabaseTime(newTime.hour == 12 ? 0 :newTime.hour, newTime.minute);
                              }
                            },
                            child: Text("I have spoken English for ..."))),
                    /*ButtonTheme(
                        buttonColor: Colors.white,

                        height: 50,
                        minWidth: 200,
                        child: ElevatedButton(
                            onPressed: () {}, child: Text("excuse"))),
                    ButtonTheme(
                        buttonColor: Colors.white,
                        height: 50,
                        minWidth: 200,
                        child: ElevatedButton(
                            onPressed: () {}, child: Text("Settings"))),*/
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  Future<bool> rootFileExists(DatabaseReference databaseReference) async{
      final snapshot = await databaseReference.get();
      return snapshot.exists;
  }

  void updateDatabaseMins(int totalmins){
    totalminsdata = totalmins;
  }

  void checkFileExistence() async {
    await rootFileExists(_ref).then((value) {
      todayDateEmpty = !value;
    });
  }

  void updateFromDatabase() async {
    final snapshotGoal = await _ref.child('goal').get();
    final snapshotTotal = await _ref.child('total').get();

    if(snapshotGoal.exists && snapshotTotal.exists){
      totalminsdata = (snapshotGoal.value as int) - (snapshotTotal.value as int);
      databaseHours = totalminsdata ~/ 60;
      databaseMins = totalminsdata % 60;

    }
    String time = await "$databaseHours:$databaseMins";
    setState(() {
      timerString = time;
    });



    }

  void updateDatabaseTime(int hour, int minutes) async {
    int totaltime = hour * 60 + minutes;
    final snapshotGoal = await _ref.child('goal').get();
    final snapshotTime = await _ref.child('total').get();
    if(snapshotGoal.exists && snapshotTime.exists){
      totalminsdata = (snapshotGoal.value as int) - (snapshotTime.value as int);
      timeTotal = (snapshotTime.value as int) + totaltime;
    }
    int timeNew = totalminsdata - totaltime;

    if(timeNew > 0) {
      await _ref.child('total').set(timeTotal);

      setState(() {

      });
    }
    else {
      await _ref.child('total').set(timeTotal);
      timerDone = true;
      showDialog(context: context, builder: (builder) {
        return AlertDialog(title: Center(child: Text("Congrats! You have finished your daily goal.")),);
      });
      setState(() {

      });
    }




    /*_ref.onChildChanged.listen((event) {
      final data = event.snapshot.value;
      updateDatabaseMins(data as int);
      databaseHours = totalminsdata ~/ 60;
      databaseMins = totalminsdata % 60;
      print(databaseHours);
      print(databaseMins);
    }); */
  }

  void checkTimerDone() async {
    final snapshotGoal = await _ref.child('goal').get();
    final snapshotTime = await _ref.child('total').get();
    if(snapshotGoal.exists && snapshotTime.exists){
      totalminsdata = (snapshotGoal.value as int) - (snapshotTime.value as int);
    }

    if(totalminsdata > 0){
      timerDone = await false;
    } else {
      timerDone = await true;
    }
    setState(() {

    });
  }

  void getTimerPercentage() async {
    final snapshotGoal = await _ref.child('goal').get();
    final snapshotTime = await _ref.child('total').get();
    if(snapshotGoal.exists && snapshotTime.exists){
      timerPercentage = (snapshotTime.value as int) / (snapshotGoal.value as int);
    }

    setState(() {

    });

  }




}
