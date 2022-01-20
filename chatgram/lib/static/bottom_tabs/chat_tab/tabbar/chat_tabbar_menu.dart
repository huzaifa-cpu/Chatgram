import 'package:chatgram/static/bottom_tabs/chat_tab/tabbar/chat_tab.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/tabbar/group_tab.dart';
import 'package:flutter/material.dart';

class ChatTabBarMenu extends StatefulWidget {
  ChatTabBarMenu({this.groupChat});
  bool groupChat;
  @override
  _ChatTabBarMenuState createState() => _ChatTabBarMenuState();
}

class _ChatTabBarMenuState extends State<ChatTabBarMenu> {
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
            toolbarHeight: kMinInteractiveDimension,
            backgroundColor: theme.primaryColorLight,
            bottom: TabBar(indicatorColor: theme.primaryColorDark, tabs: [
              Tab(
                child: Text(
                  "Chats",
                  style: theme.textTheme.headline2,
                ),
              ),
              Tab(
                child: Text(
                  "Groups",
                  style: theme.textTheme.headline2,
                ),
              ),
            ]),
          ),
          body: TabBarView(children: [ChatTab(), GroupTab()]),
        ));
  }
}
