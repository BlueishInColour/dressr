import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  User(
      {this.uid = '',
      this.displayName = '',
      this.userName = '',
      this.typeOfUser = '',
      this.listOfLikers = const [],
      this.listOfLikedPosts = const []});

  String displayName;
  String userName;
  String uid;
  List<String> listOfLikedPosts;
  String typeOfUser;

  List<String> listOfLikers;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
