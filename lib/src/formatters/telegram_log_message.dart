import 'package:loggme/src/formatters/styles.dart';

import 'log_message.dart';

class TelegramLoggMessage
    implements
        LoggMessage,
        HasBoldStyle,
        HasCodeStyle,
        HasItalicStyle,
        HasMentionStyle,
        HasNormalStyle,
        HasUnderLineStyle {
  String _message = """""";

  final _regEx = RegExp(r'[_[\]()~>`#+\-=|{}.!]');

  @override
  String get message => _message;

  @override
  void addBoldText(String text) {
    _message += _escapedSpecialCharacters(text, stylyingCharacter: '*');
  }

  @override
  void addCodeText(String text, {String language = 'dart'}) {
    _message +=
        _replaceAllSpecialCharsWithEncodedChars("```$language\n$text```");
  }

  @override
  void addItalicText(String text) {
    _message += _escapedSpecialCharacters(text, stylyingCharacter: '_');
  }

  @override
  void addUnderlineText(String text) {
    _message += _escapedSpecialCharacters(text, stylyingCharacter: '__');
  }

  @override
  void addMention(String user) {
    _message += _escapedSpecialCharacters("@$user", stylyingCharacter: '');
  }

  @override
  void addNormalText(String text) {
    _message += _escapedSpecialCharacters(text, stylyingCharacter: '');
  }

  String _escapedSpecialCharacters(String text,
      {required String stylyingCharacter}) {
    String _escapedText = '';

    // Escape all specials chars
    _escapedText = text.replaceAllMapped(_regEx, (match) {
      final encodedChar =
          '%${match[0]?.codeUnitAt(0).toRadixString(16).padLeft(2, '0')}';
      return '\\${encodedChar}';
    });

    _escapedText = '$stylyingCharacter$_escapedText$stylyingCharacter';

    return _replaceAllSpecialCharsWithEncodedChars(_escapedText);
  }

  String _replaceAllSpecialCharsWithEncodedChars(String text) {
    return text.replaceAllMapped(_regEx, (match) {
      return '%${match[0]?.codeUnitAt(0).toRadixString(16).padLeft(2, '0')}';
    });
  }
}
