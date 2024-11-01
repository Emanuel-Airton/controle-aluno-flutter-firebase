import 'package:controle_saida_aluno/firebase_options.dart';
import 'package:controle_saida_aluno/src/screens/tela_inicial.dart';
import 'package:controle_saida_aluno/src/utils/drop_down_state.dart';
import 'package:controle_saida_aluno/src/utils/list_alunos_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: ((context) => DropDownState()),
    ),
    ChangeNotifierProvider(
      create: ((context) => ListAlunosState()),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            secondary: const Color.fromARGB(255, 0, 0, 128),
            seedColor: const Color.fromARGB(255, 198, 0, 0)),
        useMaterial3: true,
      ),
      home: TelaInicial(),
    );
  }
}
