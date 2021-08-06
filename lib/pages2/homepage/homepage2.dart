import 'dart:ui';

import 'package:esportshub/pages2/feeds/feeds.dart';
import 'package:esportshub/pages2/profile/profile.dart';
import 'package:esportshub/pages2/videos/videos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'home.dart';

class Homepage1 extends StatefulWidget {
  final int index;
  const Homepage1({Key? key, required this.index}) : super(key: key);

  @override
  _Homepage1State createState() => _Homepage1State();
}

class _Homepage1State extends State<Homepage1>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(initialIndex: widget.index, length: 4, vsync: this);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Container(
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
              TabBarView(
                controller: _controller,
                children: [
                  Home(),
                  Videos(),
                  Feeds(),
                  Profile(),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                  Colors.black,
                ],
              ),
            ),
            child: TabBar(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              labelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.white, width: 2.5),
                insets: EdgeInsets.only(bottom: 72),
              ),
              tabs: tabList,
            )),
      ),
    );
  }

  List<Widget> tabList = [
    Container(
      width: 60,
      child: Tab(
        icon: Icon(Icons.home),
        iconMargin: EdgeInsets.all(2),
        text: "Home",
      ),
    ),
    Container(
      width: 60,
      child: Tab(
        icon: Icon(Icons.smart_display_outlined),
        iconMargin: EdgeInsets.all(2),
        text: "Videos",
      ),
    ),
    Container(
      width: 60,
      child: Tab(
        icon: Icon(Icons.feed_outlined),
        iconMargin: EdgeInsets.all(2),
        text: "Feeds",
      ),
    ),
    Container(
      width: 60,
      child: Tab(
        icon: Icon(Icons.person_outline),
        iconMargin: EdgeInsets.all(2),
        text: "Profile",
      ),
    ),
  ];
}
