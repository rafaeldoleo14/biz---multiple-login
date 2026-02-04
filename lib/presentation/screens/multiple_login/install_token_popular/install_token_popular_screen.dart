import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class InstallTokenPopularScreen extends StatefulWidget {
  const InstallTokenPopularScreen({super.key});

  @override
  State<InstallTokenPopularScreen> createState() =>
      _InstallTokenPopularScreenState();
}

class _InstallTokenPopularScreenState extends State<InstallTokenPopularScreen> {
  bool _acceptTerms = false;
  bool _acceptBiometrics = false;

  bool get _canInstall => _acceptTerms && _acceptBiometrics;

  void _toggleTerms() => setState(() => _acceptTerms = !_acceptTerms);
  void _toggleBiometrics() =>
      setState(() => _acceptBiometrics = !_acceptBiometrics);

  void _openTermsDetails() {
    // ✅ Abre modal / pantalla de detalles
    // context.push('/terms-details');
  }

  void _openBiometricsDetails() {
    // ✅ Abre modal / pantalla de detalles
    // context.push('/biometrics-details');
  }

  Future<void> _installWithFingerprint() async {
    if (!_canInstall) return;

    // ✅ Aquí iría tu flujo biométrico (local_auth, etc.)
    // final ok = await auth.authenticate(...)
    // if (!ok) return;

    // ✅ Luego navega o continúa instalación
    // context.go('/token-installed');
  }

  void _useOtherMethod() {
    // ✅ Navega a “otro método”
    // context.push('/token-other-method');
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);
    const divider = Color(0xFFE0E0E0);

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
                      onPressed: () => context.pop(),
                      icon: SvgPicture.asset('assets/icons/Vector 50.svg'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'INSTALAR TOKEN POPULAR',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppStyle.useGoogleFont(
                          Color(0XFF424242),
                          16,
                          FontWeight.w400,
                        ).copyWith(height: 1.4),
                        children: const [
                          TextSpan(text: 'Utilice sus '),
                          TextSpan(
                            text: 'huellas dactilares',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text:
                                ' para verificar su identidad y continuar el proceso de manera eficiente. Si ha creado su cuenta utilizando su pasaporte, favor utilizar otro método.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 56),

                    SvgPicture.asset('assets/icons/biometric.svg'),

                    const SizedBox(height: 56),

                    const Divider(color: Color(0XFFE5E5E5), height: 1),

                    _ConsentRow(
                      checked: _acceptTerms,
                      onToggle: _toggleTerms,
                      onArrowTap: _openTermsDetails,
                      primaryTextSpans: [
                        TextSpan(
                          text: 'Acepto los ',
                          style: AppStyle.useGoogleFont(
                            navy,
                            14,
                            FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: 'términos y condiciones',
                          style: AppStyle.useGoogleFont(
                            navy,
                            14,
                            FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' los cuales serán enviados a su correo.',
                          style: AppStyle.useGoogleFont(
                            navy,
                            14,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                      linkText: 'Ver detalles.',
                    ),

                    const Divider(color: Color(0XFFE5E5E5), height: 1),

                    _ConsentRow(
                      checked: _acceptBiometrics,
                      onToggle: _toggleBiometrics,
                      onArrowTap: _openBiometricsDetails,
                      primaryTextSpans: [
                        TextSpan(
                          text:
                              'Acepto que se almacenen mis datos biométricos para validar mi identidad de forma rápida en otra ocasión.',
                          style: AppStyle.useGoogleFont(
                            navy,
                            14,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                      linkText: 'Ver detalles.',
                    ),

                    const Divider(color: divider, height: 1),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Column(
                children: [
                  // Primary disabled/enabled
                  GestureDetector(
                    onTap: _canInstall ? _installWithFingerprint : null,
                    child: Container(
                      height: 54,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _canInstall ? navy : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Instalar con sus huellas',
                          style: AppStyle.useGoogleFont(
                            _canInstall
                                ? Colors.white
                                : const Color(0xFF9E9E9E),
                            16,
                            FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Secondary CTA
                  InkWell(
                    onTap: _useOtherMethod,
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
                          '¿Desea usar otro método?',
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

class _ConsentRow extends StatelessWidget {
  final bool checked;
  final VoidCallback onToggle;
  final VoidCallback onArrowTap;
  final List<TextSpan> primaryTextSpans;
  final String linkText;

  const _ConsentRow({
    required this.checked,
    required this.onToggle,
    required this.onArrowTap,
    required this.primaryTextSpans,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFED8B00);

    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox (custom)
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: GestureDetector(
                onTap: onToggle,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: checked ? orange : Colors.transparent,
                        borderRadius: BorderRadius.circular(3.6),
                        border: Border.all(color: orange, width: 2),
                      ),
                      child: checked
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: TextSpan(children: primaryTextSpans)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onArrowTap,
                    child: Text(
                      linkText,
                      style:
                          AppStyle.useGoogleFont(
                            const Color(0xFF4298B5),
                            14,
                            FontWeight.w600,
                          ).copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0XFF4298B5),
                          ),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            SvgPicture.asset('assets/icons/Chevron_icon.svg'),
          ],
        ),
      ),
    );
  }
}
