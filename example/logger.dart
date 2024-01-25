import 'package:logme/logme.dart';
import 'package:dotenv/dotenv.dart';

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

  final telegramMessage = TelegramLogMessage()
    ..addNormalText('Hello mans.\n')
    ..addBoldText("Here is a litle logger build by")
    ..addMention('Ofceab Studio');

  final slackMessage = SlackLogMessage()
    ..addNormalText('Hello mans.\n')
    ..addBoldText("Here is a litle logger build by")
    ..addMention('Ofceab Studio');

  final responses = await logger.logs(
      slackLogMessage: slackMessage, telegramLogMessage: telegramMessage);

  responses.forEach((log) {
    if (log.isLeft()) {
      print(log.fold((l) => l, (r) => null)!.error);
    }
  });
}
