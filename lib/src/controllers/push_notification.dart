import 'dart:convert';
import 'package:controle_saida_aluno/src/controllers/controllerAPI.dart';
import 'package:controle_saida_aluno/src/models/clould_mensaging.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  ApiConsumer apiConsumer = ApiConsumer();

  Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    // debugPrint("Device Token: $token");
  }

  static Future<String> getServerAccessToken() async {
    final firebaseConfigRaw = dotenv.env['FIREBASE_CONFIG'];
    final Map<String, dynamic> firebaseConfig =
        await jsonDecode(firebaseConfigRaw!);
    //  debugPrint('Firebase Project ID:  ${firebaseConfig.toString()}');

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

    //  debugPrint("log server access token: ${credentials.accessToken.data}");

    return credentials.accessToken.data;
  }

  enviarNotificacao(Saida saida) async {
    final String serverToken = await getServerAccessToken();
    final String mensagemSaida =
        ClouldMensagingModel.semDados().ToString(saida);
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/controle-saida-aluno/messages:send");

    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $serverToken",
    };

    final Map<String, dynamic> bodyMessage = {
      'message': {
        "notification": {
          "title": "Aluno Liberado!",
          "body": mensagemSaida,
        },
        "data": {
          "extraData":
              mensagemSaida // Você pode passar qualquer dado extra aqui
        },
        "android": {"priority": "high"},
        "topic":
            "users" // Certifique-se que os usuários estão inscritos neste tópico
      },
    };
    /*  final Map<String, dynamic> bodyMessage = {
      "message": {
        "topic": "users",
        "notification": {
          "body": "This week's edition is now available.",
          "title": "NewsMagazine.com",
        },
        "data": {
          "volume": "3.21.15",
          "contents": "http://www.news-magazine.com/world-week/21659772"
        },
        "android": {"priority": "high"},
        "apns": {
          "headers": {"apns-priority": "5"}
        },
        "webpush": {
          "headers": {"Urgency": "high"}
        }
      }
    };*/
    await apiConsumer.post(url, header, jsonEncode(bodyMessage));
  }
}
