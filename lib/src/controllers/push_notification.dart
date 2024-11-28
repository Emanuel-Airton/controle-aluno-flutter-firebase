import 'dart:convert';
import 'package:controle_saida_aluno/src/controllers/controllerAPI.dart';
import 'package:controle_saida_aluno/src/models/clould_mensaging.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  ApiConsumer apiConsumer = ApiConsumer();

  static Future<String> getServerAccessToken() async {
    final firebaseConfigRaw = dotenv.env['FIREBASE_CONFIG'];
    final Map<String, dynamic> firebaseConfig =
        await jsonDecode(firebaseConfigRaw!);
    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(firebaseConfig),
      scopes,
    );

    // Get Access Token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(firebaseConfig),
            scopes,
            client);
    client.close();

    return credentials.accessToken.data;
  }

  sendNotification(Saida saida) async {
    final String serverToken = await getServerAccessToken();
    final String mensagemSaida =
        ClouldMensagingModel.semDados().ToString(saida);
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/controle-saida-aluno/messages:send");

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $serverToken",
    };
    final notification = ClouldMensagingModel(
        title: 'Aluno liberado!',
        body: mensagemSaida,
        data: mensagemSaida,
        topic: "users");
    Map<String, dynamic> bodyNotification = notification.toJson();

    await apiConsumer.post(url, header, jsonEncode(bodyNotification));
  }
}
