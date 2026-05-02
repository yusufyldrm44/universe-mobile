import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Çerçevenin render edilmesini bekle
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    final auth = context.read<AuthService>();

    // bootstrap ile 2 saniyelik timeout arasında yarış: hangisi önce biterse
    await Future.any([
      auth.bootstrap(),
      Future<void>.delayed(const Duration(seconds: 2)),
    ]);

    if (!mounted) return;

    // 2 saniye doldu ama status hâlâ unknown → unauthenticated say
    if (auth.status == AuthStatus.unknown) {
      auth.forceUnauthenticated();
    }
    // Router'ın refreshListenable mekanizması status değişince
    // otomatik olarak /home veya /login'e yönlendirir.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stone900,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UNIVERSE',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
