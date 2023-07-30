import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RecordingWidget extends StatefulWidget {
  final String recordingName;
  final String date;
  final int score;
  final String length;
  final String audiolink;
  final String audioId;
  final String recordingDuration;
  final String createdDate;
  final String uid;

  RecordingWidget(this.recordingName, this.date, this.length, this.score, this.audiolink, this.audioId, this.recordingDuration, this.createdDate, this.uid);


  @override
  AudioWidgetState createState() {
    return AudioWidgetState();
  }
}

class AudioWidgetState extends State<RecordingWidget> {
   late bool isPlaying;
   late AssetsAudioPlayer audioPlayer;
   late DatabaseReference _ref;
   late Reference storageReference;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AssetsAudioPlayer();
    _ref = FirebaseDatabase.instance.ref('recordings/${FirebaseAuth.instance.currentUser!.uid}/${widget.audioId}');
    storageReference = FirebaseStorage.instance.ref(widget.audiolink);
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,

            ) ,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(size: 30, isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: onPlayButtonPressed,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.recordingName),
              Text(
                widget.date,
              ),
              (widget.score == 0)
                  ? Text("Grammar Score: Not yet")
                  : Text("Grammar Score: ${widget.score}")
            ],
          ),
    Flex(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    direction: Axis.vertical,
    children: [
    PopupMenuButton(itemBuilder: (context){
      return [/*PopupMenuItem(child: TextButton.icon(onPressed: () {
        print('recordings/${FirebaseAuth.instance.currentUser!.uid}/${widget.audioId}');
      },
          icon: Icon(Icons.zoom_in), label: Text('Analyze Grammar')),), */
      PopupMenuItem(child: TextButton.icon(onPressed: () {
        showDialog(context: context,
            builder: (context) {
              TextEditingController renameController = TextEditingController();
          return AlertDialog(

            title: Text('Rename Recording'),
            content: TextField(
              controller: renameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New name',
              ),
            ),
            actions: <Widget>[
              TextButton(onPressed: () {
                setState(() {
                  print(renameController.text);
                  _ref.set({
                    'audio_link':widget.audiolink,
                    'created_at': widget.createdDate,
                    'grammar_score':0,
                    'id':DateTime.now().toString(),
                    'title':renameController.text,
                    'user_id': widget.uid,
                    'duration': widget.recordingDuration
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
                child: Text('OK', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue,)),)
            ],

          );
            }
        );
      }, 
          icon: Icon(Icons.edit), label: Text('Rename Recording')),),
        PopupMenuItem(child: TextButton.icon(onPressed: () {
          print(widget.audiolink);

          setState(() {
            storageReference.delete();
            _ref.remove();
            Navigator.pop(context);
          });
        },
            icon: Icon(Icons.delete), label: Text('Delete Recording')),),
      ];
    }),
    Text(widget.length)
        ],
      )]


      ,
    ));


  }
  Future<void> onPlayButtonPressed() async {
    print(widget.audiolink);

    if(!isPlaying){
      print(widget.audiolink);

      isPlaying = true;
   audioPlayer.open(Audio.file(widget.audiolink), autoStart: true, showNotification: true);
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
}
