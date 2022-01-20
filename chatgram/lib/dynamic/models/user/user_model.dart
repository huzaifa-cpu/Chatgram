import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String uid;
  String name;
  String email;
  String status;
  bool state;
  String profilePhoto;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.status,
    this.state,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) =>
      _$UserModelFromJson(data);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
