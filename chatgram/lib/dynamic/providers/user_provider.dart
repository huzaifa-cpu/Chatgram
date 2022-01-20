import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _user = List<UserModel>();

  set(List<UserModel> value) {
    _user = value;
    notifyListeners();
  }

  get user => _user;

  void changeState(UserModel user, bool state) {
    for (var i in _user) {
      if (i.name == user.name && i.email == user.email && i.uid == user.uid) {
        i.state = state;
      }
    }
    notifyListeners();
  }

  List<UserModel> checkUsersList(UserModel user) {
    List<UserModel> userList = List<UserModel>();
    for (var i in _user) {
      if (i.state == true) {
        userList.add(i);
      }
    }
    userList.add(user);
    notifyListeners();
    return userList;
  }
}
