import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String senderId;
  String receiverId;
  String type;
  String message;
  int timestamp;
  String photoUrl;

  MessageModel(
      {this.senderId,
      this.receiverId,
      this.type,
      this.message,
      this.timestamp});

  //Will be only called when you wish to send an image
  MessageModel.imageMessage(
      {this.senderId,
      this.receiverId,
      this.message,
      this.type,
      this.timestamp,
      this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  MessageModel fromMap(Map<String, dynamic> map) {
    MessageModel _message = MessageModel();
    _message.senderId = map['senderId'];
    _message.receiverId = map['receiverId'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    return _message;
  }
}
