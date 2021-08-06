import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/login.dart';
import 'package:esportshub/pages2/profile/editProfile.dart';
import 'package:esportshub/pages2/profile/followinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser;
final FirebaseAuth auth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String followersId = '';
  String followingId = '';
  int followers = 0;
  int following = 0;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() {
    ref.doc(user!.uid).get().then((DocumentSnapshot doc) {
      setState(() {
        followersId = doc['followersId'];
        followingId = doc['followingId'];
      });
    });
    ref
        .doc(user!.uid)
        .collection('followers')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        followers = snapshot.docs.length;
      });
    });
    ref
        .doc(user!.uid)
        .collection('following')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        following = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(width * 0.025),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15.0,
                  sigmaY: 15.0,
                ),
                child: Container(
                  padding: EdgeInsets.all(width * 0.035),
                  width: double.infinity,
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
                        width: 1, color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [

                      SizedBox(height: height * 0.03),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: Offset(2, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: width * 0.125,
                          backgroundImage:
                              NetworkImage(user!.photoURL.toString()),
                        ),
                      ),
                      SizedBox(height: height * 0.035),
                      Text(
                        user!.displayName.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: width * 0.045),
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        user!.email.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.037,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15.0,
                  sigmaY: 15.0,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: width * 0.035),
                  width: double.infinity,
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
                        width: 1, color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                  ),
                                ),
                                SizedBox(height: height * 0.0032),
                                Text(
                                  'Cash Won',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FollowInfo(
                                        index: 0,
                                        followersId: followersId,
                                        followingId: followingId,
                                      )));
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    followers.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.05,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.0032),
                                  Text('Followers'),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FollowInfo(
                                        index: 1,
                                        followersId: followersId,
                                        followingId: followingId,
                                      )));
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Text(
                                    following.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05),
                                  ),
                                  SizedBox(height: height * 0.0032),
                                  Text('Following'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15.0,
                  sigmaY: 15.0,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.032, vertical: width * 0.015),
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
                            width: 1, color: Colors.white.withOpacity(0.2)),
                      ),
                      child: RawMaterialButton(
                        onPressed: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: width * 0.032),
                            Text(
                              'My Team',
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.032, vertical: width * 0.015),
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
                            width: 1, color: Colors.white.withOpacity(0.2)),
                      ),
                      child: RawMaterialButton(
                        onPressed: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: width * 0.032),
                            Text(
                              'My Team',
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.032, vertical: width * 0.015),
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
                            width: 1, color: Colors.white.withOpacity(0.2)),
                      ),
                      child: RawMaterialButton(
                        onPressed: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: width * 0.032),
                            Text(
                              'Settings',
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.032, vertical: width * 0.015),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.12),
                            Colors.white.withOpacity(0.12),
                          ],
                          stops: [0.0, 1.0],
                        ),
                        border: Border.all(
                            width: 1, color: Colors.white.withOpacity(0.2)),
                      ),
                      child: RawMaterialButton(
                        onPressed: () async {
                          setState(() {
                            auth.signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPg(),
                              ),
                            );
                          });
                          // setState(() {});
                          // final result = await FilePicker.platform
                          //     .pickFiles(allowMultiple: false);
                          // if (result == null) return;
                          // final path = result.files.single.path!;

                          // setState(() {
                          //   file = File(path);
                          // });
                          // await Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => ClipPreview(file: file)));
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: width * 0.032),
                            Text(
                              'Log out',
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
