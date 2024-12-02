import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_saida_aluno/src/components/ElevatedIconButtom.dart';
import 'package:controle_saida_aluno/src/components/snakbar.dart';
import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:controle_saida_aluno/src/utils/list_turmas.dart';
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
  ListTurmas listTurmas = ListTurmas();
  String primeiraAutorizacao = "Sandrileuza";
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
      //  escolhaUsuario = escolha;
      controller3.text = nomeTurma;
      primeiraTurma = nomeTurma;
      telefone = alunos.telefone;
      if (escolha == "Matutino") {
        nova = listTurmas.turmasMatutino;
      } else {
        nova = listTurmas.turmasVespertino;
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
                                  items:
                                      listTurmas.autorizacao.map((String item) {
                                    return DropdownMenuItem(
                                        value: item, child: Text(item));
                                  }).toList(),
                                  onChanged: (String? itemSelecionado) {
                                    setState(() {
                                      primeiraAutorizacao = itemSelecionado!;

                                      controller5.text = primeiraAutorizacao;
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
                  ElevatedIconButtom(
                      color: corSecundaria,
                      iconData: Icons.save,
                      onpressed: () {
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
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarWidget().snackbar(context, corPadrao,
                                  'Aluno ${controller1.text} liberado com sucesso'));
                          Navigator.pop(context);
                          limpar();
                        }
                      },
                      texto: 'Salvar'),
                  ElevatedIconButtom(
                    color: corPadrao,
                    iconData: Icons.cancel,
                    texto: 'Cancelar',
                    onpressed: () {
                      Navigator.pop(context);
                      limpar();
                    },
                  )
                ],
              )
            ],
          );
        });
  }

  limpar() {
    controller1.clear();
    //escolhaUsuario = "";
    escolhaUsuario2 = "";
    nova = [];
    listTurmas.primeiroMotivo = "dor de cabeça";
    primeiraAutorizacao = "Sandrileuza";
    controller5.clear();
    controller6.clear();
  }
}
