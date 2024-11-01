import 'dart:convert';
import 'package:controle_saida_aluno/src/controllers/controllerAPI.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import '../models/clould_mensaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: camel_case_types
class Cloud_menssaging {
  ApiConsumer apiConsumer = ApiConsumer();

  enviarNotificacaoPush(Saida saida) async {
    dotenv.load(fileName: '.env');
    final apiKey = dotenv.env['API_KEY'];
    String mensagemSaida = ClouldMensagingModel.semDados().ToString(saida);

    final notification = ClouldMensagingModel(
        title: "Aluno liberado!",
        body: mensagemSaida,
        data: {"message": mensagemSaida},
        to: "/topics/users");

    Map<String, dynamic> map = notification.toJson();
    //print(map);
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$apiKey}',
    };

    await apiConsumer.post(url, header, jsonEncode(map)

        /*    jsonEncode(<String, dynamic>{
          "notification": {
            "title": "Aluno liberado!",
            "body": mensagemSaida,
          },
          "priority": "high",
          "data": {"message": mensagemSaida},
          "to": "/topics/users"
          //"to": "/topics/topic_portaria"
        })
        
        */
        );
  }
}
