import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_reading_app/product/firebase/converter/timestamp_converter.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleModel extends Equatable
    implements BaseFirebaseModel<ArticleModel> {
  final String? articleId;
  final String? category;
  final List<Definition>? definition;
  final String? imageUrl;
  final String? level;
  final String? title;
  final String? text;
  @TimestampConverter()
  final DateTime? createdAt;

  const ArticleModel({
    this.articleId,
    this.category,
    this.definition,
    this.imageUrl,
    this.level,
    this.title,
    this.text,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    articleId,
    category,
    definition,
    imageUrl,
    level,
    title,
    text,
    createdAt,
  ];

  ArticleModel copyWith({
    String? articleId,
    String? category,
    List<Definition>? definition,
    String? imageUrl,
    String? level,
    String? title,
    String? text,
    DateTime? createdAt,
  }) => ArticleModel(
    articleId: articleId ?? this.articleId,
    category: category ?? this.category,
    definition: definition ?? this.definition,
    imageUrl: imageUrl ?? this.imageUrl,
    level: level ?? this.level,
    title: title ?? this.title,
    text: text ?? this.text,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  ArticleModel fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  @override
  String? get id => articleId;
}

@JsonSerializable()
class Definition {
  final String? text;
  final List<String>? meanings;
  final String? phraseType;

  Definition({this.text, this.meanings, this.phraseType});
  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json); 
  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
  
}
