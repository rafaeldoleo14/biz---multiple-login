import 'dart:async';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///
/// ✅ Uso recomendado (con args):
/// context.go(
///   '/validating-generic',
///   extra: const ValidatingRouteArgs(
///     nextRoute: '/biometrics',
///   ),
/// );
///
/// ✅ Con extra hacia el destino:
/// context.go(
///   '/validating-generic',
///   extra: const ValidatingRouteArgs(
///     nextRoute: '/new-dashboard',
///     extra: NewDashboardArgs(showTokenPopup: false),
///   ),
/// );
///
class ValidatingRouteScreen extends StatefulWidget {
  /// Si usas esta pantalla con GoRouter (state.extra),
  /// pásale `args` desde el builder.
  final ValidatingRouteArgs args;

  const ValidatingRouteScreen({super.key, required this.args});

  @override
  State<ValidatingRouteScreen> createState() => _ValidatingRouteScreenState();
}

class _ValidatingRouteScreenState extends State<ValidatingRouteScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(widget.args.delay, () {
      if (!mounted) return;

      // ✅ Si el destino requiere extra (como /new-dashboard), lo pasamos.
      if (widget.args.extra != null) {
        context.go(widget.args.nextRoute, extra: widget.args.extra);
      } else {
        context.go(widget.args.nextRoute);
      }
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
                widget.args.title,
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

/// ✅ Args para usarla con GoRouter (state.extra)
class ValidatingRouteArgs {
  final String nextRoute;

  /// ✅ Esto se reenviará al destino (si el destino lo necesita).
  final Object? extra;

  final Duration delay;
  final String title;

  const ValidatingRouteArgs({
    required this.nextRoute,
    this.extra,
    this.delay = const Duration(seconds: 2),
    this.title = 'Validando\nToken Popular',
  });
}
