
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/audiowidget.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../widgets/navigation_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/CloudRecordListView.dart';
import '../widgets/RecorderButton.dart';

class JournalScreen extends StatefulWidget {
  static const String routeName = '/journal-screen';

  @override
  JournalScreenState createState() => JournalScreenState();
}

class JournalScreenState extends State<JournalScreen> {
  late List<Reference>? references;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //OnUploadComplete();
    references = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(2),
      appBar: AppBar(title: Text("Journal")),
      body: Column(children: [
        Expanded(flex: 4,
            child: CloudRecordListView()),
        RecorderButtonView(OnUploadComplete: OnUploadComplete,)
      ],)
    );
  }

  Future<void> OnUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebaseStorage.ref().child('upload-voice-firebase').list();
    setState(() {
      references = listResult.items;
    });
}

}

/*
Column( children: [Container( height: 565, child: SingleChildScrollView(child: Column(
children: [
AudioWidget('Recording 1', "November 11, 2022", "1:30"),
AudioWidget('Recording 2', "November 11, 2022", "1:30"),
AudioWidget('Recording 3', "November 11, 2022", "1:30"),
AudioWidget('Recording 4', "November 11, 2022", "1:30"),
AudioWidget('Recording 5', "November 11, 2022", "1:30"),
AudioWidget('Recording 6', "November 11, 2022", "1:30"),
AudioWidget('Recording 7', "November 11, 2022", "1:30"),
AudioWidget('Recording 8', "November 11, 2022", "1:30"),
AudioWidget('Recording 9', "November 11, 2022", "1:30"),
AudioWidget('Recording 10', "November 11, 2022", "1:30"),
AudioWidget('Recording 11', "November 11, 2022", "1:30"),

],
))),]), */

/*references == null ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: LinearProgressIndicator(),),
                Text('Fetching records from Firebase')
              ],
            ) : Center(child: Text('No file uploaded yet'),)*/