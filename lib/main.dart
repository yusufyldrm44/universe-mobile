import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'utils/router.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
      ],
      child: UniVerseApp(authService: authService),
    ),
  );
}

class UniVerseApp extends StatefulWidget {
  final AuthService authService;

  const UniVerseApp({super.key, required this.authService});

  @override
  State<UniVerseApp> createState() => _UniVerseAppState();
}

class _UniVerseAppState extends State<UniVerseApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.authService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UniVerse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
