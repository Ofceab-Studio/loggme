import 'dart:convert';
import 'dart:io';

import '../../error/error.dart';
import '../../formatters/log_message.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../sender.dart';
import 'slack_channel_sender.dart';

class SlackSender implements Sender {
  final http.Client _httpClient;
  final List<SlackChannelSender> channelsSenders;

  SlackSender(this.channelsSenders, this._httpClient);

  @override
  Future<Either<LogError, void>> send(LogMessage message) async {
    return LogError.tryCatch(() async {
      final channelsSendings =
          channelsSenders.map((channelSender) => _send(channelSender, message));
      await Future.wait(channelsSendings);
    });
  }

  Future<void> _send(
      SlackChannelSender channelSender, LogMessage message) async {
    final uri = "https://slack.com/api/chat.postMessage";
    final response = await _httpClient.post(Uri.parse(uri),
        headers: _getAuthorization(channelSender),
        body: json.encode(_MessageBody(
                channelId: channelSender.channelName, content: message.message)
            .toJson()));

    if (response.statusCode != HttpStatus.ok) {
      throw GenericeError(response.statusCode.toString(), response.body);
    }
  }

  Map<String, String> _getAuthorization(SlackChannelSender channelSender) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader:
          'Bearer ${channelSender.applicationToken}'
    };
  }
}

// Define slack request body for sending text message
class _MessageBody {
  final String channelId;
  final String content;

  _MessageBody({required this.channelId, required this.content});

  Map<String, String> toJson() {
    return {"channel": channelId, "type": "mrkdwn", "text": content};
  }
}
