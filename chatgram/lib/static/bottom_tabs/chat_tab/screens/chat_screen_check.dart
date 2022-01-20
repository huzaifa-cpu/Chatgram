import 'package:chatgram/static/bottom_tabs/chat_tab/models/individual_chat/message_model.dart';
import 'package:chatgram/static/screens/loader.dart';
import 'package:chatgram/static/widgets/appbar.dart';
import 'package:chatgram/static/widgets/dialogs/custom_dialog.dart';
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

class ChatScreenCheck extends StatefulWidget {
  final UserModel receiver;
  bool selfDestruct;

  ChatScreenCheck({this.receiver, this.selfDestruct});

  @override
  _ChatScreenCheckState createState() => _ChatScreenCheckState();
}

class _ChatScreenCheckState extends State<ChatScreenCheck> {
  TextEditingController textFieldController = TextEditingController();
  CustomToast customToast = CustomToast();

  Repository _repository = Repository();

  UserModel sender;

  String _currentUserId;

  bool isWriting = false;

  @override
  void initState() {
    super.initState();

    _repository.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

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
          .collection("messages")
          .doc(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: Loader("Loading Chats"));
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
        alignment: snapshot['senderId'] == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['senderId'] == _currentUserId
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    var theme = Theme.of(context);

    Radius messageRadius = Radius.circular(20);
    if (snapshot['senderId'] == _currentUserId) {
      return Padding(
        padding: EdgeInsets.only(left: 40.0),
        child: Column(
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
                child: Text(
                  snapshot['message'],
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            ),
            snapshot['senderId'] == _currentUserId
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        Utils.readTimestamp(snapshot["timestamp"]),
                        style: TextStyle(
                            fontSize: 12, color: theme.primaryColorLight),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        // child: CircleAvatar(
                        //   radius: 15,
                        //   backgroundImage: AssetImage('message['photoUrl']'),
                        // ),
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

    if (snapshot['senderId'] != _currentUserId) {
      return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 40.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(10),
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
                child: Text(
                  snapshot['message'],
                  style: TextStyle(color: theme.primaryColorLight),
                ),
              ),
            ),
            snapshot['receiverId'] == _currentUserId
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          // child: CircleAvatar(
                          //   radius: 15,
                          //   backgroundImage: AssetImage('message['photoUrl']'),
                          // ),
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

      MessageModel _message = MessageModel(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      _repository.addMessageToDb(_message, sender, widget.receiver);
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
      actions: [
        IconButton(
          icon: Icon(
            Icons.access_time,
            color: theme.primaryColor,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomDialog(
                      btn1Text: widget.selfDestruct ? "Disable" : "Enable",
                      btn2Text: "Cancel",
                      title: "Self Destruct messages",
                      onOkPressed: () async {
                        await _repository.updateSelfDestruct(
                            !widget.selfDestruct, widget.receiver);
                        Navigator.pop(context);
                        if (widget.selfDestruct) {
                          customToast.showToast('Disabled');
                        } else {
                          customToast
                              .showToast('All messages will be vanished now');
                        }
                      });
                });
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.primaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        widget.receiver.name,
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
