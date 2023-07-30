import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:duration/duration.dart';


class RecorderButtonView extends StatefulWidget {
   final Function OnUploadComplete;

   const RecorderButtonView({
     Key? key,
     required this.OnUploadComplete
   }) : super(key: key);

  @override
  RecorderButtonViewState createState() => RecorderButtonViewState();
}

class RecorderButtonViewState extends State<RecorderButtonView> {
  late bool isPlaying;
  late bool isRecording;
  late bool isRecorded;
  late bool isUploading;

   late AssetsAudioPlayer audioPlayer;
  late String filePath;

  late FlutterSoundRecorder soundRecorder;
  late DatabaseReference _ref;
  late FirebaseAuth auth;
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
     audioPlayer = AssetsAudioPlayer();
    isRecording = false;
    isRecorded = false;
    isUploading = false;
    _ref = FirebaseDatabase.instance.ref('recordings/${FirebaseAuth.instance.currentUser!.uid}');
    auth = FirebaseAuth.instance;
     player = AudioPlayer();
  }



  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: isRecorded
            ? isUploading
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: LinearProgressIndicator(),
                      ),
                      Text('Uploading')
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: onRecordAgainButtonPressed,
                          icon: const Icon(Icons.replay)),
                      IconButton(
                          onPressed: onPlayButtonPressed,
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                      IconButton(
                          onPressed: onFileUploadButtonPressed,
                          icon: Icon(Icons.upload_file)),
                    ],
                  )
            : IconButton(
                onPressed: onRecordButtonPressed,

                icon: isRecording ? Icon(Icons.pause)


                    : Icon(Icons.fiber_manual_record)));
  }
  Future<void> onRecordButtonPressed() async {
    if(isRecording) {
      soundRecorder.stopRecorder();
      isRecording = false;
      isRecorded = true;
    } else {
      isRecorded = false;
      isRecording = true;

      await startRecording();
    }
    setState(() {

    });
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.status;
    print(status.toString());
    if(status.isGranted){
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.wav';
      soundRecorder = FlutterSoundRecorder();
      await soundRecorder.openRecorder();
      soundRecorder.startRecorder(toFile: filepath);
      filePath = filepath;
      setState(() {
      });
    } else {
      await Permission.microphone.request();
    }
  }

  void onPlayButtonPressed() {
    if(!isPlaying){
      isPlaying = true;
       audioPlayer.open(Audio.file(filePath), autoStart: true, showNotification: true);
      audioPlayer.playlistAudioFinished.listen((duration) {
        setState(() {
          isPlaying=false;
        });
      });
    } else {
       audioPlayer.pause();
      isPlaying=false;

    }

    setState(() {

    });
  }

  Future<void> onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      isUploading = true;
    });


      try {
        await firebaseStorage.ref('upload-voice-firebase')
            .child(
            filePath.substring(filePath.lastIndexOf('/'), filePath.length))
            .putFile(File(filePath));
        widget.OnUploadComplete();


          final duration = await player.setUrl(filePath);


        Map<String,dynamic> recording = {
          'audio_link':filePath,
          'created_at': DateFormat('yMMMd').format(DateTime.now()).toString(),
          'grammar_score':0,
          'id':DateTime.now().toString(),
          'title':'Recording at ${DateFormat('yMMMd').format(DateTime.now()).toString()}',
          'user_id': auth.currentUser!.uid,
          'duration': duration.toString().substring(3,7)
        };


        await _ref.push().set(recording);


      } catch (error) {
        print('error has occured while uploading to firebase ${error.toString()}');
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error occured while uploading')));
    } finally {
        setState(() {
          isUploading= false;
        });
      }
  }

  void onRecordAgainButtonPressed(){
    setState(() {
      isRecorded=false;
    });
  }

}
