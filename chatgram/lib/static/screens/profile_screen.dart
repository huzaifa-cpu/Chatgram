import 'dart:io';
import 'package:chatgram/dynamic/firebase/services/user_service.dart';
import 'package:chatgram/dynamic/firebase/storage.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/dynamic/providers/theme_provider.dart';
import 'package:chatgram/static/widgets/buttons/custom_button.dart';
import 'package:chatgram/static/widgets/dialogs/custom_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/local_storage/shared_preference.dart';
import 'package:chatgram/static/widgets/textfields/custom_textfield.dart';

class Profile extends StatefulWidget {
  UserModel user;
  Profile({this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  SharedPref pref = SharedPref();
  String name = "";
  String _currentUser;
  UserModel sender;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.forward();

    _repository.getCurrentUser().then((user) {
      _currentUser = user.uid;

      setState(() {
        sender = UserModel(
          uid: user.uid,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  Repository _repository = Repository();

  var loading = true;
  bool save = false;
  File _postImageFile;
  final ImagePicker _picker = ImagePicker();
  //ANIMATIONS
  Animation animation;
  AnimationController animationController;

  //IMAGE
  Future<void> _getImageAndCrop() async {
    File imageFileFromGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    print(imageFileFromGallery);
    if (imageFileFromGallery != null) {
      setState(() {
        _postImageFile = imageFileFromGallery;
      });
    }
    sendPost(widget.user);
  }

  //POST
  void sendPost(UserModel sender) async {
    String uid = sender.uid;
    String postImageURL;

    if (_postImageFile != null) {
      postImageURL = await Storage.uploadProfileImage(
          uid: uid, profileImageFile: _postImageFile);
      debugPrint('image uploaded');
      UserService().updateUserProfileImage(uid, postImageURL);
      loading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
                  color: theme.accentColor,
                ),
              ),
              Container(height: height * 0.7, color: theme.primaryColorLight),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.10,
              ),
              Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'CenturyGothic',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                width: width * 0.9,
                height: height * 0.28,
                child: Card(
                    elevation: 50.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: theme.primaryColorLight,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(_currentUser)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          dynamic data = snapshot.data;
                                          print(data);
                                          debugPrint("abc");
                                          print(data["profilePhoto"]);

                                          return Center(
                                            child: Stack(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 42,
                                                  backgroundImage: data[
                                                              "profilePhoto"] ==
                                                          null
                                                      ? AssetImage(
                                                          "images/profile_image.jpg")
                                                      : NetworkImage(
                                                          data["profilePhoto"]),
                                                ),
                                                Positioned(
                                                    bottom: 00.0,
                                                    right: 00.0,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (loading) {
                                                          loading = false;
                                                          _getImageAndCrop();
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.teal,
                                                        size: 28.0,
                                                      ),
                                                    ))
                                              ],
                                            ),
                                          );
                                        })),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Text(
                                  widget.user.name,
                                  style: theme.textTheme.bodyText2,
                                ),
                                SizedBox(
                                  height: height * 0.0001,
                                ),
                                Text(
                                  widget.user.email,
                                  style: theme.textTheme.bodyText2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          }
                        })),
              ),
              AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform: Matrix4.translationValues(
                          0.0, animation.value * width, 0.0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.2,
                            right: width * 0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.03,
                            ),
                            CustomButton(
                              text: 'Edit Profile',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            theme.primaryColorLight,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        content: Container(
                                          height: height * 0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: height * 0.02,
                                              ),
                                              CustomTextField(
                                                hint: 'Edit name',
                                                initialValue: widget.user.name,
                                                obscureText: false,
                                                onChanged: (val) {
                                                  setState(() {
                                                    name = val;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                height: height * 0.02,
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              CustomButton(
                                                text: "Save",
                                                onPressed: () {
                                                  setState(() {
                                                    widget.user.name = name;
                                                  });
                                                  _repository.updateUserName(
                                                      widget.user.uid, name);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Consumer<ThemeProvider>(
                              builder: (context, notifier, child) =>
                                  CustomButton(
                                text: 'Theme',
                                onPressed: () async {
                                  notifier.toggleTheme();
                                },
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            CustomButton(
                              text: 'Logout',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                          btn1Text: "Ok",
                                          btn2Text: "Cancel",
                                          title: "Logout?",
                                          onOkPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            //SIGN OUT
                                            await _repository.signOut();
                                            // CubeChatConnection.instance
                                            // .destroy();
                                          });
                                    });
                              },
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            CustomButton(
                              text: 'Back',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ]));
  }
}
