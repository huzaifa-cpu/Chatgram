import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';

class LikeServive {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  //UPDATE LIKE COUNT
  Future<void> updateLikeCount(String postId, String uid) async {
    //CHECK USER'S LIKE or DISLIKE
    DocumentSnapshot usersLikeCheckSnapshot = await firestore
        .collection('likes')
        .doc(postId)
        .collection(postId)
        .doc(uid)
        .get();
    if (usersLikeCheckSnapshot.exists) {
      await firestore
          .collection('likes')
          .doc(postId)
          .collection(postId)
          .doc(uid)
          .delete();
    } else if (!usersLikeCheckSnapshot.exists) {
      await firestore
          .collection('likes')
          .doc(postId)
          .collection(postId)
          .doc(uid)
          .set({"INITIALS": "INITIALS"});
    }
    //UPDATE COUNTS
    QuerySnapshot snap = await firestore
        .collection('likes')
        .doc(postId)
        .collection(postId)
        .get();

    int count = snap.docs.length - 1;
    await firestore
        .collection('posts')
        .doc(postId)
        .update({"postLikeCount": count});
  }
}
