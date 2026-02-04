import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_flow_args.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_verification_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final _moneyFmt = NumberFormat.currency(
  locale: 'en_US', // 1,234,567.89
  symbol: '', // el símbolo lo pones tú con currencyPrefix
  decimalDigits: 2,
);

class DepositInterestDestinationArgs {
  final DepositDraftArgs draft;
  final String interestPaymentMode; // "Crédito a cuenta"

  const DepositInterestDestinationArgs({
    required this.draft,
    required this.interestPaymentMode,
  });
}

class DepositInterestDestinationAccountScreen extends StatefulWidget {
  final DepositInterestDestinationArgs args;
  const DepositInterestDestinationAccountScreen({
    super.key,
    required this.args,
  });

  @override
  State<DepositInterestDestinationAccountScreen> createState() =>
      _DepositInterestDestinationAccountScreenState();
}

class _DepositInterestDestinationAccountScreenState
    extends State<DepositInterestDestinationAccountScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  bool _expanded = true;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = null;
  }

  // ✅ Mock. Reemplaza por tus cuentas reales filtradas (empresa + moneda)
  final List<_AccountOption> _allAccounts = const [
    // IMPORTADORA DLF
    _AccountOption(
      id: 'dl-cc-rd-799123456',
      companyId: 'company-importadora-dlf',
      currencyPrefix: 'RD\$',
      type: 'Cuenta Corriente',
      number: '799123456',
      availableBalance: 1140907.29,
    ),
    _AccountOption(
      id: 'dl-ah-us-740093900',
      companyId: 'company-importadora-dlf',
      currencyPrefix: 'US\$',
      type: 'Cuenta de Ahorro',
      number: '740093900',
      availableBalance: 5240.14,
    ),
    _AccountOption(
      id: 'dl-ah-eu-740092500',
      companyId: 'company-importadora-dlf',
      currencyPrefix: 'EU\$',
      type: 'Cuenta de Ahorro',
      number: '740092500',
      availableBalance: 1340.20,
    ),
  ];

  String get _companyId => widget.args.draft.companyId;
  String get _currencyPrefix => widget.args.draft.currencyPrefix;

  List<_AccountOption> get _filteredAccounts {
    return _allAccounts.where((a) {
      return a.companyId == _companyId && a.currencyPrefix == _currencyPrefix;
    }).toList();
  }

  String get _groupTitle {
    switch (_companyId) {
      case 'company-importadora-dlf':
        return 'IMPORTADORA DLF';
      case 'company-mat-distribuidora':
        return 'MAT DISTRIBUIDORA';
      case 'company-garp-srl':
        return 'GARP SRL';
      default:
        return 'Empresa';
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue => _selectedIndex != null;

  void _continue() {
    context.push(
      '/deposit-verification',
      extra: DepositVerificationArgs(
        currencyPrefix: widget.args.draft.currencyPrefix,
        amount: widget.args.draft.amount,
        typeLabel: 'Depósito a Plazo',
        termDays: widget.args.draft.termDays,
        annualRate: widget.args.draft.annualRate,
        estimatedInterest: widget.args.draft.estimatedInterest,
        accumulate: widget.args.draft.accumulate,
        interestPaymentMode: widget.args.interestPaymentMode,
        dueDate: widget.args.draft.dueDate,
        originAccountType: widget.args.draft.originAccountType,
        originAccountNumber: widget.args.draft.originAccountNumber,

        // Si luego quieres mostrarlo en verificación, agrega campos opcionales
        // y pásalos aquí con info de selected.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const orange = Color(0xFFED8B00);

    final accounts = _filteredAccounts;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0XFFFAFAFA)),
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
                  child: Column(
                    children: [
                      // Search
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              SvgPicture.asset('assets/icons/Orange.svg'),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  controller: _searchCtrl,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Buscar',
                                    hintStyle: AppStyle.useGoogleFont(
                                      const Color(0xFFBDBDBD),
                                      16,
                                      FontWeight.w400,
                                    ),
                                  ),
                                  style: AppStyle.useGoogleFont(
                                    const Color(0xFF002B49),
                                    16,
                                    FontWeight.w400,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 14),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Seleccione la cuenta donde desea recibir los intereses de su inversión.',
                        textAlign: TextAlign.center,
                        style: AppStyle.useGoogleFont(
                          const Color(0xFF8C8C8C),
                          12,
                          FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Group header
                      InkWell(
                        onTap: () => setState(() => _expanded = !_expanded),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E6DF),
                            border: Border.all(color: const Color(0xFFD0CBC3)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _groupTitle,
                                  style: AppStyle.useNeoSans(
                                    navy,
                                    14,
                                    FontWeight.w500,
                                  ),
                                ),
                              ),

                              SvgPicture.asset(
                                'assets/icons/${_expanded ? 'Gris500' : 'Gris5002'}.svg',
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (_expanded) ...[
                        ...List.generate(accounts.length, (i) {
                          final acc = accounts[i];
                          final selected = _selectedIndex == i;

                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = (_selectedIndex == i)
                                        ? null
                                        : i;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              acc.typeAndNumber,
                                              style: AppStyle.useGoogleFont(
                                                navy,
                                                14,
                                                FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              acc.availableLabel,
                                              style: AppStyle.useGoogleFont(
                                                const Color(0xFF616161),
                                                14,
                                                FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      _RadioLike(
                                        selected: selected,
                                        orange: orange,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFE5E5E5),
                              ),
                            ],
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: !_canContinue
                      ? const SizedBox(height: 0)
                      : Padding(
                          key: const ValueKey('note'),
                          padding: const EdgeInsets.only(top: 26),
                          child: _InfoNote(
                            text:
                                'Solo podrá seleccionar cuentas\n'
                                'pertenecientes a la empresa previamente\n'
                                'indicada que estén en la misma moneda\n'
                                'de su Depósito a Plazo.',
                            navy: navy,
                          ),
                        ),
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
                child: GestureDetector(
                  onTap: _canContinue ? _continue : null,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _canContinue ? navy : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Continuar',
                        style: AppStyle.useGoogleFont(
                          _canContinue ? Colors.white : const Color(0xFFB0B0B0),
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
      ),
    );
  }
}

class _AccountOption {
  final String id;
  final String companyId;
  final String currencyPrefix;
  final String type;
  final String number;
  final double availableBalance;

  const _AccountOption({
    required this.id,
    required this.companyId,
    required this.currencyPrefix,
    required this.type,
    required this.number,
    required this.availableBalance,
  });

  String get typeAndNumber => '$type / $number';

  String get availableLabel {
    final v = _moneyFmt.format(availableBalance).trim();
    return 'Disponible: $currencyPrefix$v';
  }
}

class _RadioLike extends StatelessWidget {
  final bool selected;
  final Color orange;

  const _RadioLike({required this.selected, required this.orange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: orange, width: 2),
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

class _InfoNote extends StatelessWidget {
  final String text;
  final Color navy;

  const _InfoNote({required this.text, required this.navy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFDCF3FF), // azul claro
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/Icon (5).svg'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyle.useGoogleFont(navy, 14, FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
