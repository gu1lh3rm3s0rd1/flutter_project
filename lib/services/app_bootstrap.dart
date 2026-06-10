import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'app_environment.dart';

class AppBootstrap {
  static Future<void> initialize() async {
    if (!AppEnvironment.useFirebase) {
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      return;
    }
  }
}