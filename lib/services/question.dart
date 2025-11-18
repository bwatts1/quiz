import 'dart:math';
import 'package:html_unescape/html_unescape.dart';

class Question {
  final String questionText;
  final String correctAnswer;
  final List<String> allOptions;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.allOptions,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    final String question = unescape.convert(json['question'] as String);
    final String correct = unescape.convert(json['correct_answer'] as String);
    final List<dynamic> incorrect = json['incorrect_answers'] as List<dynamic>;
    List<String> options = incorrect.map((e) => unescape.convert(e as String)).toList();
    options.add(correct);

    final rnd = Random();
    for (int i = options.length - 1; i > 0; i--) {
      final j = rnd.nextInt(i + 1);
      final tmp = options[i];
      options[i] = options[j];
      options[j] = tmp;
    }

    return Question(
      questionText: question,
      correctAnswer: correct,
      allOptions: options,
    );
  }
}
