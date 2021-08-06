import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/homepage2.dart';
import 'package:esportshub/pages2/profile/followers.dart';
import 'package:esportshub/pages2/profile/following.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser;

class FollowInfo extends StatefulWidget {
  final int index;
  final String followersId;
  final String followingId;
  const FollowInfo({
    Key? key,
    required this.index,
    required this.followersId,
    required this.followingId,
  }) : super(key: key);

  @override
  _FollowInfoState createState() => _FollowInfoState();
}

class _FollowInfoState extends State<FollowInfo>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(initialIndex: widget.index, length: 2, vsync: this);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            onDoubleTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Homepage1(index: 3),
                ),
              );
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text(user!.displayName.toString()),
          toolbarHeight: height * 0.15,
          bottom: TabBar(
            controller: _controller,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.white, width: 2.5),
            ),
            tabs: [
              Tab(
                child: Container(
                  width: width * 0.35,
                  alignment: Alignment.center,
                  child: Text(
                    'Followers',
                    style: TextStyle(fontSize: width * 0.045),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: width * 0.35,
                  alignment: Alignment.center,
                  child: Text(
                    'Followings',
                    style: TextStyle(fontSize: width * 0.045),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: DefaultTabController(
          length: 2,
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
              TabBarView(
                controller: _controller,
                children: [
                  Followers(),
                  Following(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
