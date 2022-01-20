import 'package:chatgram/static/bottom_tabs/bottom_navbar.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/models/group_chat/group_model.dart';
import 'package:chatgram/static/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

class GroupChatScreen extends StatefulWidget {
  String groupName;
  UserModel currentUser;
  GroupChatScreen({this.groupName, this.currentUser});
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  TextEditingController textFieldController = TextEditingController();

  Repository _repository = Repository();

  bool isWriting = false;
  List<String> uids = List<String>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("groupMessages")
          .doc(widget.groupName)
          .collection(widget.groupName)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        for (var i in snapshot.data.docs) {
          uids.add(i['uid']);
        }
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: snapshot['uid'] == widget.currentUser.uid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['uid'] == widget.currentUser.uid
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    var theme = Theme.of(context);

    Radius messageRadius = Radius.circular(20);
    if (snapshot['uid'] == widget.currentUser.uid) {
      return Padding(
        padding: EdgeInsets.only(left: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: Container(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColorLight.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot["name"],
                      style: TextStyle(
                          fontSize: 15,
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      snapshot['message'],
                      style: TextStyle(color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            snapshot['uid'] == widget.currentUser.uid
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        Utils.readTimestamp(snapshot["timestamp"]),
                        style: TextStyle(
                            fontSize: 12, color: theme.primaryColorDark),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                : Container(
                    child: null,
                  ),
          ],
        ),
      );
    }
  }

  getMessage(DocumentSnapshot snapshot) {
    var theme = Theme.of(context);

    return Text(
      snapshot['message'],
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: 16.0,
      ),
    );
  }

  getMessagereceiver(DocumentSnapshot snapshot) {
    var theme = Theme.of(context);

    return Text(
      snapshot['message'],
      style: TextStyle(
        color: theme.primaryColorLight,
        fontSize: 16.0,
      ),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    var theme = Theme.of(context);

    Radius messageRadius = Radius.circular(10);

    if (snapshot['uid'] != widget.currentUser.uid) {
      return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 40.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColorLight.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot["name"],
                      style: TextStyle(
                          fontSize: 15,
                          color: theme.primaryColorDark,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      snapshot['message'],
                      style: TextStyle(color: theme.primaryColorLight),
                    ),
                  ],
                ),
              ),
            ),
            snapshot['uid'] != widget.currentUser.uid
                ? Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Utils.readTimestamp(snapshot["timestamp"]),
                          style: TextStyle(
                              fontSize: 12, color: theme.primaryColorLight),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  )
                : Container(child: null),
          ],
        ),
      );
    } else {
      Text(
        "hello",
        style: TextStyle(color: Colors.black),
      );
    }
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      var theme = Theme.of(context);

      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: theme.primaryColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        color: theme.primaryColor,
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    sendMessage() {
      var text = textFieldController.text;

      GroupModel _message = GroupModel(
        uid: widget.currentUser.uid,
        name: widget.currentUser.name,
        message: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        type: 'text',
        group: widget.groupName,
      );

      setState(() {
        isWriting = false;
      });

      _repository.addGroupMessageToDb(
          _message, widget.currentUser, widget.groupName, uids);
      textFieldController.clear();
    }

    var theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(color: theme.primaryColor),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: theme.primaryColorLight,
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: theme.primaryColorLight,
              ),
            ),
          ),
          isWriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                      color: theme.primaryColorDark,
                    ),
                    onPressed: () => sendMessage(),
                  ))
              : Container()
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    var theme = Theme.of(context);

    return CustomAppBar(
      actions: [],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.primaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BottomNavBar(),
            ),
          );
        },
      ),
      centerTitle: true,
      title: Text(
        widget.groupName,
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
