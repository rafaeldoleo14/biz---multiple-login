import 'dart:async';
import 'dart:ui';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/new_dashboard/new_dashboard.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/multiple_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BizWelcomeBackScreen extends StatefulWidget {
  const BizWelcomeBackScreen({super.key});

  @override
  State<BizWelcomeBackScreen> createState() => _BizWelcomeBackScreenState();
}

class _BizWelcomeBackScreenState extends State<BizWelcomeBackScreen> {
  /// ✅ Flag para probar MULTIPLE RNCs
  /// (luego lo conectas a tu API / storage)

  // ✅ Tus 4 imágenes (luego cambias las rutas)
  final List<String> _images = const [
    'assets/icons/Property 1=Carrusel.png',
    'assets/icons/Property 1=Default.png',
    'assets/icons/Property 1=Default (3).png',
    'assets/icons/Property 1=Default (2).png',
  ];

  int _activeIndex = 0;
  Timer? _timer;
  late final MultipleLoginProvider multipleLoginProvider;

  @override
  void initState() {
    super.initState();

    multipleLoginProvider = Provider.of<MultipleLoginProvider>(
      context,
      listen: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() {
        _activeIndex = (_activeIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTapLogin(BuildContext context) {
    if (multipleLoginProvider.isMultipleRncs == true) {
      _showSelectCompanySheet(context);
    } else {
      // ✅ No multiple: abre biometría y dispara auth automático
      _showLoginSheetWithCompany(
        context,
        companyName:
            multipleLoginProvider.companies[0] ??
            "The Coca Cola Company For DR",
      );
    }
  }

  // =========================
  // 1) SHEET: Seleccione la empresa (MULTIPLE RNCS)
  // ✅ Al seleccionar empresa -> ir DIRECTO a contraseña
  // =========================
  Future<void> _showSelectCompanySheet(BuildContext context) async {
    final MultipleLoginProvider multipleLoginProvider =
        Provider.of<MultipleLoginProvider>(context, listen: false);

    final companies = multipleLoginProvider.companies;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _SelectCompanySheetContent(
        companies: companies,
        onBack: () => Navigator.pop(sheetCtx),
        onSeeCompanies: () async {
          Navigator.pop(sheetCtx);

          final selected = await context.push<String>('/companies');
          if (selected == null) return;
          if (!context.mounted) return;

          // ✅ MULTIPLE RNC => directo a contraseña
          _showPasswordLoginSheet(context, companyName: selected);
        },
        onSelect: (name) async {
          Navigator.pop(sheetCtx);
          await Future.delayed(const Duration(milliseconds: 120));
          if (!context.mounted) return;

          // ✅ MULTIPLE RNC: directo a contraseña (NO biometría)
          _showPasswordLoginSheet(context, companyName: name);
        },
      ),
    );
  }

  // =========================
  // 2) SHEET: Accede con rostro o huella (solo NO multiple)
  // ✅ Al abrir, dispara biometría automáticamente
  // =========================
  Future<void> _showLoginSheetWithCompany(
    BuildContext context, {
    required String companyName,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _LoginSheetContent(
        parentContext: context,
        companyName: companyName,
        onBack: () => Navigator.pop(sheetCtx),
        onPassword: () async {
          // Navigator.pop(sheetCtx);
          await Future.delayed(const Duration(milliseconds: 0));
          if (!context.mounted) return;
          _showPasswordLoginSheet(context, companyName: companyName);
        },
        onBiometricSuccess: () {
          Navigator.pop(sheetCtx);
          multipleLoginProvider.addCompany(
            multipleLoginProvider.companies[0].trim(),
          );

          multipleLoginProvider.login(
            company: multipleLoginProvider.companies[0],
            username: 'UserTest',
            password: '1234',
          );
          context.go(
            '/new-dashboard',
            extra: const NewDashboardArgs(showTokenPopup: false),
          );
        },
        onUnlink: () {},
      ),
    );
  }

  // =========================
  // 3) SHEET: Password (Inicia sesión)
  // =========================
  Future<void> _showPasswordLoginSheet(
    BuildContext context, {
    required String companyName,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => _PasswordSheetContent(
        companyLabel: "Empresa",
        companyName: companyName,
        onBack: () {
          Navigator.pop(sheetCtx);

          if (multipleLoginProvider.isMultipleRncs == true) {
            Future.microtask(() {
              if (!context.mounted) return;
              _showSelectCompanySheet(context);
            });
          }
        },
        onSubmit: (password) {
          Navigator.pop(sheetCtx);
          multipleLoginProvider.addCompany(companyName.trim());

          multipleLoginProvider.login(
            company: companyName,
            username: 'UserTest',
            password: '1234',
          );
          context.go(
            '/new-dashboard',
            extra: const NewDashboardArgs(showTokenPopup: false),
          );
        },
        onForgot: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF6F3EC),
      body: Stack(
        children: [
          // ✅ AQUÍ va el "carousel" SIN SCROLL: solo cambia con animación
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragEnd: (details) {
                final v = details.primaryVelocity ?? 0;

                // v < 0 => swipe hacia la izquierda (siguiente)
                // v > 0 => swipe hacia la derecha (anterior)
                if (v.abs() < 120)
                  return; // umbral para evitar toques accidentales

                setState(() {
                  if (v < 0) {
                    _activeIndex = (_activeIndex + 1) % _images.length;
                  } else {
                    _activeIndex =
                        (_activeIndex - 1 + _images.length) % _images.length;
                  }
                });

                // ✅ reinicia el timer para que no cambie inmediatamente después del swipe
                _timer?.cancel();
                _timer = Timer.periodic(const Duration(seconds: 5), (_) {
                  if (!mounted) return;
                  setState(() {
                    _activeIndex = (_activeIndex + 1) % _images.length;
                  });
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 650),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  // ✅ Fade simple (sin slide)
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Image.asset(
                  _images[_activeIndex],
                  key: ValueKey(_images[_activeIndex]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // const SizedBox(height: 4),

                // Container(
                //   height: 48,
                //   margin: const EdgeInsets.symmetric(horizontal: 26),
                //   child: Row(
                //     children: [
                //       ProgressLine(active: _activeIndex == 0),
                //       const SizedBox(width: 8),
                //       ProgressLine(active: _activeIndex == 1),
                //       const SizedBox(width: 8),
                //       ProgressLine(active: _activeIndex == 2),
                //       const SizedBox(width: 8),
                //       ProgressLine(active: _activeIndex == 3),
                //       const SizedBox(width: 29),
                //       SvgPicture.asset('assets/icons/Frame 427318358.svg'),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 24),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Text(
                //           'Gestione el pago de nómina desde la app BIZ',
                //           style: AppStyle.useNeoSans(
                //             Colors.white,
                //             24,
                //             FontWeight.w700,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(child: Container()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.32),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      WelcomeOption(
                        text: 'Código cash',
                        iconPath: 'CodigoCash_icon',
                      ),
                      WelcomeOption(text: 'Token', iconPath: 'Token_icon'),
                      WelcomeOption(
                        text: 'Pago empleados',
                        iconPath: 'Desembolsos_icon (1)',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _onTapLogin(context),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF002B49),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Text(
                        "Inicia sesión",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => context.push('/add-company'),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Agregar empresa",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF002B49),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// SHEET CONTENT: Seleccione la empresa
// =====================================================
class _SelectCompanySheetContent extends StatelessWidget {
  final List<String> companies;
  final VoidCallback onBack;
  final VoidCallback onSeeCompanies;
  final ValueChanged<String> onSelect;

  const _SelectCompanySheetContent({
    required this.companies,
    required this.onBack,
    required this.onSeeCompanies,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const line = Color(0xFFE5E5E5);

    return SafeArea(
      top: false,
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E6DF),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBack,
                      child: SvgPicture.asset('assets/icons/Left.svg'),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Seleccione la empresa",
                      style: AppStyle.useNeoSans(
                        const Color(0xFF012169),
                        16,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1.5, color: line),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: line),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < companies.length; i++) ...[
                      _CompanyRow(
                        title: companies[i],
                        onTap: () => onSelect(companies[i]),
                      ),
                      if (i != companies.length - 1)
                        Container(height: 1, color: line),
                    ],
                    const SizedBox(height: 6),
                    Container(height: 1, color: line),
                    InkWell(
                      onTap: onSeeCompanies,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        child: Text(
                          "Ver empresas",
                          style: AppStyle.useGoogleFont(
                            const Color(0xFF6EA6C6),
                            16,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _CompanyRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _CompanyRow({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppStyle.useGoogleFont(navy, 14, FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SvgPicture.asset('assets/icons/Chevron_icon (4).svg'),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// SHEET CONTENT: Accede con rostro o huella (NO multiple)
// =====================================================
class _LoginSheetContent extends StatefulWidget {
  final BuildContext parentContext;
  final String companyName;
  final VoidCallback onBack;
  final VoidCallback onPassword;
  final VoidCallback onUnlink;
  final VoidCallback onBiometricSuccess;

  const _LoginSheetContent({
    required this.parentContext,
    required this.companyName,
    required this.onBack,
    required this.onPassword,
    required this.onUnlink,
    required this.onBiometricSuccess,
  });

  @override
  State<_LoginSheetContent> createState() => _LoginSheetContentState();
}

class _LoginSheetContentState extends State<_LoginSheetContent> {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _attempted = false;
  bool _authing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  void _show(String msg) {
    ScaffoldMessenger.of(
      widget.parentContext,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _tryBiometric() async {
    if (_attempted || _authing) return;
    _attempted = true;

    setState(() => _authing = true);

    try {
      // ✅ Abre el "prompt" encima del bottom sheet (simulación)
      final didAuth = await showFakeBiometricPrompt(context);

      if (!mounted) return;

      if (didAuth) {
        widget.onBiometricSuccess();
      } else {
        _show('Autenticación cancelada.');
      }
    } finally {
      if (!mounted) return;
      setState(() => _authing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const line = Color(0xFFE5E5E5);

    return SafeArea(
      top: false,
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E6DF),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 72,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: widget.onBack,
                      child: SvgPicture.asset('assets/icons/Left.svg'),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.useNeoSans(
                        const Color(0xFF012169),
                        16,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1.5, color: line),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                final didAuth = await showFakeBiometricPrompt(context);

                if (!mounted) return;

                if (didAuth) {
                  widget.onBiometricSuccess();
                } else {
                  _show('Autenticación cancelada.');
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    SvgPicture.asset('assets/icons/1.svg'),
                    const SizedBox(height: 8),
                    Text(
                      "Accede con rostro o huella",
                      style: AppStyle.useGoogleFont(
                        const Color(0xFF002B49),
                        16,
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_authing) ...[
              const SizedBox(height: 14),
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0XFFED8B00),
                ),
              ),
            ],

            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: widget.onPassword,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Accede con contraseña",
                      style: AppStyle.useGoogleFont(
                        Colors.white,
                        16,
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            InkWell(
              onTap: widget.onUnlink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/Desvincular_icon.svg'),
                  const SizedBox(width: 8),
                  Text(
                    "Desvincular usuario",
                    style: AppStyle.useGoogleFont(
                      const Color(0xFF002B49),
                      14,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

Future<bool> showFakeBiometricPrompt(BuildContext ctx) async {
  return (await showGeneralDialog<bool>(
        context: ctx,
        barrierDismissible: false,
        barrierLabel: 'biometric',
        barrierColor: Colors.black.withOpacity(0.25),
        useRootNavigator: true, // ✅ asegura que salga encima del bottom sheet
        pageBuilder: (_, __, ___) {
          return _FakeBiometricDialog(
            onCancel: () => Navigator.of(ctx, rootNavigator: true).pop(false),
            onSuccess: () => Navigator.of(ctx, rootNavigator: true).pop(true),
          );
        },
        transitionDuration: const Duration(milliseconds: 180),
        transitionBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(parent: anim, curve: Curves.easeOut);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      )) ??
      false;
}

class _FakeBiometricDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const _FakeBiometricDialog({required this.onCancel, required this.onSuccess});

  @override
  State<_FakeBiometricDialog> createState() => _FakeBiometricDialogState();
}

class _FakeBiometricDialogState extends State<_FakeBiometricDialog> {
  bool _pressing = false;
  bool _verified = false;
  Timer? _holdTimer;

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHold() {
    if (_verified) return;

    _holdTimer?.cancel();
    setState(() => _pressing = true);

    // ✅ Tiempo mínimo “mantener dedo” para aprobar (ajústalo)
    _holdTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (!_pressing) return;

      setState(() {
        _verified = true;
        _pressing = false;
      });

      // ✅ pequeña pausa visual y éxito
      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        widget.onSuccess();
      });
    });
  }

  void _endHold() {
    // Si suelta antes de tiempo, se cancela el escaneo (pero NO cierra el prompt)
    _holdTimer?.cancel();
    if (!mounted) return;
    if (_verified) return;
    setState(() => _pressing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Container()),
        Material(
          type: MaterialType.transparency,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E1E1E,
                    ).withOpacity(0.75), // ✅ #1E1E1E 75%
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Biometría",
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Escanea tu huella dactilar para acceder.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        _verified
                            ? "Huella reconocida"
                            : _pressing
                            ? "Escaneando…"
                            : "Huella dactilar para “App Biz”",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      // ✅ Zona de "huella" que se mantiene presionada
                      // GestureDetector(
                      //   onLongPressStart: (_) => _startHold(),
                      //   onLongPressEnd: (_) => _endHold(),
                      //   onLongPressCancel: _endHold,
                      //   behavior: HitTestBehavior.opaque,
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 10),
                      //     width: double.infinity,
                      //     alignment: Alignment.center,
                      //     child: AnimatedOpacity(
                      //       duration: const Duration(milliseconds: 120),
                      //       opacity: _verified ? 0.6 : 1,
                      //       child: Icon(
                      //         Icons.fingerprint,
                      //         size: 34,
                      //         color: _pressing
                      //             ? Colors.white
                      //             : const Color(0xFFEAEAEA),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (_pressing) ...[
                        const SizedBox(height: 6),
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0XFFED8B00),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      InkWell(
                        onTap: widget.onCancel,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                              fontFamily: 'SF',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 28),
        GestureDetector(
          onLongPressStart: (_) => _startHold(),
          onLongPressEnd: (_) => _endHold(),
          onLongPressCancel: _endHold,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.transparent,
            child: SvgPicture.asset('assets/icons/Group 5228.svg'),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.14),
      ],
    );
  }
}

// =====================================================
// SHEET CONTENT: Password
// =====================================================
class _PasswordSheetContent extends StatefulWidget {
  final String companyLabel;
  final String companyName;
  final VoidCallback onBack;
  final void Function(String password) onSubmit;
  final VoidCallback onForgot;

  const _PasswordSheetContent({
    required this.companyLabel,
    required this.companyName,
    required this.onBack,
    required this.onSubmit,
    required this.onForgot,
  });

  @override
  State<_PasswordSheetContent> createState() => _PasswordSheetContentState();
}

class _PasswordSheetContentState extends State<_PasswordSheetContent> {
  final _passCtrl = TextEditingController();
  final _passFocus = FocusNode();

  bool _loading = false;
  bool get _canSubmit => _passCtrl.text.isNotEmpty && !_loading;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _loading = true);
    FocusScope.of(context).unfocus();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      widget.onSubmit(_passCtrl.text);
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDeco(String hint, {required bool isFocused}) {
    const focusFill = Color(0xFFFFFAF1);

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: isFocused ? focusFill : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFED8B00), width: 1),
      ),
    );
  }

  Widget _buildField({
    required FocusNode focusNode,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
  }) {
    const orange = Color(0xFFED8B00);

    return AnimatedBuilder(
      animation: focusNode,
      builder: (_, __) {
        return TextField(
          obscuringCharacter: '*',
          focusNode: focusNode,
          controller: controller,
          textInputAction: textInputAction,
          cursorColor: orange,
          obscureText: obscureText,
          enabled: !_loading,
          style: const TextStyle(
            color: Color(0xFF002B49),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: _inputDeco(
            hint,
            isFocused: focusNode.hasFocus,
          ).copyWith(suffixIcon: suffixIcon),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const line = Color(0xFFE5E5E5);
    final kb = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: kb),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E6DF),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 72,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: widget.onBack,
                        child: SvgPicture.asset('assets/icons/Left.svg'),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Inicia sesión",
                        style: AppStyle.useNeoSans(
                          const Color(0xFF012169),
                          16,
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1.5, color: line),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.companyLabel,
                            style: AppStyle.useGoogleFont(
                              const Color(0xFF012169),
                              16,
                              FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.companyName,
                            style: AppStyle.useGoogleFont(
                              const Color(0xFF002B49),
                              24,
                              FontWeight.w600,
                            ).copyWith(height: 1.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildField(
                      focusNode: _passFocus,
                      controller: _passCtrl,
                      hint: 'Contraseña',
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _loading ? null : widget.onForgot,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "¿Olvidó su usuario o contraseña?",
                          style: AppStyle.useGoogleFont(
                            const Color(0xFF0B2A6D),
                            14,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    InkWell(
                      onTap: _canSubmit ? _submit : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: navy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: _loading
                              ? const SizedBox(
                                  width: 16.5,
                                  height: 16.5,
                                  child: CircularProgressIndicator(
                                    color: Color(0XFFED8B00),
                                    strokeWidth: 1.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  "Acceder",
                                  style: AppStyle.useGoogleFont(
                                    Colors.white,
                                    16,
                                    FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================
// Shared widgets
// =====================================================
class WelcomeOption extends StatelessWidget {
  final String text;
  final String iconPath;

  const WelcomeOption({super.key, required this.text, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/$iconPath.svg'),
        const SizedBox(height: 4),
        Text(
          text,
          style: AppStyle.useGoogleFont(
            const Color(0XFF002B49),
            14,
            FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ProgressLine extends StatelessWidget {
  final bool? active;

  const ProgressLine({super.key, this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: active == true
              ? Colors.white
              : const Color.fromRGBO(255, 255, 255, 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
