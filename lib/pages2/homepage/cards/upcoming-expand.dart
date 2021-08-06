import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../joinnow.dart';

class UpcomingExpand extends StatefulWidget {
  const UpcomingExpand({Key? key}) : super(key: key);

  @override
  _UpcomingExpandState createState() => _UpcomingExpandState();
}

class _UpcomingExpandState extends State<UpcomingExpand> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('groups');

  var groupId = '';
  String stage = 'upcoming';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: width * 0.11,
                      height: width * 0.052,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: width * 0.065,
                      ),
                    ),
                  ),
                  Text(
                    'Upcoming Matches',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.047,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: width * 0.1),
                ],
              ),
              SizedBox(height: height * 0.035),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.01, vertical: 10),
                    child: StreamBuilder(
                      stream: ref.where('stage', isEqualTo: stage).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: snapshot.data!.docs
                                  .map((e) => Container(
                                        margin: EdgeInsets.only(
                                            bottom: width * 0.035),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 50.0,
                                              sigmaY: 50.0,
                                            ),
                                            child: Container(
                                              width: width * 0.95,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Colors.white
                                                        .withOpacity(0.12),
                                                    Colors.white
                                                        .withOpacity(0.12)
                                                  ],
                                                  stops: [0.0, 1.0],
                                                ),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.white
                                                        .withOpacity(0.2)),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Prize Pool',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          '${e['genre']} ${e['prospective']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  width * 0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          'Entry',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.005,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          e['prize'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  width * 0.06,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          e['entry'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  width * 0.045,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15, bottom: 10),
                                                      width: width,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey)),
                                                      child:
                                                          LinearProgressIndicator(
                                                        color: Colors.black,
                                                        backgroundColor:
                                                            Colors.white,
                                                        value: e['members']
                                                                .length /
                                                            e['limit'],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        e['members'].length ==
                                                                e['limit']
                                                            ? Text(
                                                                'Full ${e['limit']} / ${e['limit']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            : Text(
                                                                '${e['members'].length} / ${e['limit']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                        Text(
                                                          'Only ${(e['limit'] - e['members'].length).toString()} slot left',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 20,
                                                      color: Colors.white,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              e['time'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.02),
                                                            Text(
                                                              e['date'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '1st : ${e['1st_prize']}   ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          'Map : ${e['map']}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      height: height * 0.05,
                                                      width: width,
                                                      decoration: !e['members']
                                                              .contains(
                                                                  user!.uid)
                                                          ? BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border:
                                                                  Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.25),
                                                              ),
                                                            )
                                                          : BoxDecoration(
                                                              border: Border.all(
                                                                  width: width *
                                                                      0.0025,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.7)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: RawMaterialButton(
                                                          onPressed: () async {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'groups')
                                                                .doc(e[
                                                                    'groupId'])
                                                                .collection(
                                                                    'Team')
                                                                .get();
                                                            await Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        JoinNow(
                                                                            data:
                                                                                e['groupId'])));
                                                          },
                                                          child: !e['members']
                                                                  .contains(
                                                                      user!.uid)
                                                              ? Text(
                                                                  'Register Now',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                )
                                                              : Text(
                                                                  'Registered',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        } else
                          return Container(
                            width: width,
                            child: Center(
                              child: SpinKitWave(
                                size: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
