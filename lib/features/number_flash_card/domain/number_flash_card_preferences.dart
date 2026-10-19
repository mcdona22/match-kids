class NumberFlashCardPreferences {
  const NumberFlashCardPreferences({
    this.cardCount = 10,
    this.timeout = 5,
  });

  final int cardCount;
  final int timeout;

  NumberFlashCardPreferences copyWith({
    int? cardCount,
    int? timeout,
  }) {
    return NumberFlashCardPreferences(
      cardCount: cardCount ?? this.cardCount,
      timeout: timeout ?? this.timeout,
    );
  }

  Map<String, dynamic> toJson() => {
        'cardCount': cardCount,
        'timeout': timeout,
      };

  factory NumberFlashCardPreferences.fromJson(Map<String, dynamic> json) {
    return NumberFlashCardPreferences(
      cardCount: json['cardCount'] as int? ?? 10,
      timeout: json['timeout'] as int? ?? 5,
    );
  }
}
