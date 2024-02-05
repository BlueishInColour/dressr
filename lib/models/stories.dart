import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'stories.g.dart';

@JsonSerializable()
class Stories {
  Stories(
      {
      //
      this.id = '',
      this.creator = '',
      this.userId = 0,
      //
      this.title = '',
      this.body = '',
      this.picture = '',
      required this.createdAt,
      //
//counts
      this.reactions = 0,
      this.postType = '',
      this.listOfLikers = const [],
      this.tags = const []

      //
      });
  //id
  String id;
  int userId;
  //creator
  String creator;

  //title
  String title;
  DateTime createdAt;
  //content
  String picture;
  List<String> tags;
  int reactions;
  String postType; //blog or posts
  List<String> listOfLikers;
  String body;

  factory Stories.fromJson(Map<String, dynamic> json) =>
      _$StoriesFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesToJson(this);
}
