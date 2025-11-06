import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'core/routes.dart';
import 'core/theme.dart';
import 'data/movie_repository.dart';
import 'presentation/state/favorites_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to load a packaged `.env` asset (we added `.env` to pubspec.yaml
  // assets). If it's present, parse it for OMDB_API_KEY and pass it to the
  // app. If not present, we proceed and rely on --dart-define.
  String? packagedKey;
  try {
    final text = await rootBundle.loadString('.env');
    for (final line in text.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final parts = trimmed.split('=');
      if (parts.length >= 2) {
        final k = parts[0].trim();
        final v = parts.sublist(1).join('=').trim();
        if (k == 'OMDB_API_KEY' && v.isNotEmpty) {
          packagedKey = v;
          break;
        }
      }
    }
    if (packagedKey != null) {
      debugPrint('Loaded OMDB_API_KEY from packaged .env');
    } else {
      debugPrint('Packaged .env found but OMDB_API_KEY not set');
    }
  } catch (e) {
    // Asset may not exist in production or CI; that's fine — we fall back to
    // compile-time dart-define.
    debugPrint('No packaged .env asset available: $e');
  }

  runApp(FlixionApp(envApiKey: packagedKey));
}

class FlixionApp extends StatelessWidget {
  final String? envApiKey;

  const FlixionApp({super.key, this.envApiKey});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesManager()),
        Provider(create: (_) => MovieRepository(overrideApiKey: envApiKey)),
      ],
      child: MaterialApp(
        title: 'Flixión',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: Routes.home,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
