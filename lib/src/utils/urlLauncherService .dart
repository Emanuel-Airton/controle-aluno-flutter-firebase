import 'package:controle_saida_aluno/src/models/saida.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  fazerLigacao(String telefone) async {
    if (await canLaunchUrl(Uri.parse('tel:$telefone'))) {
      await launchUrl(Uri.parse('tel:$telefone'));
    } else {
      throw 'Não foi possível iniciar $telefone';
    }
  }

  enviarMensagem(String telefone, String nomeAluno) async {
    String texto =
        "Olá,tudo bem? Aqui é a direção do Colégio Municipal Joaquim Alexandre, estou falando com o responsável pelo(a) aluno(a) $nomeAluno ?";
    var whatsappUrl = "whatsapp://send?phone=$telefone&text=$texto";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Não foi possível iniciar $whatsappUrl';
    }
  }

  enviarNotificacaoResponsavel(Saida saida) async {
    String nome = saida.nome;
    String motivo = saida.getMotivo;
    String autorizacao = saida.getAutorizacao;
    // String data = saida.data;
    const int numeroEscola = 77999651129;

    String mensagemSaida = "Colégio Municipal Joaquim Alexandre da Silva Filho"
        "\n\n           Aviso da Direção/Coordenação"
        "\n\nPrezados Pais ou Responsáveis, Gostaríamos de informar que o aluno mencionado abaixo foi liberado da escola:"
        "\n\n -- Nome do aluno: $nome"
        "\n -- Motivo da saída: $motivo"
        "\n -- Saída Autorizada por: $autorizacao"
        "\n -- Data e horário de liberação: ${saida.getData}"
        "\n\nEm caso de dúvidas ou necessidade de mais informações, não hesite em entrar em contato conosco pelo telefone $numeroEscola ou diretamente com a direção do colégio."
        "\n\nAtenciosamente,"
        "\n\n$autorizacao"
        "\nDireção/Coordenação";
    String telefone = saida.telefone;
    // var dados = jsonDecode(mensagemSaida);
    String whatsappUrl = "whatsapp://send?phone=$telefone&text=$mensagemSaida";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Não foi possível iniciar $whatsappUrl';
    }
  }
}
