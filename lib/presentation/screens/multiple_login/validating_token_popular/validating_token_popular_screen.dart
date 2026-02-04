import 'dart:async';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ValidatingTokenPopularScreen extends StatefulWidget {
  const ValidatingTokenPopularScreen({super.key});

  @override
  State<ValidatingTokenPopularScreen> createState() =>
      _ValidatingTokenPopularScreenState();
}

class _ValidatingTokenPopularScreenState
    extends State<ValidatingTokenPopularScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      context.go('/biometrics');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const orange = Color(0xFFED8B00);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 55,
                height: 55,
                child: CircularProgressIndicator(
                  strokeWidth: 1.88,
                  valueColor: AlwaysStoppedAnimation<Color>(orange),
                ),
              ),
              const SizedBox(height: 20.5),
              Text(
                'Validando\nToken Popular',
                textAlign: TextAlign.center,
                style: AppStyle.useGoogleFont(
                  const Color(0XFF3B4559),
                  16,
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
