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

  @override
  String get message => escapeMarkdown(_message);

  @override
  void addBoldText(String text) {
    _message += '*$text*';
  }

  @override
  void addCodeText(String text) {
    _message += "```dart $text```";
  }

  @override
  void addItalicText(String text) {
    _message += "_${text}_";
  }

  @override
  void addUnderlineText(String text) {
    _message += "__${text}__";
  }

  @override
  void addMention(String user) {
    _message += "@$user";
  }

  @override
  void addNormalText(String text) {
    _message += text;
  }
}

final List<String> _specialChars = [
  '\\',
  '_',
  '*',
  '[',
  ']',
  '(',
  ')',
  '~',
  '`',
  '>',
  '<',
  '&',
  '+',
  '-',
  '=',
  '|',
  '{',
  '}',
  '.',
  '!'
];

String escapeMarkdown(String text) {
  String updateText = text;
  _specialChars.map((char) {
    updateText = updateText.replaceAll(char, '\\$char');
  });
  updateText = updateText.replaceAll('#', '%23');
  return updateText;
}
