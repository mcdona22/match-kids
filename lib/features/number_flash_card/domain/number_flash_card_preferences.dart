class NumberFlashCardPreferences {
  const NumberFlashCardPreferences({
    this.cardCount = 10,
    this.timeout = 5,
    this.correct = 0,
    this.incorrect = 0,
  });

  final int cardCount;
  final int timeout;
  final int correct;
  final int incorrect;

  NumberFlashCardPreferences copyWith({
    int? cardCount,
    int? timeout,
    int? correct,
    int? incorrect,
  }) {
    return NumberFlashCardPreferences(
      cardCount: cardCount ?? this.cardCount,
      timeout: timeout ?? this.timeout,
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
    );
  }

  Map<String, dynamic> toJson() => {
        'cardCount': cardCount,
        'timeout': timeout,
        'correct': correct,
        'incorrect': incorrect,
      };

  factory NumberFlashCardPreferences.fromJson(Map<String, dynamic> json) {
    return NumberFlashCardPreferences(
      cardCount: json['cardCount'] as int? ?? 10,
      timeout: json['timeout'] as int? ?? 5,
      correct: json['correct'] as int? ?? 0,
      incorrect: json['incorrect'] as int? ?? 0,
    );
  }
}
