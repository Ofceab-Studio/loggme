class SlackChannelSender {
  /// Chat name
  final String channelName;

  /// Application id
  final String applicationToken;
  SlackChannelSender(
      {required this.applicationToken, required this.channelName});
}
