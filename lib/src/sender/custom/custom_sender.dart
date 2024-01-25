import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

import '../../error/error.dart';
import '../../formatters/log_message.dart';
import '../sender.dart';

typedef SendEndpointFunc = Future<Response> Function(LoggMessage message);

abstract class CustomSender implements Sender {
  /// This method defines where and how send logs through HTTP
  Future<Response> sendEndpoint(
      LoggMessage message, SendEndpointFunc sendEndpointFunc);
}

class GenericSender implements CustomSender {
  final SendEndpointFunc sendFunc;

  GenericSender(this.sendFunc);
  @override
  Future<Either<LogError, void>> send(LoggMessage message) {
    return LogError.tryCatch(() => sendEndpoint(message, sendFunc));
  }

  @override
  Future<Response> sendEndpoint(
      LoggMessage message, SendEndpointFunc sendEndpointFunc) {
    return sendEndpointFunc(message);
  }
}
