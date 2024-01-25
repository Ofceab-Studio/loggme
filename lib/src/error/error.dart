import 'dart:convert';

import 'package:dartz/dartz.dart';

abstract class LogError {
  /// Error that occured
  String get error;

  static Future<Either<LogError, T>> tryCatch<T>(T Function() fn) async {
    try {
      return right(await fn());
    } catch (e, stackTrace) {
      if (e is LogError) {
        return left(e);
      }
      return left(GenericeError(e.toString(), stackTrace.toString()));
    }
  }
}

class GenericeError implements LogError {
  final String message;
  final String stackTrace;
  GenericeError(this.message, this.stackTrace);

  @override
  String get error => jsonEncode({'error': message, 'stackTrace': stackTrace});
}
