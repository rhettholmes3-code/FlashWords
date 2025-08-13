class Word {
  final String word;
  final String definition;
  final String? pronunciation;
  final List<String> synonyms;
  final String example;
  final WordLevel level;
  final String? audioUrl;
  final DateTime createdAt;

  Word({
    required this.word,
    required this.definition,
    this.pronunciation,
    this.synonyms = const [],
    required this.example,
    this.level = WordLevel.intermediate,
    this.audioUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? '',
      definition: json['definition'] ?? '',
      pronunciation: json['pronunciation'],
      synonyms: List<String>.from(json['synonyms'] ?? []),
      example: json['example'] ?? '',
      level: WordLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['level'],
        orElse: () => WordLevel.intermediate,
      ),
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'definition': definition,
      'pronunciation': pronunciation,
      'synonyms': synonyms,
      'example': example,
      'level': level.toString().split('.').last,
      'audioUrl': audioUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum WordLevel {
  beginner,
  intermediate,
  advanced,
}

extension WordLevelExtension on WordLevel {
  String get displayName {
    switch (this) {
      case WordLevel.beginner:
        return '初级';
      case WordLevel.intermediate:
        return '中级';
      case WordLevel.advanced:
        return '高级';
    }
  }

  String get color {
    switch (this) {
      case WordLevel.beginner:
        return '#4CAF50';
      case WordLevel.intermediate:
        return '#FF9800';
      case WordLevel.advanced:
        return '#F44336';
    }
  }
}
