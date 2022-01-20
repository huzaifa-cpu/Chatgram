import 'dart:io';
import 'dart:math';

import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/firebase/storage.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/dynamic/models/user/encode_decode_user_model.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/dynamic/providers/user_provider.dart';
import 'package:chatgram/static/utils/utilities.dart';
import 'package:chatgram/static/widgets/buttons/custom_button.dart';
import 'package:chatgram/static/widgets/custom_toast.dart';
import 'package:chatgram/static/widgets/textfields/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateGroupChat extends StatefulWidget {
  @override
  _CreateGroupChatState createState() => _CreateGroupChatState();
}

class _CreateGroupChatState extends State<CreateGroupChat> {
  Repository _repository = Repository();

  SharedPref pref = SharedPref();
  CustomToast customToast = CustomToast();
  File _groupImageFile;

  List<UserModel> finalList = List<UserModel>();
  TextEditingController groupName = TextEditingController();

  //IMAGE
  Future<void> _getImageAndCrop() async {
    File imageFileFromGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFileFromGallery != null) {
      setState(() {
        _groupImageFile = imageFileFromGallery;
      });
    }
  }

  Future<bool> createGroup(List<UserModel> usersList, String groupName) async {
    String generatedId =
        Utils.getRandomString(8) + Random().nextInt(500).toString();
    String imageUrl;
    if (_groupImageFile != null) {
      imageUrl = await Storage.uploadGroupImage(
          uid: generatedId, groupImageFile: _groupImageFile);
    }

    bool check =
        await _repository.createGroup(finalList, groupName, imageUrl ?? 'NONE');

    Navigator.pop(context);
    return check;
  }

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
          "Create Group",
          style: theme.textTheme.headline2,
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
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              List<UserModel> friendList = userProvider.user;
              return friendList.length > 0
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: friendList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                String data = await pref.read("currentUser");
                                UserModel user =
                                    EncodeDecodeUserModel.decodeUserModel(data);
                                setState(() {
                                  userProvider.changeState(friendList[index],
                                      !friendList[index].state);
                                  finalList = userProvider.checkUsersList(user);
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
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
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                image: DecorationImage(
                                                  image: friendList[index]
                                                              .profilePhoto ==
                                                          null
                                                      ? AssetImage(
                                                          'images/profile_image.jpg')
                                                      : NetworkImage(
                                                          friendList[index]
                                                              .profilePhoto),
                                                )),
                                          ),
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
                                                friendList[index].name,
                                                style:
                                                    theme.textTheme.bodyText1,
                                              ),
                                              SizedBox(
                                                height: height * 0.005,
                                              ),
                                              Text(
                                                friendList[index].email,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(
                                            friendList[index].state
                                                ? Icons.check_circle
                                                : Icons.chat,
                                            size: 25,
                                            color: friendList[index].state
                                                ? theme.primaryColor
                                                : theme.primaryColorDark,
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
                        'You have no friends',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ));
            }),
            finalList.length >= 2
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: "Start Group Chat (${finalList.length})",
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: theme.primaryColorLight,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                  content: Container(
                                    height: height * 0.35,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _getImageAndCrop();
                                          },
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: _groupImageFile ==
                                                    null
                                                ? AssetImage(
                                                    "images/profile_image.jpg")
                                                : FileImage(_groupImageFile),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.03,
                                        ),
                                        CustomTextField(
                                          hint: 'Set group name',
                                          obscureText: false,
                                          textEditingController: groupName,
                                        ),
                                        SizedBox(
                                          height: height * 0.02,
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        CustomButton(
                                          text: "Create",
                                          onPressed: () async {
                                            if (groupName.text != null) {
                                              bool check = await createGroup(
                                                  finalList, groupName.text);
                                              if (!check) {
                                                customToast.showDangerToast(
                                                    "The group already exists");
                                              } else if (check) {
                                                customToast.showToast(
                                                    '"${groupName.text}" group created');
                                              }
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
