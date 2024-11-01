import 'dart:async';
import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:controle_saida_aluno/src/screens/tela_alunos_deficientes.dart';
import 'package:controle_saida_aluno/src/screens/tela_lista_alunos_turmas.dart';
import 'package:controle_saida_aluno/src/screens/tela_quantidade_alunos_turma.dart';
import 'package:controle_saida_aluno/src/firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FutureDataWidget extends StatelessWidget {
  final Future<Map<String, int>> future;
  final Future<List<Map<String, dynamic>>> quantidade;
  FutureDataWidget({required this.future, required this.quantidade});
  int quantidadeTotalAlunos = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) => FutureBuilder<Map<String, int>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Erro ao carregar",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.primary),
            ));
          }
          Map<String, int> quantidadeAlunos = snapshot.data!;
          int quantidadeTotalAlunos =
              quantidadeAlunos.values.fold(0, (sum, val) => sum + val);
          return Column(
            children: [
              SizedBox(
                height: height * 0.2,
                width: constraints.maxWidth,
                child: ListView.builder(
                  //physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: quantidadeAlunos.length,
                  itemBuilder: (context, index) {
                    String turno = quantidadeAlunos.keys.elementAt(index);
                    int quantidadeAlunosTurno = quantidadeAlunos[turno]!;

                    //  print(quantidadeTotalAlunos.toString());
                    double containerWidth = constraints.maxWidth * 0.9;
                    if (containerWidth > 170) containerWidth = 170;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: width * 0.43,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ]),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TelaAunosTurma(turno: turno))),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        turno,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/aula_em_grupo.png',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                          ),
                                          Text(
                                            "$quantidadeAlunosTurno",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "alunos",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuantidadeAlunosTurma()));
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  height: height * 0.10,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ]),
                  child: Container(
                    //  padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    // color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total de alunos:",
                          style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          quantidadeTotalAlunos.toString(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //Text(quantidadeTotalAlunos.toString())
            ],
          );
        },
      ),
    );
  }
}

class TelaDados extends StatefulWidget {
  const TelaDados({super.key});

  @override
  State<TelaDados> createState() => _TelaDadosState();
}

class _TelaDadosState extends State<TelaDados> {
  late Future<Map<String, int>> futureQuantidadeAlunos;
  late Future<List<Map<String, dynamic>>> futureUltimasSaidas;
  late Future<List<Map<String, dynamic>>> quantidadeTurmas;
  late Future<List<Map<String, dynamic>>> alunosDeficientes;
  late Stream stream;
  @override
  void initState() {
    super.initState();
    alunosDeficientes = Firebaseclasse().listarAlunosDeficientes();
    // futureUltimasSaidas = Firebaseclasse().retornarUltimasTresSaidas();
    stream = Firebaseclasse().retornarUltimasTresSaidasComoStream();
    futureQuantidadeAlunos =
        Firebaseclasse().calcularQuantidadeAlunosPorTurno();
    quantidadeTurmas = Firebaseclasse().calcularQuantidadePorTurma();
  }

  List<int> listCurrentPageIndcator = [1, 2, 3];
  List<Widget> map<Widget>(List list, Function funcao) {
    List<Widget> listavazia = [];
    for (var i = 0; i < list.length; i++) {
      listavazia.add(funcao(i));
    }
    return listavazia;
  }

  int indice = 0;
  TextStyle estilo = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: Color.fromARGB(255, 198, 0, 0));
  TextStyle estilo2 = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 198, 0, 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Erro ao carregar dados");
                  }
                  List dados = snapshot.data;
                  return CarouselSlider(
                    items: dados.map((e) {
                      Saida saida = Saida(e["nome"], e["telefone"], e["serie"],
                          e["motivo"], e["autorizacao"], e["data"]);
                      return Builder(builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                              child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Image.asset("assets/logoJASF.png",
                                      height: 35),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade300)),
                                    child: Table(
                                      border: TableBorder(
                                          horizontalInside: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade300,
                                          ),
                                          verticalInside: BorderSide(
                                              width: 1,
                                              color: Colors.grey.shade300)),
                                      columnWidths: const {
                                        0: FlexColumnWidth(2.5),
                                        1: FlexColumnWidth(4),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 5),
                                              child: Text(
                                                'Nome',
                                                style: estilo2,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 8),
                                              child: Text(
                                                saida.nome,
                                                style: estilo,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 5),
                                              child: Text(
                                                'turma',
                                                style: estilo2,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 8),
                                              child: Text(
                                                saida.getSerie,
                                                style: estilo,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5),
                                            child:
                                                Text("motivo", style: estilo2),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 8),
                                            child: Text(
                                              saida.getMotivo,
                                              style: estilo,
                                            ),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5),
                                            child: Text("autorização",
                                                style: estilo2),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 8),
                                            child: Text(saida.getAutorizacao,
                                                style: estilo),
                                          )
                                        ]),
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, top: 5),
                                            child:
                                                Text("horario", style: estilo2),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 8),
                                            child: Text(saida.getData,
                                                style: estilo),
                                          )
                                        ]),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                        );
                      });
                    }).toList(),
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 2000),
                      height: MediaQuery.of(context).size.height * 0.25,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          indice = index;
                        });
                      },
                    ),
                  );
                }),
            //SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: listCurrentPageIndcator.asMap().entries.map((entry) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    color: indice == entry.key
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            FutureDataWidget(
              future: futureQuantidadeAlunos,
              quantidade: quantidadeTurmas,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TelaAlunosDeficientes(list: alunosDeficientes)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wheelchair_pickup,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                    Text(
                      "Alunos Especiais",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
