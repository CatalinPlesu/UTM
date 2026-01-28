// import 'package:json_annotation/json_annotation.dart';
// part 'featured.g.dart';

// @JsonSerializable()
class Featured{
  final String cover;
  final String title;

  Featured(this.cover, this.title);
  // factory Featured.fromJson(Map<String, dynamic> json) => _$FeaturedFromJson(json);
  // Map<String, dynamic> toJson() => _$FeaturedToJson(this);
}