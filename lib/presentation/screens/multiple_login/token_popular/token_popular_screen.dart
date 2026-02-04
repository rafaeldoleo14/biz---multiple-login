import 'dart:async';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class TokenPopularScreen extends StatefulWidget {
  const TokenPopularScreen({super.key});

  @override
  State<TokenPopularScreen> createState() => _TokenPopularScreenState();
}

class _TokenPopularScreenState extends State<TokenPopularScreen> {
  final _codeCtrl = TextEditingController();
  final _codeFocus = FocusNode();

  bool _loading = false;
  bool _hasError = false;

  static const int maxDigits = 8;
  static const String kValidToken = '12345678'; // ✅ raw digits (1234 5678)

  bool get _canSubmit {
    final raw = _rawDigits(_codeCtrl.text);
    return raw.length == maxDigits && !_loading;
  }

  @override
  void initState() {
    super.initState();
    _codeCtrl.addListener(_onChanged);
    _codeFocus.addListener(_refresh);
  }

  void _onChanged() {
    // si el usuario vuelve a escribir, quita error automáticamente
    if (_hasError) {
      _hasError = false;
    }
    _refresh();
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    if (!_canSubmit) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _hasError = false; // limpia error al intentar validar
    });

    try {
      // ✅ loader 2 segundos
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      final raw = _rawDigits(_codeCtrl.text);

      if (raw != kValidToken) {
        // ❌ error
        setState(() => _hasError = true);
        return;
      }

      context.go('/token-validating');
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _clearErrorAndText() {
    _codeCtrl.clear();
    setState(() => _hasError = false);
    FocusScope.of(context).requestFocus(_codeFocus);
  }

  void _installToken() {
    context.push('/token-install');
  }

  static String _rawDigits(String text) => text.replaceAll(RegExp(r'\D'), '');

  InputDecoration _inputDeco({
    required bool isFocused,
    required bool isEmpty,
    required bool hasError,
  }) {
    const focusFill = Color(0xFFFFFAF1);
    const errorFill = Color(0xFFFEF3F3);
    const orange = Color(0xFFED8B00);
    const errorRed = Color(0xFFE53935);

    final fill = hasError ? errorFill : (isFocused ? focusFill : Colors.white);

    final borderColor = hasError
        ? errorRed
        : (isFocused ? orange : const Color(0xFFE5E5E5));

    final borderWidth = hasError ? 1.5 : (isFocused ? 1.5 : 1);

    return InputDecoration(
      hintText: (!isFocused && isEmpty) ? 'Ingrese su código' : null,
      hintStyle: AppStyle.useGoogleFont(
        const Color(0xFFBDBDBD),
        16,
        FontWeight.w400,
      ),
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor,
          width: borderWidth.toDouble(),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor,
          width: borderWidth.toDouble(),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: borderColor,
          width: borderWidth.toDouble(),
        ),
      ),

      // ✅ X solo cuando hay error (como tu imagen)
      suffixIcon: hasError
          ? Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: _loading ? null : _clearErrorAndText,
                icon: SvgPicture.asset('assets/icons/Union.svg'),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);
    const orange = Color(0xFFED8B00);
    const errorRed = Color(0xFFC8102E);

    final raw = _rawDigits(_codeCtrl.text);
    final isEmpty = raw.isEmpty;
    final isFocused = _codeFocus.hasFocus;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            SizedBox(
              height: 72,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: _loading ? null : () => context.pop(),
                      icon: SvgPicture.asset('assets/icons/Vector 50.svg'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'TOKEN POPULAR',
                      style: AppStyle.useNeoSans(navy, 16, FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  children: [
                    Text(
                      'Ingrese el código de seguridad\n desplegado en su Token Popular.',
                      textAlign: TextAlign.center,
                      style: AppStyle.useGoogleFont(
                        const Color(0xFF424242),
                        16,
                        FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Input
                    AnimatedBuilder(
                      animation: _codeFocus,
                      builder: (_, __) {
                        final showError = _hasError;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              enabled: !_loading,
                              focusNode: _codeFocus,
                              controller: _codeCtrl,
                              cursorColor: orange,
                              keyboardType: TextInputType.number,
                              textAlign: isEmpty
                                  ? TextAlign.start
                                  : TextAlign.center,
                              style: AppStyle.useGoogleFont(
                                showError ? errorRed : navy,
                                20,
                                FontWeight.w400,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(maxDigits),
                                _TokenCodeFormatter(maxDigits: maxDigits),
                              ],
                              decoration: _inputDeco(
                                isFocused: isFocused,
                                isEmpty: isEmpty,
                                hasError: showError,
                              ),
                            ),

                            // Error text
                            if (showError) ...[
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  '¡Código incorrecto! Intente nuevamente.',
                                  style: AppStyle.useGoogleFont(
                                    Color(0XFFC8102E),
                                    12,
                                    FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  // Main button
                  GestureDetector(
                    onTap: _canSubmit ? _validate : null,
                    child: Container(
                      height: 54,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // ✅ NO cambia a gris cuando loading: se mantiene navy si está habilitado
                        color: (raw.length == maxDigits)
                            ? navy
                            : const Color(0xFFE0E0E0),
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
                                'Validar Token Popular',
                                style: AppStyle.useGoogleFont(
                                  (raw.length == maxDigits)
                                      ? Colors.white
                                      : const Color(0xFF9E9E9E),
                                  16,
                                  FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secondary CTA
                  InkWell(
                    onTap: _loading ? null : _installToken,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: Center(
                        child: Text(
                          '¿Desea instalar su Token Popular en Biz?',
                          style: AppStyle.useGoogleFont(
                            navy,
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
    );
  }
}

/// raw: "15201321" -> "1 5 2 0    1 3 2 1"
class _TokenCodeFormatter extends TextInputFormatter {
  final int maxDigits;

  _TokenCodeFormatter({required this.maxDigits});

  static String _rawDigits(String text) => text.replaceAll(RegExp(r'\D'), '');

  static String _format(String raw) {
    final digits = raw.split('');
    final b = StringBuffer();

    const normalGap = ' ';
    const middleGap = '    '; // ✅ gap grande después del 4to

    for (int i = 0; i < digits.length; i++) {
      b.write(digits[i]);
      if (i == digits.length - 1) break;

      if (i == 3) {
        b.write(middleGap);
      } else {
        b.write(normalGap);
      }
    }
    return b.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = _rawDigits(newValue.text);
    final trimmed = raw.length > maxDigits ? raw.substring(0, maxDigits) : raw;

    final formatted = _format(trimmed);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
