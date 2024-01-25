/// Base log message class
/// Implement defined method to meet your custom definition of text stylings
abstract class LogMessage {
  /// Message that need to be send
  String get message;

  /// Add bold text
  void addBoldText(String text);

  /// Add Normal text
  void addNormalText(String text);

  /// Add italic text
  void addItalicText(String text);

  /// Add Underline text
  void addUnderlineText(String text);

  /// Add Code text
  void addCodeText(String text);

  /// Mention some one
  void addMention(String user);
}
