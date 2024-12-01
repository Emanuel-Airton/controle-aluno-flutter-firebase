import 'package:controle_saida_aluno/src/screens/tela_dados.dart';
import 'package:controle_saida_aluno/src/screens/tela_inicial.dart';
import 'package:controle_saida_aluno/src/screens/tela_saidas.dart';
import 'package:controle_saida_aluno/src/screens/tela_turmas.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  //const HomePage({super.key});
  String? usuario;
  HomePage({super.key, this.usuario});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String tokenUser = "";
  String string = "";
  List<String> list = ["sair"];

  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  sair(String string) async {
    String valor = "sem valor";
    final user = await SharedPreferences.getInstance();
    user.setString('username', valor);
    String? nome = user.getString('username');
    if (string == "sair") {
      debugPrint('nome do usuario ao apertar o botao sair: $nome');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => TelaInicial(valorRecebido: valor)),
          (Route route) => false);
    }
  }

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            onSelected: sair,
            itemBuilder: (context) {
              return list.map((e) {
                return PopupMenuItem(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text(e), const Icon(Icons.logout)],
                    ));
              }).toList();
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("JASF - CONTROLE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
        centerTitle: true,
        bottom: TabBar(
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 6,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(
                  Icons.list,
                ),
                text: "Turmas",
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                ),
                text: "Saídas",
              ),
              Tab(
                icon: Icon(
                  Icons.data_usage_sharp,
                ),
                text: "Dados",
              ),
            ]),
      ),
      body: TabBarView(controller: _tabController, children: const [
        TelaTurmas(),
        //  TelaSaidas(),
        TelaSaidas(),
        TelaDados(),
      ]),
    );
  }
}
