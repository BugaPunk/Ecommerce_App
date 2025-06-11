import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/auth_provider.dart';
import 'providers/admin_provider.dart';
import 'providers/product_provider.dart';
import 'providers/store_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StoreProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Define default color scheme to use as fallback
    final defaultLightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    );

    final defaultDarkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    );

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Use dynamic color scheme if available, otherwise use default
        ColorScheme lightColorScheme = lightDynamic ?? defaultLightColorScheme;
        ColorScheme darkColorScheme = darkDynamic ?? defaultDarkColorScheme;

        return MaterialApp(
          title: 'Aplicación de Comercio Electrónico',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            textTheme: GoogleFonts.openSansTextTheme(
              Theme.of(context).textTheme,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: lightColorScheme.surfaceContainerHighest.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: lightColorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            textTheme: GoogleFonts.openSansTextTheme(
              Theme.of(context).textTheme.copyWith(
                bodyLarge: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                bodyMedium: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: darkColorScheme.surfaceContainerHighest.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: darkColorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
          routes: AppRoutes.getRoutes(),
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
