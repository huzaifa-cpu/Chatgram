import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/static/screens/searched_profile.dart';
import 'package:chatgram/static/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/utils/utilities.dart';

class RequestsTab extends StatefulWidget {
  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  Repository _repository = Repository();

  SharedPref pref = SharedPref();
  CustomToast customToast = CustomToast();

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    //THEMES
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Requests',
          style: TextStyle(color: theme.primaryColor),
        ),
        backgroundColor: theme.primaryColorLight,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: theme.primaryColor,
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: theme.primaryColorLight,
      body: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          children: [
            FutureBuilder(
                future: _repository.fetchRequests(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List<UserModel> userList = snapshot.data;
                    return userList.length > 0
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: userList.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return GestureDetector(
                                    onTap: () async {
                                      String currentUserJson =
                                          await pref.read("currentUser");
                                      UserModel currentUser =
                                          EncodeDecodeUserModel.decodeUserModel(
                                              currentUserJson);
                                      bool friend =
                                          await _repository.friendOrUnfriend(
                                              currentUser.uid, userList[i].uid);
                                      bool block =
                                          await _repository.blockOrUnBlock(
                                              currentUser.uid, userList[i].uid);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchedProfile(
                                                    searchedUser: userList[i],
                                                    friend: friend,
                                                    block: block,
                                                  )));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        width: width,
                                        height: height * 0.12,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          color: theme.primaryColorLight,
                                          elevation: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 13),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.04,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      userList[i].name,
                                                      style: theme
                                                          .textTheme.bodyText1,
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.005,
                                                    ),
                                                    Text(
                                                      userList[i].email,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () async {
                                                    String data = await pref
                                                        .read("currentUser");
                                                    UserModel user =
                                                        EncodeDecodeUserModel
                                                            .decodeUserModel(
                                                                data);
                                                    await _repository
                                                        .acceptRequest(user.uid,
                                                            userList[i].uid);
                                                    setState(() {
                                                      userList.removeAt(i);
                                                    });
                                                    customToast.showToast(
                                                        "Request accepted");
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    color:
                                                        theme.primaryColorDark,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.03,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    String data = await pref
                                                        .read("currentUser");
                                                    UserModel user =
                                                        EncodeDecodeUserModel
                                                            .decodeUserModel(
                                                                data);
                                                    await _repository
                                                        .rejectRequest(user.uid,
                                                            userList[i].uid);
                                                    setState(() {
                                                      userList.removeAt(i);
                                                    });
                                                    customToast.showToast(
                                                        "Request deleted");
                                                  },
                                                  child: Icon(
                                                    Icons.cancel_sharp,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                }),
                          )
                        : Center(
                            child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'No Requests yet',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
