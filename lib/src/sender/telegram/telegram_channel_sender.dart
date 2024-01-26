class TelegramChannelSender {
  /// Chat id
  final String chatId;
  // Topic id
  final String? messageThreadId;

  /// Bot id
  final String botId;
  TelegramChannelSender(
      {required this.botId, required this.chatId, this.messageThreadId});
}
