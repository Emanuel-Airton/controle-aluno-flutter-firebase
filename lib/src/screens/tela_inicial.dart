import "package:cloud_firestore/cloud_firestore.dart";
import "package:controle_saida_aluno/home.dart";
import "package:controle_saida_aluno/src/screens/login.dart";
import "package:controle_saida_aluno/src/screens/tela_portaria.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:rive/rive.dart";
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;
import "package:shared_preferences/shared_preferences.dart";

class TelaInicial extends StatefulWidget {
  //const TelaInicial({super.key});
  String? valorRecebido;
  TelaInicial({super.key, this.valorRecebido});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial>
    with SingleTickerProviderStateMixin {
  int duracao = 3000;

  List<String> userTypeList = [];

  Future<List<String>> fetchUserTypes() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection("usuario").get();
      for (DocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data.containsKey('tipo')) {
          userTypeList.add(data["tipo"]);
        }
      }
    } catch (e) {
      ArgumentError('Error fetching user types: $e');
    }
    return userTypeList;
  }

  carregarUsuario() async {
    final preferences = await SharedPreferences.getInstance();
    String nomeUsuario = preferences.getString('username') ?? 'sem usuario';
    debugPrint('nome de usuario: $nomeUsuario');
    if (nomeUsuario == 'direção/coordenação') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(usuario: nomeUsuario)),
        ModalRoute.withName('/'),
      );
    } else if (nomeUsuario == 'portaria') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TelaPortaria()),
        ModalRoute.withName('/'),
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    listaUsuarios: userTypeList,
                    valorRecebido: widget.valorRecebido,
                  )));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    fetchUserTypes();

    Duration duration = Duration(milliseconds: duracao);
    Future.delayed(duration).then((value) => carregarUsuario());
    super.initState();
    //print("duração: " + duration.toString());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 0, 0),
      body: Container(
        decoration: const BoxDecoration(
            gradient: gradient.LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
              Color.fromARGB(255, 198, 0, 0),
              Color.fromARGB(255, 0, 0, 128),
            ])),
        child: Center(
            child: CircularPercentIndicator(
          radius: 100,
          animation: true,
          lineWidth: 7,
          progressColor: const Color.fromARGB(255, 0, 0, 128),
          backgroundColor: Colors.white,
          percent: 1.0,
          animationDuration: duracao,
          footer: const Text(
            "Aguarde...",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          center: const RiveAnimation.asset('assets/new_file.riv'),
        )),
      ),
    );
  }
}
