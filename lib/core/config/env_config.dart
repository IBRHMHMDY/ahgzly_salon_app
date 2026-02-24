class EnvConfig {
  /// Pass at runtime:
  /// flutter run --dart-define=BASE_URL=https://example.com/api
  ///baseUrl = "http://10.0.2.2:8000/api"; Emulator Device
  /// flutter run --dart-define=ENV_NAME=https://example.com/api
  // AndroidDevice = "http://192.168.1.10:8000/api"; Physical Device
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api', // Default for Android emulator
  );

  /// Optional: environment name (dev/staging/prod)
  static const String ipEmulator = String.fromEnvironment(
    'ENV_NAME',
    defaultValue: 'dev',
  );
  /// Optional: environment name (dev/staging/prod)
  static const String ipDevice = String.fromEnvironment(
    'ENV_NAME',
    defaultValue: 'http://192.168.1.10:8000/api',
  );
}