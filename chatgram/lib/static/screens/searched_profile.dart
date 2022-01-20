import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/screens/chat_screen_check.dart';
import 'package:chatgram/static/bottom_tabs/post_tab/models/post_model.dart';
import 'package:chatgram/static/utils/utilities.dart';
import 'package:chatgram/static/widgets/buttons/custom_button2.dart';
import 'package:chatgram/static/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/dynamic/firebase/repository.dart';

class SearchedProfile extends StatefulWidget {
  bool friend;
  bool block;
  UserModel searchedUser;
  SearchedProfile({this.searchedUser, this.friend, this.block});
  @override
  _SearchedProfileState createState() => _SearchedProfileState();
}

class _SearchedProfileState extends State<SearchedProfile> {
  Repository _repository = Repository();
  CustomToast customToast = CustomToast();
  UserModel currentUser;
  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((User user) {
      _repository.fetchUser(user).then((UserModel userModel) {
        setState(() {
          currentUser = userModel;
        });
      });
    });
  }

  bool like = false;
  bool call = false;

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var loadingFriend = true;
    var loadingBlock = true;
    var loadingMessage = true;

    //THEMES
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Container(
                height: height * 0.3,
                color: theme.primaryColorLight,
              ),
            ),
            Container(height: height * 0.72, color: theme.primaryColorLight),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: height * 0.09,
            ),
            SizedBox(
              width: width * 0.9,
              height: height * 0.27,
              child: Card(
                elevation: 50.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: theme.primaryColorLight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: widget.searchedUser.profilePhoto ==
                                null
                            ? AssetImage('images/profile_image.jpg')
                            : NetworkImage(widget.searchedUser.profilePhoto),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        widget.searchedUser.name,
                        style: theme.textTheme.bodyText2,
                      ),
                      SizedBox(
                        height: height * 0.0001,
                      ),
                      Text(
                        widget.searchedUser.email,
                        style: theme.textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.01,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomButton2(
                        text: widget.friend ? 'Unfriend' : 'Add friend',
                        onPressed: () async {
                          if (loadingFriend) {
                            loadingFriend = false;
                            await _repository.updateFriendUnfriend(
                                currentUser.uid, widget.searchedUser.uid);

                            setState(() {
                              // widget.loading = !widget.loading;
                              widget.friend = !widget.friend;
                            });

                            widget.friend
                                ? customToast.showToast("Friend Request sent")
                                : customToast
                                    .showToast("The user is now unfriend");
                          }
                        },
                      ),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      CustomButton2(
                        text: widget.block ? 'Unblock' : 'Block',
                        onPressed: () async {
                          if (widget.friend) {
                            if (loadingBlock) {
                              loadingBlock = false;

                              await _repository.updateBlockUnblock(
                                  currentUser.uid, widget.searchedUser.uid);
                              setState(() {
                                widget.block = !widget.block;
                              });
                              widget.block
                                  ? customToast
                                      .showToast("The user is now blocked")
                                  : customToast
                                      .showToast("The user is now unblocked");
                            }
                          } else {
                            customToast.showDangerToast(
                                "The user is not in your friend list");
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomButton2(
                      text: "Message",
                      onPressed: () async {
                        if (loadingMessage) {
                          loadingMessage = false;

                          bool friend = await _repository.friendOrUnfriend(
                            widget.searchedUser.uid,
                            currentUser.uid,
                          );
                          bool block = await _repository.blockOrUnBlock(
                            widget.searchedUser.uid,
                            currentUser.uid,
                          );
                          if (friend &&
                              !block &&
                              widget.friend &&
                              !widget.block) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreenCheck(
                                          receiver: widget.searchedUser,
                                        )));
                          } else {
                            customToast.showDangerToast(
                                "The user is not in your friend list");
                          }
                        }
                      }),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Center(
              child: Text(
                'Posts',
                style: TextStyle(color: theme.primaryColor, fontSize: 25),
              ),
            ),
            FutureBuilder(
                future: _repository.getUserPosts(widget.searchedUser.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Loader("Loading Profile"));
                  } else {
                    List<PostModel> postList = snapshot.data;
                    return postList.length > 0
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: postList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          elevation: 3,
                                          color: theme.primaryColorLight,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          6.0, 2.0, 10.0, 2.0),
                                                      child: Container(
                                                        width: width * 0.10,
                                                        height: height * 0.10,
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image: widget
                                                                              .searchedUser
                                                                              .profilePhoto ==
                                                                          null
                                                                      ? AssetImage(
                                                                          'images/profile_image.jpg')
                                                                      : NetworkImage(widget
                                                                          .searchedUser
                                                                          .profilePhoto),
                                                                )),
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                                postList[index]
                                                                    .userName,
                                                                style: theme
                                                                    .textTheme
                                                                    .bodyText2),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Text(
                                                                Utils.readTimestamp(
                                                                    postList[
                                                                            index]
                                                                        .postTimeStamp),
                                                                style: theme
                                                                    .textTheme
                                                                    .headline5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                postList[index].postImage !=
                                                        'NONE'
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            postList[index]
                                                                .postContent,
                                                            style: theme
                                                                .textTheme
                                                                .headline5,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          GestureDetector(
                                                              onTap: () {},
                                                              child: Image(
                                                                image: postList[index]
                                                                            .postImage ==
                                                                        'NONE'
                                                                    ? AssetImage(
                                                                        'images/profile_image.jpg')
                                                                    : NetworkImage(
                                                                        postList[index]
                                                                            .postImage),
                                                              )),
                                                          Divider(
                                                            height: 2,
                                                            color: theme
                                                                .primaryColorDark,
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              postList[index]
                                                                  .postContent,
                                                              style: theme
                                                                  .textTheme
                                                                  .headline5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ]))));
                                }))
                        : Center(
                            child: Padding(
                            padding: const EdgeInsets.only(top: 100.0),
                            child: Text(
                              'No posts',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ));
                  }
                })
          ],
        ),
      ]),
    );
  }
}
