import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/screens/chat_screen_check.dart';
import 'package:flutter/material.dart';

class FriendSearch extends StatefulWidget {
  List<UserModel> userList;
  FriendSearch({this.userList});
  @override
  _FriendSearchState createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearch> {
  Repository _repository = Repository();

  String query = "";
  TextEditingController searchController = TextEditingController();

  searchAppBar(BuildContext context) {
    //THEMES
    var theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.primaryColorLight,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: theme.primaryColorDark,
            autofocus: true,
            style: theme.textTheme.headline2,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: theme.primaryColor),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    var theme = Theme.of(context);
    final List<UserModel> suggestionList = query.isEmpty
        ? widget.userList
        : widget.userList.where((UserModel user) {
            return (user.email.toLowerCase().contains(query.toLowerCase())) ||
                (user.name.toLowerCase().contains(query.toLowerCase()));
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserModel searchedUser = UserModel(
          uid: suggestionList[index].uid,
          email: suggestionList[index].email,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
        );

        return ListTile(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreenCheck(
                          receiver: searchedUser,
                        )));
          },
          title: Text(searchedUser.name, style: theme.textTheme.headline2),
          subtitle: Text(
            searchedUser.email,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //THEMES
    var theme = Theme.of(context);
    return Scaffold(
      appBar: searchAppBar(context),
      backgroundColor: theme.primaryColorLight,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: buildSuggestions(query),
      ),
    );
  }
}
