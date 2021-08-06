import 'dart:ui';

import 'package:esportshub/pages2/homepage/cards/cards.dart';
import 'package:esportshub/pages2/homepage/cards/completed-expand.dart';
import 'package:esportshub/pages2/homepage/cards/upcoming-expand.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final user = FirebaseAuth.instance.currentUser;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.025),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.04),
              Text(
                ' Welcome',
                style: TextStyle(color: Colors.white, fontSize: width * 0.045),
              ),
              Text(
                ' ${user!.displayName}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: height * 0.06),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  Upcoming Matches',
                    style:
                        TextStyle(color: Colors.white, fontSize: width * 0.042),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpcomingExpand()));
                        },
                        child: Text(
                          'See all',
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.042),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: width * 0.04,
                      )
                    ],
                  ),
                ],
              ),
              Container(
                height: width * 0.615,
                child: Column(
                  children: [
                    Expanded(
                      child: CardUpcoming1(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.04),
              Text(
                '  Ongoing Matches',
                style: TextStyle(color: Colors.white, fontSize: width * 0.042),
              ),
              Container(
                height: width * 0.61,
                child: Column(
                  children: [
                    Expanded(
                      child: CardOngoing(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '  Completed Matches',
                    style:
                        TextStyle(color: Colors.white, fontSize: width * 0.042),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CompletedExpand()));
                        },
                        child: Text(
                          'See all',
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.042),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: width * 0.04,
                      )
                    ],
                  ),
                ],
              ),
              Container(
                height: width * 0.61,
                child: Column(
                  children: [
                    Expanded(
                      child: Cardcompleted(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
