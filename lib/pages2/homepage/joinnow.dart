import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('groups');
FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class JoinNow extends StatefulWidget {
  final String data;
  const JoinNow({Key? key, required this.data}) : super(key: key);

  @override
  _JoinNowState createState() => _JoinNowState();
}

class _JoinNowState extends State<JoinNow> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder<DocumentSnapshot>(
      future: ref.doc('${widget.data}').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> e =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(width * 0.027),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black87,
                    Colors.black,
                  ],
                ),
              ),
              child: SafeArea(
                child: Stack(children: [
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
                  Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SizedBox(
                                width: width * 0.1,
                                height: width * 0.057,
                                child: Icon(Icons.arrow_back,
                                    color: Colors.white, size: width * 0.065),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.32,
                              height: width * 0.057,
                              child: Text(
                                e['genre'],
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.1,
                              height: width * 0.057,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.027),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025, vertical: width * 0.032),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Prize Pool',
                                  style: TextStyle(color: Colors.white),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              margin: EdgeInsets.only(top: 15, bottom: 10),
                              width: width,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.grey)),
                              child: LinearProgressIndicator(
                                color: Colors.white.withOpacity(0.7),
                                backgroundColor: Colors.white,
                                value: e['members'].length / e['limit'],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                e['members'].length == e['limit']
                                    ? Text(
                                        'Full ${e['limit']} / ${e['limit']}',
                                        style: TextStyle(
                                            color: Colors.red[100],
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Text(
                                        '${e['members'].length} /${e['limit']}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                Text(
                                  'Only ${(e['limit'] - e['members'].length).toString()} slot left',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Divider(
                                height: 20,
                                color: Colors.white.withOpacity(0.7)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '1st : ${e['1st_prize']}   ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Per Kill : 10${e['per_kill']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  'Map : ${e['map']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '${e['prospective']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Divider(color: Colors.white.withOpacity(0.7)),
                            SizedBox(height: height * 0.01),
                            Center(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                    // ignore: unnecessary_statements
                                    e['idpass']? null: ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          'Button will be activated on time',
                                          style: TextStyle(
                                              fontSize: width * 0.035,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ));
                                      e['idpass'] &&
                                              e['members'].contains(user!.uid)
                                          ? showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              context: context,
                                              builder: (context) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                          width * 0.13),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  width * 0.13),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300)),
                                                      child: Column(
                                                        children: [
                                                          SelectableText(
                                                            "Room ID : ${e['Room_ID']}",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            "Password : ${e['Room_Password']}",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: width * 0.42,
                                                        height: width * 0.12,
                                                        padding: EdgeInsets.all(
                                                            width * 0.02),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black87
                                                              .withOpacity(0.7),
                                                        ),
                                                        child: Text(
                                                          "Done",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  width * 0.035,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: width * 0.15)
                                                  ],
                                                );
                                              })
                                          // ignore: unnecessary_statements
                                          : null;
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: width * 0.42,
                                      height: width * 0.12,
                                      padding: EdgeInsets.all(width * 0.02),
                                      decoration: e['idpass'] &&
                                              e['members'].contains(user!.uid)
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Colors.black,
                                            )
                                          : BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.7)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.transparent,
                                            ),
                                      child: Text(
                                        "BGMI ID & Password",
                                        style: e['idpass'] &&
                                                e['members'].contains(user!.uid)
                                            ? TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.035,
                                                fontWeight: FontWeight.w600)
                                            : TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.035,
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.005),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Text(
                          'If your team name is not listed below please create you team here and ask your teammates to join',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: height * 0.015),
                      Teams1(
                          data1: widget.data,
                          data2: e['groupId'],
                          data3: e['members']),
                      Container(
                        decoration:
                            !e['members'].contains(user!.uid) && e['squads'] < 3
                                ? BoxDecoration(
                                    color: Colors.black.withOpacity(0.76),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade600,
                                          blurRadius: 14,
                                          spreadRadius: 1,
                                          offset: Offset(0, 2))
                                    ],
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                        width: width * 0.0015,
                                        color: Colors.white),
                                    borderRadius: BorderRadius.circular(10)),
                        width: width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.14,
                        child: RawMaterialButton(
                          onPressed: () {
                            !e['members'].contains(user!.uid) && e['squads'] < 3
                                ? setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              backgroundColor: Colors.grey[900],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              content: DialogBox(
                                                  members: e['members'],
                                                  squads: e['squads'],
                                                  groupId: e['groupId']));
                                        });
                                  })
                                // ignore: unnecessary_statements
                                : null;
                          },
                          child: !e['members'].contains(user!.uid) &&
                                  e['squads'] < 3
                              ? Text(
                                  'Create Squad',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  'Registered',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        }

        return Container(
          width: width,
          height: height,
          color: Colors.black,
        );
      },
    );
  }
}

class DialogBox extends StatefulWidget {
  final List members;
  final int squads;
  final String groupId;
  const DialogBox({
    Key? key,
    required this.members,
    required this.squads,
    required this.groupId,
  }) : super(key: key);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  void _joinGroup(BuildContext context, String groupId, String userName) async {
    String _returnString =
        await Database().joinGroup(groupId, user!.uid, userName);
    await _firestore.collection('groups').doc(groupId).update({
      'joined': true,
    });

    if (_returnString == 'success') {
      print('all done');
    }
  }

  void _sqauds(BuildContext context, String groupId, int squads) async {
    await _firestore.collection('groups').doc(groupId).update({
      'squads': squads + 1,
    });
  }

  void _createTeam(BuildContext context, String groupName, String groupId,
      String userName, int squads) async {
    String _returnString = await Database()
        .createTeam(groupName, groupId, user!.uid, userName, squads);

    if (_returnString == 'success') {
      print('all done');
      Navigator.of(context).pop();
    }
  }

  var groupId = '';
  bool maxlimit = false;
  bool _squadNameEmpty = false;
  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: width * 0.07, bottom: width * 0.02),
          width: width,
          decoration: BoxDecoration(
            color: Colors.black87.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            controller: _groupNameController,
            cursorColor: Colors.white.withOpacity(0.7),
            cursorHeight: width * 0.05,
            style: TextStyle(color: Colors.white, fontSize: width * 0.045),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: width * 0.12, vertical: height * 0.023),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide:
                    BorderSide(color: _squadNameEmpty? Colors.red: Colors.white.withOpacity(0.7), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: _squadNameEmpty? Colors.red: Colors.grey.shade800,
                    width: 2,
                  )),
              fillColor: Colors.grey[100],
              hintText: _squadNameEmpty?'Feild cannot be empty': 'Enter your squad name',
              hintStyle: TextStyle(
                color: _squadNameEmpty? Colors.red: Colors.grey[600],
                fontSize: width * 0.041,
                height: 0.6,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: width / 3.4,
                  margin: EdgeInsets.symmetric(vertical: width * 0.06),
                  decoration: !widget.members.contains(user!.uid)
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        )
                      : BoxDecoration(
                          border: Border.all(
                              width: width * 0.0015,
                              color: Colors.white.withOpacity(0.7)),
                          borderRadius: BorderRadius.circular(10)),
                  height: width * 0.14,
                  child: RawMaterialButton(
                    onPressed: () {
                      !widget.members.contains(user!.uid) && widget.squads < 3
                          ? setState(() {
                              if (_groupNameController.text.isEmpty) {
                                _squadNameEmpty = true;
                              } else {
                                groupId = widget.groupId;
                                _joinGroup(context, groupId,
                                    user!.displayName.toString());
                                _createTeam(
                                    context,
                                    _groupNameController.text,
                                    user!.displayName.toString(),
                                    groupId,
                                    widget.squads);
                                _sqauds(context, groupId, widget.squads);
                              }
                            })
                          // ignore: unnecessary_statements
                          : null;
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
              Container(
                width: width / 3.4,
                margin: EdgeInsets.symmetric(vertical: width * 0.06),
                decoration: !widget.members.contains(user!.uid)
                    ? BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10))
                    : BoxDecoration(
                        border: Border.all(
                            width: width * 0.0015,
                            color: Colors.white.withOpacity(0.7)),
                        borderRadius: BorderRadius.circular(10)),
                height: width * 0.14,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.038,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Teams1 extends StatefulWidget {
  final String data1;
  final String data2;
  final List data3;
  const Teams1(
      {Key? key, required this.data1, required this.data2, required this.data3})
      : super(key: key);

  @override
  _Teams1State createState() => _Teams1State();
}

class _Teams1State extends State<Teams1> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.41,
      child: StreamBuilder(
        stream: ref.doc('${widget.data1}').collection('Teams').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
                child: Column(
                    children: snapshot.data!.docs
                        .map((e) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Join(
                                              data1: e['name'],
                                              data2: e['limit'],
                                              data3: e['players'],
                                              data4: e['teamId'],
                                              data5: e['members'],
                                              data6: widget.data1,
                                              data7: widget.data2,
                                              data8: widget.data3,
                                            );
                                          });
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: height * 0.004),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.035),
                                      width: width,
                                      height: width * 0.15,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                ('${(e['team-no'] + 1).toString()}.'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.039),
                                              ),
                                              SizedBox(width: width * 0.025),
                                              Text(
                                                e['name'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.04),
                                              ),
                                            ],
                                          ),
                                          2 > e['members'].length
                                              ? Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: width * 0.04,
                                                )
                                              : Icon(Icons.check,
                                                  size: width * 0.047,
                                                  color: Colors.red[100])
                                        ],
                                      )),
                                ),
                              ],
                            ))
                        .toList()));
          } else
            return Center(
              child: SpinKitWave(
                size: MediaQuery.of(context).size.width * 0.1,
                color: Colors.white.withOpacity(0.7),
              ),
            );
        },
      ),
    );
  }
}

class Join extends StatefulWidget {
  final String data1;
  final int data2;
  final List data3;
  final String data4;
  final List data5;
  final String data6;
  final String data7;
  final List data8;

  const Join({
    Key? key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
    required this.data5,
    required this.data6,
    required this.data7,
    required this.data8,
  }) : super(key: key);

  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  void _joinGroup(BuildContext context, String groupId, String userName) async {
    String _returnString =
        await Database().joinGroup(groupId, user!.uid, userName);
    await _firestore.collection('groups').doc(groupId).update({
      'joined': true,
    });

    if (_returnString == 'success') {
      print('all done');
    }
  }

  late Timer timer;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void _joinTeam(
    BuildContext context,
    String userName,
    String groupId,
    String teamId,
  ) async {
    String _returnString1 =
        await Database().joinTeam(userName, user!.uid, groupId, teamId);
    await _firestore.collection('groups').doc(groupId).update({
      'joined': true,
    });

    if (_returnString1 == 'success') {
      print('all done');
      setState(() {
        Navigator.of(context).pop();
      });
      setState(() {
        Route route = MaterialPageRoute(
          builder: (context) => JoinNow(data: widget.data6),
        );
        Navigator.pushReplacement(context, route).then(onGoBack);
      });
    }
  }

  // void _edit(BuildContext context, String groupId, String userUid,
  //     String userName) async {
  //   List<String> members = [];
  //   List<String> players = [];

  //   try {
  //     members.remove(userUid);
  //     players.remove(userName);
  //     await _firestore
  //         .collection('groups')
  //         .doc(groupId)
  //         .collection('Teams')
  //         .doc(widget.data4)
  //         .update({
  //       'members': FieldValue.arrayRemove(members),
  //       'players': FieldValue.arrayRemove(players),
  //     });
  //     Navigator.of(context).pop();
  //   } catch (e) {}
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.data1,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '${widget.data3.length.toString()}/${widget.data2}',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: width * 0.05),
          for (int i = 0; i < widget.data3.length; i++)
            Container(
              padding: EdgeInsets.symmetric(vertical: width * 0.01),
              child: Row(
                children: [
                  Text(
                    widget.data3[i],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.036,
                        fontWeight: FontWeight.w500),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _edit(context, widget.data7, widget.data5[i],
                  //         widget.data3[i]);
                  //   },
                  //   child: Icon(Icons.remove),
                  // )q
                ],
              ),
            ),
        ],
      ),
      actions: <Widget>[
        widget.data5.length < 4 && !widget.data8.contains(user!.uid)
            ? TextButton(
                child: Text(
                  'Join',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: width * 0.037),
                ),
                onPressed: () {
                  setState(() {
                    _joinTeam(context, user!.displayName.toString(),
                        widget.data6.toString(), widget.data4);
                    _joinGroup(
                        context, widget.data7, user!.displayName.toString());
                  });
                })
            : SizedBox(),
        SizedBox(
          width: width * 0.42,
        ),
        TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: width * 0.037),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
