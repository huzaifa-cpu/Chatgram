// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouplist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupListModel _$GroupListModelFromJson(Map<String, dynamic> json) {
  return GroupListModel(
    uid: json['uid'] as String,
    groupName: json['groupName'] as String,
    message: json['message'] as String,
    timestamp: json['timestamp'] as int,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$GroupListModelToJson(GroupListModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'groupName': instance.groupName,
      'message': instance.message,
      'timestamp': instance.timestamp,
      'imageUrl': instance.imageUrl,
    };
