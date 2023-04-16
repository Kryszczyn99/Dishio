import 'package:dishio/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usersTable');
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categoriesTable');

//#1
  Future setUserInformation(String uid, String email) async {
    return await userCollection.doc(uid).set({
      'name': "",
      'surname': "",
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

//#4
  Future getAllCategories() async {
    return await categoryCollection.get();
  }
}
