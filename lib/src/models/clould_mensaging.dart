import 'package:controle_saida_aluno/src/models/saida.dart';

class ClouldMensagingModel {
  late final String title;
  late final String body;
  late final String priority;
  late final Map<String, String> data;
  late final String to;

  ClouldMensagingModel(
      {required this.title,
      required this.body,
      this.priority = 'high',
      required this.data,
      required this.to});

  ClouldMensagingModel.semDados();
  Map<String, dynamic> toJson() {
    return {
      "notification": {
        "title": title,
        "body": body,
      },
      "priority": priority,
      'data': data,
      "to": to
    };
  }

  String ToString(Saida saida) {
    String mensagemSaida =
        "Nome do aluno: ${saida.nome} \nTurma: ${saida.getSerie} \nMotivo da saída: ${saida.getMotivo} \nSaída autorizada por: ${saida.getAutorizacao} \nData e horário de saída: ${saida.getData}";
    return mensagemSaida;
  }
}
