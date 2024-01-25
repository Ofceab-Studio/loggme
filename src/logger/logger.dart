import 'package:dartz/dartz.dart';

import '../error/error.dart';
import '../formatters/log_message.dart';
import '../formatters/slack_log_message.dart';
import '../formatters/telegram_log_message.dart';
import '../sender/custom/custom_sender.dart';
import '../sender/sender.dart';
import '../sender/slack/slack_channel_sender.dart';
import '../sender/slack/slack_sender.dart';
import '../sender/telegram/telegram_channel_sender.dart';
import 'package:http/http.dart' as http;

import '../sender/telegram/telegram_sender.dart';

class Logger {
  final List<SlackChannelSender>? slackChannelsSenders;
  final List<TelegramChannelSender>? telegramChannelsSenders;
  final List<SendEndpointFunc>? customSenders;
  http.Client? httpClient;

  /// You may need to use this constructor if you want to send logs on multiple channels
  Logger(
      {required this.slackChannelsSenders,
      required this.telegramChannelsSenders,
      this.customSenders,
      this.httpClient});

  /// Send logs on telegram channels only
  Logger.sendOnTelegram(this.telegramChannelsSenders, {this.httpClient})
      : customSenders = null,
        slackChannelsSenders = null;

  /// Send logs on slack channels only
  Logger.sendOnSlack(this.slackChannelsSenders, {this.httpClient})
      : customSenders = null,
        telegramChannelsSenders = null;

  /// Send logs on custom channels only
  Logger.sendOnCustomEndpoint(this.customSenders, {this.httpClient})
      : slackChannelsSenders = null,
        telegramChannelsSenders = null;

  /// Send logs
  Future<List<Either<LogError, void>>> logs(
      {TelegramLogMessage? telegramLogMessage,
      SlackLogMessage? slackLogMessage,
      LogMessage? customMessage}) async {
    httpClient ??= http.Client();
    final _futures = <Future<Either<LogError, void>>>[];
    if (slackChannelsSenders != null &&
        slackChannelsSenders!.isNotEmpty &&
        slackLogMessage != null) {
      _futures.add(SlackSender(slackChannelsSenders!, httpClient!)
          .send(slackLogMessage));
    }

    if (telegramChannelsSenders != null &&
        telegramChannelsSenders!.isNotEmpty &&
        telegramLogMessage != null) {
      _futures.add(TelegramSender(telegramChannelsSenders!, httpClient!)
          .send(telegramLogMessage));
    }

    if (customSenders != null &&
        customSenders!.isNotEmpty &&
        customMessage != null) {
      _futures.addAll(customSenders!
          .map((customSend) => GenericSender(customSend).send(customMessage)));
    }

    return Future.wait(_futures);
  }
}
