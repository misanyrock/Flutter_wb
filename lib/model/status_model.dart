import 'package:json_annotation/json_annotation.dart';

part 'status_model.g.dart';

@JsonSerializable()
class MainModel {
  List<StatusModel> statuses;

  int original_num;
  int num;
  String remind_text; //更新了15条微博

  MainModel(this.statuses,this.remind_text,this.num,this.original_num);

  //反序列化
  factory MainModel.fromJson(Map<String,dynamic> json) => _$MainModelFromJson(json);
  //序列化
  Map<String,dynamic> toJson() => _$MainModelToJson(this);
}

@JsonSerializable()
class StatusModel {

  int id;
  bool can_edit;
  String text;
  int textLength;
  int source_type; //weibo type
  String source;
  bool favorited;
  String pic_types;
  bool is_paid;
  int mblog_vip_type;
  StatusUserModel user;
  List<PictureInfoModel> pic_urls;
  RetweetedStatusModel retweeted_status;
  int reposts_count; //转发数
  int comments_count; //评论数
  int attitudes_count; //点赞数
  int pending_approval_count;
  bool isLongText;
  List<StatusAttiModel> multi_attitude;
  int most_attitude_type;
  String pic_bg_new; //签名后面图片
  int pic_bg_type;
  int weibo_position;
  String obj_ext; //"791万次观看"
  StatusPageInfoModel page_info;
  String timestamp_text;

  StatusModel(this.id,this.can_edit,this.text,this.textLength,this.source_type,this.source,
      this.favorited,this.pic_types,this.is_paid,this.mblog_vip_type,
      this.user,this.pic_urls,this.retweeted_status,this.reposts_count,this.comments_count,
      this.attitudes_count,this.pending_approval_count,
      this.isLongText,this.multi_attitude,this.most_attitude_type,this.pic_bg_new,this.pic_bg_type,
      this.weibo_position,this.obj_ext,this.page_info,this.timestamp_text);

  //反序列化
  factory StatusModel.fromJson(Map<String,dynamic> json) => _$StatusModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$StatusModelToJson(this);
}

@JsonSerializable()
class StatusUserModel {
  int id;
  String screen_name;
  String province;
  String city;
  String description;
  String url;
  String profile_image_url;
  String cover_image;
  String cover_image_phone;
  String gender;
  int followers_count;
  int friends_count;
  int pagefriends_count;
  bool following;
  bool allow_all_act_msg;
  bool verified;
  int verified_type;
  String remark;
  String avatar_large;
  String avatar_hd;
  String verified_reason;
  int verified_state;
  String verified_reason_modified;
  int verified_level;
  int verified_type_ext;
  bool has_service_tel;
  bool follow_me;
  bool like;
  bool like_me;
  StatusBadgeModel badge;
  int has_ability_tag;
  String bility_tags;
  int credit_score;
  int user_ability;

  StatusUserModel(this.id,this.screen_name,this.province,this.city,this.description,
      this.url,this.profile_image_url,this.cover_image,this.cover_image_phone,
      this.gender,this.followers_count,this.friends_count,this.pagefriends_count,
      this.following,this.allow_all_act_msg,this.verified,this.verified_type,
      this.remark,this.avatar_large,this.avatar_hd,this.verified_reason,this.verified_state,
      this.verified_reason_modified,this.verified_level,this.verified_type_ext,this.has_service_tel,
      this.follow_me,this.like,this.like_me,this.badge,this.has_ability_tag,
      this.bility_tags,this.credit_score,this.user_ability);

  //反序列化
  factory StatusUserModel.fromJson(Map<String,dynamic> json) => _$StatusUserModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$StatusUserModelToJson(this);

}

@JsonSerializable()
class StatusBadgeModel {

  StatusBadgeModel();

  //反序列化
  factory StatusBadgeModel.fromJson(Map<String,dynamic> json) => _$StatusBadgeModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$StatusBadgeModelToJson(this);
}

@JsonSerializable()
class StatusAttiModel {
  int type;
  int count;

  StatusAttiModel(this.type,this.count);

  //反序列化
  factory StatusAttiModel.fromJson(Map<String,dynamic> json) => _$StatusAttiModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$StatusAttiModelToJson(this);
}

@JsonSerializable()
class StatusPageInfoModel {
  String type;
  String page_id;
  String object_type;
  String object_id;
  String content1;
  String content2;
  int act_status;
  StatusMediaInfoModel media_info;

  StatusPageInfoModel(this.type,this.page_id,this.object_id,this.object_type,
      this.content1,this.content2,this.act_status,this.media_info);

  //反序列化
  factory StatusPageInfoModel.fromJson(Map<String,dynamic> json) => _$StatusPageInfoModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$StatusPageInfoModelToJson(this);

}

@JsonSerializable()
class StatusMediaInfoModel {

  String video_orientation;
  String name;
  int duration;
  String stream_url;
  String stream_url_hd;
  String h5_url;
  String mp4_sd_url;
  String mp4_hd_url;
  String h265_mp4_hd;
  String h265_mp4_ld;
  String inch_4_mp4_hd;
  String inch_5_mp4_hd;
  String inch_5_5_mp4_hd;
  String mp4_720p_mp4;
  String hevc_mp4_720p;
  int prefetch_type;
  int prefetch_size;
  int act_status;
  String next_title;

  StatusMediaInfoModel(this.video_orientation,this.name,this.duration,
      this.stream_url,this.stream_url_hd,this.h5_url,this.mp4_sd_url,
      this.mp4_hd_url,this.h265_mp4_hd,this.h265_mp4_ld,this.inch_4_mp4_hd,
      this.inch_5_5_mp4_hd,this.inch_5_mp4_hd,this.mp4_720p_mp4,
      this.hevc_mp4_720p,this.prefetch_size,this.prefetch_type,
      this.act_status,this.next_title);

  //反序列化
  factory StatusMediaInfoModel.fromJson(Map<String,dynamic> json) => _$StatusMediaInfoModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$StatusMediaInfoModelToJson(this);

}

@JsonSerializable()
class RetweetedStatusModel {

  int id;
  bool can_edit;
  String text;
  int textLength;
  int source_type; //weibo type  2?转发 1?原创
  String source;
  bool favorited;
  List<PictureInfoModel> pic_urls;
  StatusUserModel user;

  RetweetedStatusModel(this.id,this.can_edit,this.text,this.textLength,this.source_type,this.source,
      this.favorited,this.user,this.pic_urls);

  //反序列化
  factory RetweetedStatusModel.fromJson(Map<String,dynamic> json) => _$RetweetedStatusModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$RetweetedStatusModelToJson(this);
}

@JsonSerializable()
class PictureInfoModel {

  String thumbnail;
  String thumbnail_pic;
  String bmiddle;
  String middleplus;
  String large;
  String original;
  String largest;

  String object_id;
  String pic_id;
  String type;
  int photo_tag;
  int pic_status;

  PictureInfoModel(this.thumbnail,this.bmiddle,this.middleplus,this.large,this.original,this.largest,
      this.object_id,this.pic_id,this.type,this.photo_tag,this.pic_status,this.thumbnail_pic);

  //反序列化
  factory PictureInfoModel.fromJson(Map<String,dynamic> json) => _$PictureInfoModelFromJson(json);

  //序列化
  Map<String,dynamic> toJson() => _$PictureInfoModelToJson(this);

}




