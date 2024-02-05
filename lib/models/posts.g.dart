// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      albumId: (json['albumId'] as num?)?.toDouble() ?? 0,
      postId: json['postId'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      stock: (json['stock'] as num?)?.toDouble() ?? 0,
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      creatorDisplayName: json['creatorDisplayName'] as String? ?? '',
      creatorProfilePicture: json['creatorProfilePicture'] as String? ?? '',
      creatorUserName: json['creatorUserName'] as String? ?? '',
      listOfLikers: (json['listOfLikers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      headPostId: json['headPostId'] as String? ?? 'general',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'listOfLikers': instance.listOfLikers,
      'albumId': instance.albumId,
      'postId': instance.postId,
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'caption': instance.caption,
      'discountPercentage': instance.discountPercentage,
      'stock': instance.stock,
      'price': instance.price,
      'category': instance.category,
      'brand': instance.brand,
      'rating': instance.rating,
      'images': instance.images,
      'headPostId': instance.headPostId,
      'creatorDisplayName': instance.creatorDisplayName,
      'creatorUserName': instance.creatorUserName,
      'creatorProfilePicture': instance.creatorProfilePicture,
    };

Every _$EveryFromJson(Map<String, dynamic> json) => Every(
      products: (json['products'] as List<dynamic>)
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: (json['limit'] as num?)?.toDouble() ?? 0,
      skip: (json['skip'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$EveryToJson(Every instance) => <String, dynamic>{
      'products': instance.products,
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
    };
