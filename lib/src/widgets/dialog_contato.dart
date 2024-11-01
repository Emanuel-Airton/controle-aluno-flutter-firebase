import 'package:controle_saida_aluno/src/models/alunos.dart';
import 'package:controle_saida_aluno/src/utils/urlLauncherService%20.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

// ignore: camel_case_types
class Dialog_contato {
  Color corPadrao = const Color.fromARGB(255, 198, 0, 0);
  Color corSecundaria = const Color.fromARGB(255, 0, 0, 128);
  dialogTelefone(BuildContext context, Alunos alunos) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                    //   border: Border.all(color: corPadrao, width: 3),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/logoJASF.png', height: 50),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                        child: Text("Comunicar responsável",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: corSecundaria),
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          // padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer),
                              borderRadius: BorderRadius.circular(5)),
                          child: Table(
                            border: TableBorder(
                                horizontalInside: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer),
                                verticalInside: BorderSide(
                                    width: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .errorContainer)),
                            columnWidths: const {
                              0: FlexColumnWidth(1.1),
                              1: FlexColumnWidth(4)
                            },
                            children: [
                              TableRow(children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, bottom: 5),
                                    child: Icon(
                                      Icons.person,
                                      color: corSecundaria,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    alunos.nome,
                                    style: TextStyle(
                                        fontSize: 14, color: corSecundaria),
                                  ),
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 5, bottom: 5),
                                    child: Icon(
                                      Icons.phone,
                                      color: corSecundaria,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    alunos.telefone,
                                    style: TextStyle(
                                        fontSize: 16, color: corSecundaria),
                                  ),
                                )
                              ])
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: corPadrao),
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      UrlLauncherService().fazerLigacao(alunos.telefone);
                    },
                    label: const Text(
                      "Ligar",
                      style: TextStyle(color: Colors.white),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton.icon(
                      icon: const Icon(
                        SimpleIcons.whatsapp,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: corSecundaria),
                      // backgroundColor: MaterialStatePropertyAll(Colors.green)
                      onPressed: () {
                        UrlLauncherService()
                            .enviarMensagem(alunos.telefone, alunos.nome);
                      },
                      label: const Text("WhatsApp",
                          style: TextStyle(color: Colors.white))),
                )
              ],
            ),
          );
        });
  }
}
