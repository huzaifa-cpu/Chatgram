import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';

class CommentServive {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  //COMMENT
  Future<void> insertComment(
      String postId, UserModel user, String comment) async {
    await firestore
        .collection('comments')
        .doc(postId)
        .collection(postId)
        .doc(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'postID': postId,
      'userName': user.name,
      'userEmail': user.email,
      'userUID': user.uid,
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'comment': comment
    });
  }
}
