import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/providers/user_provider.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/models/group_chat/grouplist_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/screens/create_group_chat.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/screens/group_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/utils/utilities.dart';

class GroupTab extends StatelessWidget {
  SharedPref pref = SharedPref();
  Repository _repository = Repository();

  var loading = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget buildNavigationButton() =>
        Consumer<UserProvider>(builder: (context, userProvider, child) {
          return FloatingActionButton(
            backgroundColor: theme.primaryColorDark,
            child: Icon(Icons.add, color: theme.primaryColorLight),
            onPressed: () async {
              if (loading) {
                loading = false;
                List<UserModel> userList = await _repository.fetchFriendList();
                userProvider.set(userList);
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateGroupChat(),
                ),
              );
            },
          );
        });
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //THEMES
    return Scaffold(
      floatingActionButton: buildNavigationButton(),
      backgroundColor: theme.primaryColorLight,
      body: FutureBuilder(
          future: _repository.fetchGroupList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Loader('Loading Groups'));
            } else {
              List<GroupListModel> groupList = snapshot.data;
              return groupList.length > 0
                  ? ListView.builder(
                      itemCount: groupList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            String currentUserJson =
                                await pref.read("currentUser");
                            UserModel currentUser =
                                EncodeDecodeUserModel.decodeUserModel(
                                    currentUserJson);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupChatScreen(
                                    groupName: groupList[index].groupName,
                                    currentUser: currentUser),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: theme.primaryColorLight,
                              elevation: 3,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            groupList[index].imageUrl == 'NONE'
                                                ? AssetImage(
                                                    'images/profile_image.jpg')
                                                : NetworkImage(
                                                    groupList[index].imageUrl),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      padding: EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    groupList[index].groupName,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  groupList[index].timestamp ==
                                                          null
                                                      ? ''
                                                      : Utils.readTimestamp(
                                                          groupList[index]
                                                              .timestamp),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: theme
                                                          .primaryColorDark),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              groupList[index].message == null
                                                  ? "No texts"
                                                  : groupList[index].message,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontStyle:
                                                    groupList[index].message ==
                                                            null
                                                        ? FontStyle.italic
                                                        : FontStyle.normal,
                                                color:
                                                    groupList[index].message ==
                                                            null
                                                        ? Colors.grey
                                                        : theme.primaryColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        'Start group chating with your friends',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ));
            }
          }),
    );
  }
}
