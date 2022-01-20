import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/tabbar/chat_tabbar_menu.dart';
import 'package:chatgram/static/bottom_tabs/post_tab/screens/post_tab.dart';
import 'package:chatgram/static/screens/add_friend_search.dart';
import 'package:chatgram/static/screens/friend_search.dart';
import 'package:chatgram/static/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class BottomNavBar extends StatefulWidget {
  UserModel currentUser;
  BottomNavBar({this.currentUser});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Repository _repository = Repository();

  SharedPref pref = SharedPref();
  EncodeDecodeUserModel encodeDecodeUserModel = EncodeDecodeUserModel();

  int _page = 0;

  final screen = [ChatTabBarMenu(), PostTab()];

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var loading = true;

    //THEMES
    var theme = Theme.of(context);
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(
              Icons.chat_outlined,
              size: 25,
              color: theme.primaryColorLight,
            ),
            Icon(
              Icons.list_rounded,
              size: 30,
              color: theme.primaryColorLight,
            ),
          ],
          color: theme.primaryColor,
          buttonBackgroundColor: theme.primaryColorDark,
          backgroundColor: theme.primaryColorLight,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 800),
          onTap: (index) {
            setState(() {
              _page = index;
              // loading = true;
            });
          },
          letIndexChange: (index) => true,
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.primaryColorLight,
          title: Text(
            "Chatgram",
            style: theme.textTheme.headline1,
          ),
          actions: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: theme.primaryColorDark,
                  ),
                  onPressed: () async {
                    if (loading) {
                      loading = false;
                      List<UserModel> userList =
                          await _repository.fetchFriendList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendSearch(
                                    userList: userList,
                                  )));
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: theme.primaryColorDark,
                  ),
                  onPressed: () {
                    //SEARCH PEOPLE
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddFriendSearch()));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: theme.primaryColorDark,
                  ),
                  onPressed: () async {
                    UserModel user = await encodeDecodeUserModel
                        .getUserModelFromSharedPreference();
                    //PROFILE
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  user: user,
                                )));
                  },
                ),
              ],
            )
          ],
        ),
        body: screen[_page]);
  }
}
