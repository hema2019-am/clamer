import 'dart:async';
import 'dart:io';


import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';

import 'package:fluttertoast/fluttertoast.dart';

typedef void OnError(Exception exception);

class display_music extends StatefulWidget {
  final String music_path;
  final String music_name;
  final String music_cover;

  const display_music(
      {Key key, this.music_path, this.music_name, this.music_cover})
      : super(key: key);

  @override
  _display_musicState createState() => _display_musicState();
}

enum PlayerState { stopped, playing, paused }

class _display_musicState extends State<display_music> {
  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  String localFilePath;
  PlayerState playerState = PlayerState.stopped;

  bool filePresent = false;
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _MusicFiles = [] ;
  bool _isInternet = true;
  String musicAtDisk;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;



  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    getFromDirectory();
    checkInternet();
    getFileFromUrl(widget.music_path).then((f) {
      setState(() {
        musicAtDisk = f.path;
        audioPlayer.play(musicAtDisk);
        setState(() {

          playerState = PlayerState.playing;
          print("this wrorks");
        });

        print(musicAtDisk);
      });
    }

    );
  }

  checkInternet() async {
    try {
      final response = await InternetAddress.lookup("example.com");
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        _isInternet = true;
        setState(() {

        });
      }
    } on SocketException catch (_) {
      _isInternet = false;
      setState(() {

      });
    }
  }

  void getFromDirectory() async {
    try {

      Directory dir = await getApplicationDocumentsDirectory();
      String file ="${dir.path}/${widget.music_name}.mp3";
      print(file);


      _files = dir.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity entity in _files) {
        String path = entity.path;
        if (path.endsWith("${widget.music_name}.mp3")) {
          _MusicFiles.add(entity);

        }



      }


      setState(() {

      });
    }
    catch (e) {
      print(e);
    }
  }


  Future<File> getFileFromUrl(String url,) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/${widget.music_name}.mp3");

      File urlFile = await file.writeAsBytes(bytes);
      print("getUrl");
      setState(() {

      });
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }
  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
   if(_MusicFiles.length > 0){
    await audioPlayer.play(_MusicFiles[0].path);
     setState(() {
       playerState = PlayerState.playing;
     });

   }else{


     if(_isInternet) {
       Fluttertoast.showToast(
           msg: "please wait for 5sc to download and play music",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.blueAccent[400],
           textColor: Colors.white
       );

      await audioPlayer.play(musicAtDisk);




     }else{
       showDialog(context: context, builder: (context) =>
           AlertDialog(title: Text("No Internet"),
             content: Text("Connect to intenet"),
             actions: [
               FlatButton(
                   child: Text("Retry"),
                   onPressed: () {
                     Navigator.pop(context);
                   }
               )
             ],));
       setState(() {
         checkInternet();
       });
     }

   }
  }

  Future _PlayLocal() async{

  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      playerState = PlayerState.paused;
    });
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }


  void onComplete() {
    setState(() {
      playerState = PlayerState.stopped;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent[100],
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.blue[100],
          elevation: 0,
          title: Text(
            widget.music_name,
            style: TextStyle(
                color: Colors.blue[500],
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FadeInImage.assetNetwork(
                  placeholder: "assets/headphones_placeholder.png",
                  image: widget.music_cover),
              Material(child: _buildPlayer()),

            ],
          ),
        ));
  }

  Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.blueAccent[100],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: isPlaying ? null : () => play(),
                  iconSize: 64.0,
                  color: Colors.black,
                ),
                IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: isPlaying ? () => pause() : null,
                  iconSize: 64.0,
                  color: Colors.black,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: isPlaying || isPaused ? () => stop() : null,
                  iconSize: 64.0,
                  color: Colors.black,
                ),
              ],
            ),
            if (position != null) _buildMuteButtons(),
            if (position != null) _buildProgressView(),
          ],
        ),
      );

  Row _buildProgressView() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              value: position != null && position.inMilliseconds > 0
                  ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                      (duration?.inMilliseconds?.toDouble() ?? 0.0)
                  : 0.0,
              valueColor: AlwaysStoppedAnimation(Colors.grey.shade600),
              backgroundColor: Colors.black,
            ),
          ),
          Text(
            position != null
                ? "${positionText ?? ''} / ${durationText ?? ''}"
                : duration != null ? durationText : '',
            style: TextStyle(fontSize: 24.0),
          )
        ],
      );

  Row _buildMuteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!isMuted)
          FlatButton.icon(
            onPressed: () => mute(true),
            icon: Icon(
              Icons.headset_off,
              color: Colors.black,
            ),
            label: Text('Mute', style: TextStyle(color: Colors.black)),
          ),
        if (isMuted)
          FlatButton.icon(
            onPressed: () => mute(false),
            icon: Icon(Icons.headset, color: Colors.black),
            label: Text('Unmute', style: TextStyle(color: Colors.black)),
          ),
      ],
    );
  }
}
