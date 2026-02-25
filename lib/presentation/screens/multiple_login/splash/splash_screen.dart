import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  Timer? _startAnimTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _startAnimTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _controller.forward();
    });

    _navTimer = Timer(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      context.go('/login');
      // context.go('/welcome');
    });
  }

  @override
  void dispose() {
    _startAnimTimer?.cancel();
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/Mask_group.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          SafeArea(
            child: SizedBox.expand(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 91),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset('assets/icons/LogoBPD.svg'),
                  ),
                  const Spacer(),

                  // ✅ Icono con animación (ahora empieza después del delay)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Opacity(
                        opacity: _fade.value,
                        child: Transform.scale(
                          scale: _scale.value,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/Biz logo.svg',
                              width: 96, // opcional
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
