import 'package:dishio/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishio/services/firebasestorageapi.dart';
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
  final CollectionReference likeCollection =
      FirebaseFirestore.instance.collection('likesTable');
  final CollectionReference dislikeCollection =
      FirebaseFirestore.instance.collection('dislikesTable');
  final CollectionReference reportCollection =
      FirebaseFirestore.instance.collection('reportsTable');

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
      String desp,
      String user_id) async {
    return await recipeCollection.doc(uid).set({
      'category': category,
      'products': products,
      'title': title,
      'time': time,
      'product_desp': product_desp,
      'desp': desp,
      'views': 0,
      'user_id': user_id,
    });
  }

  Future giveLike(String user_id, String uid, String recipe_id) async {
    return await likeCollection
        .doc(uid)
        .set({'user_id': user_id, 'recipe_id': recipe_id});
  }

  Future cancelLike(String user_id, String recipe_id) async {
    var result = await likeCollection
        .where('user_id', isEqualTo: user_id)
        .where('recipe_id', isEqualTo: recipe_id)
        .get();
    await likeCollection.doc(result.docs[0].id).delete();
    return true;
  }

  Future giveDisLike(String user_id, String uid, String recipe_id) async {
    return await dislikeCollection
        .doc(uid)
        .set({'user_id': user_id, 'recipe_id': recipe_id});
  }

  Future cancelDisLike(String user_id, String recipe_id) async {
    var result = await dislikeCollection
        .where('user_id', isEqualTo: user_id)
        .where('recipe_id', isEqualTo: recipe_id)
        .get();
    await dislikeCollection.doc(result.docs[0].id).delete();
    return true;
  }

  Future incrementView(String recipe_id) async {
    var result = await recipeCollection.doc(recipe_id).get();
    String views = result.get("views").toString();
    int newViews = int.parse(views) + 1;
    await recipeCollection.doc(recipe_id).update({'views': newViews});
    return true;
  }

  Future setReportInformation(
      String report_id, String user_id, String recipe_id, String desp) async {
    return await reportCollection
        .doc(report_id)
        .set({'user_id': user_id, 'recipe_id': recipe_id, 'desp': desp});
  }

  Future addCategory(String uid, String text) async {
    return categoryCollection.doc(uid).set({
      'name': text,
    });
  }

  Future deleteCategory(String uid) async {
    var result = await categoryCollection.doc(uid).get();
    String name = result.get("name").toString();
    var recipes =
        await recipeCollection.where("category", isEqualTo: name).get();
    for (var temp in recipes.docs) {
      var res2 =
          await likeCollection.where("recipe_id", isEqualTo: temp.id).get();
      for (var temp2 in res2.docs) {
        await likeCollection.doc(temp2.id).delete();
      }
      res2 =
          await dislikeCollection.where("recipe_id", isEqualTo: temp.id).get();
      for (var temp2 in res2.docs) {
        await dislikeCollection.doc(temp2.id).delete();
      }
      res2 =
          await reportCollection.where("recipe_id", isEqualTo: temp.id).get();
      for (var temp2 in res2.docs) {
        await reportCollection.doc(temp2.id).delete();
      }
      await FirebaseApi.deleteFolder("images/${temp.id}");
      await recipeCollection.doc(temp.id).delete();
    }
    return await categoryCollection.doc(uid).delete();
  }

  Future becomeUser(String uid) async {
    var result = await userCollection.where('userId', isEqualTo: uid).get();

    return await userCollection.doc(uid).update({
      'name': result.docs[0].get('name'),
      'surname': result.docs[0].get('surname'),
      'userId': uid,
      'email': result.docs[0].get('email'),
      'role': 'user',
    });
  }

  Future becomeAdmin(String uid) async {
    var result = await userCollection.where('userId', isEqualTo: uid).get();
    return await userCollection.doc(uid).update({
      'name': result.docs[0].get('name'),
      'surname': result.docs[0].get('surname'),
      'userId': uid,
      'email': result.docs[0].get('email'),
      'role': 'admin',
    });
  }

  Future reportDone(String uid) async {
    return await reportCollection.doc(uid).delete();
  }
}
