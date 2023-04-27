import 'package:dishio/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('usersTable');
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categoriesTable');
  final CollectionReference ingredientCollection =
      FirebaseFirestore.instance.collection('ingredientsTable');
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipesTable');

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

//#5
  Future getAllIngredients() async {
    return await ingredientCollection.get();
  }

//#6
  Future setRecipeInformation(
      String uid,
      String category,
      List<String> products,
      String title,
      String time,
      String product_desp,
      String desp) async {
    return await recipeCollection.doc(uid).set({
      'category': category,
      'products': products,
      'title': title,
      'time': time,
      'product_desp': product_desp,
      'desp': desp,
    });
  }
}
