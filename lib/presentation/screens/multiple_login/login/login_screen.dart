import 'dart:async';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _companyUserCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _companyFocus = FocusNode();
  final _userFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _obscure = true;
  bool _loading = false; // ✅ loader state

  bool get _canLogin =>
      _companyUserCtrl.text.trim().isNotEmpty &&
      _userCtrl.text.trim().isNotEmpty &&
      _passCtrl.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _companyUserCtrl.addListener(_refresh);
    _userCtrl.addListener(_refresh);
    _passCtrl.addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _companyUserCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();

    _companyFocus.dispose();
    _userFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_canLogin || _loading) return;

    setState(() => _loading = true);

    FocusScope.of(context).unfocus();

    try {
      // Simula llamada (reemplaza por tu API)
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      context.push('/token-popular');
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
    Widget? suffixIcon,
  }) {
    const orange = Color(0xFFED8B00);

    return AnimatedBuilder(
      animation: focusNode,
      builder: (_, __) {
        return TextField(
          focusNode: focusNode,
          controller: controller,
          cursorColor: orange,
          obscureText: obscureText,
          enabled: !_loading, // ✅ bloquea inputs mientras carga
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
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);

    // final canTap = _canLogin && !_loading;
    final isEnabled = _canLogin; // solo para color/estilo
    final canPress = _canLogin && !_loading; // solo para onTap

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 72,
                child: Row(
                  children: [SvgPicture.asset('assets/icons/Menu_icon.svg')],
                ),
              ),
              SvgPicture.asset('assets/icons/LogoBPD2.svg'),
              const SizedBox(height: 80),

              _buildField(
                focusNode: _companyFocus,
                controller: _companyUserCtrl,
                hint: 'Usuario empresa',
              ),
              const SizedBox(height: 14),

              _buildField(
                focusNode: _userFocus,
                controller: _userCtrl,
                hint: 'Usuario',
              ),
              const SizedBox(height: 14),

              _buildField(
                focusNode: _passFocus,
                controller: _passCtrl,
                hint: 'Contraseña',
                obscureText: _obscure,
                suffixIcon: IconButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() => _obscure = !_obscure),
                  icon: SvgPicture.asset(
                    'assets/icons/${_obscure ? 'Eye_visible_ocultar_icon' : 'Ocultar=Visible'}.svg',
                  ),
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: canPress ? _onLogin : null,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? navy
                        : const Color(0xFFE0E0E0), // ✅ no cambia con loader
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _loading
                        ? const SizedBox(
                            width: 16.5,
                            height: 16.5,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Acceder',
                            style: AppStyle.useGoogleFont(
                              isEnabled
                                  ? Colors.white
                                  : const Color(0xFF9E9E9E),
                              16,
                              FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
