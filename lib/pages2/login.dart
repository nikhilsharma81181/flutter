import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homepage/homepage2.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

class LoginPg extends StatefulWidget {
  const LoginPg({Key? key}) : super(key: key);

  @override
  _LoginPgState createState() => _LoginPgState();
}

class _LoginPgState extends State<LoginPg> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
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
            isLoading
                ? Center(
                    child: SpinKitWave(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  )
                : Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 15.0,
                              sigmaY: 15.0,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: width * 0.9,
                              height: height * 0.9,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.032,
                                  vertical: width * 0.015),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
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
                                  SizedBox(height: height * 0.04),
                                  Text(
                                    ' Welcome',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: height * 0.002),
                                  RichText(
                                    text: TextSpan(
                                      text: '   ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.047,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Join',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.05,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        TextSpan(
                                            text: ' us on a exiting journey')
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height * 0.58),
                                  GestureDetector(
                                    onTap: () {
                                      signInWithGoogle(context);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(width * 0.05),
                                        padding: EdgeInsets.all(width * 0.02),
                                        width: width,
                                        height: width * 0.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            width: 2,
                                            color:
                                                Colors.white.withOpacity(0.26),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/google.png'),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                'Sign in with google   ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: width * 0.047,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        final UserCredential authResult =
            await auth.signInWithCredential(credential);

        final User? user = authResult.user;

        var userData = {
          'name': googleSignInAccount.displayName,
          'provider': 'google',
          'photoUrl': googleSignInAccount.photoUrl,
          'email': googleSignInAccount.email,
        };

        users.doc(user!.uid).get().then((doc) {
          if (doc.exists) {
            //old user
            doc.reference.update(userData);

            Navigator.of(context).pushReplacement((MaterialPageRoute(
                builder: (context) => Homepage1(
                      index: 0,
                    ))));
          } else {
            //new user
            users.doc(user.uid).set(userData);

            Navigator.of(context).pushReplacement((MaterialPageRoute(
                builder: (context) => Homepage1(
                      index: 0,
                    ))));
          }
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (PlatformException) {
      print('PlatformException');
      print('Error, please check internet connection');
    }
  }
}
