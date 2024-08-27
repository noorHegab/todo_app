import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:todo/models/user_model.dart';

class FireBaseFunctions {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference<UserModel?> userMainFireStore() {
    return firestore.collection("Users").withConverter(
      fromFirestore: (snapshot, options) {
        return UserModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value!.toJson();
      },
    );
  }

  static CollectionReference<TaskModel?> taskSubCollection() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    return userMainFireStore().doc(userId).collection("Tasks").withConverter(
      fromFirestore: (snapshot, options) {
        return TaskModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value!.toJson();
      },
    );
  }

  static Future<void> addTask(TaskModel task) async {
    var ref = taskSubCollection();
    var docRef = ref.doc();
    task.id = docRef.id;
    await docRef.set(task);
  }

  static Stream<QuerySnapshot<TaskModel?>> getTask(int time) {
    var ref = taskSubCollection();
    return ref.where("date", isEqualTo: time).snapshots();
  }

  static Future<void> deleteTask(String id) async {
    var ref = taskSubCollection();
    await ref.doc(id).delete();
  }

  static Future<void> setDone(TaskModel model) async {
    var ref = taskSubCollection();
    model.isDone = !model.isDone;
    await ref.doc(model.id).update(model.toJson());
  }

  static Future<void> updateTask(TaskModel task) async {
    var ref = taskSubCollection();
    await ref.doc(task.id).update(task.toJson());
  }

  static Future<void> addUser(UserModel user) async {
    var ref = userMainFireStore();
    await ref.doc(user.id).set(user);
  }

  static Future<UserModel> getUser() async {
    var ref = userMainFireStore();
    var data =
        await ref.doc(FirebaseAuth.instance.currentUser?.uid ?? "").get();
    UserModel userModel = data.data()!;
    return userModel;
  }

  static Future<UserCredential> createAccount(
      String email, String password, String name, String phone) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user!.sendEmailVerification();
      await addUser(UserModel(
          email: email, name: name, id: credential.user!.uid, phone: phone));
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      throw e.toString();
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  static Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
