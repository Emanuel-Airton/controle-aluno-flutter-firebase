import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:controle_saida_aluno/src/utils/urlLauncherService%20.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

// ignore: camel_case_types
class Dialog_list {
  Color corPadrao = const Color.fromARGB(255, 198, 0, 0);
  Color corSecundaria = const Color.fromARGB(255, 0, 0, 128);
  TextStyle estiloTexto = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 0, 0, 128));
  TextStyle estiloTexto2 =
      const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 128));
  dialogList(BuildContext context, Saida saida, {String? usuario}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logoJASF.png', height: 60),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                    child: Text("Registro de saída",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: corSecundaria),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .errorContainer)),
                      child: Table(
                        border: TableBorder(
                            horizontalInside: BorderSide(
                              width: 2,
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                            ),
                            verticalInside: BorderSide(
                              width: 2,
                              color:
                                  Theme.of(context).colorScheme.errorContainer,
                            )),
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(6)
                        },
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Aluno(a) ",
                                  textAlign: TextAlign.center,
                                  style: estiloTexto),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(saida.nome,
                                  textAlign: TextAlign.center,
                                  style: estiloTexto2),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Turma",
                                  textAlign: TextAlign.center,
                                  style: estiloTexto),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(saida.getSerie,
                                  textAlign: TextAlign.center,
                                  style: estiloTexto2),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Motivo",
                                  textAlign: TextAlign.center,
                                  style: estiloTexto),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(saida.getMotivo,
                                  textAlign: TextAlign.center,
                                  style: estiloTexto2),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Autorização",
                                  textAlign: TextAlign.center,
                                  style: estiloTexto),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(saida.getAutorizacao,
                                  textAlign: TextAlign.center,
                                  style: estiloTexto2),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text("Data/horário de saída",
                                  textAlign: TextAlign.center,
                                  style: estiloTexto),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(saida.getData,
                                  textAlign: TextAlign.center,
                                  style: estiloTexto2),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    usuario == "portaria"
                        ? Container()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: corPadrao,
                                minimumSize: const Size.fromHeight(50)),
                            onPressed: () {
                              UrlLauncherService()
                                  .enviarNotificacaoResponsavel(saida);
                              Navigator.pop(context);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text(
                                    "Informar o responsável",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Icon(
                                  SimpleIcons.whatsapp,
                                  color: Colors.white,
                                )
                              ],
                            )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor: corSecundaria,
                              minimumSize: const Size.fromHeight(50)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ok, fechar",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.close, color: Colors.white)
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
