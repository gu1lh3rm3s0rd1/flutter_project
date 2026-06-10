import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'services/app_bootstrap.dart';
import 'views/auth/login_view.dart';
import 'views/auth/cadastro_view.dart';
import 'views/auth/recuperacao_view.dart';
import 'views/home/home_view.dart';
import 'views/sobre/sobre_view.dart';
import 'views/especificas/api_consumo_view.dart';
import 'views/especificas/clientes_veiculos_view.dart';
import 'views/especificas/ordens_servico_view.dart';
import 'views/especificas/pesquisa_ordens_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()),
        ],
        child: const RuralApp(),
      ),
    ),
  );
}

class RuralApp extends StatelessWidget {
  const RuralApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E3A5F);
    const Color accentOrange = Color(0xFFF28C28);

    return MaterialApp(
      title: 'AutoFlow Oficina',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: accentOrange,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/login': (context) => const LoginView(),
        '/cadastro': (context) => const CadastroView(),
        '/recuperar': (context) => const RecuperacaoView(),
        '/home': (context) => const HomeView(),
        '/sobre': (context) => const SobreView(),

        '/clientes': (context) => const ClientesVeiculosView(),
        '/ordens-servico': (context) => const OrdensServicoView(),
        '/pesquisa': (context) => const PesquisaOrdensView(),
        '/api': (context) => const ApiConsumoView(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    if (auth.estaLogado) {
      return const HomeView();
    }

    return const LoginView();
  }
}