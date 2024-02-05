import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'chat_user.g.dart';

@JsonSerializable()
class ChatUser {
  ChatUser({
    required this.displayName,
    required this.lastMessage,
    required this.lastMessageStatus,
    required this.profilePicture,
    required this.uid,
    required this.userName,
  });
  String displayName;
  String userName;
  String profilePicture;
  String uid;
//
  String lastMessage;
  String lastMessageStatus;

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}
