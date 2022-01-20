import 'package:json_annotation/json_annotation.dart';
part 'grouplist_model.g.dart';

@JsonSerializable()
class GroupListModel {
  String uid;
  String groupName;
  String message;
  int timestamp;
  String imageUrl;

  GroupListModel(
      {this.uid, this.groupName, this.message, this.timestamp, this.imageUrl});

  factory GroupListModel.fromJson(Map<String, dynamic> data) =>
      _$GroupListModelFromJson(data);

  Map<String, dynamic> toJson() => _$GroupListModelToJson(this);
}
