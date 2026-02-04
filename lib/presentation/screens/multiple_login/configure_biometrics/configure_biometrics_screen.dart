import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class ConfigureBiometricsScreen extends StatefulWidget {
  const ConfigureBiometricsScreen({super.key});

  @override
  State<ConfigureBiometricsScreen> createState() =>
      _ConfigureBiometricsScreenState();
}

class _ConfigureBiometricsScreenState extends State<ConfigureBiometricsScreen> {
  bool _accepted = false;
  bool _loading = false;

  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _onContinue() async {
    if (!_accepted || _loading) return;

    setState(() => _loading = true);

    try {
      // 1) Soporte del dispositivo
      final isSupported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      // 2) Biométricos disponibles (MUY útil para depurar)
      final available = await _auth.getAvailableBiometrics();

      if (!isSupported) {
        _show('Este dispositivo no soporta biometría.');
        return;
      }

      // Si vas biometricOnly:true, asegúrate que haya biometría enrolada
      if (!canCheck || available.isEmpty) {
        _show('No hay biometría configurada en el dispositivo.');
        return;
      }

      debugPrint('isSupported=$isSupported');
      debugPrint('canCheck=$canCheck');
      debugPrint('available=$available');

      final auth = LocalAuthentication();

      final supported = await auth.isDeviceSupported();

      debugPrint(
        "isDeviceSupported: $supported | canCheckBiometrics: $canCheck",
      );

      final didAuth = await _auth.authenticate(
        localizedReason: 'Valide su identidad para continuar.',
        biometricOnly: true,
        // Opcional (si tu app se puede ir a background durante auth)
        // persistAcrossBackgrounding: true,
      ); // firma actual de authenticate :contentReference[oaicite:1]{index=1}

      if (!mounted) return;

      if (didAuth) {
        context.go('/new-dashboard');
      } else {
        _show('Autenticación cancelada.');
      }
    } on PlatformException catch (e) {
      final auth = LocalAuthentication();
      final supported = await auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      debugPrint('PlatformException: ${e.code} | ${e.message}');
      if (!mounted) return;
      _show('Biometría falló: ${e.message ?? e.code}');
      debugPrint(
        'Biometría falló: ${e.message ?? e.code} isDeviceSupported: $supported',
      );

      debugPrint(
        "isDeviceSupported: $supported | canCheckBiometrics: $canCheck",
      );
    } on LocalAuthException catch (e) {
      final msg = switch (e.code) {
        LocalAuthExceptionCode.noBiometricsEnrolled =>
          'No tienes huella/rostro configurado.',
        LocalAuthExceptionCode.noCredentialsSet =>
          'Configura un PIN/Patrón/Clave en el dispositivo.',
        LocalAuthExceptionCode.temporaryLockout =>
          'Demasiados intentos. Intenta más tarde.',
        LocalAuthExceptionCode.biometricLockout =>
          'Biometría bloqueada. Desbloquea con PIN/Clave y vuelve a intentar.',
        LocalAuthExceptionCode.userCanceled => 'Autenticación cancelada.',
        _ => 'No se pudo usar la biometría.',
      };

      if (!mounted) return;
      _show(msg);
    } catch (e) {
      debugPrint('Error inesperado: $e');
      if (!mounted) return;
      _show('Error inesperado al autenticar.');
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);
    const orange = Color(0xFFED8B00);

    final canContinue = _accepted && !_loading;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 72,
              child: Center(
                child: Text(
                  'CONFIGURE SU ROSTRO O HUELLA',
                  textAlign: TextAlign.center,
                  style: AppStyle.useNeoSans(navy, 16, FontWeight.w500),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SvgPicture.asset('assets/icons/Frame 2608596.svg'),

            const SizedBox(height: 44),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Acceda con mayor rapidez a su App BIZ Popular utilizando el dato biométrico en su móvil.',
                textAlign: TextAlign.center,
                style: AppStyle.useGoogleFont(
                  const Color(0xFF555555),
                  16,
                  FontWeight.w400,
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => setState(() => _accepted = !_accepted),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _accepted ? orange : Colors.white,
                            borderRadius: BorderRadius.circular(3.6),
                            border: Border.all(color: orange, width: 2),
                          ),
                          child: _accepted
                              ? Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/Checkmark.svg',
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppStyle.useGoogleFont(
                            const Color(0xFF002B49),
                            14,
                            FontWeight.w400,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Reconozco que he leído y aceptado los\n',
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  context.push('/terms');
                                },
                                child: Text(
                                  'Términos y Condiciones.',
                                  style: AppStyle.useGoogleFont(
                                    const Color(0xFF002B49),
                                    14,
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: canContinue ? navy : const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: canContinue ? _onContinue : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Continuar',
                            style: AppStyle.useGoogleFont(
                              canContinue
                                  ? Colors.white
                                  : const Color(0xFF9E9E9E),
                              16,
                              FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: InkWell(
                  onTap: () {
                    context.go('/new-dashboard');
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    child: Text(
                      'Lo haré luego',
                      style: AppStyle.useGoogleFont(navy, 16, FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
