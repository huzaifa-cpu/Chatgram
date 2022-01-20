import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class FriendServive {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  Future<List<UserModel>> fetchFriendList() async {
    UserModel currentUser =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();
    List<UserModel> userList = List<UserModel>();
    QuerySnapshot querySnapshot = await firestore
        .collection('friends')
        .doc(currentUser.uid)
        .collection(currentUser.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot;
    });
    List<DocumentSnapshot> data = querySnapshot.docs;
    List<DocumentSnapshot> dataWithOutInitials = List<DocumentSnapshot>();

    for (var i in data) {
      if (i.id != "INITIALS") {
        dataWithOutInitials.add(i);
      }
    }

    for (var i = 0; i < dataWithOutInitials.length; i++) {
      bool friend =
          await friendOrUnfriend(dataWithOutInitials[i].id, currentUser.uid);
      bool block = await blockOrUnBlock(
        currentUser.uid,
        dataWithOutInitials[i].id,
      );
      bool opponetBlock =
          await blockOrUnBlock(dataWithOutInitials[i].id, currentUser.uid);
      if (friend && !block && !opponetBlock) {
        DocumentSnapshot documentSnapshot = await firestore
            .collection('users')
            .doc(dataWithOutInitials[i].id)
            .get();

        UserModel userFromDB = UserModel(
          uid: documentSnapshot['uid'],
          name: documentSnapshot['name'],
          email: documentSnapshot['email'],
          state: false,
          profilePhoto: documentSnapshot['profilePhoto'],
          status: documentSnapshot['status'],
        );
        userList.add(userFromDB);
      }
    }

    String encodedData = EncodeDecodeUserModel.encodeUserModelList(userList);
    await pref.saveWithJson("friendList", encodedData);
    return userList;
  }

  //CHECK FRIEND UNFRIEND
  Future<bool> friendOrUnfriend(String uid, String friendUid) async {
    DocumentSnapshot usersLikeCheckSnapshot = await firestore
        .collection('friends')
        .doc(uid)
        .collection(uid)
        .doc(friendUid)
        .get();
    if (usersLikeCheckSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  //CHECK BLOCK UNBLOCK
  Future<bool> blockOrUnBlock(String uid, String friendUid) async {
    DocumentSnapshot usersLikeCheckSnapshot = await firestore
        .collection('friends')
        .doc(uid)
        .collection(uid)
        .doc(friendUid)
        .get();
    if (usersLikeCheckSnapshot.exists) {
      if (usersLikeCheckSnapshot['block'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //UPDATE FRIEND UNFRIEND
  Future<void> updateFriendUnfriend(String uid, String friendUid) async {
    bool friend = await friendOrUnfriend(uid, friendUid);
    bool oponnent = await friendOrUnfriend(friendUid, uid);
    if (oponnent) {
      if (friend) {
        await firestore
            .collection('friends')
            .doc(uid)
            .collection(uid)
            .doc(friendUid)
            .delete();
        await firestore
            .collection('friends')
            .doc(friendUid)
            .collection(friendUid)
            .doc(uid)
            .delete();
      } else {
        await firestore
            .collection('friends')
            .doc(uid)
            .collection(uid)
            .doc(friendUid)
            .set({"block": false});
      }
    } else {
      if (friend) {
        await firestore
            .collection('friends')
            .doc(uid)
            .collection(uid)
            .doc(friendUid)
            .delete();
        await firestore
            .collection('requests')
            .doc(friendUid)
            .collection(friendUid)
            .doc(uid)
            .delete();
      } else {
        await firestore
            .collection('friends')
            .doc(uid)
            .collection(uid)
            .doc(friendUid)
            .set({"block": false});
        await firestore
            .collection('requests')
            .doc(friendUid)
            .collection(friendUid)
            .doc(uid)
            .set({
          "uid": uid,
        });
      }
    }
  }

  //UPDATE Block UNBLOCK
  Future<void> updateBlockUnblock(String uid, String friendUid) async {
    bool friend = await friendOrUnfriend(uid, friendUid);

    bool block = await blockOrUnBlock(uid, friendUid);
    if (friend) {
      if (block) {
        await firestore
            .collection('friends')
            .doc(uid)
            .collection(uid)
            .doc(friendUid)
            .update({"block": false});
      } else {
        await firestore
            .collection('friends')
            .doc(uid)
            .collection(uid)
            .doc(friendUid)
            .set({"block": true});
      }
    }
  }
}
