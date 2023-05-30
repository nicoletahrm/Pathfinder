import '../models/difficulty.dart';

double stringToDouble(String value) {
  return double.parse(value);
}

int stringToInt(String value) {
  return int.parse(value);
}

Difficulty stringToDifficulty(String value) {
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
