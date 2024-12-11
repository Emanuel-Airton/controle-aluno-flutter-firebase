import 'package:controle_saida_aluno/home.dart';
import 'package:controle_saida_aluno/src/screens/tela_portaria.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  List<String>? listaUsuarios;
  String? valorRecebido;
  Login({super.key, this.listaUsuarios, this.valorRecebido});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? recebeNomeUsuario;
  String? nomeUsuario;
  static const String userSemValor = "sem valor";
  static const String userDirecao = "direção/coordenação";
  static const String userPortaria = "portaria";

  Future<void> login() async {
    final userActions = {
      userDirecao: navigateToHomePage,
      userPortaria: navigateToPortariaPage,
    };

    if (userActions.containsKey(nomeUsuario)) {
      userActions[nomeUsuario]?.call();
    } else if (nomeUsuario == userSemValor) {
      nomeUsuario = userSemValor;
    }
  }

  void navigateToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage(usuario: nomeUsuario)),
      ModalRoute.withName('/'),
    );
  }

  void navigateToPortariaPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaPortaria()),
      ModalRoute.withName('/'),
    );
  }

  Future<void> loadPreferences() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      setState(() {
        if (widget.valorRecebido == userSemValor) {
          nomeUsuario = widget.valorRecebido;
          preferences.setString('username', nomeUsuario!);
        } else {
          nomeUsuario = preferences.getString('username') ?? userSemValor;
        }
      });
      await login();
    } catch (e) {
      ArgumentError("Erro ao carregar preferências: $e");
    }
  }

  List<String> listaRecebeUsuarios = [];
  @override
  void initState() {
    // TODO: implement initState
    loadPreferences();
    listaRecebeUsuarios = widget.listaUsuarios!;
    super.initState();
  }

  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(255, 198, 0, 0),
              Color.fromARGB(255, 0, 0, 128),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              Image.asset(
                'assets/logoJASF.png',
                height: 120,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 70),
                child: Container(
                  //height: 220,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(10),
                  //color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "JASF - Controle de alunos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Form(
                          key: key,
                          child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 3),
                                borderRadius: BorderRadius.circular(20),
                              )),
                              hint: const Text("Selecione o usuario"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'selecione uma opção';
                                }
                                return null;
                              },
                              isExpanded: true,
                              items: listaRecebeUsuarios.map((String item) {
                                return DropdownMenuItem(
                                    value: item, child: Text(item));
                              }).toList(),
                              value: recebeNomeUsuario,
                              onChanged: (String? selecionado) {
                                setState(() {
                                  recebeNomeUsuario = selecionado!;
                                  nomeUsuario = recebeNomeUsuario;
                                });
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor:
                                    const Color.fromARGB(255, 198, 0, 0),
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () async {
                              if (key.currentState!.validate()) {
                                final pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('username', nomeUsuario!);
                                await login();
                              }
                            },
                            child: const Text(
                              "Entrar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
