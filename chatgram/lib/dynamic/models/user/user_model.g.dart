// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    uid: json['uid'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    status: json['status'] as String,
    state: json['state'] as bool,
    profilePhoto: json['profilePhoto'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'status': instance.status,
      'state': instance.state,
      'profilePhoto': instance.profilePhoto,
    };
