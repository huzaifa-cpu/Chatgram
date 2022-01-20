import 'package:chatgram/static/bottom_tabs/post_tab/widgets/comments_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatgram/dynamic/firebase/repository.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';

class Comment extends StatefulWidget {
  String image;
  String text;
  String time;
  String name;
  String postId;
  Comment({this.image, this.name, this.text, this.time, this.postId});
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  Repository _repository = Repository();

  TextEditingController commentController = TextEditingController();
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

  // List<CommentModel> comments = comments;
  _sendMessageArea() {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //THEMES
    var theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: theme.primaryColorLight,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: theme.primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration.collapsed(
                  hintText: 'Write a comment...',
                  hintStyle: theme.textTheme.bodyText1),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: theme.primaryColorDark,
            onPressed: () async {
              if (commentController.text != null) {
                _repository.insertComment(
                    widget.postId, currentUser, commentController.text);
                commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //THEMES
    var theme = Theme.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: theme.primaryColor,
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColorLight,
        title: Text(
          "Comments",
          style: theme.textTheme.headline2,
        ),
      ),
      backgroundColor: theme.primaryColorLight,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .doc(widget.postId)
              .collection(widget.postId)
              .orderBy('postTimeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data.docs.length > 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                dynamic comment = snapshot.data.docs[index];
                                return CommentItem(
                                  data: comment,
                                );
                              }),
                        ),
                        _sendMessageArea()
                      ],
                    )
                  : Column(
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'There is no comments yet',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                            textAlign: TextAlign.center,
                          ),
                        )),
                        Spacer(),
                        _sendMessageArea()
                      ],
                    );
            }
          }),
    );
  }
}
