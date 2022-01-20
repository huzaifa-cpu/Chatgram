import 'dart:io';
import 'dart:math';

import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/firebase/storage.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/utils/utilities.dart';
import 'package:chatgram/static/widgets/buttons/custom_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class WritePost extends StatefulWidget {
  UserModel user;
  String url;
  WritePost({this.user, this.url});
  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePost> {
  Repository _repository = Repository();

  //INTIALIZATIONS
  TextEditingController writePostController = TextEditingController();
  bool post = false;
  File _postImageFile;
  bool loading = false;

  //POST
  void sendPost(UserModel _currentUser) async {
    String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String postImageURL;
    if (_postImageFile != null) {
      postImageURL = await Storage.uploadPostImages(
          postID: postID, postImageFile: _postImageFile);
    }

    _repository.sendPostInFirebase(
        postID, writePostController.text, _currentUser, postImageURL ?? 'NONE');
    Navigator.pop(context);
  }

  //IMAGE
  Future<void> _getImageAndCrop() async {
    File imageFileFromGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFileFromGallery != null) {
      setState(() {
        _postImageFile = imageFileFromGallery;
      });
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
        backgroundColor: theme.primaryColorLight,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Create Post",
            style: theme.textTheme.headline2,
          ),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: theme.primaryColor,
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: theme.primaryColorLight,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    _getImageAndCrop();
                  },
                  icon: Icon(
                    Icons.add_photo_alternate_rounded,
                    color: theme.primaryColor,
                  )),
            )
          ],
        ),
        body: loading
            ? Loader('Posting...')
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                    image: widget.url != null
                                        ? NetworkImage(widget.url)
                                        : AssetImage(
                                            'images/profile_image.jpg'))),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Text(
                            widget.user.name,
                            style: theme.textTheme.headline2,
                          ),
                        ],
                      ),
                      Container(
                        width: width,
                        height: height * 0.001,
                        color: theme.primaryColorDark,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      TextFormField(
                        controller: writePostController,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Whats on your mind?',
                          hintMaxLines: 4,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      _postImageFile != null
                          ? Column(
                              children: [
                                Container(
                                  width: width * 0.91,
                                  height: height * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      image: DecorationImage(
                                          image: FileImage(
                                            _postImageFile,
                                          ),
                                          fit: BoxFit.fill)),
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                              ],
                            )
                          : Container(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: CustomAnimatedButton(
                            text: "Post",
                            changeButton: post,
                            onPressed: () async {
                              if (_postImageFile != null ||
                                  writePostController.text != null) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             Loader("Cancelling...")));
                                setState(() {
                                  post = !post;
                                  loading = true;
                                });
                                Future.delayed(Duration(seconds: 1), () {
                                  sendPost(widget.user);
                                });
                              } else {
                                print("Error");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
