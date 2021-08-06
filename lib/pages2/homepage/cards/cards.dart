import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/joinnow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CardUpcoming1 extends StatefulWidget {
  const CardUpcoming1({Key? key}) : super(key: key);

  @override
  _CardUpcoming1State createState() => _CardUpcoming1State();
}

class _CardUpcoming1State extends State<CardUpcoming1> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('groups');

  var groupId = '';
  String stage = 'upcoming';
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0, viewportFraction: 0.97);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
        stream: ref.where('stage', isEqualTo: stage).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return PageView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: snapshot.data!.docs
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: width * 0.02),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 27.0,
                              sigmaY: 27.0,
                            ),
                            child: Container(
                              width: width,
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
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Prize Pool',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${e['genre']} ${e['prospective']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'Entry',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e['prize'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.06,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          e['entry'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 15, bottom: 10),
                                      width: width,
                                      height: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: LinearProgressIndicator(
                                        color: Colors.black,
                                        backgroundColor: Colors.white,
                                        value: e['members'].length / e['limit'],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        e['members'].length == e['limit']
                                            ? Text(
                                                'Full ${e['limit']} / ${e['limit']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            : Text(
                                                '${e['members'].length} / ${e['limit']}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                        Text(
                                          'Only ${(e['limit'] - e['members'].length).toString()} slot left',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              e['time'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Text(
                                              e['date'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '1st : ${e['1st_prize']}   ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Map : ${e['map']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: height * 0.05,
                                      width: width,
                                      decoration: !e['members']
                                              .contains(user!.uid)
                                          ? BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.white
                                                    .withOpacity(0.25),
                                              ),
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  width: width * 0.0025,
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                      child: RawMaterialButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection('groups')
                                                .doc(e['groupId'])
                                                .collection('Team')
                                                .get();
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        JoinNow(
                                                            data:
                                                                e['groupId'])));
                                          },
                                          child:
                                              !e['members'].contains(user!.uid)
                                                  ? Text(
                                                      'Register Now',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )
                                                  : Text(
                                                      'Registered',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
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
    );
  }
}

class CardOngoing extends StatefulWidget {
  const CardOngoing({Key? key}) : super(key: key);

  @override
  _CardOngoingState createState() => _CardOngoingState();
}

class _CardOngoingState extends State<CardOngoing> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('groups');

  var groupId = '';
  String stage = 'ongoing';
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0, viewportFraction: 0.97);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
        stream: ref.where('stage', isEqualTo: stage).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData) {
            return PageView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              children: snapshot.data!.docs
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: width * 0.02),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 50.0,
                              sigmaY: 50.0,
                            ),
                            child: Container(
                              width: width * 0.9,
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
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Prize Pool',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${e['genre']} ${e['prospective']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'Entry',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e['prize'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.06,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          e['entry'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: width * 0.015),
                                    Container(
                                      padding: EdgeInsets.all(width * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Ongoing ',
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.85),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.white
                                                  .withOpacity(0.85),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: width * 0.015),
                                    Divider(
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e['date'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.032,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '1st : ${e['1st_prize']}   ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Per Kill : ${e['per_kill']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Map : ${e['map']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: height * 0.05,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.white
                                                  .withOpacity(0.25))),
                                      child: RawMaterialButton(
                                          onPressed: () {
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Watch now',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
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
    );
  }
}

class Cardcompleted extends StatefulWidget {
  const Cardcompleted({Key? key}) : super(key: key);

  @override
  _CardcompletedState createState() => _CardcompletedState();
}

class _CardcompletedState extends State<Cardcompleted> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('groups');

  var groupId = '';
  String stage = 'completed';
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0, viewportFraction: 0.97);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 10),
      child: StreamBuilder(
        stream: ref.where('stage', isEqualTo: stage).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData) {
            return PageView(
              controller: controller,
              physics: ScrollPhysics(parent: ScrollPhysics()),
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: width * 0.02),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 50.0,
                              sigmaY: 50.0,
                            ),
                            child: Container(
                              width: width * 0.9,
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
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Prize Pool',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '${e['genre']} ${e['prospective']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.04,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'Entry',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.005,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e['prize'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.06,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          e['entry'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.045,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: width * 0.015),
                                    Container(
                                      padding: EdgeInsets.all(width * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Completed ',
                                              style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.85),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white
                                                  .withOpacity(0.85),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: width * 0.015),
                                    Divider(
                                      height: 20,
                                      color: Colors.white,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          e['date'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.032,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '1st : ${e['1st_prize']}   ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Per Kill : ${e['per_kill']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Map : ${e['map']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: height * 0.05,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.white
                                                  .withOpacity(0.25))),
                                      child: RawMaterialButton(
                                          onPressed: () {
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Watch now',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
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
    );
  }
}
