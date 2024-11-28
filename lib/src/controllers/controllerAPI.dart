import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiConsumer {
  post(Uri url, Map<String, String>? map, Object? bodyObj) async {
    final response = await http.post(url, headers: map, body: bodyObj);
    if (response.statusCode == 200) {
      debugPrint("Notificação enviada com sucesso.");
    } else {
      debugPrint("falha ao enviar notificação:${response.statusCode}");
    }
    return jsonDecode(response.body);
  }
}
