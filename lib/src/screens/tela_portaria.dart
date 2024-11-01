import 'package:controle_saida_aluno/src/controllers/controllerFCM.dart';
import 'package:controle_saida_aluno/src/widgets/dropDownEscolha.dart';
import 'package:controle_saida_aluno/src/widgets/stream_list_saidas.dart';
import 'package:controle_saida_aluno/src/screens/tela_inicial.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaPortaria extends StatefulWidget {
  const TelaPortaria({super.key});

  @override
  State<TelaPortaria> createState() => _TelaPortariaState();
}

class _TelaPortariaState extends State<TelaPortaria> {
  List<String> list = ["sair"];
  String userPortaria = "portaria";
/*
  void _configureFCMListeners() async {
    await FirebaseMessaging.instance
        .requestPermission(
            alert: true, sound: true, badge: true, provisional: false)
        .then((permissao) {
      if (permissao.authorizationStatus == AuthorizationStatus.authorized) {
        // print("Permissão concedida ao usuario: ${permissao.authorizationStatus}");
        FirebaseMessaging.instance.subscribeToTopic('topic_portaria');
      } else {
        print("permissão negada: " + permissao.authorizationStatus.toString());
      }
      return permissao;
    });
    // Manipula mensagens de dados recebidas quando o aplicativo está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Map<String, dynamic> map = message.data;
      //String data = map["message"];
      _lidarComMensagem(message);
      //  print("Mensagem de dados recebida: ${message.data} ");
      // Extrai dados e executar ações personalizadas
    });
    // Trata a mensagem de dados recebida quando o aplicativo está em segundo plano ou finalizado
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //print("Data message open: ${message.data} ");
      _lidarComMensagem(message);
    });

    //Se o aplicativo for aberto a partir de um estado finalizado, este método retornará um Future contendo um RemoteMessage
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Dialog_fcm(remoteMessage: message);
        //_lidarComMensagem(message);
      }
    });
  }

  _lidarComMensagem(RemoteMessage message) {
    Map<String, dynamic> map = message.data;
    if (map.isNotEmpty) {
      Dialog_fcm(remoteMessage: message);
      // dialog(context, message);
    }
  }*/

  dialog(BuildContext context, RemoteMessage remoteMessage) {
    Map<String, dynamic> map = remoteMessage.data;
    var dados = map["message"];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Aluno liberado!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(dados)],
            ),
          );
        });
  }

  sair(String string) async {
    String valor = "sem valor";
    final user = await SharedPreferences.getInstance();
    user.setString('username', valor);
    String? nome = user.getString('username');
    //  print(string);
    if (string == "sair") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TelaInicial(valorRecebido: valor)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //   _configureFCMListeners();
    // ControllerFCM();
    ControllerFCM(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(
                iconColor: Colors.white,
                onSelected: sair,
                itemBuilder: (context) => list.map((e) {
                      return PopupMenuItem(value: e, child: Text(e));
                    }).toList())
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Portaria",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropDownEscolha().dropDownEscolha(),
            SaidaStream(user: userPortaria)
          ],
        ));
  }
}
