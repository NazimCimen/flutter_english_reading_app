class WordModel {
  final String id;
  final String word;
  final String? definition;
  final String? tag;
  final String? tagColor;

  WordModel({
    required this.id,
    required this.word,
     this.tag,
     this.tagColor,
    this.definition,
  });

  factory WordModel.fromJson(Map<String, dynamic> json, String docId) {
    return WordModel(
      id: docId,
      word: json['word'] as String,
      definition: json['definition'] as String?,
      tag: json['tag'] as String,
      tagColor: json['tagColor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'word': word, 'definition': definition};
  }
}
