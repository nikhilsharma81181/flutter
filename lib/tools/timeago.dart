import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Time extends StatefulWidget {
  final TextStyle style;
  final Timestamp time;
  const Time({Key? key, required this.time, required this.style})
      : super(key: key);

  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  String month = '';
  String timeAgo = '';

  _month(Timestamp mon) {
    mon.toDate().month == 1
        ? month = 'jan'
        : mon.toDate().month == 2
            ? month = 'feb'
            : mon.toDate().month == 3
                ? month = 'mar'
                : mon.toDate().month == 4
                    ? month = 'april'
                    : mon.toDate().month == 5
                        ? month = 'may'
                        : mon.toDate().month == 6
                            ? month = 'june'
                            : mon.toDate().month == 7
                                ? month = 'july'
                                : mon.toDate().month == 8
                                    ? month = 'aug'
                                    : mon.toDate().month == 9
                                        ? month = 'sep'
                                        : mon.toDate().month == 10
                                            ? month = 'oct'
                                            : mon.toDate().month == 11
                                                ? month = 'nov'
                                                : month = 'dec';
  }

  String ampm = '';
  String hours = '';

  _wordClock(Timestamp hour) {
    hour.toDate().hour < 12 ? ampm = 'AM' : ampm = 'PM';
    hour.toDate().hour > 12
        ? hours = '${hour.toDate().hour - 12}'
        : hours = '${hour.toDate().hour}';
  }

  @override
  void initState() {
    _month(widget.time);
    _wordClock(widget.time);
    _timeAgo(
      widget.time,
    );
    super.initState();
  }

  _timeAgo(Timestamp hour) {
    if (hour.toDate().year == DateTime.now().year &&
        hour.toDate().month == DateTime.now().month) {
      if (hour.toDate().day == DateTime.now().day) {
        if (hour.toDate().hour == DateTime.now().hour) {
          if (hour.toDate().minute == DateTime.now().minute) {
            if (hour.toDate().second == DateTime.now().second) {
            } else {
              setState(() {
                timeAgo =
                    '${DateTime.now().second - hour.toDate().second} seconds ago';
              });
            }
          } else {
            setState(() {
              timeAgo =
                  '${DateTime.now().minute - hour.toDate().minute} minutes ago';
            });
          }
        } else {
          setState(() {
            timeAgo = '${DateTime.now().hour - hour.toDate().hour} hour ago';
          });
        }
      } else {
        setState(() {
          timeAgo = '${DateTime.now().day - hour.toDate().day} days ago';
        });
      }
    } else {
      setState(() {
        timeAgo =
            '$hours:${widget.time.toDate().minute} $ampm, ${widget.time.toDate().day} $month';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            timeAgo,
            style: widget.style,
          ),
        ],
      ),
    );
  }
}
