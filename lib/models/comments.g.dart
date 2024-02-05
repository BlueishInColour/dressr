// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      commentId: json['commentId'] as String? ?? 's',
      postId: json['postId'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      text: json['text'] as String? ?? '',
      creator: json['creator'] as String? ?? '',
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'commentId': instance.commentId,
      'postId': instance.postId,
      'text': instance.text,
      'picture': instance.picture,
      'creator': instance.creator,
    };
