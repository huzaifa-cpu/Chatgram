import 'package:chatgram/static/screens/tabbar/sign_in.dart';
import 'package:chatgram/static/screens/tabbar/sign_up.dart';
import 'package:flutter/material.dart';

class TabbarMenu extends StatefulWidget {
  @override
  _TabbarMenuState createState() => _TabbarMenuState();
}

class _TabbarMenuState extends State<TabbarMenu> {
  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: theme.primaryColorLight,
          appBar: AppBar(
            backgroundColor: theme.primaryColorLight,
            bottom: TabBar(indicatorColor: theme.primaryColorDark, tabs: [
              Tab(
                child: Text(
                  "Sign In ",
                  style: theme.textTheme.headline2,
                ),
              ),
              Tab(
                child: Text(
                  "Sign Up ",
                  style: theme.textTheme.headline2,
                ),
              ),
            ]),
          ),
          body: TabBarView(children: [SignIn(), SignUp()]),
        ));
  }
}
