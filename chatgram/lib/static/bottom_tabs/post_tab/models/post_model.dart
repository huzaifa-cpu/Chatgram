class PostModel {
  PostModel({
    this.postCommentCount,
    this.postContent,
    this.postId,
    this.postImage,
    this.postLikeCount,
    this.postTimeStamp,
    this.userEmail,
    this.userName,
    this.userUid,
  });

  int postCommentCount;
  String postContent;
  String postId;
  String postImage;
  int postLikeCount;
  int postTimeStamp;
  String userEmail;
  String userName;
  String userUid;

  PostModel.fromMap(Map<String, dynamic> mapData) {
    this.postCommentCount = mapData["postCommentCount"];
    this.postContent = mapData["postContent"];
    this.postId = mapData["postID"];
    this.postImage = mapData["postImage"];
    this.postLikeCount = mapData["postLikeCount"];
    this.postTimeStamp = mapData["postTimeStamp"];
    this.userEmail = mapData["userEmail"];
    this.userName = mapData["userName"];
    this.userUid = mapData["userUID"];
  }

  Map toMap(PostModel post) {
    var data = Map<String, dynamic>();
    data['postCommentCount'] = post.postCommentCount;
    data['postContent'] = post.postContent;
    data['postId'] = post.postId;
    data['postImage'] = post.postImage;
    data['postLikeCount'] = post.postLikeCount;
    data['postTimeStamp'] = post.postTimeStamp;
    data['userEmail'] = post.userEmail;
    data['userName'] = post.userName;
    data['userUid'] = post.userUid;
    return data;
  }
}
