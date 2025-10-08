/// Environment configuration for RareCube
///
/// Stores all environment variables and API endpoints
/// Replace these values with your actual credentials
class EnvConfig {
  // Convex Backend URL (Direct connection)
  static const String convexUrl = String.fromEnvironment(
    'CONVEX_URL',
    defaultValue: 'https://prestigious-ox-805.convex.cloud',
  );

  // Next.js Backend URL (for OAuth callbacks and API proxies)
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'https://join.rarecube.tv',
  );

  // Twitter OAuth 2.0 Credentials
  static const String twitterClientId = String.fromEnvironment(
    'TWITTER_CLIENT_ID',
    defaultValue: '', // Set via --dart-define
  );

  static const String twitterClientSecret = String.fromEnvironment(
    'TWITTER_CLIENT_SECRET',
    defaultValue: '', // Set via --dart-define
  );

  // Deep Link Scheme for OAuth callbacks
  static const String deepLinkScheme = 'rarecube';
  static const String deepLinkHost = 'callback';

  // App Constants
  static const String appName = 'RareCube';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableRemotionGeneration = false; // Disabled for MVP
  static const bool enableSolanaIntegration = true; // For future wallet features
}
