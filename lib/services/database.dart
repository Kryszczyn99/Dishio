import 'dart:math';

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
  final CollectionReference statsCollection =
      FirebaseFirestore.instance.collection('statsTable');
//#1
  Future setUserInformation(String uid, String email) async {
    await userCollection.doc(uid).set({
      'name': "",
      'surname': "",
      'userId': uid,
      'email': email,
      'role': 'user',
      'credibility': 0
    });
    await updateCredibility(uid);
    return true;
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
    await likeCollection
        .doc(uid)
        .set({'user_id': user_id, 'recipe_id': recipe_id});
    await updateCredibility(user_id);
    return true;
  }

  Future cancelLike(String user_id, String recipe_id) async {
    var result = await likeCollection
        .where('user_id', isEqualTo: user_id)
        .where('recipe_id', isEqualTo: recipe_id)
        .get();
    await likeCollection.doc(result.docs[0].id).delete();
    await updateCredibility(user_id);
    return true;
  }

  Future giveDisLike(String user_id, String uid, String recipe_id) async {
    await dislikeCollection
        .doc(uid)
        .set({'user_id': user_id, 'recipe_id': recipe_id});
    await updateCredibility(user_id);
    return true;
  }

  Future cancelDisLike(String user_id, String recipe_id) async {
    var result = await dislikeCollection
        .where('user_id', isEqualTo: user_id)
        .where('recipe_id', isEqualTo: recipe_id)
        .get();
    await dislikeCollection.doc(result.docs[0].id).delete();
    await updateCredibility(user_id);
    return true;
  }

  Future incrementView(String recipe_id) async {
    var result = await recipeCollection.doc(recipe_id).get();
    String views = result.get("views").toString();
    String user_id = result.get("user_id").toString();
    int newViews = int.parse(views) + 1;
    await recipeCollection.doc(recipe_id).update({'views': newViews});
    await updateCredibility(user_id);
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

  Future checkIfAdmin(String user_id) async {
    var result = await userCollection.where('userId', isEqualTo: user_id).get();
    String role = result.docs[0].get('role').toString();
    if (role == "admin") return true;
    return false;
  }

  Future deleteRecipe(String uid) async {
    var res2 = await likeCollection.where("recipe_id", isEqualTo: uid).get();
    for (var temp2 in res2.docs) {
      await likeCollection.doc(temp2.id).delete();
    }
    res2 = await dislikeCollection.where("recipe_id", isEqualTo: uid).get();
    for (var temp2 in res2.docs) {
      await dislikeCollection.doc(temp2.id).delete();
    }
    res2 = await reportCollection.where("recipe_id", isEqualTo: uid).get();
    for (var temp2 in res2.docs) {
      await reportCollection.doc(temp2.id).delete();
    }
    await FirebaseApi.deleteFolder("images/${uid}");
    var res = await recipeCollection.doc(uid).get();
    String user_id = res.get("user_id");
    await recipeCollection.doc(uid).delete();
    await updateCredibility(user_id);
    return true;
  }

  Future<int> countLikes(String uid) async {
    var res = await likeCollection.where("recipe_id", isEqualTo: uid).get();
    return res.size;
  }

  Future<int> countDisLikes(String uid) async {
    var res = await dislikeCollection.where("recipe_id", isEqualTo: uid).get();
    return res.size;
  }

  Future updateCredibility(String user_id) async {
    int views = 0;
    int likes = 0;
    int dislikes = 0;
    var recipes =
        await recipeCollection.where('user_id', isEqualTo: user_id).get();
    for (var temp in recipes.docs) {
      int current_v = temp.get("views");
      views = views + current_v;
      var current_likes = await countLikes(temp.id);
      var current_dislikes = await countDisLikes(temp.id);
      likes = likes + current_likes;
      dislikes = dislikes + current_dislikes;
    }
    double w = (log(views + 1) / ln10) + sqrt(likes + 1) - sqrt(dislikes + 1);
    await userCollection.doc(user_id).update({'credibility': w});
    return true;
  }

  Future createStatsForUser(String user_id, String stat_id) async {
    var res = await categoryCollection.get();
    var lista = [];
    for (var temp in res.docs) {
      var nazwa = temp.get("name").toString();
      if (nazwa != "Wszystkie") {
        lista.add(nazwa);
      }
    }
    var data = <String, int>{};
    for (var element in lista) {
      data[element] = 0;
    }
    await statsCollection.doc(stat_id).set({'user_id': user_id, 'stats': data});
  }

  Future incrementStatsForCategory(String user_id, String category) async {
    var res = await statsCollection.where("user_id", isEqualTo: user_id).get();
    print(res);
    for (var temp in res.docs) {
      Map<String, dynamic> data = temp.get("stats");
      var value = data[category];
      data[category] = value + 1;
      await statsCollection.doc(temp.id).update({'stats': data});
    }
  }
}
