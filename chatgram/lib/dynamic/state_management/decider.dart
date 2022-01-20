import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/bottom_tabs/bottom_navbar.dart';
import 'package:chatgram/static/screens/tabbar/tabbar_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Decider extends StatefulWidget {
  @override
  _DeciderState createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {
  Repository _repository = Repository();
  SharedPref pref = SharedPref();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if (user == null) {
      return TabbarMenu();
    } else {
      return BottomNavBar();
    }
  }
}
