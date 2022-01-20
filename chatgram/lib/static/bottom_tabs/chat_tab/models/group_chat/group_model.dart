import 'package:json_annotation/json_annotation.dart';
part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  String uid;
  String name;
  String type;
  String message;
  int timestamp;
  String group;

  GroupModel(
      {this.uid,
      this.name,
      this.type,
      this.message,
      this.timestamp,
      this.group});

  factory GroupModel.fromJson(Map<String, dynamic> data) =>
      _$GroupModelFromJson(data);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
