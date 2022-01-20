import 'package:chatgram/dynamic/firebase/services/auth_service.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/dynamic/state_management/decider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Collector extends StatefulWidget {
  @override
  _CollectorState createState() => _CollectorState();
}

class _CollectorState extends State<Collector> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
        initialData: null,
        value: AuthService().getUserForState,
        child: Decider());
  }
}
