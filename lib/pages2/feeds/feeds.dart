import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/tools/timeago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('feeds');

class Feeds extends StatefulWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(width * 0.025),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.01),
              Text(
                '   Feeds',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: width * 0.02),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.032),
                height: height,
                child: StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs
                            .map((e) => ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 15.0,
                                      sigmaY: 15.0,
                                    ),
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: width * 0.94,
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
                                            color:
                                                Colors.white.withOpacity(0.2)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width * 0.12,
                                                  height: height * 0.06,
                                                  child: CircleAvatar(),
                                                ),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                Container(
                                                  height: width * 0.1,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.4,
                                                        child: Text(
                                                          'Esports Hub',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.042,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Time(
                                                        time: e['created'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.037,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.01,
                                                  vertical: width * 0.017),
                                              child: Text(
                                                e['title'],
                                                style: TextStyle(
                                                    fontSize: width * 0.042,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.01),
                                              child: Text(
                                                e['body'],
                                                style: TextStyle(
                                                    fontSize: width * 0.041,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
                    } else
                      return Center(
                        child: SpinKitWave(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
