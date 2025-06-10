import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({Key? key}) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  // Lista com os caminhos das suas imagens na pasta assets
  final List<String> _imagePaths = [
    'assets/nav/ban1.webp',
    'assets/nav/ban2.webp',
    'assets/nav/ban3.webp',
    'assets/nav/ban4.webp',
  ];

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Função para avançar para a próxima página no carrossel
  void _nextPage() {
    // Calcula a próxima página, voltando para o início se chegar ao fim
    final nextPage = (_currentPage + 1) % _imagePaths.length;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pega a largura da tela para o carrossel se ajustar
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // O AspectRatio garante que o carrossel mantenha a proporção 16:9
        AspectRatio(
          aspectRatio: 16 / 9,
          child: GestureDetector(
            onTap: _nextPage, // Chama a função para avançar a página ao clicar
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              onPageChanged: (index) {
                // Atualiza o indicador de página (bolinhas)
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  // Um pequeno preenchimento para as imagens não colarem nas bordas
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      _imagePaths[index],
                      fit: BoxFit.cover,
                      width: screenWidth,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8), // Espaço entre o carrossel e os indicadores
        // Indicadores de página (as bolinhas)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_imagePaths.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8,
              width: _currentPage == index ? 24 : 8, // A bolinha ativa é mais larga
              decoration: BoxDecoration(
                color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }
}