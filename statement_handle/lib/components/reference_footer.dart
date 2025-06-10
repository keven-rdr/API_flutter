import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferenceFooter extends StatelessWidget {
  const ReferenceFooter({Key? key}) : super(key: key);

  // URL do seu perfil no GitHub
  static const String _githubUrl = 'https://github.com/keven-rdr';

  // Função para abrir a URL
  Future<void> _launchURL() async {
    final Uri url = Uri.parse(_githubUrl);
    if (!await launchUrl(url)) {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchURL,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.github,
              size: 16.0,
              color: Colors.grey,
            ),
            const SizedBox(width: 8.0),
            Text(
              '© ${DateTime.now().year} keven-rdr',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
