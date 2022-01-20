class CommentModel {
  String userName, comment, postTimeStamp, userEmail, userUid, postId;
  CommentModel(
      {this.userName,
      this.postTimeStamp,
      this.comment,
      this.postId,
      this.userEmail,
      this.userUid});

  CommentModel.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData["postID"];
    this.postTimeStamp = mapData["postTimeStamp"];
    this.userEmail = mapData["userEmail"];
    this.userName = mapData["userName"];
    this.userUid = mapData["userUID"];
    this.comment = mapData["comment"];
  }

  Map toMap(CommentModel comment) {
    var data = Map<String, dynamic>();
    data['comment'] = comment.comment;
    data['postId'] = comment.postId;
    data['postTimeStamp'] = comment.postTimeStamp;
    data['userEmail'] = comment.userEmail;
    data['userName'] = comment.userName;
    data['userUid'] = comment.userUid;
    return data;
  }
}
