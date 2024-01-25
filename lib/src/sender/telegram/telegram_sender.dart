import 'dart:io';

import '../../error/error.dart';
import '../../formatters/log_message.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../sender.dart';
import 'telegram_channel_sender.dart';

class TelegramSender implements Sender {
  final http.Client _httpClient;
  final List<TelegramChannelSender> channelsSenders;

  TelegramSender(this.channelsSenders, this._httpClient);

  @override
  Future<Either<LogError, void>> send(loggmessage message) async {
    return LogError.tryCatch(() async {
      final channelsSendings =
          channelsSenders.map((channelSender) => _send(channelSender, message));
      await Future.wait(channelsSendings);
    });
  }

  Future<void> _send(
      TelegramChannelSender channelSender, loggmessage message) async {
    final uri =
        "https://api.telegram.org/bot${channelSender.botId}/sendMessage?${_getMessage(message.message, channelSender.chatId)}";
    final response = await _httpClient.post(Uri.parse(uri));
    if (response.statusCode != HttpStatus.ok) {
      throw GenericeError(response.statusCode.toString(), response.body);
    }
  }

  String _getMessage(String message, String chatId) =>
      "text=$message&&chat_id=$chatId&parse_mode=MarkdownV2";
}
