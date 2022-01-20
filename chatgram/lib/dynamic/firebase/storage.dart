import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';

class Storage {
  static Future<String> uploadPostImages(
      {@required String postID, @required File postImageFile}) async {
    try {
      String fileName = 'postImages/$postID/image';
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await reference.putFile(postImageFile);
      String postIageURL = await reference.getDownloadURL();
      return postIageURL;
    } catch (e) {
      return null;
    }
  }

  static Future<String> uploadProfileImage(
      {@required String uid, @required File profileImageFile}) async {
    try {
      String fileName = 'profileImages/$uid/image';
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await reference.putFile(profileImageFile);
      String profileIageURL = await reference.getDownloadURL();
      return profileIageURL;
    } catch (e) {
      return null;
    }
  }

  static Future<String> uploadGroupImage(
      {@required String uid, @required File groupImageFile}) async {
    try {
      String fileName = 'groupImages/$uid/image';
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await reference.putFile(groupImageFile);
      String groupIageURL = await reference.getDownloadURL();
      return groupIageURL;
    } catch (e) {
      return null;
    }
  }
}
