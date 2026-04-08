import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cliente_controller.dart';
import 'controllers/os_controller.dart';
import 'controllers/insumo_controller.dart';
import 'controllers/financeiro_controller.dart';
import 'views/auth/login_view.dart';
import 'views/auth/cadastro_view.dart';
import 'views/auth/recuperacao_view.dart';
import 'views/home/home_view.dart';
import 'views/sobre/sobre_view.dart';
import 'views/especificas/clientes_veiculos_view.dart';
import 'views/especificas/ordens_servico_view.dart';
import 'views/especificas/cadastro_os_view.dart';
import 'views/especificas/estoque_pecas_view.dart';
import 'views/especificas/financeiro_view.dart';
import 'views/especificas/entregas_view.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthController()),
          ChangeNotifierProvider(create: (_) => ClienteController()),
          ChangeNotifierProvider(create: (_) => OSController()),
          ChangeNotifierProvider(create: (_) => InsumoController()),
          ChangeNotifierProvider(create: (_) => FinanceiroController()),
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
        '/': (context) => const LoginView(),
        '/cadastro': (context) => const CadastroView(),
        '/recuperar': (context) => const RecuperacaoView(),
        '/home': (context) => const HomeView(),
        '/sobre': (context) => const SobreView(),

        '/clientes': (context) => const ClientesVeiculosView(),
        '/ordens-servico': (context) => const OrdensServicoView(),
        '/cadastro-os': (context) => const CadastroOSView(),
        '/estoque': (context) => const EstoquePecasView(),
        '/financeiro': (context) => const FinanceiroView(),
        '/entregas': (context) => const EntregasView(),
      },
    );
  }
}