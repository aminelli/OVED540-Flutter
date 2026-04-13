/// File principale dell'applicazione che configura il MaterialApp
/// con routing, tema e provider globali.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/app_router.dart';
import 'config/routes/route_names.dart';
import 'core/theme/app_theme.dart';

/// Widget principale dell'applicazione
class DemoMediaApp extends StatelessWidget {
  const DemoMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Media App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: RouteNames.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
