import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  late final String uid;

  DataBaseService({required this.uid});

  final userCollection = FirebaseFirestore.instance.collection("users");

  Future updateUserInfo(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
    });
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Future getData() async {
    try {
      DocumentSnapshot ds = await userCollection.doc(uid).get();
      String email = ds.get('email');
      String name = ds.get('name');
      return [email, name];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
