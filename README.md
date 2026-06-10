# AutoFlow Oficina

Aplicativo Flutter para gestão de oficina mecânica com autenticação, Firestore, busca e consumo de API REST.

## Funcionalidades

- Login de usuario com Firebase Authentication
- Cadastro de usuario com salvamento de perfil em Firestore
- Recuperacao de senha
- Insercao, atualizacao e recuperacao em tempo real de clientes/veiculos e ordens de servico
- Pesquisa dedicada com ordenacao e filtro case-insensitive
- Consumo de API REST externa

## Tecnologias

- Flutter
- Dart
- Provider (ChangeNotifier)
- Firebase Authentication
- Cloud Firestore
- HTTP

## Como executar

### 1) Pre-requisitos

- Instalar o Flutter SDK e configurar o PATH.
- Instalar o Google Chrome (para rodar na web).
- (Opcional) Instalar Android Studio para rodar no emulador/dispositivo Android.
- Ter um projeto Firebase criado se quiser usar o modo real com Auth e Firestore.

Verifique se o Flutter esta pronto no seu ambiente:

```bash
flutter doctor
```

### 2) Clonar o projeto

```bash
git clone https://github.com/gu1lh3rm3s0rd1/flutter_project.git
cd flutter_project
```

### 3) Instalar as dependencias

```bash
flutter pub get
```

### 4) Configurar o Firebase

Se for usar o modo Firebase real, siga estes passos uma vez por projeto:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Isso gera o arquivo `lib/firebase_options.dart` com as credenciais do seu projeto.

### 5) Rodar a aplicacao

Modo local de demonstracao:

Web (Chrome):

```bash
flutter run -d chrome
```

Modo Firebase real depois de configurar o projeto:

```bash
flutter run -d chrome --dart-define=USE_FIREBASE=true
```

## Observacao

Quando o Firebase nao estiver configurado, o app abre em modo local de demonstracao para permitir navegar e testar a interface.
