import 'package:demo_logger/logme.dart';
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

  final telegramMessage = TelegramLogMessage()
    ..addNormalText('Bonjours Mans.\n')
    ..addBoldText("Ici le logger du Ofceab Studio build par ")
    ..addMention('yaya');

  final slackMessage = SlackLogMessage()
    ..addNormalText('Bonjours Mans. Ici le logger du Studio build par ')
    ..addBoldText("Ici le logger du Ofceab Studio build par")
    ..addMention('yaya');

  final responses = await logger.logs(
      slackLogMessage: slackMessage, telegramLogMessage: telegramMessage);

  responses.forEach((log) {
    if (log.isLeft()) {
      print(log.fold((l) => l, (r) => null)!.error);
    }
  });
}
