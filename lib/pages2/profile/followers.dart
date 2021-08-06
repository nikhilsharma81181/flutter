import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/homepage2.dart';
import 'package:esportshub/pages2/profile/followinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'following.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser;

class Followers extends StatefulWidget {
  const Followers({Key? key}) : super(key: key);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  _unfollow(String userUid) async {
    try {
      await ref.doc(user!.uid).collection('followers').doc(userUid).delete();
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
        stream: ref.doc(user!.uid).collection('followers').snapshots(),
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
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FollowingInfo(
                                        userId: e['useruid'],
                                      ),
                                    ),
                                  );
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
                                            'remove',
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
