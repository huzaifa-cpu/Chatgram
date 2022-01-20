import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  String text;
  Loader(this.text);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      child: Container(
        color: theme.primaryColorLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SpinKitCircle(
                color: theme.primaryColorDark,
                size: 60,
              ),
            ),
            Text(text,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 14.0,
                )),
          ],
        ),
      ),
    );
  }
}
