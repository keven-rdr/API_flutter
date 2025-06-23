# 📱 API Flutter - Estudo com API gratuitas

Este projeto foi desenvolvido como parte do meu processo de aprendizado em **Flutter** e **Dart**, com foco no desenvolvimento **frontend mobile**. A aplicação simula uma **timeline interativa**, ela inicialmente consumia dados da [API JSONPlaceholder](https://jsonplaceholder.typicode.com/), uma API pública gratuita para testes, acabei alterando para a API [Fake Store API](https://fakestoreapi.com/), que simula uma loja e-commerce.

---

## ✨ Funcionalidades

- 📜 Tela de timeline com **scroll infinito**.
- 📦 Consumo de dois endpoints REST da API:
  - `/posts` → lista de postagens.
  - `/posts/{id}/comments` → comentários de um post específico.
- 🧩 Utilização de **componentes reutilizáveis** (`PostCard`, etc).
- 💡 Cards com **sombra e destaque visual** para melhor legibilidade.
- 💬 Ícone de comentários (`message_circle`) que **expande o card** e carrega os comentários do post **na mesma tela**, sem navegar.
- 🗺️ Navegação controlada usando:
  ```dart
  Map<AppRoute, String> _routeNames
  para evitar empilhamento excessivo de páginas.

 ## 🚀 Tecnologias utilizadas

- Flutter 3.7.2
- Dart
- JSONPlaceholder (API REST fake)
- http package para chamadas HTTP
- lucide_icons para ícones vetoriais modernos

  ## 🧠 Aprendizados

  - Construção de componentes visuais reutilizáveis no Flutter
  - Gerenciamento de estado com StatefulWidget
  - Requisições assíncronas HTTP com tratamento de erros
  - Renderização condicional (carregando, sucesso, erro)
  - Organização de rotas e estrutura de pastas
  - Utilização de temas e padronização visual com utils/app_colors.dart
 
   ## 🗂️ Estrutura do projeto (resumida)
```
  lib/
├── main.dart               # Entrada da aplicação
├── models/                 # Modelos de dados (Post, etc)
├── screens/
│   ├── main_screen.dart    # Tela principal (Timeline)
│   ├── mainTabs_screen.dart
│   └── post_detail.dart    # Detalhes/comentários de um post
├── services/
│   └── timeline_service.dart
├── utils/
│   ├── api_service.dart    # Requisições genéricas HTTP
│   └── app_colors.dart     # Cores do tema da aplicação
└── widgets/
    └── post_card.dart      # Componente visual dos cards de post
```

  ## 🛠️ Como executar
  1. Clone o repositório:
     ```
     git clone https://github.com/keven-rdr/API_flutter.git
     ```
  2. Acesse a pasta do projeto:
      ```
      cd API_flutter
      ```
  3. Instale as dependências:
     ```
     flutter pub get
     ```
  4. Rode o projeto:
     ```
     flutter run
     ```
  ## Observações
  - Este projeto não utiliza backend próprio. Todos os dados vêm da API pública JSONPlaceholder.
  - O foco foi aprender boas práticas no frontend Flutter: componentização, requisições HTTP, organização de arquivos e controle de rotas.
    
  ## 👨‍💻 Autor
  Feito com 💙 por Keven Rodrigues - 
  GitHub: @keven-rdr

  <h2>📸 Demonstração</h2>

<div style="display: flex; gap: 400px;">
  <img src="https://github.com/keven-rdr/API_flutter/blob/main/statement_handle/assets/timeline_demo.gif?raw=true" width="300"/>
  <img src="https://github.com/keven-rdr/API_flutter/blob/main/statement_handle/assets/timeline_demo2.gif?raw=true" width="294"/>
</div>

