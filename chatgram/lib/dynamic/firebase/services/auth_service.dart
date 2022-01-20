import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  // METHODS
  Future<User> getCurrentFirebaseUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  // CHECK IF USER IS PRESENT OR NOT
  UserModel _userFromFirebaseUser(User user) {
    if (user != null) {
      return UserModel(uid: user.uid, email: user.email);
    } else {
      return null;
    }
  }

  // STATE MANAGEMENT THROUGH STREAM-PROVIDER
  Stream<UserModel> get getUserForState {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //CHECK USER IN DB
  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot;
    });

    List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  // sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future<User> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //SIGN IN WITH GOOGLE
  Future<User> signInWithGoogle() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken);

    User user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }
}
