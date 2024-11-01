import 'package:controle_saida_aluno/src/utils/drop_down_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropDownEscolha {
  final List<String> items = [
    "Últimos 7 dias",
    "Últimos 15 dias",
    "Últimos 30 dias",
    "todo periodo"
  ];

  dropDownEscolha() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                spreadRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            shape: BoxShape.rectangle),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Registro de saídas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                  fontSize: 18,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red.shade800, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Consumer<DropDownState>(
                    builder: (context, dropDownState, child) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(enabled: false),
                        value: dropDownState.selectItem,
                        items: dropDownState.list.map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            dropDownState.updateSelectedItem(value);
                          }
                        },
                      );
                    },
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
