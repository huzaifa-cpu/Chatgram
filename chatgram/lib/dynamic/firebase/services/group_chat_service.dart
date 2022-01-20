import 'package:chatgram/static/bottom_tabs/chat_tab/models/group_chat/group_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/models/group_chat/grouplist_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class GroupChatService {
  //INITIALIZATIONS
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  Future<List<GroupListModel>> fetchGroupList() async {
    UserModel currentUser =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();
    List<GroupListModel> groupList = List<GroupListModel>();

    QuerySnapshot querySnapshot = await firestore
        .collection('grouplist')
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
      GroupListModel userFromDB = GroupListModel(
        uid: dataWithOutInitials[i]['uid'],
        groupName: dataWithOutInitials[i]['groupName'],
        message: dataWithOutInitials[i]['message'],
        timestamp: dataWithOutInitials[i]['timestamp'],
        imageUrl: dataWithOutInitials[i]['imageUrl'],
      );
      groupList.add(userFromDB);
    }

    return groupList;
  }

  //Make group
  Future<bool> createGroup(
      List<UserModel> users, String groupName, String imageUrl) async {
    UserModel currentUser =
        await encodeDecodeUserModel.getUserModelFromSharedPreference();
    DocumentSnapshot snapshot = await firestore
        .collection("grouplist")
        .doc(currentUser.uid)
        .collection(currentUser.uid)
        .doc(groupName)
        .get();
    if (!snapshot.exists) {
      for (var i in users) {
        await firestore
            .collection('grouplist')
            .doc(i.uid)
            .collection(i.uid)
            .doc(groupName)
            .set({
          "uid": null,
          "groupName": groupName,
          "message": null,
          "timestamp": null,
          "imageUrl": imageUrl
        });
        await firestore
            .collection('groups')
            .doc(currentUser.uid)
            .collection(groupName)
            .doc(i.uid)
            .set({
          "active": true,
        });
      }
      return true;
    } else {
      return false;
    }
  }

  Future<void> addGroupMessageToDb(GroupModel message, UserModel sender,
      String groupName, List<String> uids) async {
    var map = message.toJson();

    await firestore
        .collection("groupMessages")
        .doc(groupName)
        .collection(groupName)
        .doc()
        .set(map);

    populateGroupChatList(message, sender, groupName, uids);
  }

  Future populateGroupChatList(GroupModel message, UserModel sender,
      String groupName, List<String> uids) async {
    //CHECK SENDER
    DocumentSnapshot snapshotSender = await firestore
        .collection("grouplist")
        .doc(sender.uid)
        .collection(sender.uid)
        .doc(groupName)
        .get();
    for (var i in uids) {
      if (snapshotSender.exists) {
        await firestore
            .collection("grouplist")
            .doc(i)
            .collection(i)
            .doc(groupName)
            .update({
          "uid": i,
          "timestamp": message.timestamp,
          "message": message.message,
          "groupName": groupName,
        });
      } else {
        await firestore
            .collection("grouplist")
            .doc(i)
            .collection(i)
            .doc(groupName)
            .set({
          "uid": i,
          "timestamp": message.timestamp,
          "message": message.message,
          "groupName": groupName,
        });
      }
    }
  }
}
