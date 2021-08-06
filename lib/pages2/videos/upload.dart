import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/homepage2.dart';
import 'package:esportshub/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class ClipPreview extends StatefulWidget {
  final File file;
  const ClipPreview({Key? key, required this.file}) : super(key: key);

  @override
  _ClipPreviewState createState() => _ClipPreviewState();
}

class _ClipPreviewState extends State<ClipPreview> {
  late VideoPlayerController controller;
  bool showMenu = false;
  late Timer timer;

  String getPosition() {
    final duration = Duration(
        milliseconds: controller.value.position.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  String getlength() {
    final duration = Duration(
        milliseconds: controller.value.duration.inMilliseconds.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  void initState() {
    var file = widget.file;
    super.initState();
    controller = VideoPlayerController.file(file)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(width * 0.015),
            child: RawMaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                fillColor: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadClips(file: widget.file)));
                },
                child: Text(
                  'Next',
                  style:
                      TextStyle(color: Colors.white, fontSize: width * 0.042),
                )),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Stack(
              children: [
                buildVideoPlayer(),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();

                      if (showMenu == false) {
                        setState(() {
                          showMenu = true;
                        });
                      }

                      timer = Timer.periodic(
                        Duration(seconds: 1),
                        (timer) {
                          setState(() {
                            showMenu = false;
                            timer.cancel();
                          });
                        },
                      );
                    },
                    child: buidPlay(),
                  ),
                )
              ],
            ),
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.015,
                  vertical: width * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getPosition()),
                  buildIndicator(),
                  Text(getlength())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buidPlay() {
    return AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.bounceOut,
        padding: showMenu
            ? EdgeInsets.all(MediaQuery.of(context).size.width * 0.35)
            : EdgeInsets.all(MediaQuery.of(context).size.width * 0.32),
        color: Colors.white.withOpacity(0.000000001),
        width: MediaQuery.of(context).size.width * 0.78,
        height: MediaQuery.of(context).size.height * 0.67,
        child: showMenu
            ? Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.6)),
                child: Icon(
                  !controller.value.isPlaying ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.132,
                ),
              )
            : Container());
  }

  Widget buildVideoPlayer() => Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller)),
      );

  Widget buildIndicator() => Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.purpleAccent,
            bufferedColor: Colors.white54,
          ),
        ),
      );
}

class UploadClips extends StatefulWidget {
  final File file;
  const UploadClips({Key? key, required this.file}) : super(key: key);

  @override
  _UploadClipsState createState() => _UploadClipsState();
}

class _UploadClipsState extends State<UploadClips> {
  TextEditingController captionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  UploadTask? task;
  bool uploading = false;
  bool private = false;
  bool _validate1 = false;
  bool _validate2 = false;
  var videoUrl = '';
  var _id1 = '';
  var _id2 = '';

  @override
  void dispose() {
    captionController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: uploading
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Container(),
            )
          : AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
              title: uploading ? Text('Uploading...') : Text('Add Details'),
              actions: [
                uploading
                    ? Container()
                    : Container(
                        padding: EdgeInsets.all(width * 0.015),
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          fillColor: Colors.black,
                          onPressed: () {
                            if (_validate1 == false && _validate2 == false) {
                              uploadFile();
                              setState(() {
                                finish();
                                uploading = true;
                              });
                            }
                            setState(() {
                              captionController.text.isEmpty
                                  ? _validate1 = true
                                  : _validate1 = false;
                              commentController.text.isEmpty
                                  ? _validate2 = true
                                  : _validate2 = false;
                            });
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.042),
                          ),
                        ),
                      )
              ],
            ),
      body: uploading
          ? Container(
              child: Center(
                child: Container(
                  height: height * 0.4,
                  width: width * 0.6,
                  child: buildUploadStatus(task!),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.325,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(user!.photoURL.toString()),
                        ),
                        Text(
                          user!.displayName.toString(),
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: captionController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Enter caption',
                      labelStyle: TextStyle(color: Colors.grey.shade300),
                      errorText: _validate1 ? 'Feild Can\'t Be Empty' : null,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  TextFormField(
                    controller: commentController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Add comment',
                      labelStyle: TextStyle(color: Colors.grey.shade300),
                      errorText: _validate2 ? 'Feild Can\'t Be Empty' : null,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.035),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' Make video private (only you can view)',
                        style: TextStyle(fontSize: width * 0.038),
                      ),
                      Switch(
                        value: private,
                        onChanged: (bool public) {
                          setState(() {
                            private = public;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Future uploadFile() async {
    final fileName = captionController.text.trim();
    final destination = 'videos/$fileName.mp4';

    task = FirebaseApiUpload.uploadFile(destination, widget.file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
    setState(() {
      videoUrl = urlDownload;
    });
  }

  Future comment() async {
    try {
      List liked = [];
      DocumentReference _docRef = await _firestore
          .collection('LC')
          .doc(_id2)
          .collection('comments')
          .add({
        'comments': commentController.text.trim(),
        'username': user!.displayName,
        'useruid': user!.uid,
        'photourl': user!.photoURL,
        'veryfied': true,
        'liked': liked,
        'amount': 0,
        'timestamp': Timestamp.now(),
      });
      await _firestore
          .collection('LC')
          .doc(_id2)
          .collection('comments')
          .doc(_docRef.id)
          .update({
        'commentId': _docRef.id,
      });

      await _firestore.collection('clips').doc(_id1).update({
        'video-link': videoUrl,
      });
    } catch (e) {}
  }

  Future finish() async {
    try {
      List likes = [];
      DocumentReference _docRef = await _firestore.collection('clips').add({
        'useruid': user!.uid,
        'profile': user!.photoURL,
        'username': user!.displayName,
        'uploadDate': Timestamp.now(),
        'caption': captionController.text.trim(),
        'commentsCount': 0,
        'avalible': private ? 'private' : 'public',
      });

      DocumentReference _docRef3 = await _firestore.collection('LC').add({
        'liked': 'liked',
      });
      DocumentReference _docRef2 = await _firestore
          .collection('LC')
          .doc(_docRef3.id)
          .collection('likes')
          .add({
        'liked': likes,
      });
      setState(() {
        _id1 = _docRef.id;
        _id2 = _docRef3.id;
      });

      await _firestore.collection('clips').doc(_docRef.id).update({
        'uploadId': _docRef.id,
        'likesId': _docRef2.id,
        'LCId': _docRef3.id,
      });
    } catch (e) {
      print(e);
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            final percent = (progress * 100).toInt();

            return Container(
              height: MediaQuery.of(context).size.width * 0.35,
              width: MediaQuery.of(context).size.width * 0.35,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned.fill(
                          child: Container(
                        alignment: Alignment.center,
                        child: percent == 100
                            ? Icon(
                                Icons.check,
                                size: MediaQuery.of(context).size.width * 0.25,
                                color: Colors.green,
                              )
                            : Text(
                                '$percentage %',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                      )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        child: CircularProgressIndicator(
                          color: percent == 100 ? Colors.green : Colors.white,
                          backgroundColor: Colors.grey,
                          value: snap.bytesTransferred / snap.totalBytes,
                          strokeWidth:
                              MediaQuery.of(context).size.width * 0.025,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  percent == 100
                      ? Container(
                          height: MediaQuery.of(context).size.width * 0.12,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: RawMaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            fillColor: Colors.black,
                            onPressed: () {
                              comment();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => Homepage1(
                                            index: 1,
                                          )));
                            },
                            child: Text(
                              'Finish',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text:
                              "Do not press back or quit application before pressing",
                          style: TextStyle(
                              color: Colors.red.shade300,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                          children: [
                            TextSpan(
                                text: ' Finish button',
                                style: TextStyle(
                                    color: Colors.red.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.042)),
                          ]))
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      );
}
