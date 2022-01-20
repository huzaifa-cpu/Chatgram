import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class RequestService {
//INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  Future<List<UserModel>> fetchRequests() async {
    UserModel currentUser =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();
    List<UserModel> userList = List<UserModel>();
    QuerySnapshot querySnapshot = await firestore
        .collection('requests')
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

    print(dataWithOutInitials);

    for (var i = 0; i < dataWithOutInitials.length; i++) {
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
    return userList;
  }

  Future acceptRequest(String uid, String friendUid) async {
    await firestore
        .collection('friends')
        .doc(uid)
        .collection(uid)
        .doc(friendUid)
        .set({"block": false});
    await firestore
        .collection('requests')
        .doc(uid)
        .collection(uid)
        .doc(friendUid)
        .delete();
  }

  Future rejectRequest(String uid, String friendUid) async {
    await firestore
        .collection('friends')
        .doc(friendUid)
        .collection(friendUid)
        .doc(uid)
        .delete();
    await firestore
        .collection('requests')
        .doc(uid)
        .collection(uid)
        .doc(friendUid)
        .delete();
  }
}
