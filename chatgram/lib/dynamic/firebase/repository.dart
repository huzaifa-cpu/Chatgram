import 'package:chatgram/dynamic/firebase/services/auth_service.dart';
import 'package:chatgram/dynamic/firebase/services/chat_service.dart';
import 'package:chatgram/dynamic/firebase/services/comment_service.dart';
import 'package:chatgram/dynamic/firebase/services/friend_service.dart';
import 'package:chatgram/dynamic/firebase/services/group_chat_service.dart';
import 'package:chatgram/dynamic/firebase/services/like_service.dart';
import 'package:chatgram/dynamic/firebase/services/post_service.dart';
import 'package:chatgram/dynamic/firebase/services/request_service.dart';
import 'package:chatgram/dynamic/firebase/services/user_service.dart';
import 'package:chatgram/dynamic/models/user/user_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/models/group_chat/group_model.dart';
import 'package:chatgram/static/bottom_tabs/chat_tab/models/individual_chat/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  //IMPORTINGS
  UserService userService = UserService();
  AuthService authService = AuthService();
  CommentServive commentServive = CommentServive();
  GroupChatService groupChatService = GroupChatService();
  PostService postService = PostService();
  LikeServive likeServive = LikeServive();
  ChatService chatService = ChatService();
  FriendServive friendServive = FriendServive();
  RequestService requestService = RequestService();

  //METHODS
  Future<User> getCurrentUser() => authService.getCurrentFirebaseUser();

  Future<UserModel> getUserModelFromFirebaseUser() =>
      userService.getUserModelFromFirebaseUser();

  Future<bool> authenticateUser(User user) =>
      authService.authenticateUser(user);
  Future<User> signInWithGoogle() => authService.signInWithGoogle();
  Future<User> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);
  Future<User> registerWithEmailAndPassword(String email, String password) =>
      authService.registerWithEmailAndPassword(email, password);

  Future<void> insertUser(User user) => userService.insertUser(user);

  Future<void> signOut() => userService.signOut();

  Future<List<UserModel>> fetchAllUsers(User user) =>
      userService.fetchAllUsers(user);
  Future<void> addMessageToDb(
          MessageModel message, UserModel sender, UserModel receiver) =>
      chatService.addMessageToDb(message, sender, receiver);

  Future updateSelfDestruct(bool value, UserModel reciever) =>
      chatService.updateSelfDestruct(value, reciever);

  Future vanishMessages(UserModel reciever) =>
      chatService.vanishMessages(reciever);

  Future<void> addGroupMessageToDb(GroupModel message, UserModel sender,
          String groupName, List<String> uids) =>
      groupChatService.addGroupMessageToDb(message, sender, groupName, uids);

  Future<UserModel> fetchUser(User user) => userService.fetchUser(user);

  Future updateUserName(String uid, String name) =>
      userService.updateUserName(uid, name);
  Future updateUserProfileImage(String uid, String name) =>
      userService.updateUserProfileImage(uid, name);

  Future updateLikeCount(String postId, String uid) =>
      likeServive.updateLikeCount(postId, uid);

  Future insertComment(String postId, UserModel user, String comment) =>
      commentServive.insertComment(postId, user, comment);

  Future friendOrUnfriend(String uid, String friendUid) =>
      friendServive.friendOrUnfriend(uid, friendUid);

  Future blockOrUnBlock(String uid, String friendUid) =>
      friendServive.blockOrUnBlock(uid, friendUid);

  Future updateFriendUnfriend(String uid, String friendUid) =>
      friendServive.updateFriendUnfriend(uid, friendUid);

  Future updateBlockUnblock(String uid, String friendUid) =>
      friendServive.updateBlockUnblock(uid, friendUid);

  Future fetchGroupList() => groupChatService.fetchGroupList();

  Future getUserPosts(String uid) => postService.getUserPosts(uid);

  Future fetchFriendList() => friendServive.fetchFriendList();

  Future fetchRequests() => requestService.fetchRequests();

  Future acceptRequest(String uid, String friendUid) =>
      requestService.acceptRequest(uid, friendUid);

  Future rejectRequest(String uid, String friendUid) =>
      requestService.rejectRequest(uid, friendUid);

  Future createGroup(
          List<UserModel> users, String groupName, String imageUrl) =>
      groupChatService.createGroup(users, groupName, imageUrl);

  Future<void> sendPostInFirebase(String postID, String postContent,
          UserModel userProfile, String postImageURL) =>
      postService.sendPostInFirebase(
          postID, postContent, userProfile, postImageURL);
}
