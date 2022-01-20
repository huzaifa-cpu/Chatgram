import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  String title;
  Function onOkPressed;
  String btn1Text;
  String btn2Text;
  CustomDialog({this.title, this.onOkPressed, this.btn1Text, this.btn2Text});
  @override
  Widget build(BuildContext context) {
    //THEMES
    var theme = Theme.of(context);
    //height - width
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text(
        title,
        style: theme.textTheme.headline2,
      ),
      backgroundColor: theme.primaryColorLight,
      actions: [
        RaisedButton(
            elevation: 0.0,
            child: Text(btn1Text),
            color: theme.primaryColorLight,
            onPressed: onOkPressed),
        RaisedButton(
            elevation: 0.0,
            color: theme.primaryColorLight,
            child: Text(
              btn2Text,
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
