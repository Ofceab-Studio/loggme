# loggme

_A litle package be relax when your apps are running on production. Allways receive logs about what happen there through Telegram, slack and any other http REST API._

## Features

- [x] Support logging through telegram
- [x] Support logging through slack 
- [x] Support logging through custom REST API endpoints 

## Example
```dart
void main() async {
  final dotEnv = DotEnv()..load();

  final telegramChannelsSenders = <TelegramChannelSender>[
    TelegramChannelSender(
        botId: dotEnv['TELEGRAM_BOT_ID']!, chatId: dotEnv['TELEGRAM_CHAT_ID']!)
  ];

  final slackChannelsSenders = <SlackChannelSender>[
    SlackChannelSender(
        applicationToken: dotEnv['SLACK_APPLICATION_ID']!,
        channelName: dotEnv['SLACK_CHANNEL_NAME']!)
  ];

  /// Send on multiple channels (telegram, slack, and custom)
  final logger = Logger(
      slackChannelsSenders: slackChannelsSenders,
      telegramChannelsSenders: telegramChannelsSenders);

  /// Send o Slack only
  Logger.sendOnSlack(slackChannelsSenders);

  /// Send o Telegram only
  Logger.sendOnTelegram(telegramChannelsSenders);

  final telegramMessage = TelegramLoggMessage()
    ..addNormalText('Hello mans.\n')
    ..addBoldText("Here is a litle logger build by")
    ..addMention('Ofceab Studio');

  final slackMessage = SlackLoggMessage()
    ..addNormalText('Hello mans.\n')
    ..addBoldText("Here is a litle logger build by")
    ..addMention('Ofceab Studio');

  final responses = await logger.logs(
      slackLoggMessage: slackMessage, telegramLoggMessage: telegramMessage);

  responses.forEach((log) {
    if (log.isLeft()) {
      print(log.fold((l) => l, (r) => null)!.error);
    }
  });
}
```

## Issues
Feel you free to open issue [here](https://github.com/Ofceab-Studio/loggme/issues)