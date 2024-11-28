import 'package:controle_saida_aluno/src/models/saida.dart';

class ClouldMensagingModel {
  late final String title;
  late final String body;
  late final String priority;
  late final String data;
  late final String topic;

  ClouldMensagingModel(
      {required this.title,
      required this.body,
      this.priority = 'high',
      required this.data,
      required this.topic});

  ClouldMensagingModel.semDados();
  Map<String, dynamic> toJson() {
    return {
      "message": {
        "topic": topic,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {"extraData": data},
        "android": {"priority": priority},
      }
    };
  }

  String ToString(Saida saida) {
    String mensagemSaida =
        "Nome do aluno: ${saida.nome} \nTurma: ${saida.getSerie} \nMotivo da saída: ${saida.getMotivo} \nSaída autorizada por: ${saida.getAutorizacao} \nData e horário de saída: ${saida.getData}";
    return mensagemSaida;
  }
}
