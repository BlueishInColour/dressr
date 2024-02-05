// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      typeOfUser: json['typeOfUser'] as String? ?? '',
      listOfLikers: (json['listOfLikers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      listOfLikedPosts: (json['listOfLikedPosts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'userName': instance.userName,
      'uid': instance.uid,
      'listOfLikedPosts': instance.listOfLikedPosts,
      'typeOfUser': instance.typeOfUser,
      'listOfLikers': instance.listOfLikers,
    };
