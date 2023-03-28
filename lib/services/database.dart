import 'package:dishio/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usersTable');

//#1
  Future setUserInformation(
      String name, String uid, String email, String surname) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'surname': surname,
      'userId': uid,
      'email': email,
      'role': 'user',
    });
  }

//#2
  Future modifyUserData(String name, String surname, String uid) async {
    var result = await userCollection.where('userId', isEqualTo: uid).get();
    return await userCollection.doc(uid).update({
      'name': name,
      'surname': surname,
      'userId': uid,
      'email': result.docs[0].get('email'),
      'role': result.docs[0].get('role'),
    });
  }

//#3
  Future deleteUserFromDB(String uid) async {
    await userCollection.doc(uid).delete();
    return true;
  }
}
