import 'dart:convert';

import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/utils/utilities.dart';
import 'package:chatgram/static/bottom_tabs/post_tab/screens/comment.dart';
import 'package:chatgram/static/bottom_tabs/post_tab/screens/write_post.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../widgets/textfields/custom_textfield.dart';

class PostTab extends StatefulWidget {
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  SharedPref pref = SharedPref();
  String url;
  Repository _repository = Repository();

  UserModel currentUser;
  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((User user) {
      _repository.fetchUser(user).then((UserModel userModel) {
        setState(() {
          currentUser = userModel;
          if (currentUser.profilePhoto != null) {
            url = currentUser.profilePhoto;
          }
        });
      });
    });

    // Future<UserModel> current(User currentUser) async {
    //   UserModel userList = UserModel();

    //   DocumentSnapshot querySnapshot = await firestore
    //       .collection('users')
    //       .doc(currentUser.uid)
    //       .get()
    //       .then((DocumentSnapshot querySnapshot) {
    //     return querySnapshot;
    //   });
    //   for (var i = 0; i < querySnapshot.toString().length; i++) {
    //     userList = UserModel.fromJson(querySnapshot.data());
    //   }
    //   return userList;
    // }
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //THEMES
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: width * 0.12,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: url != null
                              ? NetworkImage(url)
                              : AssetImage('images/profile_image.jpg'))),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    readOnly: true,
                    onTap: () async {
                      String data = await pref.read("currentUser");
                      dynamic data2 = jsonDecode(data);
                      UserModel user = UserModel.fromJson(data2);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WritePost(user: user, url: url)));
                    },
                    hintStyle: theme.textTheme.headline5,
                    obscureText: false,
                    hint: "What's on your mind?",
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('postTimeStamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Loader("LoadingPosts"));
                    } else {
                      return snapshot.data.docs.length > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          dynamic data = snapshot.data.docs;
                                          print(url);

                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  elevation: 3,
                                                  color:
                                                      theme.primaryColorLight,
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          6.0,
                                                                          2.0,
                                                                          10.0,
                                                                          2.0),
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        width *
                                                                            0.10,
                                                                    height:
                                                                        height *
                                                                            0.10,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: DecorationImage(
                                                                            image: url != null
                                                                                ? NetworkImage(url)
                                                                                : AssetImage('images/profile_image.jpg'))),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            data[index][
                                                                                "userName"],
                                                                            style:
                                                                                theme.textTheme.bodyText2),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(2.0),
                                                                          child:
                                                                              Text(
                                                                            Utils.readTimestamp(data[index]["postTimeStamp"]),
                                                                            style:
                                                                                theme.textTheme.headline5,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            data[index]["postImage"] !=
                                                                    "NONE"
                                                                ? Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        data[index]
                                                                            [
                                                                            "postContent"],
                                                                        style: theme
                                                                            .textTheme
                                                                            .headline2,
                                                                      ),
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.01,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {},
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              width * 0.99,
                                                                          height:
                                                                              height * 0.3,
                                                                          decoration:
                                                                              BoxDecoration(image: DecorationImage(image: NetworkImage(data[index]["postImage"]), fit: BoxFit.fill)),
                                                                        ),
                                                                      ),
                                                                      Divider(
                                                                        height:
                                                                            2,
                                                                        color: theme
                                                                            .primaryColorDark,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        data[index]
                                                                            [
                                                                            "postContent"],
                                                                        style: theme
                                                                            .textTheme
                                                                            .headline2,
                                                                      ),
                                                                    ],
                                                                  ),
                                                            Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        10),
                                                                child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            await _repository.updateLikeCount(data[index]['postID'],
                                                                                currentUser.uid);
                                                                          },
                                                                          child:
                                                                              Row(children: <Widget>[
                                                                            Icon(
                                                                              Icons.thumb_up,
                                                                              size: 18,
                                                                              color: theme.primaryColorDark,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0),
                                                                              child: Text('Like ( ${snapshot.data.docs[index]['postLikeCount']} )', style: theme.textTheme.headline5),
                                                                            ),
                                                                          ])),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => Comment(
                                                                                        postId: data[index]['postID'],
                                                                                      )));
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Icon(Icons.mode_comment,
                                                                                color: theme.primaryColorDark,
                                                                                size: 18),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0),
                                                                              child: Text('Comment', style: theme.textTheme.headline5),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ]))
                                                          ]))));
                                        }),
                                  )
                                ])
                          : Center(
                              child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'Write your first post',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                            ));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
