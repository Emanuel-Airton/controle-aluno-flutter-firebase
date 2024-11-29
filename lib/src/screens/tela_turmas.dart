import 'package:controle_saida_aluno/src/utils/list_turmas.dart';
import 'package:controle_saida_aluno/src/widgets/Future_list_alunos.dart';
import 'package:controle_saida_aluno/src/widgets/dialog_cadastro.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TelaTurmas extends StatefulWidget {
  const TelaTurmas({super.key});

  @override
  State<TelaTurmas> createState() => _TelaTurmasState();
}

enum Turno { matutino, vespertino }

class _TelaTurmasState extends State<TelaTurmas> {
  List<String> lista = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i <= 20; i++) {
      String texto = 'valor ${[i]}';
      lista.add(texto);
    }
  }

  Dialog_cadastro dialog_cadastro = Dialog_cadastro();
  ListTurmas listTurmas = ListTurmas();
  int currentPageCarousel = 0;
  String nome = "sem nome";
  List _nova = [];
  String _primeiraTurma = "";
  String _nomeTurma = "";
  String _escolha = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ]),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 350) {
                      // Layout para telas estreitas
                      return Column(
                        children: [
                          RadioListTile(
                            title: const Text(
                              "Matutino",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: "Matutino",
                            groupValue: _escolha,
                            onChanged: (value) {
                              setState(() {
                                _escolha = value!;
                                _primeiraTurma = listTurmas.primeiraM;
                                _nomeTurma = _primeiraTurma;
                                _nova = listTurmas.turmasMatutino;
                              });
                            },
                          ),
                          RadioListTile(
                            title: const Text(
                              "Vespertino",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: "Vespertino",
                            groupValue: _escolha,
                            onChanged: (value) {
                              setState(() {
                                _escolha = value!;
                                _primeiraTurma =
                                    listTurmas.primeiraTurmaVespertino;
                                _nomeTurma = _primeiraTurma;
                                _nova = listTurmas.turmasVespertino;
                              });
                            },
                          ),
                        ],
                      );
                    } else {
                      // Layout para telas largas
                      return Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                "Matutino",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: "Matutino",
                              groupValue: _escolha,
                              onChanged: (value) {
                                setState(() {
                                  _escolha = value!;
                                  _primeiraTurma = listTurmas.primeiraM;
                                  _nomeTurma = _primeiraTurma;
                                  _nova = listTurmas.turmasMatutino;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                "Vespertino",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: "Vespertino",
                              groupValue: _escolha,
                              onChanged: (value) {
                                setState(() {
                                  _escolha = value!;
                                  _primeiraTurma =
                                      listTurmas.primeiraTurmaVespertino;
                                  _nomeTurma = _primeiraTurma;
                                  _nova = listTurmas.turmasVespertino;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  child: DropdownButtonFormField2(
                    value: _primeiraTurma,
                    hint: const Text("Selecione a turma"),
                    decoration: InputDecoration(
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 198, 0, 0), width: 3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: _nova.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: DropdownButtonHideUnderline(
                          child: Text(
                            e,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _primeiraTurma = value.toString();
                        _nomeTurma = _primeiraTurma;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          _nomeTurma.isEmpty
              ? Container()
              : Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child:
                      ListAlunosTurma(nomeTurma: _nomeTurma, escolha: _escolha),
                )),

          // child: ListAlunosTurma(nomeTurma: _nomeTurma, escolha: _escolha))
        ],
      ),
    );
  }
}
