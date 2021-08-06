import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/videos/likes.dart';
import 'package:esportshub/tools/timeago.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';

final user = FirebaseAuth.instance.currentUser;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference ref = FirebaseFirestore.instance.collection('LC');

class ReplyComments extends StatefulWidget {
  final String profile;
  final String username;
  final Timestamp timestamp;
  final String comments;
  final List liked;
  final String commentId;
  final String lc;
  const ReplyComments({
    Key? key,
    required this.comments,
    required this.profile,
    required this.timestamp,
    required this.username,
    required this.liked,
    required this.commentId,
    required this.lc,
  }) : super(key: key);

  @override
  _ReplyCommentsState createState() => _ReplyCommentsState();
}

class _ReplyCommentsState extends State<ReplyComments> {
  TextEditingController replyController = TextEditingController();
  post(String docID) async {
    List liked = [];
    DocumentReference _docRef = await _firestore
        .collection('LC')
        .doc(docID)
        .collection('comments')
        .doc(widget.commentId)
        .collection('reply')
        .add({
      'comments': replyController.text.trim(),
      'username': user!.displayName,
      'useruid': user!.uid,
      'photourl': user!.photoURL,
      'veryfied': false,
      'liked': liked,
      'commentId': '',
      'timestamp': DateTime.now(),
    });

    await _firestore
        .collection('LC')
        .doc(docID)
        .collection('comments')
        .doc(widget.commentId)
        .collection('reply')
        .doc(_docRef.id)
        .update({
      'commentId': _docRef.id,
    });
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Replies',
                  style: TextStyle(fontSize: width * 0.042),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close),
                )
              ],
            ),
          ),
          SizedBox(height: height * 0.025),
          Container(
            padding: EdgeInsets.all(width * 0.035),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade900.withOpacity(0.65),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.profile),
                    ),
                    SizedBox(width: width * 0.035),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.67,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.username,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade300,
                                      fontSize: width * 0.035),
                                ),
                                SizedBox(width: width * 0.012),
                                Time(
                                    time: widget.timestamp,
                                    style: TextStyle(
                                        fontSize: width * 0.0335,
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.004),
                          Container(
                            width: width * 0.67,
                            child: ReadMoreText(
                              widget.comments,
                              style: TextStyle(fontSize: width * 0.042),
                              trimLines: 4,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Read more',
                              trimExpandedText: 'Read less',
                              moreStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.037,
                                  fontWeight: FontWeight.w500),
                              lessStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.037,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CommentLikes(
                        lc: widget.lc,
                        commentId: widget.commentId,
                        liked: widget.liked)
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.005),
          Container(
            padding: EdgeInsets.all(width * 0.012),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.004),
                  child: CircleAvatar(
                    radius: width * 0.037,
                    backgroundImage: NetworkImage(
                      user!.photoURL.toString(),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  width: width * 0.604,
                  child: TextFormField(
                    controller: replyController,
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
                      hintStyle: TextStyle(fontSize: width * 0.036),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  height: width * 0.06,
                  width: width * 0.14,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: height * 0.004),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade900.withOpacity(0.3),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        post(widget.lc);
                        replyController.clear();
                      });
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontSize: width * 0.036, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.004),
          Container(
            color: Colors.grey.shade800,
            width: width * 0.97,
            height: width * 0.002,
          ),
          SizedBox(height: width * 0.035),
          StreamBuilder(
            stream: ref
                .doc(widget.lc)
                .collection('comments')
                .doc(widget.commentId)
                .collection('reply')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              if (snapshot.data!.docs.contains('commentId')) {
                return SpinKitWave();
              }

              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data!.docs
                        .map(
                          (e) => Container(
                            padding: EdgeInsets.all(width * 0.015),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: width * 0.04,
                                      backgroundImage:
                                          NetworkImage(e['photourl']),
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e['username'],
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Colors.grey.shade300,
                                                      fontSize: width * 0.035),
                                                ),
                                                SizedBox(width: width * 0.012),
                                                Time(
                                                    time: e['timestamp'],
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.0335,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.004),
                                          Container(
                                            width: width * 0.7,
                                            child: ReadMoreText(
                                              e['comments'],
                                              style: TextStyle(
                                                  fontSize: width * 0.04),
                                              trimLines: 4,
                                              trimMode: TrimMode.Line,
                                              trimCollapsedText: 'Read more',
                                              trimExpandedText: 'Read less',
                                              moreStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width * 0.037,
                                                  fontWeight: FontWeight.w500),
                                              lessStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: width * 0.037,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ReplyLikes(
                                      lc: widget.lc,
                                      commentId: widget.commentId,
                                      liked: e['liked'],
                                      replyId: e['commentId'],
                                    )
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
                        )
                        .toList());
              } else
                return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
