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
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () async {
                        try {
                          await Firebaseclasse().excluirRegistroDeSaida(id);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: corSecundaria,
                              content: const Text(
                                  "Registro excluido com sucesso!")));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                        Navigator.pop(context);
                      },
                      label: const Text("apagar",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      label: const Text(
                        "cancelar",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                    ),
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
