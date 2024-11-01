import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Dialog_cadastro {
  String escolhaUsuario = "";
  String escolhaUsuario2 = "";
  Color corSecundaria = const Color.fromARGB(255, 198, 0, 0);
  Color corPadrao = const Color.fromARGB(255, 0, 0, 128);

  List<String> nova = [];
  String primeiraTurma = "";
  List<String> turmasM = [
    "6º A matutino",
    "6º B matutino",
    "7º A matutino",
    "7º B matutino",
    "8º A matutino",
    "8º B matutino",
    "9º A matutino",
    "9º B matutino",
    "9º C matutino"
  ];
  String primeiraM = "6º A matutino";
  List<String> turmasV = [
    "6º A vespertino",
    "6º B vespertino",
    "6º C vespertino",
    "7º A vespertino",
    "7º B vespertino",
    "7º C vespertino",
    "8º A vespertino",
    "8º B vespertino",
    "9º A vespertino"
  ];
  String primeiraV = "6º A vespertino";

  var primeiroMotivo = "dor de cabeça";

  List<String> autorizacao = [
    "Sandrileuza",
    "Edeezio",
    "Valdicelia",
  ];
  String primeiraAut = "Rosa";
  String telefone = "";

  //List<Anotacao> lista = Firebaseclasse().listar();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Widget> children = <Widget>[];
  void dialogInserir(BuildContext context,
      {Alunos? alunos, String? escolha, String? nomeTurma}) {
    //String nomeAluno = "Nome do aluno";
    if (alunos != null && escolha != null && nomeTurma != null) {
      controller1.text = alunos.nome;
      escolhaUsuario = escolha;
      controller3.text = nomeTurma;
      primeiraTurma = nomeTurma;
      telefone = alunos.telefone;
      if (escolha == "Matutino") {
        nova = turmasM;
      } else {
        nova = turmasV;
      }
    }
    String texto = "Nova saída de aluno";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/logoJASF.png', height: 30),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(texto,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: corPadrao),
                                    textAlign: TextAlign.center),
                              ),
                              Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(alunos!.nome)),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text('Turma: $primeiraTurma')),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: TextFormField(
                                  autofocus: true,
                                  controller: controller4,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: corSecundaria,
                                    )),
                                    labelText: "Motivo da saída",
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Digite o motivo!';
                                    }
                                    return null;
                                  },
                                  //value: primeiroMotivo,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: corSecundaria),
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  isExpanded: true,
                                  hint: const Text("Autorização"),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Selecione quem autorizou a saída!';
                                    }
                                    return null;
                                  },
                                  //value: primeiraAut,
                                  items: autorizacao.map((String item) {
                                    return DropdownMenuItem(
                                        value: item, child: Text(item));
                                  }).toList(),
                                  onChanged: (String? itemSelecionado) {
                                    setState(() {
                                      primeiraAut = itemSelecionado!;

                                      controller5.text = primeiraAut;
                                      //   print("controller 5: ${controller5.text}");
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 37,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            actions: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Timestamp timeNow = Timestamp.now();

                        Saida anotacao = Saida(
                            alunos?.nome,
                            alunos?.telefone,
                            controller3.text,
                            controller4.text,
                            controller5.text,
                            //"10/04/2024 10:35"
                            timeNow);
                        Firebaseclasse().inserir(anotacao);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: corPadrao,
                            content: Text(
                              "Aluno(a) ${controller1.text} liberado com sucesso!",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )));
                        Navigator.pop(context);
                        limpar();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: corSecundaria,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    label: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        //  print(dat.toString());
                        Navigator.pop(context);
                        limpar();
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          backgroundColor: corPadrao,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      label: const Text(
                        "cancelar",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                ],
              )
            ],
          );
        });
  }

  limpar() {
    controller1.clear();
    escolhaUsuario = "";
    escolhaUsuario2 = "";
    nova = [];
    primeiroMotivo = "dor de cabeça";
    primeiraAut = "Rosa";
    controller5.clear();
    controller6.clear();
  }
}