// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      displayName: json['displayName'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageStatus: json['lastMessageStatus'] as String,
      profilePicture: json['profilePicture'] as String,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'userName': instance.userName,
      'profilePicture': instance.profilePicture,
      'uid': instance.uid,
      'lastMessage': instance.lastMessage,
      'lastMessageStatus': instance.lastMessageStatus,
    };
