
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createGroup(
      String groupName, String userUid, String userName) async {
    String retVal = 'error';
    List<String> members = [];
    List<String> players = [];

    try {
      members.add(userUid);
      players.add(userName);
      DocumentReference _docRef = await _firestore.collection('groups').add({
        'name': groupName,
        'leader': userUid,
        'prize': "1000",
        'entry': "120",
        '1st_prize': "500",
        'per_kill': "10",
        'map': "Livik",
        'prospective': "TPP",
        'genre': 'Tier 3 squad',
        'members': members,
        'players': players,
        'limit': 4,
        'stage': 'upcoming',
        'idpass': false,
        'Room_ID': '',
        'Room_Password': '',
        'squads': 0,
        'groupCreate': Timestamp.now(),
      });

      await _firestore.collection('users').doc(userUid).update({
        'groupId': _docRef.id,
      });
      await _firestore.collection('groups').doc(_docRef.id).update({
        'groupId': _docRef.id,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> createTeam(String groupName, String userName, String userUid,
      String groupId, int squads) async {
    String retVal = 'error';
    List<String> members = [];
    List<String> players = [];

    try {
      members.add(userUid);
      players.add(userName);
      DocumentReference _docRef = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('Teams')
          .add({
        'name': groupName,
        'leader': userUid,
        'members': members,
        'players': players,
        'limit': 4,
        'team-no': squads,
      });

      await _firestore.collection('users').doc(userUid).update({
        'teamId': _docRef.id,
      });
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('Teams')
          .doc(_docRef.id)
          .update({
        'teamId': _docRef.id,
        'teamIdExists': false,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinTeam(
      String userName, String userUid, String groupId, String teamId) async {
    String retVal = 'error';
    List<String> members = [];
    List<String> players = [];

    try {
      members.add(userUid);
      players.add(userName);
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('Teams')
          .doc(teamId)
          .update({
        'members': FieldValue.arrayUnion(members),
        'players': FieldValue.arrayUnion(players),
      });

      await _firestore.collection('users').doc(userUid).update({
        'teamId': teamId,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinGroup(
      String groupId, String userUid, String userName) async {
    String retVal = 'error';
    List<String> members = [];
    List<String> players = [];

    try {
      members.add(userUid);
      players.add(userName);
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion(members),
        'players': FieldValue.arrayUnion(players),
      });

      await _firestore.collection('users').doc(userUid).update({
        'groupId': groupId,
      });

      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}

class FirebaseApiDownload {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}

class FirebaseFile {
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFile({
    required this.ref,
    required this.name,
    required this.url,
  });
}

class FirebaseApiUpload {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
  static UploadTask? uploadFile1(String destination1, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination1);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}
