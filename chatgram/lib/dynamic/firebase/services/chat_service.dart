import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/models/individual_chat/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';

class ChatService {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  Future<void> addMessageToDb(
      MessageModel message, UserModel sender, UserModel receiver) async {
    var map = message.toMap();

    await firestore
        .collection("messages")
        .doc(message.senderId)
        .collection(receiver.uid)
        .doc()
        .set(map);

    populateChatList(message, sender, receiver);

    return await firestore
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId)
        .doc()
        .set(map);
  }

  Future populateChatList(
      MessageModel message, UserModel sender, UserModel receiver) async {
    //CHECK SENDER
    DocumentSnapshot snapshotSender = await firestore
        .collection("chatlist")
        .doc(sender.uid)
        .collection(sender.uid)
        .doc(receiver.uid)
        .get();

    if (snapshotSender.exists) {
      await firestore
          .collection("chatlist")
          .doc(sender.uid)
          .collection(sender.uid)
          .doc(receiver.uid)
          .update({
        "uid": receiver.uid,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profilePhoto": receiver.profilePhoto,
        "name": receiver.name,
      });
    } else {
      await firestore
          .collection("chatlist")
          .doc(sender.uid)
          .collection(sender.uid)
          .doc(receiver.uid)
          .set({
        "uid": receiver.uid,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profilePhoto": receiver.profilePhoto,
        "name": receiver.name,
        "self-destruct": false,
      });
    }

    //CHECK RECIEVER
    DocumentSnapshot snapshotReciever = await firestore
        .collection("chatlist")
        .doc(receiver.uid)
        .collection(receiver.uid)
        .doc(sender.uid)
        .get();

    if (snapshotReciever.exists) {
      await firestore
          .collection("chatlist")
          .doc(receiver.uid)
          .collection(receiver.uid)
          .doc(sender.uid)
          .update({
        "uid": sender.uid,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profilePhoto": sender.profilePhoto,
        "name": sender.name,
      });
    } else {
      await firestore
          .collection("chatlist")
          .doc(receiver.uid)
          .collection(receiver.uid)
          .doc(sender.uid)
          .set({
        "uid": sender.uid,
        "timeStamp": message.timestamp,
        "message": message.message,
        "profilePhoto": sender.profilePhoto,
        "name": sender.name,
        "self-destruct": false,
      });
    }
  }

  //SELF DESTRUCT MSGS
  Future updateSelfDestruct(bool value, UserModel reciever) async {
    UserModel currentUser =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();

    if (value) {
      // RECIEVER
      await firestore
          .collection("chatlist")
          .doc(currentUser.uid)
          .collection(currentUser.uid)
          .doc(reciever.uid)
          .update({
        "self-destruct": value,
        "timeStamp": null,
        "message": "",
      });
    } else {
      // RECIEVER
      await firestore
          .collection("chatlist")
          .doc(currentUser.uid)
          .collection(currentUser.uid)
          .doc(reciever.uid)
          .update({
        "self-destruct": value,
      });
    }
  }

  //VANISH MSGS
  Future vanishMessages(UserModel reciever) async {
    UserModel currentUser =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();
    firestore
        .collection("messages")
        .doc(currentUser.uid)
        .collection(reciever.uid)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
