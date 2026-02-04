import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DepositValidatingArgs {
  final Object nextArgs; // aquí mandas los args de la pantalla final

  const DepositValidatingArgs({required this.nextArgs});
}

class DepositValidatingTokenScreen extends StatefulWidget {
  final DepositValidatingArgs args;

  const DepositValidatingTokenScreen({super.key, required this.args});

  @override
  State<DepositValidatingTokenScreen> createState() =>
      _DepositValidatingTokenScreenState();
}

class _DepositValidatingTokenScreenState
    extends State<DepositValidatingTokenScreen> {
  @override
  void initState() {
    super.initState();

    // Simula validación (API). Cuando termine, navega.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      context.go('/deposit-submitted', extra: widget.args.nextArgs);
    });
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFED8B00);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 27.5,
                height: 27.5,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: const AlwaysStoppedAnimation<Color>(orange),
                  backgroundColor: const Color.fromRGBO(127, 129, 135, 0.1197),
                ),
              ),
              const SizedBox(height: 22.25),
              Text(
                'Validando\nToken Popular',
                textAlign: TextAlign.center,
                style: AppStyle.useGoogleFont(
                  const Color(0xFF616161),
                  16,
                  FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
