// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DictionaryEntry _$DictionaryEntryFromJson(Map<String, dynamic> json) =>
    DictionaryEntry(
      documentId: json['documentId'] as String?,
      word: json['word'] as String?,
      meanings: (json['meanings'] as List<dynamic>?)
          ?.map((e) => Meaning.fromJson(e as Map<String, dynamic>))
          .toList(),
      phonetics: (json['phonetics'] as List<dynamic>?)
          ?.map((e) => Phonetic.fromJson(e as Map<String, dynamic>))
          .toList(),
      phonetic: json['phonetic'] as String?,
      origin: json['origin'] as String?,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DictionaryEntryToJson(DictionaryEntry instance) =>
    <String, dynamic>{
      'documentId': instance.documentId,
      'word': instance.word,
      'phonetic': instance.phonetic,
      'phonetics': instance.phonetics?.map((e) => e.toJson()).toList(),
      'origin': instance.origin,
      'meanings': instance.meanings?.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

Phonetic _$PhoneticFromJson(Map<String, dynamic> json) => Phonetic(
      text: json['text'] as String?,
      audio: json['audio'] as String?,
    );

Map<String, dynamic> _$PhoneticToJson(Phonetic instance) => <String, dynamic>{
      'text': instance.text,
      'audio': instance.audio,
    };

Meaning _$MeaningFromJson(Map<String, dynamic> json) => Meaning(
      partOfSpeech: json['partOfSpeech'] as String,
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$MeaningToJson(Meaning instance) => <String, dynamic>{
      'id': instance.id,
      'partOfSpeech': instance.partOfSpeech,
      'definitions': instance.definitions.map((e) => e.toJson()).toList(),
    };

Definition _$DefinitionFromJson(Map<String, dynamic> json) => Definition(
      definition: json['definition'] as String,
      example: json['example'] as String?,
      synonyms: (json['synonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      antonyms: (json['antonyms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DefinitionToJson(Definition instance) =>
    <String, dynamic>{
      'definition': instance.definition,
      'example': instance.example,
      'synonyms': instance.synonyms,
      'antonyms': instance.antonyms,
    };
