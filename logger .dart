import 'dart:async';

import 'script.dart';
import 'sender.dart';

Future<void> main() async {
  print("Start logger ...");
  final error = generateError();
  final secrets = await getSecrets();
  final token = secrets[0];
  final chatId = secrets[1];
  await sendErrorToTelegram(error, chatId, token);
}
