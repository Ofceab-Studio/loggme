import 'dart:convert';
import 'package:http/http.dart' as http;
import 'script.dart';

Future<void> sendErrorToTelegram(
    Map<String, dynamic> error, String chatId, String token) async {
  final errorJ = json.encode(error);
  final query = "text=```\n$errorJ\n```&&chat_id=$chatId&parse_mode=MarkdownV2";
  await sendBaseError(chatId, token);
  await sendMessage(query, token);
}

Future<void> sendBaseError(String chatId, String token) async {
  final baseError = getBaseErrorMessage();
  final query = "text=$baseError&&chat_id=$chatId";
  await sendMessage(query, token);
}

Future<void> sendMessage(String query, String token) async {
  final uri = "https://api.telegram.org/bot$token/sendMessage?$query";
  await http.post(Uri.parse(uri));
}
