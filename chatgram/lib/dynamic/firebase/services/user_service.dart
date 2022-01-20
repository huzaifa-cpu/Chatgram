import 'package:chatgram/static/bottom_tabs/post_tab/models/post_model.dart';
import 'package:chatgram/static/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class UserService {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  // FETCH USER
  Future<UserModel> getUserModelFromFirebaseUser() async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(_auth.currentUser.uid).get();

    if (documentSnapshot.exists) {
      UserModel userFromDB = UserModel(
          uid: documentSnapshot['uid'],
          name: documentSnapshot['name'],
          email: documentSnapshot['email'],
          status: documentSnapshot['status'],
          state: documentSnapshot['state'],
          profilePhoto: documentSnapshot['profilePhoto']);

      await pref.saveWithJson(
          "currentUser", EncodeDecodeUserModel.encodeUserModel(userFromDB));
      return userFromDB;
    }
  }

  //INSERT USER DATA
  Future<void> insertUser(User currentUser) async {
    UserModel user = UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        name: Utils.getNameFromEmail(currentUser.email),
        profilePhoto: null,
        status: null,
        state: false);

    firestore.collection("users").doc(currentUser.uid).set(user.toJson());

    //TO CHECK FRIEND - UNFRIEND
    firestore
        .collection("friends")
        .doc(currentUser.uid)
        .collection(currentUser.uid)
        .doc("INITIALS")
        .set({"block": false});
  }

  // FETCH USER
  Future<UserModel> fetchUser(User currentUser) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();

    if (documentSnapshot.exists) {
      UserModel userFromDB = UserModel(
          uid: documentSnapshot['uid'],
          name: documentSnapshot['name'],
          email: documentSnapshot['email'],
          status: documentSnapshot['status'],
          state: documentSnapshot['state'],
          profilePhoto: documentSnapshot['profilePhoto']);

      await pref.saveWithJson(
          "currentUser", EncodeDecodeUserModel.encodeUserModel(userFromDB));
      return userFromDB;
    }
  }

  //SIGN OUT
  Future<void> signOut() async {
    // await _googleSignIn.disconnect();
    // await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  // FETCH ALL USERS
  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = List<UserModel>();

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot;
    });
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(UserModel.fromJson(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  // UPDATE USER NAME
  Future updateUserName(String uid, String name) async {
    // /IN SHARED PREF
    UserModel user =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();
    UserModel changedUser = UserModel(
        uid: user.uid,
        name: name,
        email: user.email,
        status: user.status,
        state: user.state,
        profilePhoto: user.profilePhoto);

    await pref.saveWithJson(
        "currentUser", EncodeDecodeUserModel.encodeUserModel(changedUser));

    //IN POST
    List<PostModel> postList = List<PostModel>();

    QuerySnapshot querySnapshot = await firestore
        .collection('posts')
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot;
    });

    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i]["userUID"] == uid) {
        postList.add(PostModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    for (PostModel post in postList) {
      await firestore
          .collection('posts')
          .doc(post.postId)
          .update({"userName": name});
    }
    //IN USER
    await firestore.collection('users').doc(uid).update({"name": name});

    //IN CHATLIST
    QuerySnapshot qs = await firestore
        .collection('users')
        .get()
        .then((QuerySnapshot querySnap) {
      return querySnap;
    });
    for (var i = 0; i < qs.docs.length; i++) {
      await firestore
          .collection("chatlist")
          .doc(qs.docs[i].id)
          .collection(qs.docs[i].id)
          .doc(uid)
          .update({
        "name": name,
      });
    }
  }

  // UPDATE USER IMAGE
  Future updateUserProfileImage(String uid, String postImageURL) async {
    //IN SHARED PREF
    UserModel user =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();

    UserModel changedUser = UserModel(
        uid: user.uid,
        name: user.name,
        email: user.email,
        status: user.status,
        state: user.state,
        profilePhoto: postImageURL);

    await pref.saveWithJson(
        "currentUser", EncodeDecodeUserModel.encodeUserModel(changedUser));
    await firestore
        .collection('users')
        .doc(uid)
        .update({"profilePhoto": postImageURL});

    //IN CHATLIST
    QuerySnapshot qs = await firestore
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot;
    });
    for (var i = 0; i < qs.docs.length; i++) {
      await firestore
          .collection("chatlist")
          .doc(qs.docs[i].id)
          .collection(qs.docs[i].id)
          .doc(uid)
          .update({
        "profilePhoto": postImageURL,
      });
    }
  }
}
