enum Difficulty { easy, mediu, hard }

Difficulty difficultyFromString(String value) {
  switch (value) {
    case 'easy':
      return Difficulty.easy;
    case 'mediu':
      return Difficulty.mediu;
    case 'hard':
      return Difficulty.hard;
    default:
      throw ArgumentError('Invalid value for Difficulty: $value');
  }
}
