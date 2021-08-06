import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esportshub/pages2/homepage/home.dart';
import 'package:flutter/material.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CommentLikes extends StatefulWidget {
  final String lc;
  final String commentId;
  final List liked;
  const CommentLikes(
      {Key? key,
      required this.commentId,
      required this.lc,
      required this.liked})
      : super(key: key);

  @override
  _CommentLikesState createState() => _CommentLikesState();
}

class _CommentLikesState extends State<CommentLikes> {
  late bool liked;
  Timer timer2 = Timer.periodic(Duration(seconds: 1), (timer) {});
  double likesCount = 0;
  var likesSuffix = '';

  void _like(BuildContext context, String userUid, String lcId,
      String commentId) async {
    List<String> liked = [];

    try {
      liked.add(userUid);
      await _firestore
          .collection('LC')
          .doc(lcId)
          .collection('comments')
          .doc(commentId)
          .update({
        'liked': FieldValue.arrayUnion(liked),
      });
    } catch (e) {
      print(e);
    }
    return print('');
  }

  void _disLike(BuildContext context, String userUid, String lcId,
      String commentId) async {
    List<String> liked = [];

    try {
      liked.add(userUid);
      await _firestore
          .collection('LC')
          .doc(lcId)
          .collection('comments')
          .doc(commentId)
          .update({
        'liked': FieldValue.arrayRemove(liked),
      });
    } catch (e) {
      print(e);
    }
    return print('');
  }

  @override
  void initState() {
    super.initState();
    getLikescount();
    widget.liked.contains(user!.uid) ? liked = true : liked = false;
  }

  getLikescount() {
    if (widget.liked.length >= 1000 && widget.liked.length < 1000000) {
      likesCount = widget.liked.length / 1000;
      likesSuffix = 'k';
    } else if (widget.liked.length >= 1000000 &&
        widget.liked.length < 1000000000) {
      likesCount = widget.liked.length / 1000000;
      likesSuffix = 'M';
    } else if (widget.liked.length >= 1000000000) {
      likesCount = widget.liked.length / 1000000000;
      likesSuffix = 'B';
    }
    likesCount = widget.liked.length.toDouble();
  }

  @override
  void dispose() {
    timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
                if (liked == true) {
                  _like(context, user!.uid, widget.lc, widget.commentId);
                } else if (liked == false) {
                  _disLike(context, user!.uid, widget.lc, widget.commentId);
                }
                timer.cancel();
              });
              if (liked == true) {
                setState(() {
                  liked = false;
                  likesCount--;
                });
              } else if (liked == false) {
                setState(() {
                  liked = true;
                  likesCount++;
                });
              }
            },
            child: liked
                ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: width * 0.042,
                  )
                : Icon(
                    Icons.favorite_outline_sharp,
                    size: width * 0.04,
                    color: Colors.white,
                  ),
          ),
          SizedBox(height: height * 0.002),
          widget.liked.length < 1000
              ? Text(
                  likesCount.toInt().toString(),
                  style: TextStyle(fontSize: width * 0.032),
                )
              : Text('$likesCount$likesSuffix'),
        ],
      ),
    );
  }
}

class ReplyLikes extends StatefulWidget {
  final String lc;
  final String commentId;
  final List liked;
  final String replyId;
  const ReplyLikes({
    Key? key,
    required this.commentId,
    required this.lc,
    required this.liked,
    required this.replyId,
  }) : super(key: key);

  @override
  _ReplyLikesState createState() => _ReplyLikesState();
}

class _ReplyLikesState extends State<ReplyLikes> {
  late bool liked;
  Timer timer2 = Timer.periodic(Duration(seconds: 1), (timer) {});
  double likesCount = 0;
  var likesSuffix = '';

  void _like(BuildContext context, String userUid, String lcId,
      String commentId, String replyId) async {
    List<String> liked = [];

    try {
      liked.add(userUid);
      await _firestore
          .collection('LC')
          .doc(lcId)
          .collection('comments')
          .doc(commentId)
          .collection('reply')
          .doc(replyId)
          .update({
        'liked': FieldValue.arrayUnion(liked),
      });
    } catch (e) {
      print(e);
    }
    return print('');
  }

  void _disLike(BuildContext context, String userUid, String lcId,
      String commentId, String replyId) async {
    List<String> liked = [];

    try {
      liked.add(userUid);
      await _firestore
          .collection('LC')
          .doc(lcId)
          .collection('comments')
          .doc(commentId)
          .collection('reply')
          .doc(replyId)
          .update({
        'liked': FieldValue.arrayRemove(liked),
      });
    } catch (e) {
      print(e);
    }
    return print('');
  }

  @override
  void initState() {
    super.initState();
    getLikescount();
    widget.liked.contains(user!.uid) ? liked = true : liked = false;
  }

  getLikescount() {
    if (widget.liked.length >= 1000 && widget.liked.length < 1000000) {
      likesCount = widget.liked.length / 1000;
      likesSuffix = 'k';
    } else if (widget.liked.length >= 1000000 &&
        widget.liked.length < 1000000000) {
      likesCount = widget.liked.length / 1000000;
      likesSuffix = 'M';
    } else if (widget.liked.length >= 1000000000) {
      likesCount = widget.liked.length / 1000000000;
      likesSuffix = 'B';
    }
    likesCount = widget.liked.length.toDouble();
  }

  @override
  void dispose() {
    timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
                if (liked == true) {
                  _like(context, user!.uid, widget.lc, widget.commentId,
                      widget.replyId);
                } else if (liked == false) {
                  _disLike(context, user!.uid, widget.lc, widget.commentId,
                      widget.replyId);
                }
                timer.cancel();
              });
              if (liked == true) {
                setState(() {
                  liked = false;
                  likesCount--;
                });
              } else if (liked == false) {
                setState(() {
                  liked = true;
                  likesCount++;
                });
              }
            },
            child: liked
                ? Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: width * 0.042,
                  )
                : Icon(
                    Icons.favorite_outline_sharp,
                    size: width * 0.04,
                    color: Colors.white,
                  ),
          ),
          SizedBox(height: height * 0.002),
          widget.liked.length < 1000
              ? Text(
                  likesCount.toInt().toString(),
                  style: TextStyle(fontSize: width * 0.032),
                )
              : Text('$likesCount$likesSuffix'),
        ],
      ),
    );
  }
}

class ReplyCount extends StatefulWidget {
  final String lc;
  final String commentId;
  const ReplyCount({Key? key, required this.lc, required this.commentId})
      : super(key: key);

  @override
  _ReplyCountState createState() => _ReplyCountState();
}

class _ReplyCountState extends State<ReplyCount> {
  String count = '';
  bool zero = true;

  @override
  void initState() {
    replyCount(widget.commentId);
    super.initState();
  }

  replyCount(String commentId) {
    _firestore
        .collection('LC')
        .doc(widget.lc)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        count = snapshot.docs.length.toString();
        snapshot.docs.length == 0 ? zero = true : zero = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return zero
        ? Text('')
        : Text(
            '$count replies',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade300,
            ),
          );
  }
}
