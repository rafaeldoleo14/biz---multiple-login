import 'dart:async';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/new_dashboard/new_dashboard.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/multiple_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BizCompanyLoginScreen extends StatefulWidget {
  const BizCompanyLoginScreen({super.key});

  @override
  State<BizCompanyLoginScreen> createState() => _BizCompanyLoginScreenState();
}

class _BizCompanyLoginScreenState extends State<BizCompanyLoginScreen> {
  final _companyCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _companyFocus = FocusNode();
  final _userFocus = FocusNode();
  final _passFocus = FocusNode();
  late final MultipleLoginProvider multipleLoginProvider;

  bool _obscure = true;
  bool _loading = false;

  bool get _canSubmit =>
      _companyCtrl.text.trim().isNotEmpty &&
      _userCtrl.text.trim().isNotEmpty &&
      _passCtrl.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    multipleLoginProvider = Provider.of<MultipleLoginProvider>(
      context,
      listen: false,
    );
    _companyCtrl.addListener(_refresh);
    _userCtrl.addListener(_refresh);
    _passCtrl.addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _companyFocus.dispose();
    _userFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_canSubmit || _loading) return;

    setState(() => _loading = true);
    FocusScope.of(context).unfocus();

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      multipleLoginProvider.addCompany(_companyCtrl.text.trim());

      context.go(
        '/new-dashboard',
        extra: const NewDashboardArgs(showTokenPopup: false),
      );
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
    TextInputAction? textInputAction,
    Widget? suffixIcon,
  }) {
    const orange = Color(0xFFED8B00);

    return AnimatedBuilder(
      animation: focusNode,
      builder: (_, __) {
        return TextField(
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
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);

    final isEnabled = _canSubmit; // para colores
    final canPress = _canSubmit && !_loading; // para onTap

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 70,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: SvgPicture.asset('assets/icons/Chevron_icon (3).svg'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: SvgPicture.asset('assets/icons/LogoBPD2.svg'),
                      ),

                      const SizedBox(height: 80),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "La empresa se guardará automáticamente al acceder",
                          style: AppStyle.useGoogleFont(
                            navy,
                            14,
                            FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      _buildField(
                        focusNode: _companyFocus,
                        controller: _companyCtrl,
                        hint: 'Usuario empresa',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 15),

                      _buildField(
                        focusNode: _userFocus,
                        controller: _userCtrl,
                        hint: 'Usuario',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 15),

                      _buildField(
                        focusNode: _passFocus,
                        controller: _passCtrl,
                        hint: 'Contraseña',
                        textInputAction: TextInputAction.done,
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

                      const SizedBox(height: 15),

                      Center(
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                      ),

                      // const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            GestureDetector(
              onTap: canPress ? _onLogin : null,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isEnabled ? navy : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(8),
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
                            isEnabled ? Colors.white : const Color(0xFF9E9E9E),
                            16,
                            FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
