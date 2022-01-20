import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/screens/chat_screen_check.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/tabbar/friend_requests.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  Repository _repository = Repository();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //THEMES
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: FloatingActionButton.extended(
          label: const Icon(Icons.person_add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RequestsTab()));
          },
          backgroundColor: Colors.green,
        ),
      ),
      backgroundColor: theme.primaryColorLight,
      body: FutureBuilder<UserModel>(
        future: EncodeDecodeUserModel().getUserModelFromSharedPreference(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                'Start chating with your friends',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ));
          } else {
            UserModel user = snapshot.data;
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatlist")
                    .doc(user.uid)
                    .collection(user.uid)
                    .orderBy("timeStamp", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Loader("Loading Chats"));
                  } else {
                    dynamic data = snapshot.data.docs;
                    List<dynamic> chatlist = [];
                    for (var i in data) {
                      if (i != "INITIALS") {
                        chatlist.add(i);
                      }
                    }
                    return chatlist.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(top: 60.0),
                            child: ListView.builder(
                              itemCount: chatlist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () async {
                                    UserModel reciever = UserModel(
                                      uid: chatlist[index]["uid"],
                                      name: chatlist[index]["name"],
                                      profilePhoto: chatlist[index]
                                          ["profilePhoto"],
                                    );
                                    bool selfDestructVlaue =
                                        chatlist[index]['self-destruct'];
                                    print(selfDestructVlaue);
                                    if (selfDestructVlaue) {
                                      await _repository
                                          .vanishMessages(reciever);
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreenCheck(
                                            receiver: reciever,
                                            selfDestruct: selfDestructVlaue),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
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
                                                    backgroundImage: chatlist[
                                                                    index][
                                                                "profilePhoto"] ==
                                                            null
                                                        ? AssetImage(
                                                            'images/profile_image.jpg')
                                                        : NetworkImage(
                                                            chatlist[index][
                                                                "profilePhoto"],
                                                          ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  padding: EdgeInsets.only(
                                                    left: 13,
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Text(
                                                                chatlist[index]
                                                                    ["name"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Text(
                                                              chatlist[index][
                                                                          "timeStamp"] ==
                                                                      null
                                                                  ? ""
                                                                  : Utils
                                                                      .readTimestamp(
                                                                      chatlist[
                                                                              index]
                                                                          [
                                                                          "timeStamp"],
                                                                    ),
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
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
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          chatlist[index]
                                                              ["message"],
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: theme
                                                                .primaryColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'Start chating with your friends',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ));
                  }
                });
          }
        },
      ),
    );
  }
}
