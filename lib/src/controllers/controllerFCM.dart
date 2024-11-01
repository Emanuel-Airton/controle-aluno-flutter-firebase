import 'package:controle_saida_aluno/src/controllers/push_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:controle_saida_aluno/src/widgets/dialog_FCM.dart';
import 'package:flutter/material.dart';

class ControllerFCM {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final PushNotificationService _pushNotificationService =
      PushNotificationService();
  static const String topic = "users";

  ControllerFCM(BuildContext context) {
    configureFCMListeners(context);
  }

  void configureFCMListeners(BuildContext context) async {
    await firebaseMessaging
        .requestPermission(
      alert: true,
      sound: true,
      badge: true,
    )
        .then((NotificationSettings permission) {
      if (permission.authorizationStatus == AuthorizationStatus.authorized) {
        firebaseMessaging.subscribeToTopic(topic);
        /*  firebaseMessaging.getToken().then(
          (token) {
            debugPrint('token do dispositivo: $token');
            _pushNotificationService.sendNotification(
              deviceToken: token!,
              message: 'olá mundo!',
            );
          },
        );*/
        debugPrint(
            "permissao concedida: ${permission.authorizationStatus.name}");
      } else {
        debugPrint(
            "permissao negada: ${permission.authorizationStatus.toString()}");
      }
    });
    _firstPlaneNotification(context);
    _secondPlaneOrFinishNotification(context);
    _futureNotification(context);
  }

  // Manipula mensagens de dados recebidas quando o aplicativo está em primeiro plano
  _firstPlaneNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      _lidarComMensagem(context, remoteMessage);
    });
  }

  // Trata a mensagem de dados recebida quando o aplicativo está em segundo plano ou finalizado
  _secondPlaneOrFinishNotification(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      _lidarComMensagem(context, remoteMessage);
    });
  }

  //Se o aplicativo for aberto a partir de um estado finalizado, este método retornará um Future contendo um RemoteMessage
  _futureNotification(BuildContext context) {
    firebaseMessaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        _lidarComMensagem(context, remoteMessage);
      }
    });
  }

  _lidarComMensagem(BuildContext context, RemoteMessage message) {
    Map<String, dynamic> map = message.data;
    if (map.isNotEmpty) {
      return Dialog_fcm.show(context, message);
      // dialog(context, message);
    }
  }
}
