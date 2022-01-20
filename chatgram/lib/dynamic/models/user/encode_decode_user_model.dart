import 'dart:convert';

import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class EncodeDecodeUserModel {
  SharedPref pref = SharedPref();

  // OBJECT
  static Map encodeUserModel(UserModel user) {
    return user.toJson();
  }

  static UserModel decodeUserModel(String map) {
    Map data = jsonDecode(map);
    return UserModel.fromJson(data);
  }

  // LIST
  static String encodeUserModelList(List<UserModel> users) {
    return json.encode(
      users.map<Map<String, dynamic>>((user) => user.toJson()).toList(),
    );
  }

  static List<UserModel> decodeUserModelList(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserModel>((item) => UserModel.fromJson(item))
          .toList();

  //SHARED PREFERENCE

  // OBJECT
  Future<UserModel> getUserModelFromSharedPreference() async {
    String data = await pref.read("currentUser");
    UserModel user = decodeUserModel(data);
    return user;
  }
}
