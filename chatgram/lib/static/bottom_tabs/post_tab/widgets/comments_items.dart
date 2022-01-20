import 'package:chatgram/static/utils/utilities.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatefulWidget {
  dynamic data;
  CommentItem({this.data});
  @override
  State<StatefulWidget> createState() => _CommentItem();
}

class _CommentItem extends State<CommentItem> {
  bool like = false;
  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    //THEMES
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  width: width * 0.10,
                  height: height * 0.10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                        "images/profile_image.jpg",
                      ))),
                ),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              widget.data["userName"],
                              style: theme.textTheme.headline3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              widget.data["comment"],
                              style: theme.textTheme.headline3,
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: width * 0.7,
                    decoration: BoxDecoration(
                      color: theme.primaryColorDark,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Text(Utils.readTimestamp(widget.data["postTimeStamp"]),
                          style: theme.textTheme.headline5),
                      SizedBox(
                        width: width * 0.07,
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       like = !like;
                      //     });
                      //   },
                      //   child: Text(
                      //     'Like',
                      //     style: TextStyle(
                      //         fontFamily: 'CenturyGothic',
                      //         color: like ? Color(0xFF1CD860) : Colors.grey,
                      //         fontSize: 14,
                      //         fontWeight:
                      //             like ? FontWeight.w700 : FontWeight.w500),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
