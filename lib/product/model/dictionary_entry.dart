import 'package:json_annotation/json_annotation.dart';
import 'package:english_reading_app/product/firebase/model/base_firebase_model.dart';
import 'package:equatable/equatable.dart';

part 'dictionary_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class DictionaryEntry extends Equatable
    implements BaseFirebaseModel<DictionaryEntry> {
  @JsonKey(name: 'documentId')
  final String? documentId;
  final String? word;
  final String? phonetic;
  final List<Phonetic>? phonetics;
  final String? origin;
  final List<Meaning>? meanings;
  @JsonKey(name: 'userId')
  final String? userId;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  const DictionaryEntry({
    this.documentId,
    this.word,
    this.meanings,
    this.phonetics,
    this.phonetic,
    this.origin,
    this.userId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    documentId,
    word,
    meanings,
    phonetics,
    phonetic,
    origin,
    userId,
    createdAt,
  ];

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
class Phonetic extends Equatable {
  final String? text;
  final String? audio;

  const Phonetic({this.text, this.audio});

  @override
  List<Object?> get props => [text, audio];

  factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneticToJson(this);

  Phonetic copyWith({String? text, String? audio}) {
    return Phonetic(text: text ?? this.text, audio: audio ?? this.audio);
  }
}

@JsonSerializable(explicitToJson: true)
class Meaning extends Equatable {
  final String? id;
  final String partOfSpeech;
  final List<Definition> definitions;

  const Meaning({
    required this.partOfSpeech,
    required this.definitions,
    this.id,
  });

  @override
  List<Object?> get props => [id, partOfSpeech, definitions];

  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);

  Map<String, dynamic> toJson() => _$MeaningToJson(this);

  Meaning copyWith({
    String? id,
    String? partOfSpeech,
    List<Definition>? definitions,
  }) {
    return Meaning(
      id: id ?? this.id,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      definitions: definitions ?? this.definitions,
    );
  }
}

@JsonSerializable()
class Definition extends Equatable {
  final String definition;
  final String? example;
  final List<String>? synonyms;
  final List<String>? antonyms;

  const Definition({
    required this.definition,
    this.example,
    this.synonyms,
    this.antonyms,
  });

  @override
  List<Object?> get props => [definition, example, synonyms, antonyms];

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);

  Definition copyWith({
    String? definition,
    String? example,
    List<String>? synonyms,
    List<String>? antonyms,
  }) {
    return Definition(
      definition: definition ?? this.definition,
      example: example ?? this.example,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
    );
  }
}
