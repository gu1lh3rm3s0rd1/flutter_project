class AppEnvironment {
  static const bool useFirebase = bool.fromEnvironment(
    'USE_FIREBASE',
    defaultValue: false,
  );
}