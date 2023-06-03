// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSearchModel _$ChatSearchModelFromJson(Map<String, dynamic> json) =>
    ChatSearchModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SearchMessage.fromJson(e))
          .toList(),
    );

Map<String, dynamic> _$ChatSearchModelToJson(ChatSearchModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('data', instance.data);
  return val;
}

SearchMessage _$SearchMessageFromJson(Map<String, dynamic> json) =>
    SearchMessage(
      chat_message_id: json['chat_message_id'] as int?,
      sender_id: json['sender_id'] as int?,
      receiver_id: json['receiver_id'] as int?,
      message: json['message'] as String?,
      message_type: json['message_type'] as String?,
      send_date: json['send_date'] as String?,
      send_time: json['send_time'] as String?,
      read_date: json['read_date'] as String?,
      created_at: json['created_at'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$SearchMessageToJson(SearchMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chat_message_id', instance.chat_message_id);
  writeNotNull('sender_id', instance.sender_id);
  writeNotNull('receiver_id', instance.receiver_id);
  writeNotNull('message', instance.message);
  writeNotNull('message_type', instance.message_type);
  writeNotNull('send_date', instance.send_date);
  writeNotNull('send_time', instance.send_time);
  writeNotNull('read_date', instance.read_date);
  writeNotNull('created_at', instance.created_at);
  writeNotNull('status', instance.status);
  return val;
}
