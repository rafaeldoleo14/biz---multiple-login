import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_flow_args.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_interest_destination_account_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_verification_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DepositInterestTypeScreen extends StatefulWidget {
  final DepositDraftArgs args;
  const DepositInterestTypeScreen({super.key, required this.args});

  @override
  State<DepositInterestTypeScreen> createState() =>
      _DepositInterestTypeScreenState();
}

class _DepositInterestTypeScreenState extends State<DepositInterestTypeScreen> {
  int? _selectedIndex;
  bool _loading = false;

  final List<_InterestOption> _options = const [
    _InterestOption(
      title: 'Capitalizable',
      description:
          'El interés generado mensualmente se integrará al monto original invertido,incrementando así el valor total de su inversión a lo largo del tiempo.',
    ),
    _InterestOption(
      title: 'Crédito a cuenta',
      description:
          'Reciba de manera periódica los intereses generados por su inversión, acreditados directamente en la cuenta de su elección.',
    ),
  ];

  bool get _canContinue => _selectedIndex != null;

  void _onContinue() async {
    if (_selectedIndex == null || _loading) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final mode =
        _options[_selectedIndex!].title; // Capitalizable / Crédito a cuenta

    if (mode == 'Crédito a cuenta') {
      context.push(
        '/deposit-interest-destination-account',
        extra: DepositInterestDestinationArgs(
          draft: widget.args,
          interestPaymentMode: mode,
        ),
      );
    } else {
      context.push(
        '/deposit-verification',
        extra: DepositVerificationArgs(
          currencyPrefix: widget.args.currencyPrefix,
          amount: widget.args.amount,
          typeLabel: 'Depósito a Plazo',
          termDays: widget.args.termDays,
          annualRate: widget.args.annualRate,
          estimatedInterest: widget.args.estimatedInterest,
          accumulate: widget.args.accumulate,
          interestPaymentMode: mode,
          dueDate: widget.args.dueDate,
          originAccountType: widget.args.originAccountType,
          originAccountNumber: widget.args.originAccountNumber,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);
    const orange = Color(0xFFED8B00);
    const borderGrey = Color(0xFFE5E5E5);
    const selectedFill = Color(0xFFFFFAF1); // beige suave similar al diseño

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
                        'assets/icons/Chevron_icon (1).svg',
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'DEPÓSITO A PLAZO',
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Cómo desea recibir sus intereses?',
                      style: AppStyle.useGoogleFont(
                        const Color(0xFF424242),
                        14,
                        FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ...List.generate(_options.length, (i) {
                      final opt = _options[i];
                      final selected = _selectedIndex == i;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _SelectableCard(
                          title: opt.title,
                          description: opt.description,
                          selected: selected,
                          navy: navy,
                          orange: orange,
                          borderGrey: borderGrey,
                          selectedFill: selectedFill,
                          onTap: () => setState(() => _selectedIndex = i),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: GestureDetector(
                onTap: _canContinue ? _onContinue : null,
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _canContinue ? navy : const Color(0xFFE0E0E0),
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
                            'Continuar',
                            style: AppStyle.useGoogleFont(
                              _canContinue
                                  ? Colors.white
                                  : const Color(0xFF9E9E9E),
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
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  final Color navy;
  final Color orange;
  final Color borderGrey;
  final Color selectedFill;

  const _SelectableCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    required this.navy,
    required this.orange,
    required this.borderGrey,
    required this.selectedFill,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? orange : borderGrey;
    final bgColor = selected ? selectedFill : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyle.useGoogleFont(
                      const Color(0xFF424242),
                      16,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: AppStyle.useGoogleFont(
                      const Color(0xFF424242),
                      14,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Radio (derecha)
            _RadioLike(selected: selected, orange: orange, navy: navy),
          ],
        ),
      ),
    );
  }
}

class _RadioLike extends StatelessWidget {
  final bool selected;
  final Color orange;
  final Color navy;

  const _RadioLike({
    required this.selected,
    required this.orange,
    required this.navy,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = selected ? orange : navy;

    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2),
          ),
          child: selected
              ? Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _InterestOption {
  final String title;
  final String description;

  const _InterestOption({required this.title, required this.description});
}
