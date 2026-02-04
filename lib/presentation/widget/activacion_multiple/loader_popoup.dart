import 'package:biz_codigo_cash/provider/multiple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Llama a esto para mostrar tu loader giratorio
Future<void> showLoader(BuildContext context, {bool again = false}) {
  return showDialog<void>(
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
    barrierDismissible: false,
    context: context,
    builder: (_) => _LoaderDialog(again: again),
  );
}

/// Un StatefulWidget que crea y maneja el AnimationController
class _LoaderDialog extends StatefulWidget {
  final bool again;
  const _LoaderDialog({required this.again});

  @override
  State<_LoaderDialog> createState() => _LoaderDialogState();
}

class _LoaderDialogState extends State<_LoaderDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late MultipleActivationProvider provider;

  @override
  void initState() {
    super.initState();

    provider = Provider.of<MultipleActivationProvider>(context, listen: false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(); // sigue girando hasta que se cierre el diálogo

    Future.delayed(
      Duration(seconds: 4),
      () => {
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          // 1) Cierra el diálogo usando el mismo Navigator que lo abrió
          Navigator.of(context).pop();
          // 2) Luego navega con GoRouter
          context.go('/activation-card');
          provider.activateSelectedCards(again: widget.again);
        }),
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: UnconstrainedBox(
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.1416,
                  child: SvgPicture.asset(
                    'assets/icons/Loading.svg',
                    width: 40,
                    height: 40,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
