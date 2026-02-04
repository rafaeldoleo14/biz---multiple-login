import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DepositCreateScreen extends StatefulWidget {
  const DepositCreateScreen({super.key});

  @override
  State<DepositCreateScreen> createState() => _DepositCreateScreenState();
}

class _DepositCreateScreenState extends State<DepositCreateScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _accepted = false;

  // ✅ NUEVO: se queda true cuando llega al final por primera vez
  bool _hasReadTerms = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final reachedBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80;

    // ✅ Si llegó al final una vez, se queda en true para siempre en esta pantalla
    if (reachedBottom && !_hasReadTerms) {
      setState(() => _hasReadTerms = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);

    final bool canAccept = _hasReadTerms && _accepted;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: const _TermsBody(),
                  ),
                ],
              ),
            ),

            Container(
              color: bg,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                children: [
                  // ✅ Bloquea taps hasta que haya leído (llegó al final una vez)
                  AbsorbPointer(
                    absorbing: !_hasReadTerms,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _accepted =
                              !_accepted; // ✅ NO se marca por bajar, solo por tap
                        });
                      },
                      child: Container(
                        color: const Color(0XFFFAFAFA),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox custom
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: Center(
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.6),
                                    border: Border.all(
                                      // ✅ Gris antes de leer / Naranja luego de leer
                                      color: _hasReadTerms
                                          ? const Color(0xFFED8B00)
                                          : const Color(0XFFBABABA),
                                      width: 2,
                                    ),
                                    // ✅ Relleno naranja solo si ya leyó y además aceptó
                                    color: (_hasReadTerms && _accepted)
                                        ? const Color(0xFFED8B00)
                                        : Colors.transparent,
                                  ),
                                  // ✅ Check solo si ya leyó y aceptó
                                  child: (_hasReadTerms && _accepted)
                                      ? const Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
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
                                      text: 'He leído y acepto los ',
                                    ),
                                    TextSpan(
                                      text: 'términos y condiciones',
                                      style: AppStyle.useGoogleFont(
                                        const Color(0xFF002B49),
                                        14,
                                        FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' de depósito a plazo.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  GestureDetector(
                    onTap: canAccept
                        ? () {
                            context.push('/deposit-select-account');
                          }
                        : null,
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: canAccept
                            ? const Color(0XFF002B49)
                            : const Color(0XFFE0E0E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Acepto',
                          style: AppStyle.useGoogleFont(
                            canAccept ? Colors.white : const Color(0xFF9E9E9E),
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
          ],
        ),
      ),
    );
  }
}

class _TermsBody extends StatelessWidget {
  const _TermsBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          width: double.infinity,
          height: 72,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: SvgPicture.asset('assets/icons/Chevron_icon (1).svg'),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Términos y condiciones',
                  style: TextStyle(
                    fontFamily: 'Neo Sans Std',
                    color: Color(0xFF002B49),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: SvgPicture.asset('assets/icons/Download.svg'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Términos y condiciones para\nDepósito a plazo Empresarial a\ntravés de la App BIZ.',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF002B49),
                  20,
                  FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Servicio de BANCO POPULAR DOMINICANO, S.A.\nBANCO MÚLTIPLE',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '20 de marzo de 2025',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Al utilizar este servicio, la Empresa acepta las\nsiguientes condiciones.',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w400,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'DESCRIPCIÓN',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _lorem1,
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _lorem2,
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w400,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'POLÍTICA DE PRIVACIDAD',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: AppStyle.useGoogleFont(
                    const Color(0XFF424242),
                    14,
                    FontWeight.w400,
                  ),
                  children: const [
                    TextSpan(
                      text:
                          'Al utilizar nuestro servicio, la empresa reconoce y se adhiere a las políticas de uso y privacidad de Banco Popular, '
                          'las cuales son aplicables para el uso de App BIZ Popular y el servicio de Depósito a plazo Empresarial, '
                          'a las cuales puede acceder en el siguiente link: ',
                    ),
                    TextSpan(
                      text:
                          'https://www.popularenlinea.com/empresarial/paginas/TcAppNegocios.aspx',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '© 2024 Banco Popular Dominicano. Todos los\nderechos reservados.',
                style: AppStyle.useGoogleFont(
                  const Color(0XFF424242),
                  14,
                  FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}

const String _lorem1 =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
    'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

const String _lorem2 =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';
