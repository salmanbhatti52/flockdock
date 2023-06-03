import 'package:json_annotation/json_annotation.dart';
part 'chat_search_model.g.dart';



@JsonSerializable(includeIfNull: false)
class ChatSearchModel {
  @JsonKey(name: 'status',)
  String? status;
  @JsonKey(name: 'data',)
  List<SearchMessage>? data;

  ChatSearchModel({
    this.status,
    this.data,
  });

  Map<String, dynamic> toJson() => _$ChatSearchModelToJson(this);
  factory ChatSearchModel.fromJson(json) => _$ChatSearchModelFromJson(json);


}
@JsonSerializable(includeIfNull: false)
class SearchMessage {
  int? chat_message_id;
  int? sender_id;
  int? receiver_id;
  String? message;
  String? message_type;
  String? send_date;
  String? send_time;
  String? read_date;
  String? created_at;
  String? status;

  SearchMessage({
    this.chat_message_id,
    this.sender_id,
    this.receiver_id,
    this.message,
    this.message_type,
    this.send_date,
    this.send_time,
    this.read_date,
    this.created_at,
    this.status,
  });

  Map<String, dynamic> toJson() => _$SearchMessageToJson(this);

  factory SearchMessage.fromJson(json) => _$SearchMessageFromJson(json);
}
