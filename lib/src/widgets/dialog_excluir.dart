import 'package:controle_saida_aluno/src/components/ElevatedIconButtom.dart';
import 'package:controle_saida_aluno/src/components/snakbar.dart';
import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Dialog_excluir {
  Color corPadrao = const Color.fromARGB(255, 198, 0, 0);
  Color corSecundaria = const Color.fromARGB(255, 0, 0, 128);
  void dialogExcluir(BuildContext context, {var id}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Deseja apagar esse registro?",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ElevatedIconButtom(
                        color: Theme.of(context).colorScheme.primary,
                        iconData: Icons.delete,
                        texto: 'Apagar',
                        onpressed: () async {
                          try {
                            await Firebaseclasse().excluirRegistroDeSaida(id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBarWidget().snackbar(context, corSecundaria,
                                  'Registro excluido com sucesso!'),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                          Navigator.pop(context);
                        },
                      )),
                  ElevatedIconButtom(
                    color: Theme.of(context).colorScheme.secondary,
                    iconData: Icons.cancel,
                    texto: 'cancelar',
                    onpressed: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
          );
        });
  }

  final snackBarDelete =
      const SnackBar(content: Text("Registro excluido com sucesso!"));
}
