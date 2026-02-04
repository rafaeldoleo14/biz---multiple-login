import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_amount_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DepositSelectAccountScreen extends StatefulWidget {
  const DepositSelectAccountScreen({super.key});

  @override
  State<DepositSelectAccountScreen> createState() =>
      _DepositSelectAccountScreenState();
}

class _DepositSelectAccountScreenState
    extends State<DepositSelectAccountScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  String? _selectedAccountId;

  final List<_CompanyGroup> _groups = [
    _CompanyGroup(
      companyId: 'company-importadora-dlf',
      name: 'IMPORTADORA DLF',
      isOpen: true,
      accounts: [
        _AccountItem(
          id: 'cc-799123456',
          title: 'Cuenta Corriente / 799123456',
          subtitle: 'Disponible: RD\$5,140,907.29',
          isDisabled: false,
          showInfoInsteadOfRadio: false,
          currencyPrefix: 'RD\$',
          minAmount: 10000.00,
          availableBalance: 5140907.29,
        ),
        _AccountItem(
          id: 'ah-740093900',
          title: 'Cuenta de Ahorro / 740093900',
          subtitle: 'Disponible: US\$5,240.14',
          isDisabled: false,
          showInfoInsteadOfRadio: false,
          currencyPrefix: 'US\$',
          minAmount: 3000.00,
          availableBalance: 5240.14,
        ),
        _AccountItem(
          id: 'ah-740092500',
          title: 'Cuenta de Ahorro / 740092500',
          subtitle: 'Disponible: EU\$1,340.20',
          isDisabled: true,
          showInfoInsteadOfRadio: true,
          currencyPrefix: 'EU\$',
          minAmount: 3000.00,
          availableBalance: 1340.20,
        ),
      ],
    ),
    _CompanyGroup(
      companyId: 'company-mat-distribuidora',
      name: 'MAT DISTRIBUIDORA',
      isOpen: false,
      accounts: const [],
    ),
    _CompanyGroup(
      companyId: 'company-garp-srl',
      name: 'GARP SRL',
      isOpen: false,
      accounts: const [],
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool get _canContinue => _selectedAccountId != null;

  _AccountItem? get _selectedAccount {
    if (_selectedAccountId == null) return null;
    for (final g in _groups) {
      for (final a in g.accounts) {
        if (a.id == _selectedAccountId) return a;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Content scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
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
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'DEPÓSITO A PLAZO',
                              style: const TextStyle(
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
                    const SizedBox(height: 16),

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

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Seleccione la cuenta origen para su inversión',
                      style: AppStyle.useGoogleFont(
                        const Color(0xFF808080),
                        12,
                        FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Groups
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _groups.length,
                      itemBuilder: (context, index) {
                        final g = _groups[index];

                        final query = _searchCtrl.text.trim().toLowerCase();
                        final bool groupMatches =
                            query.isEmpty ||
                            g.name.toLowerCase().contains(query);

                        final filteredAccounts = g.accounts.where((a) {
                          if (query.isEmpty) return true;
                          return a.title.toLowerCase().contains(query) ||
                              a.subtitle.toLowerCase().contains(query);
                        }).toList();

                        if (!groupMatches && filteredAccounts.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return _CompanyAccordion(
                          name: g.name,
                          isOpen: g.isOpen,
                          onToggle: () {
                            setState(() {
                              _groups[index] = g.copyWith(isOpen: !g.isOpen);
                            });
                          },
                          child: Column(
                            children: [
                              if (_groups[index].isOpen) ...[
                                ...filteredAccounts.map((a) {
                                  return _AccountRow(
                                    title: a.title,
                                    subtitle: a.subtitle,
                                    isDisabled: a.isDisabled,
                                    showInfoInsteadOfRadio:
                                        a.showInfoInsteadOfRadio,
                                    selected: _selectedAccountId == a.id,
                                    onTap: () {
                                      if (a.isDisabled) return;
                                      setState(() => _selectedAccountId = a.id);
                                    },
                                  );
                                }),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom info + button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCF3FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/Icon.svg'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'La cuenta origen determinará la moneda\nde su Depósito a Plazo.',
                            style: AppStyle.useGoogleFont(
                              navy,
                              14,
                              FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  GestureDetector(
                    onTap: _canContinue
                        ? () {
                            final acc = _selectedAccount!;
                            final parts = acc.title.split(' / ');
                            final originType =
                                parts.first; // "Cuenta Corriente"
                            final originNumber = parts.length > 1
                                ? parts[1]
                                : '';

                            final company = _groups.firstWhere(
                              (g) => g.accounts.any((a) => a.id == acc.id),
                            );

                            context.push(
                              '/deposit-amount',
                              extra: DepositAccountArgs(
                                companyId: company.companyId,
                                currencyPrefix: acc.currencyPrefix,
                                minAmount: acc.minAmount,
                                accountId: acc.id,
                                availableBalance: acc.availableBalance,
                                originAccountType: originType,
                                originAccountNumber: originNumber,
                              ),
                            );
                          }
                        : null,
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _canContinue
                            ? const Color(0xFF002B49)
                            : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyAccordion extends StatelessWidget {
  final String name;
  final bool isOpen;
  final VoidCallback onToggle;
  final Widget child;

  const _CompanyAccordion({
    required this.name,
    required this.isOpen,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);

    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E6DF),
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color: const Color(0xFFD0CBC3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: AppStyle.useNeoSans(navy, 14, FontWeight.w500),
                ),
                SvgPicture.asset(
                  'assets/icons/${isOpen ? 'Gris500' : 'Gris5002'}.svg',
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(color: Colors.white),
            child: child,
          ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDisabled;
  final bool showInfoInsteadOfRadio;
  final bool selected;
  final VoidCallback onTap;

  const _AccountRow({
    required this.title,
    required this.subtitle,
    required this.isDisabled,
    required this.showInfoInsteadOfRadio,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const orange = Color(0xFFED8B00);

    final titleColor = isDisabled ? const Color(0xFF9E9E9E) : navy;
    final subtitleColor = isDisabled
        ? const Color(0xFFBDBDBD)
        : const Color(0xFF616161);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyle.useGoogleFont(
                          titleColor,
                          14,
                          FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppStyle.useGoogleFont(
                          subtitleColor,
                          14,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                if (showInfoInsteadOfRadio)
                  InkWell(
                    onTap: () async {
                      await showInsufficientFundsDialog(context);
                    },
                    child: SvgPicture.asset('assets/icons/Unselected2.svg'),
                  )
                else
                  SizedBox(
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
                                  decoration: const BoxDecoration(
                                    color: orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 18, right: 18),
          height: 1,
          color: const Color(0xFFE5E5E5),
        ),
      ],
    );
  }
}

// ======= Models =======

class _CompanyGroup {
  final String companyId;
  final String name;
  final bool isOpen;
  final List<_AccountItem> accounts;

  const _CompanyGroup({
    required this.companyId,
    required this.name,
    required this.isOpen,
    required this.accounts,
  });

  _CompanyGroup copyWith({
    String? name,
    bool? isOpen,
    List<_AccountItem>? accounts,
  }) {
    return _CompanyGroup(
      companyId: companyId,
      name: name ?? this.name,
      isOpen: isOpen ?? this.isOpen,
      accounts: accounts ?? this.accounts,
    );
  }
}

class _AccountItem {
  final String id;
  final String title;
  final String subtitle;
  final bool isDisabled;
  final bool showInfoInsteadOfRadio;
  final double availableBalance;

  final String currencyPrefix; // RD$ / US$ / EU$
  final double minAmount; // 10000 / 3000 / 3000

  const _AccountItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isDisabled,
    required this.showInfoInsteadOfRadio,
    required this.currencyPrefix,
    required this.minAmount,
    required this.availableBalance,
  });
}

Future<void> showInsufficientFundsDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'insufficient_funds',
    barrierColor: Color.fromRGBO(0, 0, 0, 0.32),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, __) {
      return const _InsufficientFundsDialog();
    },
    transitionBuilder: (context, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _InsufficientFundsDialog extends StatelessWidget {
  const _InsufficientFundsDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
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
            children: [
              SvgPicture.asset('assets/icons/Alert_icon.svg'),

              const SizedBox(height: 16),

              Text(
                'Fondos insuficientes',
                textAlign: TextAlign.center,
                style: AppStyle.useGoogleFont(
                  Color(0xFF424242),
                  20,
                  FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'El balance disponible en esta cuenta es\ninferior al mínimo permitido para esta\noperación.',
                textAlign: TextAlign.center,
                style: AppStyle.useGoogleFont(
                  Color(0xFF333333),
                  14,
                  FontWeight.w400,
                ),
              ),

              const SizedBox(height: 24),

              // Botón
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 13.5),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Color(0XFFED8B00),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Entendido',
                      style: AppStyle.useGoogleFont(
                        Colors.white,
                        14,
                        FontWeight.w500,
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
