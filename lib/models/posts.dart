import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'posts.g.dart';

@JsonSerializable()
class Post {
  Post(
      {this.albumId = 0,
      this.postId = '',
      this.caption = '',
      this.discountPercentage = 0,
      this.price = 0,
      this.rating = 0,
      this.thumbnail = '',
      this.brand = '',
      this.stock = 0,
      this.title = '',
      this.category = '',
      this.creatorDisplayName = '',
      this.creatorProfilePicture = '',
      this.creatorUserName = '',
      this.listOfLikers = const [],
      this.headPostId = 'general',
      this.images = const []});

  List<String> listOfLikers; //

  double albumId;
  String postId; //
  String thumbnail;
  String title; //
  String caption; //
  double discountPercentage;
  double stock;
  double price;
  String category;
  String brand;
  // Time timestamp;
  double rating;
  List<String> images; //
  String headPostId; //

  //
  String creatorDisplayName;
  String creatorUserName; //
  String creatorProfilePicture; //

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Every {
  Every(
      {required this.products, this.limit = 0, this.skip = 0, this.total = 0});

  List<Post> products;
  double total;
  double skip;
  double limit;
  factory Every.fromJson(Map<String, dynamic> json) => _$EveryFromJson(json);

  Map<String, dynamic> toJson() => _$EveryToJson(this);
}

// {
//   "albumId": 1,
//   "id": 2,
//   "title": "reprehenderit est deserunt velit ipsam",
//   "url": "https://via.placeholder.com/600/771796",
//   "thumbnailUrl": "https://via.placeholder.com/150/771796"
// },
