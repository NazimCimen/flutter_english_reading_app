import 'package:json_annotation/json_annotation.dart';
import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';

part 'dictionary_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class DictionaryEntry implements BaseFirebaseModel<DictionaryEntry> {
  @JsonKey(name: 'documentId')
  final String? documentId;
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final String? origin;
  final List<Meaning> meanings;
  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  DictionaryEntry({
    this.documentId,
    required this.word,
    required this.meanings,
    required this.phonetics,
    this.phonetic,
    this.origin,
    this.userId,
    this.createdAt,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DictionaryEntryFromJson(json);

  @override
  DictionaryEntry fromJson(Map<String, dynamic> json) =>
      _$DictionaryEntryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DictionaryEntryToJson(this);

  DictionaryEntry copyWith({
    String? documentId,
    String? word,
    String? phonetic,
    List<Phonetic>? phonetics,
    String? origin,
    List<Meaning>? meanings,
    String? userId,
    DateTime? createdAt,
  }) {
    return DictionaryEntry(
      documentId: documentId ?? this.documentId,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      phonetics: phonetics ?? this.phonetics,
      origin: origin ?? this.origin,
      meanings: meanings ?? this.meanings,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String? get id => this.documentId;
}

@JsonSerializable()
class Phonetic {
  final String? text;
  final String? audio;

  Phonetic({this.text, this.audio});

  factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneticToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);

  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}

@JsonSerializable()
class Definition {
  final String definition;
  final String? example;
  final List<String>? synonyms;
  final List<String>? antonyms;

  Definition({
    required this.definition,
    this.example,
    this.synonyms,
    this.antonyms,
  });

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
}
