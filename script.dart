import 'dart:io';

final ofceab = "@ofceab";
final sacko = "@sackoBA";
final david = "@david";
final yayahc = "@yayahc";

Map<String, dynamic> generateError() {
  return {
    'devMessage': "User with id 0 doesn't exist",
    'userFriendlyMessage': "Utilisateur non trouver",
  };
}

String getBaseErrorMessage() {
  return "Oops une erreur c'est produite sur le serveur 😢\nPensez a y j'etter un coup 👀 $ofceab - $sacko - $david - $yayahc";
}

Future<List<String>> getSecrets() async {
  final secrets = File('.secrets').readAsLines();
  return secrets;
}
