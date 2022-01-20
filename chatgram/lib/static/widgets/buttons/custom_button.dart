import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function onPressed;
  String text;
  CustomButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Center(
        child: Container(
          width: width * 0.5,
          child: TextButton(
            onPressed: onPressed,
            child: Text(text,
                style: TextStyle(fontSize: 14, color: theme.primaryColorDark)),
            style: ElevatedButton.styleFrom(
              side: BorderSide(width: 2.0, color: theme.primaryColorDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
