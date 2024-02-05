import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'comments.g.dart';

@JsonSerializable()
class Comments {
  Comments({
    this.commentId = 's',
    this.postId = '',
    this.picture = '',
    this.text = '',
    this.creator = '',
  });
  String commentId;
  final String postId;
  String text;
  String picture;
  String creator;

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
