import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style (status bar)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    // Riverpod provider scope wraps entire app
    const ProviderScope(
      child: RareCubeApp(),
    ),
  );
}

class RareCubeApp extends ConsumerWidget {
  const RareCubeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'RareCube',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Routing
      routerConfig: router,
    );
  }
}
