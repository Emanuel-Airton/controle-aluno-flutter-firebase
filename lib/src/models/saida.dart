import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:intl/intl.dart';

class Saida extends Alunos {
  String? id;
  late String _serie;
  late String _motivo;
  late String _autorizacao;
  late Timestamp _data;

  Saida.semDados();

  set setId(id) => id;
  get getSerie => _serie;

  set setSerie(serie) => _serie = serie;

  get getMotivo => _motivo;

  set setMotivo(motivo) => _motivo = motivo;

  get getAutorizacao => _autorizacao;

  set setAutorizacao(autorizacao) => _autorizacao = autorizacao;

  get getData {
    DateTime data = _data.toDate();
    String dateFormat = DateFormat('dd/MM/yyyy').add_Hm().format(data);
    return dateFormat;
  }

  set setData(data) => _data = data;

  Saida(String nomeAluno, String telefone, this._serie, this._motivo,
      this._autorizacao, this._data,
      {this.id}) {
    setId = id;
    nome = nomeAluno;
    this.telefone = telefone;
    setSerie = _serie;
    setMotivo = _motivo;
    setAutorizacao = _autorizacao;
    setData = _data;
  }

  List<Saida> listarPordata(List<Saida> list, String valorRecebido) {
    List<Saida> listaSaida = [];
    for (var item in list) {
      Timestamp data = item._data;
      DateTime dateTime = data.toDate();
      if (periodoSelecionado(dateTime, valorRecebido)) {
        listaSaida.add(item);
      }
    }
    list.clear();
    return listaSaida;
  }

  bool periodoSelecionado(DateTime dateTime, String valorRecebido) {
    final dataAtual = DateTime.now();
    final difference = dataAtual.difference(dateTime).inDays;

    switch (valorRecebido) {
      case 'Últimos 7 dias':
        return difference <= 7;
      case 'Últimos 15 dias':
        return difference <= 15;
      case 'Últimos 30 dias':
        return difference <= 30;
      default:
        return true;
    }
  }

  Map<String, dynamic> map() {
    Map<String, dynamic> mapa = {
      "nome": nome,
      "telefone": telefone,
      "serie": _serie,
      "motivo": _motivo,
      "autorizacao": _autorizacao,
      "data": _data,
      "id": id,
    };
    return mapa;
  }
}
