import 'package:chatgram/static/bottom_tabs/post_tab/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class PostService {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  // INSERT POSTS
  Future<void> sendPostInFirebase(String postID, String postContent,
      UserModel userProfile, String postImageURL) async {
    FirebaseFirestore.instance.collection('posts').doc(postID).set({
      'postID': postID,
      'userName': userProfile.name,
      'userEmail': userProfile.email,
      'userUID': userProfile.uid,
      'postTimeStamp': DateTime.now().millisecondsSinceEpoch,
      'postContent': postContent,
      'postImage': postImageURL,
      'postLikeCount': 0,
      'postCommentCount': 0,
    });
    FirebaseFirestore.instance
        .collection('likes')
        .doc(postID)
        .collection(postID)
        .doc("Initials")
        .set({});
    FirebaseFirestore.instance
        .collection('comments')
        .doc(postID)
        .collection(postID)
        .doc("Initials")
        .set({});
  }

//GET USER ALL POSTS
  Future<List<PostModel>> getUserPosts(String uid) async {
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
    return postList;
  }
}
