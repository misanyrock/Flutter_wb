// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessModel _$AccessModelFromJson(Map<String, dynamic> json) {
  return AccessModel(
      json['access_token'] as String,
      json['remind_in'] as String,
      json['expires_in'] as int,
      json['uid'] as String,
      json['isRealName'] as String);
}

Map<String, dynamic> _$AccessModelToJson(AccessModel instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'remind_in': instance.remind_in,
      'expires_in': instance.expires_in,
      'uid': instance.uid,
      'isRealName': instance.isRealName
    };
