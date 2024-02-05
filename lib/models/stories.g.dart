// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stories _$StoriesFromJson(Map<String, dynamic> json) => Stories(
      id: json['id'] as String? ?? '',
      creator: json['creator'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      reactions: json['reactions'] as int? ?? 0,
      postType: json['postType'] as String? ?? '',
      listOfLikers: (json['listOfLikers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$StoriesToJson(Stories instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'creator': instance.creator,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'picture': instance.picture,
      'tags': instance.tags,
      'reactions': instance.reactions,
      'postType': instance.postType,
      'listOfLikers': instance.listOfLikers,
      'body': instance.body,
    };
