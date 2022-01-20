import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel {
  String uid;
  String name;
  String message;
  int timestamp;
  String profilePhoto;

  ChatListModel(
      {this.uid, this.name, this.message, this.timestamp, this.profilePhoto});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['uid'] = this.uid;
    map['name'] = this.name;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['profilePhoto'] = this.profilePhoto;
    return map;
  }

  ChatListModel fromMap(Map<String, dynamic> map) {
    ChatListModel _message = ChatListModel();
    _message.uid = map['uid'];
    _message.name = map['name'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    _message.profilePhoto = map['profilePhoto'];
    return _message;
  }
}
