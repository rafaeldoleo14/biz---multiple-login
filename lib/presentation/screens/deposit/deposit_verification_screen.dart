import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_submitted_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_validating_token_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DepositVerificationArgs {
  final String currencyPrefix; // RD$ / US$ / EU$
  final double amount; // capital a invertir

  final String typeLabel; // "Depósito a Plazo"
  final int termDays; // 120
  final double annualRate; // 8.70 (%)

  final double estimatedInterest; // 143,013.70
  final double accumulate; // 5,143,013.70

  final String interestPaymentMode; // "Capitalizable" / "Crédito a cuenta"
  final DateTime dueDate; // 12 feb 2026

  final String originAccountType; // "Cuenta Corriente"
  final String originAccountNumber; // "799123456"

  final String authorizedUserText; // "usuario autorizado" (resaltado)

  const DepositVerificationArgs({
    required this.currencyPrefix,
    required this.amount,
    required this.typeLabel,
    required this.termDays,
    required this.annualRate,
    required this.estimatedInterest,
    required this.accumulate,
    required this.interestPaymentMode,
    required this.dueDate,
    required this.originAccountType,
    required this.originAccountNumber,
    this.authorizedUserText = 'usuario autorizado',
  });
}

class DepositVerificationScreen extends StatelessWidget {
  final DepositVerificationArgs args;
  const DepositVerificationScreen({super.key, required this.args});

  String _fmtMoney(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final intPart = parts[0];
    final dec = parts[1];

    final buf = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      final left = intPart.length - i;
      buf.write(intPart[i]);
      if (left > 1 && left % 3 == 1) buf.write(',');
    }
    return '${buf.toString()}.$dec';
  }

  String _fmtRate(double r) => '${r.toStringAsFixed(2)}%';

  String _fmtDateEs(DateTime d) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final m = months[d.month - 1];
    return '${d.day} $m ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const grey = Color(0xFF424242);
    const line = Color(0xFFFAFAFA);
    const orange = Color(0xFFED8B00);

    final bool requiredApprove = true;

    return Scaffold(
      // ✅ Fondo con el MISMO gradient de DepositInfoScreen
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8E6DF), Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
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
                        icon: SvgPicture.asset(
                          'assets/icons/Chevron_icon (1).svg',
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'VERIFICACIÓN',
                        style: TextStyle(
                          fontFamily: 'Neo Sans Std',
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24.25, 0, 24.25, 12),
                  child: Column(
                    children: [
                      // Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(8, 52, 8, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${args.currencyPrefix}${_fmtMoney(args.amount)}',
                              style: AppStyle.useNeoSans(
                                navy,
                                24,
                                FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),

                            _RowItem(
                              left: 'Tipo',
                              right: args.typeLabel,
                              navy: navy,
                              grey: grey,
                            ),

                            const _Divider(line: line),

                            _RowItem(
                              left: 'Plazo',
                              right: '${args.termDays} días',
                              navy: navy,
                              grey: grey,
                            ),
                            const _Divider(line: line),

                            _RowItem(
                              left: 'Tasa de interés anual',
                              right: _fmtRate(args.annualRate),
                              navy: navy,
                              grey: grey,
                            ),
                            const _Divider(line: line),

                            _RowItem(
                              left: 'Interés estimado total',
                              right:
                                  '${args.currencyPrefix}${_fmtMoney(args.estimatedInterest)}',
                              navy: navy,
                              grey: grey,
                            ),
                            const _Divider(line: line),

                            _RowItem(
                              left: 'Monto a acumular',
                              right:
                                  '${args.currencyPrefix}${_fmtMoney(args.accumulate)}',
                              navy: navy,
                              grey: grey,
                            ),
                            const _Divider(line: line),

                            _RowItem(
                              left: 'Modalidad de pago\nde interés',
                              right: args.interestPaymentMode,
                              navy: navy,
                              grey: grey,
                            ),
                            const _Divider(line: line),

                            _RowItem(
                              left: 'Vencimiento',
                              right: _fmtDateEs(args.dueDate),
                              navy: navy,
                              grey: grey,
                            ),
                            const _Divider(line: line),

                            _RowItem(
                              left: 'Cuenta de origen',
                              right: args.originAccountType,
                              navy: navy,
                              grey: grey,
                              rightBelow: args.originAccountNumber,
                            ),
                            const _Divider(line: line),

                            const SizedBox(height: 14),

                            Text(
                              'La cancelación solo estará disponible de lunes a viernes, de 3:00 a.m. a 3:00 p.m. En caso de cancelación anticipada, se aplicará una penalidad sobre los intereses generados.',
                              style: AppStyle.useGoogleFont(
                                const Color(0xFF424242),
                                12,
                                FontWeight.w400,
                              ),
                            ),

                            const SizedBox(height: 16),

                            if (requiredApprove == true) ...{
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  12,
                                  16,
                                  12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF1DA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/Icon (1).svg',
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: AppStyle.useGoogleFont(
                                            const Color(0xFF424242),
                                            12,
                                            FontWeight.w400,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text:
                                                  'Su transacción será completada una vez sea aprobada por el ',
                                            ),
                                            TextSpan(
                                              text: args.authorizedUserText,
                                              style:
                                                  AppStyle.useGoogleFont(
                                                    orange,
                                                    12,
                                                    FontWeight.w700,
                                                  ).copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                            ),
                                            const TextSpan(text: '.'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SvgPicture.asset(
                                      'assets/icons/Icon (2).svg',
                                    ),
                                  ],
                                ),
                              ),
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => showDepositCancelPopup(
                          context,
                          onExit: () => context.go('/dashboard'),
                        ),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: Center(
                            child: Text(
                              'Cancelar',
                              style: AppStyle.useGoogleFont(
                                navy,
                                16,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final submittedArgs = DepositSubmittedArgs(
                            productNumber: '732645895',
                            verifierCode: 'Z5bR8oG1IS2tA3zH0eW4vN9xK6uJ7pQ3',
                            currencyPrefix: args.currencyPrefix,
                            amount: args.amount,
                            typeLabel: args.typeLabel,
                            termDays: args.termDays,
                            annualRate: args.annualRate,
                            estimatedInterest: args.estimatedInterest,
                            interestPaymentMode: args.interestPaymentMode,
                            dueDate: args.dueDate,
                          );

                          context.push(
                            '/deposit-validating-token',
                            extra: DepositValidatingArgs(
                              nextArgs: submittedArgs,
                            ),
                          );
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              requiredApprove == true ? 'Someter' : 'Continuar',
                              style: AppStyle.useGoogleFont(
                                Colors.white,
                                16,
                                FontWeight.w500,
                              ),
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

Future<void> showDepositCancelPopup(
  BuildContext context, {
  VoidCallback? onExit,
}) {
  const orange = Color(0xFFED8B00);
  const navy = Color(0xFF002B49);

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'deposit_cancel',
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, __) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, _, __) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 0,
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Esta acción cancelará la operación actual.',
                      style: AppStyle.useGoogleFont(
                        const Color(0xFF424242),
                        20,
                        FontWeight.w700,
                      ).copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Al salir en este momento, los datos ingresados no quedarán registrados.',
                      style: AppStyle.useGoogleFont(
                        const Color(0xFF616161),
                        16,
                        FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.pop(), // cerrar popup
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancelar',
                                  style: AppStyle.useGoogleFont(
                                    navy,
                                    16,
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.pop(); // cerrar popup
                              (onExit ?? () => context.pop())(); // salir
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Salir',
                                  style: AppStyle.useGoogleFont(
                                    Colors.white,
                                    16,
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _Divider extends StatelessWidget {
  final Color line;
  const _Divider({required this.line});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(height: 1.5, color: line),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String left;
  final String right;
  final String? rightBelow;
  final Color navy;
  final Color grey;

  const _RowItem({
    required this.left,
    required this.right,
    required this.navy,
    required this.grey,
    this.rightBelow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              left,
              style: AppStyle.useGoogleFont(grey, 14, FontWeight.w400),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                right,
                textAlign: TextAlign.right,
                style: AppStyle.useGoogleFont(navy, 14, FontWeight.w600),
              ),
              if (rightBelow != null) ...[
                const SizedBox(height: 2),
                Text(
                  rightBelow!,
                  style: AppStyle.useGoogleFont(
                    const Color(0xFF616161),
                    14,
                    FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
