import 'dart:math';
import '../data/answers.dart';
import '../models/magic_answer.dart';

class AnswerService {
  final _rng = Random();

  MagicAnswer pickRandom({required Set<String> discoveredIds}) {
    final undiscovered = kMagicAnswers.where((a) => !discoveredIds.contains(a.id)).toList();
    final pool = undiscovered.isNotEmpty ? undiscovered : kMagicAnswers;
    return pool[_rng.nextInt(pool.length)];
  }

  int totalCount() => kMagicAnswers.length;
}
