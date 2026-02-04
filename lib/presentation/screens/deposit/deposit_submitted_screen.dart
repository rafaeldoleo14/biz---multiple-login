import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DepositSubmittedArgs {
  final String productNumber; // 732645895
  final String verifierCode; // Z5bR8o...
  final String channel; // App BIZ

  final String currencyPrefix;
  final double amount;
  final String typeLabel;
  final int termDays;
  final double annualRate;
  final double estimatedInterest;
  final String interestPaymentMode;
  final DateTime dueDate;

  final String authorizedUserText;

  const DepositSubmittedArgs({
    required this.productNumber,
    required this.verifierCode,
    this.channel = 'App BIZ',
    required this.currencyPrefix,
    required this.amount,
    required this.typeLabel,
    required this.termDays,
    required this.annualRate,
    required this.estimatedInterest,
    required this.interestPaymentMode,
    required this.dueDate,
    this.authorizedUserText = 'usuario autorizado',
  });
}

class DepositSubmittedScreen extends StatelessWidget {
  final DepositSubmittedArgs args;

  const DepositSubmittedScreen({super.key, required this.args});

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
    const orange = Color(0xFFED8B00);

    final bool requiredApprove = true;

    return Scaffold(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 23.5),
                height: 72,
                width: double.infinity,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/Asset 2.svg'),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('assets/icons/ShareIOS_icon.svg'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24.25, 32, 24.25, 12),
                  child: Column(
                    children: [
                      // ===== Card + Icono flotante (como DepositInfoScreen) =====
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Card principal (con padding top para dejar espacio al icono flotante)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(8, 40, 8, 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Número de producto',
                                  style: AppStyle.useGoogleFont(
                                    const Color(0xFF424242),
                                    16,
                                    FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: args.productNumber),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        args.productNumber,
                                        style: AppStyle.useNeoSans(
                                          navy,
                                          24,
                                          FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      SvgPicture.asset(
                                        'assets/icons/Copiar_icon.svg',
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: requiredApprove == true ? 8 : 0,
                                ),

                                // Chip: "Su solicitud ha sido sometida"
                                if (requiredApprove == true) ...{
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1DA),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Su solicitud ha sido sometida',
                                      style: AppStyle.useGoogleFont(
                                        Color(0XFFBB6200),
                                        12,
                                        FontWeight.w400,
                                      ).copyWith(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                } else ...{
                                  SizedBox(
                                    height: 32,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Depósito a plazo creado exitosamente',
                                          style: AppStyle.useGoogleFont(
                                            Color(0XFF9E9E9E),
                                            12,
                                            FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                },

                                const SizedBox(height: 32),

                                _LineRow('Tipo', args.typeLabel),
                                const _SoftDivider(),
                                _LineRow(
                                  'Monto invertido',
                                  '${args.currencyPrefix}${_fmtMoney(args.amount)}',
                                ),
                                const _SoftDivider(),
                                _LineRow('Plazo', '${args.termDays} días'),
                                const _SoftDivider(),
                                _LineRow(
                                  'Tasa de interés anual',
                                  _fmtRate(args.annualRate),
                                ),
                                const _SoftDivider(),
                                _LineRow(
                                  'Interés estimado',
                                  '${args.currencyPrefix}${_fmtMoney(args.estimatedInterest)}',
                                ),
                                const _SoftDivider(),
                                _LineRow(
                                  'Modalidad de pago\nde interés',
                                  args.interestPaymentMode,
                                ),
                                const _SoftDivider(),
                                _LineRow(
                                  'Vencimiento',
                                  _fmtDateEs(args.dueDate),
                                ),
                                const _SoftDivider(),
                                _LineRow('Canal', args.channel),
                                const _SoftDivider(),

                                const SizedBox(height: 4),

                                // Código verificador
                                Container(
                                  padding: EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Código verificador:',
                                              style: AppStyle.useGoogleFont(
                                                navy,
                                                16,
                                                FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              args.verifierCode,
                                              style: AppStyle.useGoogleFont(
                                                const Color(0xFF424242),
                                                14,
                                                FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Banner amarillo
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
                                          'assets/icons/Icon (3).svg',
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: AppStyle.useGoogleFont(
                                                const Color(0xFF424242),
                                                14,
                                                FontWeight.w400,
                                              ),
                                              children: [
                                                const TextSpan(
                                                  text:
                                                      'Su depósito será completado una vez sea aprobado por el ',
                                                ),
                                                TextSpan(
                                                  text: args.authorizedUserText,
                                                  style:
                                                      AppStyle.useGoogleFont(
                                                        orange,
                                                        14,
                                                        FontWeight.w600,
                                                      ).copyWith(
                                                        decoration:
                                                            TextDecoration
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
                                          'assets/icons/Icon (4).svg',
                                        ),
                                      ],
                                    ),
                                  ),
                                },
                              ],
                            ),
                          ),

                          // ===== Icono flotante superior (como tu patrón) =====
                          Positioned(
                            top: -32,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/${requiredApprove == true ? 'AutorizacionesPendientes_icon' : 'Check_circle_icon'}.svg',
                                    width: 48,
                                    height: 48,
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

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.go('/dashboard'),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Center(
                            child: Text(
                              'Ir a mis productos',
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
                        onTap: () => context.go('/deposit-info'),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Nuevo depósito',
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

class _LineRow extends StatelessWidget {
  final String left;
  final String right;

  const _LineRow(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    return Container(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              left,
              style: AppStyle.useGoogleFont(
                const Color(0xFF424242),
                14,
                FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            right,
            textAlign: TextAlign.right,
            style: AppStyle.useGoogleFont(navy, 14, FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1.5, color: const Color(0xFFFAFAFA));
  }
}
