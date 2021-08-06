import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/videos/replyComments.dart';
import 'package:esportshub/tools/timeago.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';

import 'likes.dart';

CollectionReference ref2 = FirebaseFirestore.instance.collection('LC');
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Comment extends StatefulWidget {
  final String lc;
  const Comment({Key? key, required this.lc}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController commentController = TextEditingController();
  bool editing = false;
  String commentId = '';

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  post(String docID) async {
    List liked = [];
    DocumentReference _docRef = await _firestore
        .collection('LC')
        .doc(docID)
        .collection('comments')
        .add({
      'comments': commentController.text.trim(),
      'username': user!.displayName,
      'useruid': user!.uid,
      'photourl': user!.photoURL,
      'veryfied': true,
      'liked': liked,
      'commentId': '',
      'timestamp': DateTime.now(),
    });

    await _firestore
        .collection('LC')
        .doc(docID)
        .collection('comments')
        .doc(_docRef.id)
        .update({
      'commentId': _docRef.id,
    });
  }

  edit(String commentId) async {
    await _firestore
        .collection('LC')
        .doc(widget.lc)
        .collection('comments')
        .doc(commentId)
        .update({
      'comments': commentController.text.trim(),
    });
  }

  replyCount(String commentId) {
    String count = '';
    ref2
        .doc(widget.lc)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        count = snapshot.docs.length.toString();
      });
      Text(count);
    });
  }

  delete(String userId, String commentId) async {
    if (user!.uid == userId) {
      await _firestore
          .collection('LC')
          .doc(widget.lc)
          .collection('comments')
          .doc(commentId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.7,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          left: MediaQuery.of(context).size.width * 0.04),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.expand_more,
                    size: width * 0.075,
                  )),
              Row(
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.047),
                  ),
                  SizedBox(width: width * 0.02)
                ],
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.paperPlane,
                    size: width * 0.057,
                  ),
                  SizedBox(width: width * 0.015)
                ],
              ),
            ],
          ),
          SizedBox(height: width * 0.017),
          Container(
            padding: EdgeInsets.all(width * 0.012),
            decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.003),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoURL.toString()),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  width: width * 0.604,
                  child: TextFormField(
                    controller: commentController,
                    maxLines: null,
                    cursorColor: Colors.grey,
                    cursorHeight: width * 0.055,
                    cursorWidth: 1.4,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(1),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      labelStyle: TextStyle(color: Colors.grey),
                      hintText: '  Comment as ${user!.displayName} . . .',
                      hintStyle: TextStyle(fontSize: width * 0.04),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  height: width * 0.1,
                  width: width * 0.14,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: height * 0.005),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade900.withOpacity(0.3),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        editing ? edit(commentId) : post(widget.lc);
                        commentController.clear();
                      });
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontSize: width * 0.038, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Container(
            color: Colors.grey.shade800,
            width: width * 0.97,
            height: width * 0.002,
          ),
          SizedBox(height: width * 0.035),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: ref2.doc(widget.lc).collection('comments').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (!snapshot.hasData) {
                    return SpinKitWave(
                      color: Colors.white.withOpacity(0.4),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Text("Be the first one to comments");
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    return Column(
                        children: snapshot.data!.docs
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Colors.black,
                                      context: context,
                                      builder: (context) {
                                        return ReplyComments(
                                          comments: e['comments'],
                                          profile: e['photourl'],
                                          timestamp: e['timestamp'],
                                          username: e['username'],
                                          liked: e['liked'],
                                          commentId: e['commentId'],
                                          lc: widget.lc,
                                        );
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(width * 0.015),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(e['photourl']),
                                              ),
                                              user!.uid != e['useruid']
                                                  ? Container()
                                                  : Container(
                                                      width: width * 0.092,
                                                      child:
                                                          PopupMenuButton<int>(
                                                        color: Colors
                                                            .grey.shade900,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        onSelected: (item) {
                                                          switch (item) {
                                                            case 0:
                                                              setState(() {
                                                                commentController
                                                                        .text =
                                                                    e['comments'];
                                                                commentId = e[
                                                                    'commentId'];
                                                                editing = true;
                                                              });
                                                              break;
                                                            case 1:
                                                              setState(
                                                                () {
                                                                  delete(
                                                                      e['useruid'],
                                                                      e['commentId']);
                                                                },
                                                              );
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (context) => [
                                                          const PopupMenuItem<
                                                              int>(
                                                            value: 0,
                                                            height: 42,
                                                            child: Text('edit'),
                                                          ),
                                                          const PopupMenuItem<
                                                              int>(
                                                            value: 1,
                                                            height: 42,
                                                            child:
                                                                Text('delete'),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                          SizedBox(width: width * 0.035),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: width * 0.71,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e['username'],
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .grey.shade300,
                                                            fontSize:
                                                                width * 0.035),
                                                      ),
                                                      SizedBox(
                                                          width: width * 0.012),
                                                      Time(
                                                          time: e['timestamp'],
                                                          style: TextStyle(
                                                              fontSize: width *
                                                                  0.0335,
                                                              color:
                                                                  Colors.grey)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: height * 0.004),
                                                Container(
                                                  width: width * 0.7,
                                                  child: ReadMoreText(
                                                    e['comments'],
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.042),
                                                    trimLines: 4,
                                                    trimMode: TrimMode.Line,
                                                    trimCollapsedText:
                                                        'Read more',
                                                    trimExpandedText:
                                                        'Read less',
                                                    moreStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width * 0.037,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    lessStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: width * 0.037,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: height * 0.004),
                                                ReplyCount(
                                                  lc: widget.lc,
                                                  commentId: e['commentId'],
                                                ),
                                              ],
                                            ),
                                          ),
                                          CommentLikes(
                                              lc: widget.lc,
                                              commentId: e['commentId'],
                                              liked: e['liked']),
                                        ],
                                      ),
                                      SizedBox(height: height * 0.016),
                                      Container(
                                        color: Colors.grey.shade800,
                                        width: width * 0.97,
                                        height: width * 0.002,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList());
                  } else
                    return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
