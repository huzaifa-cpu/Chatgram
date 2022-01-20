// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return GroupModel(
    uid: json['uid'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    message: json['message'] as String,
    timestamp: json['timestamp'] as int,
    group: json['group'] as String,
  );
}

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'type': instance.type,
      'message': instance.message,
      'timestamp': instance.timestamp,
      'group': instance.group,
    };
