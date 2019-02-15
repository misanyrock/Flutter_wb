import 'package:json_annotation/json_annotation.dart';

part 'access_model.g.dart';

@JsonSerializable()
class AccessModel {

  @JsonKey(name: 'access_token')
  String access_token;

  @JsonKey(name: 'remind_in')
  String remind_in;

  @JsonKey(name: 'expires_in')
  int expires_in;

  @JsonKey(name: 'uid')
  String uid;

  @JsonKey(name: 'isRealName')
  String isRealName;

  AccessModel(this.access_token,this.remind_in,this.expires_in,this.uid,this.isRealName);

  //反序列化
  factory AccessModel.fromJson(Map<String,dynamic> json) => _$AccessModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$AccessModelToJson(this);

}