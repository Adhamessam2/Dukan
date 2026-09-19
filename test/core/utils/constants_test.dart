import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/utils/constants.dart';

void main() {
  group('AppConstants.htmlBoldRegex', () {
    test('matches single line <b> tags', () {
      final input = 'Normal text <b>bold text</b> end text';
      final matches = AppConstants.htmlBoldRegex.allMatches(input).toList();

      expect(matches.length, 3);
      expect(matches[0].group(2), 'Normal text ');
      expect(matches[1].group(1), 'bold text');
      expect(matches[2].group(2), ' end text');
    });

    test('matches multiline <b> tags across newlines', () {
      final input = 'Line 1\n<b>bold\nwith\nnewlines</b>\nLine 2';
      final matches = AppConstants.htmlBoldRegex.allMatches(input).toList();

      final boldMatches = matches.where((m) => m.group(1) != null).toList();
      expect(boldMatches.length, 1);
      expect(boldMatches.first.group(1), 'bold\nwith\nnewlines');
    });
  });
}
