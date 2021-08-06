import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/profile/following.dart';
import 'package:esportshub/pages2/videos/comments.dart';
import 'package:esportshub/pages2/videos/upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('clips');
CollectionReference ref1 = FirebaseFirestore.instance.collection('users');
CollectionReference ref2 = FirebaseFirestore.instance.collection('LC');
final user = FirebaseAuth.instance.currentUser;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final user = FirebaseAuth.instance.currentUser;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _scaffoldKey,
      child: StreamBuilder(
        stream: ref.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return SpinKitWave(
              color: Colors.white.withOpacity(0.4),
            );
          }

          if (snapshot.hasData) {
            return PageView(
                controller: pageController,
                scrollDirection: Axis.vertical,
                children: snapshot.data!.docs
                    .map(
                      (e) => Container(
                        child: FutureBuilder(
                            future: ref2
                                .doc(e['LCId'])
                                .collection('likes')
                                .doc(e['likesId'])
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return Text("Document does not exist");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> f = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                return FutureBuilder(
                                  future: ref1.doc(e['useruid']).get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map<String, dynamic> g = snapshot.data!
                                          .data() as Map<String, dynamic>;
                                      return VideoCard(
                                          file: e['video-link'],
                                          profile: e['profile'],
                                          description: e['caption'],
                                          channel: e['username'],
                                          useruid: e['useruid'],
                                          lc: e['LCId'],
                                          lcId: e['likesId'],
                                          liked: f['liked'],
                                          followersId: g['followersId']);
                                    } else
                                      return Container();
                                  },
                                );
                              } else
                                return Container();
                            }),
                      ),
                    )
                    .toList());
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final String file;
  final String profile;
  final String description;
  final String channel;
  final String useruid;
  final String lc;
  final String lcId;
  final List liked;
  final String followersId;
  const VideoCard({
    Key? key,
    required this.file,
    required this.profile,
    required this.description,
    required this.channel,
    required this.useruid,
    required this.lc,
    required this.lcId,
    required this.liked,
    required this.followersId,
  }) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController controller;
  bool showMenu = false;
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  Timer timer1 = Timer.periodic(Duration(seconds: 1), (timer) {});
  Timer timer2 = Timer.periodic(Duration(seconds: 1), (timer) {});
  Timer timer3 = Timer.periodic(Duration(seconds: 1), (timer) {});
  late bool liked;
  double likesCount = 0;
  var likesSuffix = '';
  bool follower = false;
  bool follower1 = false;
  String docId = '';
  String docId1 = '';
  int start = 5;
  bool wait = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.file)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
    widget.liked.contains(user!.uid) ? liked = true : liked = false;
    matchUser();
    getLikescount();
  }

  matchUser() {
    ref1
        .doc(widget.useruid)
        .collection('followers')
        .where('useruid', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
        docId =  doc.get('docId');
        });
        if (doc['useruid'] == user!.uid) {
          setState(() {
            follower = true;
          });
        } else {
          setState(() {
            follower = false;
          });
        }
      });
    });
    ref1
        .doc(user!.uid)
        .collection('following')
        .where('useruid', isEqualTo: widget.useruid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          docId1 =  doc.get('docId');
        });
        if (doc['useruid'] == widget.useruid) {
          setState(() {
            follower1 = true;
          });
        } else {
          setState(() {
            follower1 = false;
          });
        }
      });
    });
  }

  _follow() async {
    try {
      DocumentReference _docRef =
          await ref1.doc(widget.useruid).collection('followers').add({
        'name': user!.displayName,
        'pic': user!.photoURL,
        'useruid': user!.uid,
        'docId': '',
      });

      DocumentReference _docRef1 =
          await ref1.doc(user!.uid).collection('following').add({
        'name': widget.channel,
        'pic': widget.profile,
        'useruid': widget.useruid,
        'docId': '',
      });

      await ref1
          .doc(user!.uid)
          .collection('following')
          .doc(_docRef1.id)
          .update({
        'docId': _docRef1.id,
      });

      await ref1
          .doc(widget.useruid)
          .collection('followers')
          .doc(_docRef.id)
          .update({
        'docId': _docRef.id,
      });

      setState(() {
        docId = _docRef.id;
        docId1 = _docRef1.id;
      });
    } catch (e) {
      print(e);
    }
  }

  _unfollow() async {
    try {
      await ref1
          .doc(widget.useruid)
          .collection('followers')
          .doc(docId)
          .delete();
    } catch (e) {
      print('e');
    }
  }

  _unfollow1() async {
    try {
      await ref1.doc(user!.uid).collection('following').doc(docId1).delete();
    } catch (e) {
      print('e');
    }
  }

  getLikescount() {
    if (widget.liked.length >= 1000 && widget.liked.length < 1000000) {
      likesCount = widget.liked.length / 1000;
      likesSuffix = 'k';
    } else if (widget.liked.length >= 1000000 &&
        widget.liked.length < 1000000000) {
      likesCount = widget.liked.length / 1000000;
      likesSuffix = 'M';
    } else if (widget.liked.length >= 1000000000) {
      likesCount = widget.liked.length / 1000000000;
      likesSuffix = 'B';
    }
    likesCount = widget.liked.length.toDouble();
  }

  @override
  void dispose() {
    controller.dispose();
    timer.cancel();
    timer1.cancel();
    timer2.cancel();
    timer3.cancel();
    VideoPlayerController.asset('assets/bbb.mp4').dispose();
    super.dispose();
  }

  void _like(
      BuildContext context, String userUid, String lc, String lcid) async {
    List<String> liked = [];

    try {
      liked.add(userUid);
      await _firestore
          .collection('LC')
          .doc(lc)
          .collection('likes')
          .doc(lcid)
          .update({
        'liked': FieldValue.arrayUnion(liked),
      });
    } catch (e) {
      print(e);
    }
    return print('');
  }

  void _disLike(
      BuildContext context, String userUid, String lc, String lcid) async {
    List<String> liked = [];

    try {
      liked.add(userUid);
      await _firestore
          .collection('LC')
          .doc(lc)
          .collection('likes')
          .doc(lcid)
          .update({
        'liked': FieldValue.arrayRemove(liked),
      });
    } catch (e) {
      print(e);
    }
    return print('');
  }

  @override
  Widget build(BuildContext context) {
    late File file;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: ref2
            .doc(widget.lc)
            .collection('likes')
            .doc(widget.lcId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          return Stack(children: [
            buildVideoPlayer(),
            Positioned(
                bottom: 10,
                child: Container(
                  width: width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.035),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      FollowingInfo(userId: widget.useruid)));
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(widget.profile),
                            ),
                          ),
                          SizedBox(width: width * 0.032),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      FollowingInfo(userId: widget.useruid)));
                            },
                            child: Text(
                              widget.channel,
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ),
                          SizedBox(width: width * 0.032),
                          wait
                              ? Container(
                                  height: width * 0.07,
                                  width: width * 0.2,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black.withOpacity(0.7),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade500)),
                                  child: Text(
                                    start.toString(),
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                )
                              : Container(
                                  height: width * 0.07,
                                  width: width * 0.2,
                                  decoration: !follower && !follower1
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.black.withOpacity(0.7),
                                          border: Border.all(
                                              width: 1, color: Colors.white))
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                  child: RawMaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () {
                                      setState(() {
                                        timer2 = Timer.periodic(
                                            Duration(milliseconds: 5), (timer) {
                                          if (follower == true &&
                                              follower1 == true) {
                                            _follow();
                                          } else if (follower == false &&
                                              follower1 == false) {
                                            _unfollow();
                                            _unfollow1();
                                            wait = true;
                                            startTimer();
                                          } else if (follower && !follower1) {
                                            _unfollow();
                                            _unfollow1();
                                          } else if (!follower && follower1) {
                                            _unfollow1();
                                            _unfollow();
                                          }
                                          timer.cancel();
                                        });
                                      });
                                      if (follower == true &&
                                          follower1 == true) {
                                        setState(() {
                                          follower = false;
                                          follower1 = false;
                                        });
                                      } else if (follower == false &&
                                          follower1 == false) {
                                        setState(() {
                                          follower = true;
                                          follower1 = true;
                                        });
                                      }
                                      matchUser();
                                    },
                                    child: follower && follower1
                                        ? Text(
                                            'Following',
                                            style: TextStyle(
                                                color: Colors.grey.shade300),
                                          )
                                        : Text(
                                            'Follow',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                  ),
                                )
                        ],
                      ),
                      SizedBox(height: height * 0.0082),
                      Row(
                        children: [
                          SizedBox(width: width * 0.042),
                          Container(
                            width: width * 0.6,
                            child: Text(
                              widget.description,
                              maxLines: 2,
                              style: TextStyle(fontSize: width * 0.037),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            Positioned(
              top: 15,
              left: 15,
              child: Text(
                'Clips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 1,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.001),
                height: height * 0.86,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        setState(() {});
                        final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false, type: FileType.video);
                        if (result == null) return;
                        final path = result.files.single.path!;

                        setState(() {
                          file = File(path);
                        });
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ClipPreview(file: file)));
                      },
                      icon: Icon(
                        Icons.publish_outlined,
                        size: width * 0.076,
                      ),
                    ),
                    Container(
                      height: height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      timer1 = Timer.periodic(
                                          Duration(seconds: 1), (timer) {
                                        if (liked == true) {
                                          _like(context, user!.uid, widget.lc,
                                              widget.lcId);
                                        } else if (liked == false) {
                                          _disLike(context, user!.uid,
                                              widget.lc, widget.lcId);
                                        }
                                        timer.cancel();
                                      });
                                    });

                                    if (liked == true) {
                                      setState(() {
                                        liked = false;
                                        likesCount--;
                                      });
                                    } else if (liked == false) {
                                      setState(() {
                                        liked = true;
                                        likesCount++;
                                      });
                                    }
                                  },
                                  child: liked
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: width * 0.08,
                                        )
                                      : Icon(
                                          Icons.favorite_outline_sharp,
                                          size: width * 0.077,
                                          color: Colors.white,
                                        ),
                                ),
                                SizedBox(height: height * 0.002),
                                widget.liked.length < 1000
                                    ? Text(likesCount.toInt().toString())
                                    : Text('$likesCount$likesSuffix'),
                                // SizedBox(height: height * 0.003)
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.black87,
                                  context: context,
                                  builder: (bottomSheetContext) {
                                    return Comment(lc: widget.lc);
                                  });
                            },
                            icon: Icon(
                              FontAwesomeIcons.comment,
                              size: width * 0.07,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.paperPlane,
                              size: width * 0.06,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              size: width * 0.07,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
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

                  setState(() {
                    timer = Timer.periodic(Duration(seconds: 1), (timer) {
                      setState(() {
                        showMenu = false;
                        timer.cancel();
                      });
                    });
                  });
                },
                onDoubleTap: () {
                  if (liked == false) {
                    setState(() {
                      liked = true;
                      likesCount++;
                    });
                    _like(context, user!.uid, widget.lc, widget.lcId);
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      buidPlay(),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: width * 0.025),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        });
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer timer3 = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 5;
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget buildVideoPlayer() => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller)),
      );

  Widget buidPlay() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.bounceOut,
      padding: showMenu
          ? EdgeInsets.all(MediaQuery.of(context).size.width * 0.29)
          : EdgeInsets.all(MediaQuery.of(context).size.width * 0.26),
      color: Colors.white.withOpacity(0.000000001),
      width: MediaQuery.of(context).size.width * 0.78,
      height: MediaQuery.of(context).size.height * 0.67,
      child: showMenu
          ? Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black.withOpacity(0.6)),
              child: Icon(
                !controller.value.isPlaying ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: MediaQuery.of(context).size.width * 0.132,
              ),
            )
          : Container(),
    );
  }
}