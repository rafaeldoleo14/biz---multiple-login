import 'dart:async';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/new_dashboard/new_dashboard.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/validating_route/validating_route_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BizCompanyForLoginScreen extends StatefulWidget {
  final String companyName;

  const BizCompanyForLoginScreen({super.key, required this.companyName});

  @override
  State<BizCompanyForLoginScreen> createState() =>
      _BizCompanyForLoginScreenState();
}

class _BizCompanyForLoginScreenState extends State<BizCompanyForLoginScreen> {
  static const bg = Color(0xFFFAFAFA);
  static const navy = Color(0xFF002B49);
  static const linkBlue = Color(0xFF012169);
  static const disabledBtn = Color(0xFFE0E0E0);

  final _passCtrl = TextEditingController();
  final _passFocus = FocusNode();
  bool _obscure = true;

  bool _loading = false; // ✅ NEW: loader state

  bool get _canSubmit => _passCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passCtrl.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit || _loading) return;

    setState(() => _loading = true);
    FocusScope.of(context).unfocus();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      context.go(
        '/validating-generic',
        extra: const ValidatingRouteArgs(
          nextRoute: '/new-dashboard',
          extra: NewDashboardArgs(showTokenPopup: false),
          title: 'Validando\nToken Popular',
          delay: Duration(seconds: 2),
        ),
      );
    } finally {
      if (!mounted) {
        return;
      }
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFED8B00);
    const focusFill = Color(0xFFFFFAF1);

    final canPress = _canSubmit && !_loading; // ✅ click real
    final isEnabled = _canSubmit; // ✅ color/estilo (no cambia con loader)

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 72,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: _loading ? null : () => context.pop(),
                      icon: SvgPicture.asset(
                        'assets/icons/Chevron_icon (5).svg',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: IconButton(
                        onPressed: _loading
                            ? null
                            : () {
                                // icono derecha del mock
                              },
                        icon: SvgPicture.asset(
                          'assets/icons/Desvincular_icon (1).svg',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SvgPicture.asset('assets/icons/LogoBPD2.svg'),
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Empresa",
                                style: AppStyle.useGoogleFont(
                                  const Color(0xFF012169),
                                  16,
                                  FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.companyName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.useNeoSans(
                                  navy,
                                  26,
                                  FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        SvgPicture.asset('assets/icons/Frame 48096207.svg'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  AnimatedBuilder(
                    animation: _passFocus,
                    builder: (_, __) {
                      return TextField(
                        focusNode: _passFocus,
                        controller: _passCtrl,
                        obscureText: _obscure,
                        cursorColor: orange,
                        enabled: !_loading, // ✅ bloquea input mientras carga
                        style: const TextStyle(
                          color: Color(0xFF002B49),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          hintStyle: const TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: _passFocus.hasFocus
                              ? focusFill
                              : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E5E5),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFED8B00),
                              width: 1,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: _loading
                                ? null
                                : () => setState(() => _obscure = !_obscure),
                            icon: SvgPicture.asset(
                              'assets/icons/${_obscure ? 'Eye_visible_ocultar_icon' : 'Ocultar=Visible'}.svg',
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  InkWell(
                    onTap: _loading
                        ? null
                        : () {
                            // TODO: forgot flow
                          },
                    child: Text(
                      "¿Olvidó su usuario o contraseña?",
                      style: AppStyle.useGoogleFont(
                        linkBlue,
                        14,
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: canPress ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? const Color(0XFF002B49)
                    : disabledBtn,
                disabledBackgroundColor: disabledBtn,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 16.5,
                      height: 16.5,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Acceder",
                      style: AppStyle.useGoogleFont(
                        isEnabled ? Colors.white : const Color(0xFF9E9E9E),
                        16,
                        FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
