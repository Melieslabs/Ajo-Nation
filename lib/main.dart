import 'package:ajo_nation/theme/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes/app_router.dart';
import 'services/app_data.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AppData(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: ThemeController.instance,
        builder: (context, _) {
          return MaterialApp(
            title: 'Ajo Hub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme().copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            themeMode: ThemeController.instance.mode,
            darkTheme: AppTheme.darkTheme().copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        });
  }
}
