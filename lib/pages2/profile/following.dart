import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/homepage2.dart';
import 'package:esportshub/pages2/profile/followinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser;

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  _unfollow(String userUid) async {
    try {
      await ref.doc(user!.uid).collection('following').doc(userUid).delete();
    } catch (e) {
      print('e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
          top: width * 0.05, right: width * 0.022, left: width * 0.022),
      child: StreamBuilder(
        stream: ref.doc(user!.uid).collection('following').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: SpinKitWave(
                color: Colors.white.withOpacity(0.6),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitWave(
                color: Colors.white.withOpacity(0.6),
              ),
            );
          }
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                  children: snapshot.data!.docs
                      .map((e) => ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 27.0,
                                sigmaY: 27.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          FollowingInfo(userId: e['useruid'])));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(width * 0.007),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.12),
                                        Colors.white.withOpacity(0.12)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.white.withOpacity(0.2)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.022,
                                      horizontal: width * 0.022),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: width * 0.058,
                                            backgroundImage:
                                                NetworkImage(e['pic']),
                                          ),
                                          SizedBox(width: width * 0.035),
                                          Text(
                                            e['name'],
                                            style: TextStyle(
                                                fontSize: width * 0.04,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: width * 0.095,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.white
                                                    .withOpacity(0.4)),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: RawMaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () {
                                            _unfollow(e['docId']);
                                          },
                                          child: Text(
                                            'following',
                                            style: TextStyle(
                                                fontSize: width * 0.037,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList()),
            );
          } else
            return SpinKitWave(
              color: Colors.white.withOpacity(0.6),
            );
        },
      ),
    );
  }
}

class FollowingInfo extends StatefulWidget {
  final String userId;
  const FollowingInfo({Key? key, required this.userId}) : super(key: key);

  @override
  _FollowingInfoState createState() => _FollowingInfoState();
}

class _FollowingInfoState extends State<FollowingInfo> {
  String followersId = '';
  String followingId = '';
  int followerCount = 0;
  int followingCount = 0;
  bool follower = false;
  bool follower1 = false;
  String docId = '';
  String docId1 = '';
  String docId2 = '';
  String docId3 = '';
  String name = '';
  String pic = '';

  @override
  void initState() {
    getData();
    matchUser();
    super.initState();
  }

  matchUser() {
    ref
        .doc(user!.uid)
        .collection('followers')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          docId = doc['docId'];
        });
        if (doc['useruid'] == widget.userId) {
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
    ref
        .doc(user!.uid)
        .collection('following')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          docId1 = doc['docId'];
        });
        if (doc['useruid'] == widget.userId) {
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
    ref
        .doc(widget.userId)
        .collection('followers')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          docId2 = doc['docId'];
        });
      });
    });
    ref
        .doc(widget.userId)
        .collection('following')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        setState(() {
          docId3 = doc['docId'];
        });
      });
    });
  }

  getData() {
    ref.doc(user!.uid).get().then((DocumentSnapshot doc) {
      setState(() {
        followersId = doc['followersId'];
        followingId = doc['followingId'];
      });
    });
    ref
        .doc(widget.userId)
        .collection('followers')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        followerCount = snapshot.docs.length;
      });
    });

    ref
        .doc(widget.userId)
        .collection('following')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        followingCount = snapshot.docs.length;
      });
    });
  }

  _follow() async {
    try {
      DocumentReference _docRef =
          await ref.doc(widget.userId).collection('followers').add({
        'name': user!.displayName,
        'pic': user!.photoURL,
        'useruid': user!.uid,
      });

      DocumentReference _docRef1 =
          await ref.doc(user!.uid).collection('following').add({
        'name': name,
        'pic': pic,
        'useruid': widget.userId,
      });

      await ref.doc(user!.uid).collection('following').doc(_docRef1.id).update({
        'docId': _docRef1.id,
      });

      await ref
          .doc(widget.userId)
          .collection('followers')
          .doc(_docRef.id)
          .update({
        'docId': _docRef.id,
      });

      setState(() {
        docId2 = _docRef.id;
        docId1 = _docRef1.id;
      });
    } catch (e) {
      print('e');
    }
  }

  _unfollow(String userUid) async {
    try {
      await ref.doc(user!.uid).collection('followers').doc(docId).delete();
    } catch (e) {
      print('e');
    }
  }

  _unfollow1(String userUid) async {
    try {
      await ref.doc(user!.uid).collection('following').doc(docId1).delete();
    } catch (e) {
      print('e');
    }
  }

  _unfollow2(String userUid) async {
    try {
      await ref.doc(userUid).collection('followers').doc(docId2).delete();
    } catch (e) {
      print('e');
    }
  }

  _unfollow3(String userUid) async {
    try {
      await ref.doc(userUid).collection('following').doc(docId3).delete();
    } catch (e) {
      print('e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black87.withOpacity(0.9),
            Colors.black.withOpacity(0.85),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: height * 0.12,
            right: -width * 0.2,
            child: Container(
              height: width * 0.65,
              width: width * 0.65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.grey.withOpacity(0.15),
                    Colors.grey.withOpacity(0.1),
                    Colors.white.withOpacity(0.45),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 130,
            left: -70,
            child: Container(
              height: width * 0.6,
              width: width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  end: Alignment.centerRight,
                  begin: Alignment.centerLeft,
                  colors: [
                    Colors.white.withOpacity(0.65),
                    Colors.grey.withOpacity(0.25),
                    Colors.grey.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height,
            right: -70,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    end: Alignment.centerRight,
                    begin: Alignment.centerLeft,
                    colors: [
                      Colors.white.withOpacity(0.65),
                      Colors.grey.withOpacity(0.25),
                      Colors.grey.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                onDoubleTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Homepage1(index: 3)));
                },
                child: Icon(Icons.arrow_back),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(width * 0.02),
              child: FutureBuilder<DocumentSnapshot>(
                future: ref.doc(widget.userId).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document does not exist");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> e =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 27.0,
                              sigmaY: 27.0,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(width * 0.04),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.12)
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                                border: Border.all(
                                    width: 1,
                                    color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: width * 0.11,
                                        backgroundImage:
                                            NetworkImage(e['photoUrl']),
                                      ),
                                      Container(
                                        width: width * 0.652,
                                        height: width * 0.22,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(width: width * 0.002),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.05,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.0032),
                                                  Text(
                                                    'Cash Won',
                                                    style: TextStyle(
                                                        fontSize: width * 0.034,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowInfo(
                                                      index: 0,
                                                      followersId: followersId,
                                                      followingId: followingId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      followerCount.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width * 0.05,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            height * 0.0032),
                                                    Text(
                                                      'Followers',
                                                      style: TextStyle(
                                                        fontSize: width * 0.034,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FollowInfo(
                                                              index: 1,
                                                              followersId:
                                                                  followersId,
                                                              followingId:
                                                                  followingId,
                                                            )));
                                              },
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      followingCount.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                              width * 0.05),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            height * 0.0032),
                                                    Text(
                                                      'Following',
                                                      style: TextStyle(
                                                        fontSize: width * 0.034,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: height * 0.007),
                                      Text(
                                        e['name'],
                                        style: TextStyle(
                                          fontSize: width * 0.047,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.0025),
                                      Text(
                                        e['email'],
                                        style: TextStyle(
                                          fontSize: width * 0.0385,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.015),
                                      Container(
                                        width: double.infinity,
                                        height: width * 0.11,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                width: 1),
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: follower
                                            ? TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    name = e['name'];
                                                    pic = e['photoUrl'];
                                                  });
                                                  setState(() {
                                                    _unfollow(widget.userId);
                                                    _unfollow3(widget.userId);
                                                  });
                                                  if (follower == true) {
                                                    setState(() {
                                                      follower = false;
                                                    });
                                                  } else if (follower ==
                                                      false) {
                                                    setState(() {
                                                      follower = true;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  'remove',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.038,
                                                  ),
                                                ),
                                              )
                                            : follower1
                                                ? TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _unfollow1(
                                                            widget.userId);
                                                        _unfollow2(
                                                            widget.userId);
                                                      });
                                                      if (follower1 == true) {
                                                        setState(() {
                                                          follower1 = false;
                                                        });
                                                      } else if (follower1 ==
                                                          false) {
                                                        setState(() {
                                                          follower1 = true;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      'unfollow',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width * 0.038,
                                                      ),
                                                    ),
                                                  )
                                                : TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _follow();
                                                        follower1 = true;
                                                      });
                                                    },
                                                    child: Text(
                                                      'follow',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width * 0.038,
                                                      ),
                                                    ),
                                                  ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else
                    return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
