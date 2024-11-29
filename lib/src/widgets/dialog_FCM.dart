import 'package:controle_saida_aluno/src/components/ElevatedIconButtom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Dialog_fcm {
  static Color corPadrao = const Color.fromARGB(255, 198, 0, 0);
  static Color corSecundaria = const Color.fromARGB(255, 0, 0, 128);

  static void show(BuildContext context, RemoteMessage remoteMessage) {
    Map<String, dynamic> map = remoteMessage.data;
    var dados = map["extraData"];
    //debugPrint('remote message: ${map.toString()}');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: corPadrao, width: 3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Image.asset('assets/logoJASF.png', height: 60),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Aluno liberado!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: corPadrao,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Text(
              dados,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedIconButtom(
                  color: corSecundaria,
                  iconData: Icons.close,
                  texto: 'Ok, fechar',
                  onpressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
