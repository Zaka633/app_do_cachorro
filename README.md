# app_do_cachorro

Projeto CRUD Flutter básico. Este aplicativo permite adicionar, editar, excluir e visualizar detalhes de cachorros, incluindo a capacidade de compartilhar os detalhes em formato PDF.

## Funcionalidades

- Adicionar novos cachorros com informações como nome, raça, peso, idade, telefone e imagem.
- Editar informações de cachorros existentes.
- Visualizar detalhes dos cachorros, incluindo a imagem.
- Compartilhar os detalhes dos cachorros em formato PDF.
- Buscar cachorros por nome.
- Alternar entre tema claro e escuro.

## Bibliotecas Usadas

Para começar, certifique-se de ter as seguintes dependências adicionadas ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.3
  image_picker: ^0.8.4+4
  path_provider: ^2.0.11
  sqflite: ^2.0.0+4
  path: ^1.8.0
  share_plus: ^10.1.4
  pdf: ^3.11.3
