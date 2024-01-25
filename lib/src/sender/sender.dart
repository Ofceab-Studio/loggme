import 'package:dartz/dartz.dart';

import '../error/error.dart';
import '../formatters/log_message.dart';

abstract class Sender {
  /// Call this method to send your logs
  Future<Either<LogError, void>> send(LoggMessage message);
}
