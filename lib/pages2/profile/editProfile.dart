import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/homepage2.dart';
import 'package:esportshub/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

CollectionReference ref = FirebaseFirestore.instance.collection('users');
final user = FirebaseAuth.instance.currentUser;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {});
  var photoUrl = '';
  late File file;
  UploadTask? task;
  bool done = false;
  bool asset = false;

  @override
  void initState() {
    _username.text = user!.displayName.toString();
    _email.text = user!.email.toString();
    photoUrl = user!.photoURL.toString();
    super.initState();
  }

  edit() {
    ref.doc(user!.uid).update({
      'name': _username.text.trim(),
      'email': _email.text.trim(),
      'photoUrl': photoUrl,
    });
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Homepage1(index: 3)));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: width * 0.2,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '   Cancel',
              style: TextStyle(
                  fontSize: width * 0.042, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        actions: [
          !done
              ? Container(
                  width: width * 0.17,
                  alignment: Alignment.center,
                  child: Text(
                    'Wait...',
                    style: TextStyle(
                        fontSize: width * 0.042, fontWeight: FontWeight.w500),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    edit();
                  },
                  child: Container(
                    width: width * 0.17,
                    alignment: Alignment.center,
                    child: Text(
                      'Save',
                      style: TextStyle(
                          fontSize: width * 0.042, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.01),
                  Container(
                    width: double.infinity,
                    height: width * 0.35,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {});
                            final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false, type: FileType.image);
                            if (result == null) return;
                            final path = result.files.single.path!;

                            setState(() {
                              file = File(path);
                              asset = true;
                            });
                            setState(() {
                              uploadFile();
                            });
                            timer =
                                Timer.periodic(Duration(seconds: 5), (timer) {
                              setState(() {
                                done = true;
                              });
                              timer.cancel();
                            });
                          },
                          child: Container(
                            child: asset
                                ? CircleAvatar(
                                    radius: width * 0.17,
                                    backgroundImage: FileImage(file),
                                  )
                                : CircleAvatar(
                                    radius: width * 0.17,
                                    backgroundImage: NetworkImage(photoUrl),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.012),
                  Text('Tap to select photo',
                      style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: height * 0.02),
              Text('   Username',
                  style: TextStyle(
                      fontSize: width * 0.042, fontWeight: FontWeight.w500)),
              SizedBox(height: height * 0.007),
              TextFormField(
                controller: _username,
                cursorColor: Colors.white,
                cursorHeight: width * 0.06,
                decoration: InputDecoration(
                  hintText: 'Enter your in-game name',
                  contentPadding: EdgeInsets.all(width * 0.06),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text('   Email',
                  style: TextStyle(
                      fontSize: width * 0.042, fontWeight: FontWeight.w500)),
              SizedBox(height: height * 0.007),
              TextFormField(
                controller: _email,
                cursorColor: Colors.white,
                cursorHeight: width * 0.06,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  contentPadding: EdgeInsets.all(width * 0.06),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future uploadFile() async {
    final fileName = _username.text.trim();
    final destination = 'videos/$fileName.mp4';

    task = FirebaseApiUpload.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
    setState(() {
      photoUrl = urlDownload;
    });
  }
}
