
import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'audiowidget.dart';

class CloudRecordListView extends StatefulWidget {


  @override
  CloudRecordListViewState createState() => CloudRecordListViewState();
}

class CloudRecordListViewState extends State<CloudRecordListView> {
  late bool isPlaying;
  // late AudioPlayer audioPlayer;
  late int selectedIndex;
  late Query _ref;


  @override
  void initState() {
    super.initState();
    isPlaying = false;
    // audioPlayer=AudioPlayer();
    selectedIndex = -1;
    _ref = FirebaseDatabase.instance
        .ref('recordings/${FirebaseAuth.instance.currentUser!.uid}').orderByChild('title');
  }

  Widget buildRecordingItem({required Map recording, required String? key}){
    return RecordingWidget(recording['title'], recording['created_at'], recording['duration'], recording['grammar_score'],recording['audio_link'],key!, recording['duration'], recording['created_at'], recording['user_id']);
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: _ref, itemBuilder: (context, snapshot, animation, index) {

          Map recording = jsonDecode(jsonEncode(snapshot.value));

          final key = snapshot.key;

          return buildRecordingItem(recording: recording, key: key);
    });
  }

  Future<void> onPlayButton() async {

    // audioPlayer.play(AssetSource(await widget.references.elementAt(index).getDownloadURL()), );

    /* audioPlayer.onPlayerComplete.listen((duratioin) {
      setState(() {
        selectedIndex=-1;
      });
    }); */
  }
}

/* ListView.builder(itemCount: widget.references.length, reverse: true,
    itemBuilder: (BuildContext context, int index){
      return ListTile(
        title: Text(widget.references.elementAt(index).name),
        trailing: IconButton(
          icon: (selectedIndex == index) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          onPressed: () => onListTileButtonPressed(index),
        ),

      );
    },
    ) */
