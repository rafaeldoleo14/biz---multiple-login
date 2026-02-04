import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_flow_args.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

String currencyCodeFromPrefix(String prefix) {
  final p = prefix.replaceAll(' ', '');
  if (p.startsWith('US')) return 'USD';
  if (p.startsWith('EU')) return 'EUR';
  return 'DOP'; // RD$
}

class DepositAccountArgs {
  final String companyId;
  final String accountId;
  final String currencyPrefix;
  final double minAmount;
  final double availableBalance;

  final String originAccountType;
  final String originAccountNumber;

  const DepositAccountArgs({
    required this.companyId,
    required this.accountId,
    required this.currencyPrefix,
    required this.minAmount,
    required this.availableBalance,
    required this.originAccountType,
    required this.originAccountNumber,
  });
}

class DepositAmountScreen extends StatefulWidget {
  final DepositAccountArgs args;

  const DepositAmountScreen({super.key, required this.args});

  @override
  State<DepositAmountScreen> createState() => _DepositAmountScreenState();
}

class DepositError {
  final bool show;
  final String message;

  const DepositError.none() : show = false, message = '';
}

class _DepositAmountScreenState extends State<DepositAmountScreen> {
  late final TextEditingController _amountCtrl;

  final List<_TermOption> _options = const [
    _TermOption(rate: 9.00, days: 30),
    _TermOption(rate: 8.90, days: 60),
    _TermOption(rate: 8.70, days: 120),
    _TermOption(rate: 8.50, days: 180),
    _TermOption(rate: 8.50, days: 360),
  ];

  final FocusNode _amountFocus = FocusNode();
  bool isAmountFocused = false;

  double _committedAmount = 0.0;
  int _selectedIndex = 0;

  double? _firstItemW;
  double? _lastItemW;

  final ScrollController _dotsCtrl = ScrollController();
  bool _syncingDots = false;

  final ScrollController _ratesCtrl = ScrollController();
  final GlobalKey _ratesViewportKey = GlobalKey();
  late final List<GlobalKey> _rateItemKeys;
  bool _updatingFromScroll = false;

  // ===== VALIDACIONES solicitadas =====
  bool _hasValidatedOnce =
      false; // muestra errores solo tras aceptar o tap fuera
  bool _insufficientFunds = false; // setéalo desde backend cuando aplique

  @override
  void initState() {
    super.initState();

    _amountCtrl = TextEditingController(text: _fmtMoney(widget.args.minAmount));
    _committedAmount = widget.args.minAmount;

    _rateItemKeys = List.generate(_options.length, (_) => GlobalKey());
    _ratesCtrl.addListener(_onRatesScroll);

    _amountFocus.addListener(() {
      setState(() {
        isAmountFocused = _amountFocus.hasFocus;
      });

      // ✅ validar al tocar fuera (pierde foco)
      if (!_amountFocus.hasFocus) {
        _commitAmountAndValidate();
      }
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _amountFocus.dispose();
    _ratesCtrl.removeListener(_onRatesScroll);
    _ratesCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  void _onRatesScroll() {
    if (_updatingFromScroll) return;
    _updatingFromScroll = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatingFromScroll = false;
      _updateSelectedIndexFromViewport();
      _syncDotsToRates();
    });
  }

  void _syncDotsToRates() {
    if (_syncingDots) return;
    if (!_ratesCtrl.hasClients || !_dotsCtrl.hasClients) return;

    final ratesMax = _ratesCtrl.position.maxScrollExtent;
    final dotsMax = _dotsCtrl.position.maxScrollExtent;

    if (ratesMax <= 0 || dotsMax <= 0) return;

    final t = (_ratesCtrl.offset / ratesMax).clamp(0.0, 1.0);
    final target = (t * dotsMax).clamp(0.0, dotsMax);

    _syncingDots = true;
    _dotsCtrl.jumpTo(target);
    _syncingDots = false;
  }

  void _updateSelectedIndexFromViewport() {
    final viewportCtx = _ratesViewportKey.currentContext;
    if (viewportCtx == null) return;

    final viewportBox = viewportCtx.findRenderObject() as RenderBox?;
    if (viewportBox == null || !viewportBox.hasSize) return;

    final viewportW = viewportBox.size.width;
    final viewportX = viewportBox.localToGlobal(Offset.zero).dx;
    final viewportCenterX = viewportX + viewportW / 2;

    int bestIndex = _selectedIndex;
    double bestDist = double.infinity;

    for (int i = 0; i < _rateItemKeys.length; i++) {
      final itemCtx = _rateItemKeys[i].currentContext;
      if (itemCtx == null) continue;

      final itemBox = itemCtx.findRenderObject() as RenderBox?;
      if (itemBox == null || !itemBox.hasSize) continue;

      final itemX = itemBox.localToGlobal(Offset.zero).dx;
      final itemCenterX = itemX + itemBox.size.width / 2;

      final dist = (itemCenterX - viewportCenterX).abs();
      if (dist < bestDist) {
        bestDist = dist;
        bestIndex = i;
      }
    }

    if (bestIndex != _selectedIndex) {
      setState(() => _selectedIndex = bestIndex);
    }
  }

  // ======= VALIDACIONES: commit + mensajes =======
  void _commitAmountAndValidate() {
    _hasValidatedOnce = true;

    final raw = _amountCtrl.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _committedAmount = 0.0;
        _insufficientFunds = false; // al cambiar, resetea este error local
      });
      return;
    }

    final normalized = raw.replaceAll(',', '');
    final parsed = double.tryParse(normalized);

    setState(() {
      _committedAmount = parsed ?? 0.0;

      _amountCtrl.text = _fmtMoney(_committedAmount);
      _insufficientFunds = _committedAmount > widget.args.availableBalance;
    });
  }

  // ✅ Mínimos según moneda para el texto EXACTO
  double get _minForCurrency {
    final p = widget.args.currencyPrefix.trim().toUpperCase();
    if (p.startsWith('RD')) return 10000.0;
    if (p.startsWith('US')) return 3000.0;
    if (p.startsWith('EUR') || p.contains('€')) return 3000.0;
    // fallback por si te pasan args.minAmount
    return widget.args.minAmount;
  }

  String get _minText {
    final p = widget.args.currencyPrefix.trim();
    return '$p ${_fmtMoney(_minForCurrency)}';
  }

  bool get _isBelowMinimum => _committedAmount < _minForCurrency;

  // ✅ prioridad: fondos insuficientes > mínimo
  String get _errorText {
    if (_insufficientFunds) {
      return 'Esta cuenta no posee fondos suficientes. Indique un nuevo monto';
    }
    return 'El monto a invertir debe ser superior a $_minText';
  }

  bool get _showError =>
      _hasValidatedOnce && (_insufficientFunds || _isBelowMinimum);

  // Estilo rojo para borde + delete cuando hay error
  Color get _fieldLineColor {
    if (_showError) return const Color(0xFFD0021B);
    return isAmountFocused ? const Color(0xFFED8B00) : const Color(0xFFE5E5E5);
  }

  Color get _deleteColor {
    if (_showError) return const Color(0xFFD0021B);
    return isAmountFocused ? const Color(0xFFED8B00) : const Color(0xFF002B49);
  }

  // ======= cálculos (los dejas igual) =======
  double get _amountValue {
    final raw = _amountCtrl.text.trim();
    if (raw.isEmpty) return 0;
    final normalized = raw.replaceAll(',', '');
    return double.tryParse(normalized) ?? 0;
  }

  bool get _isValidAmount => !_isBelowMinimum && !_insufficientFunds;

  _TermOption get _selectedOption => _options[_selectedIndex];

  double get _estimatedInterest {
    final a = _committedAmount;
    final r = _selectedOption.rate / 100.0;
    final d = _selectedOption.days.toDouble();
    if (a <= 0) return 0;
    return a * r * (d / 360.0);
  }

  double get _accumulate => _committedAmount + _estimatedInterest;

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

  String _fmtDatePlusDays(int days) {
    final now = DateTime.now();
    final due = now.add(Duration(days: days));
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final m = months[due.month - 1];
    return '${due.day} $m ${due.year}';
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);
    const fadeW = 22.0;
    const red = Color(0xFFC8102E);

    return Scaffold(
      backgroundColor: bg,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(), // ✅ tap fuera valida
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Especifique el monto que desea invertir:',
                              style: AppStyle.useGoogleFont(
                                const Color(0xFF424242),
                                14,
                                FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.args.currencyPrefix,
                                  style: AppStyle.useGoogleFont(
                                    navy,
                                    30,
                                    FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 4),

                                Expanded(
                                  child: TextField(
                                    focusNode: _amountFocus,
                                    controller: _amountCtrl,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.,]'),
                                      ),
                                    ],
                                    style: AppStyle.useGoogleFont(
                                      navy,
                                      30,
                                      FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                      hintText: '0.00',
                                      hintStyle: AppStyle.useGoogleFont(
                                        const Color(0xFFBABABA),
                                        30,
                                        FontWeight.w400,
                                      ),
                                    ),
                                    onSubmitted: (_) {
                                      // ✅ aceptar valida
                                      FocusScope.of(context).unfocus();
                                      // commit lo hace el listener de focus
                                    },
                                  ),
                                ),

                                const SizedBox(width: 12),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _amountCtrl.text = '';
                                      _committedAmount = 0.0;
                                      // al borrar no mostramos nada hasta validar
                                      // (si ya validó antes, al tocar fuera volverá a mostrar mínimo)
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/DeleteField_icon.svg',
                                    colorFilter: ColorFilter.mode(
                                      _deleteColor, // ✅ rojo si hay error
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Container(height: 1, color: _fieldLineColor),

                            if (_showError) ...[
                              const SizedBox(height: 10),
                              Text(
                                _errorText,
                                style: AppStyle.useGoogleFont(
                                  red,
                                  12,
                                  FontWeight.w500,
                                ),
                              ),
                            ],

                            const SizedBox(height: 22),

                            Text(
                              'Especifique la tasa anual y el plazo de su inversión:',
                              style: AppStyle.useGoogleFont(
                                const Color(0xFF424242),
                                14,
                                FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                              height: 74,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final viewportW = constraints.maxWidth;
                                  final leftPad = (_firstItemW == null)
                                      ? 0.0
                                      : ((viewportW - _firstItemW!) / 2).clamp(
                                          0.0,
                                          9999.0,
                                        );

                                  const fadeWLocal = 24.0;

                                  return Stack(
                                    children: [
                                      Positioned.fill(
                                        child: KeyedSubtree(
                                          key: _ratesViewportKey,
                                          child: ListView.separated(
                                            controller: _ratesCtrl,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _options.length,
                                            padding: EdgeInsets.only(
                                              left: leftPad,
                                              right: 0,
                                            ),
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(width: 0),
                                            itemBuilder: (context, i) {
                                              final opt = _options[i];
                                              final isActive =
                                                  i == _selectedIndex;

                                              Widget item = KeyedSubtree(
                                                key: _rateItemKeys[i],
                                                child: GestureDetector(
                                                  onTap: () => setState(
                                                    () => _selectedIndex = i,
                                                  ),
                                                  child: Container(
                                                    height: 74,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: isActive
                                                          ? const Color(
                                                              0xFFFFF1DA,
                                                            )
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${opt.rate.toStringAsFixed(2)}%',
                                                          style: AppStyle.useGoogleFont(
                                                            isActive
                                                                ? const Color(
                                                                    0xFFED8B00,
                                                                  )
                                                                : const Color(
                                                                    0xFF555555,
                                                                  ),
                                                            isActive ? 20 : 16,
                                                            FontWeight.w700,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: isActive
                                                              ? 0
                                                              : 5,
                                                        ),
                                                        Text(
                                                          '${opt.days} días',
                                                          style: AppStyle.useGoogleFont(
                                                            isActive
                                                                ? const Color(
                                                                    0xFFED8B00,
                                                                  )
                                                                : const Color(
                                                                    0xFF555555,
                                                                  ),
                                                            isActive ? 18 : 14,
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );

                                              if (i == 0) {
                                                item = _MeasureSize(
                                                  onChange: (s) {
                                                    if (_firstItemW !=
                                                        s.width) {
                                                      setState(
                                                        () => _firstItemW =
                                                            s.width,
                                                      );
                                                    }
                                                  },
                                                  child: item,
                                                );
                                              }
                                              if (i == _options.length - 1) {
                                                item = _MeasureSize(
                                                  onChange: (s) {
                                                    if (_lastItemW != s.width) {
                                                      setState(
                                                        () => _lastItemW =
                                                            s.width,
                                                      );
                                                    }
                                                  },
                                                  child: item,
                                                );
                                              }
                                              return item;
                                            },
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: IgnorePointer(
                                          child: Container(
                                            width: fadeWLocal,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  Color(0xFFFAFAFA),
                                                  Color(0x00FAFAFA),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: IgnorePointer(
                                          child: Container(
                                            width: fadeWLocal,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  Color(0xFFFAFAFA),
                                                  Color(0x00FAFAFA),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: SizedBox(
                                height: 16,
                                width: 60,
                                child: ClipRect(
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ListView.separated(
                                          controller: _dotsCtrl,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: _options.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(width: 8),
                                          itemBuilder: (context, i) {
                                            final active = i == _selectedIndex;
                                            return Container(
                                              width: active ? 10 : 8,
                                              height: active ? 10 : 8,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: active
                                                    ? const Color(0xFFAAAAAA)
                                                    : const Color(0xFFD9D9D9),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: IgnorePointer(
                                          child: Container(
                                            width: fadeW,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [bg, Color(0x00FAFAFA)],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // --- resto de tu UI (sin cambios) ---
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.5,
                                  color: const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Monto a acumular',
                                    style: AppStyle.useGoogleFont(
                                      const Color(0xFF424242),
                                      14,
                                      FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.args.currencyPrefix}${_fmtMoney(_accumulate)}',
                                    style: AppStyle.useGoogleFont(
                                      navy,
                                      30,
                                      FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Capital a invertir',
                                          style: AppStyle.useGoogleFont(
                                            const Color(0xFF424242),
                                            14,
                                            FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Interés estimado total',
                                          style: AppStyle.useGoogleFont(
                                            const Color(0xFF424242),
                                            14,
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0XFFFAFAFA),
                                        border: Border.all(
                                          color: const Color(0xFFE5E5E5),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${widget.args.currencyPrefix}${_fmtMoney(_amountValue)}',
                                                  style: AppStyle.useGoogleFont(
                                                    navy,
                                                    16,
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 2,
                                            height: 36,
                                            color: const Color(0xFFE5E5E5),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${widget.args.currencyPrefix}${_fmtMoney(_estimatedInterest)}',
                                                  style: AppStyle.useGoogleFont(
                                                    navy,
                                                    16,
                                                    FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _RowLine(
                                    left: 'Tasa de interés anual:',
                                    right:
                                        '${_selectedOption.rate.toStringAsFixed(2)}%',
                                  ),
                                  _DividerLine(),
                                  const SizedBox(height: 16),
                                  _RowLine(
                                    left: 'Interés estimado mensual:',
                                    right:
                                        '${widget.args.currencyPrefix}${_fmtMoney(_estimatedInterest)}',
                                  ),
                                  _DividerLine(),
                                  const SizedBox(height: 16),
                                  _RowLine(
                                    hasBottomPadding: false,
                                    left: 'Fecha de vencimiento:',
                                    right: _fmtDatePlusDays(
                                      _selectedOption.days,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ====== (Opcional) botón de prueba para simular fondos insuficientes ======
                            // ElevatedButton(
                            //   onPressed: () => setState(() {
                            //     _insufficientFunds = true;
                            //     _hasValidatedOnce = true;
                            //   }),
                            //   child: const Text('Simular fondos insuficientes'),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: GestureDetector(
                  onTap: _isValidAmount
                      ? () {
                          _commitAmountAndValidate();
                          if (!_isValidAmount) return;

                          final selected = _selectedOption;

                          final draft = DepositDraftArgs(
                            companyId: widget.args.companyId,
                            currencyCode: currencyCodeFromPrefix(
                              widget.args.currencyPrefix,
                            ),

                            accountId: widget.args.accountId,
                            currencyPrefix: widget.args.currencyPrefix,
                            minAmount: widget.args.minAmount,
                            availableBalance: widget.args.availableBalance,
                            originAccountType: widget.args.originAccountType,
                            originAccountNumber:
                                widget.args.originAccountNumber,

                            amount: _committedAmount,
                            termDays: selected.days,
                            annualRate: selected.rate,
                            estimatedInterest: _estimatedInterest,
                            accumulate: _accumulate,
                            dueDate: DateTime.now().add(
                              Duration(days: selected.days),
                            ),
                          );

                          context.push('/deposit-interest-type', extra: draft);
                        }
                      : null,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isValidAmount
                          ? const Color(0xFF002B49)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Continuar',
                        style: AppStyle.useGoogleFont(
                          _isValidAmount
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
      ),
    );
  }
}

class _RowLine extends StatelessWidget {
  final String left;
  final String right;
  final bool? hasBottomPadding;

  const _RowLine({
    required this.left,
    required this.right,
    this.hasBottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: hasBottomPadding == false ? 0 : 14,
        left: 12,
        right: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: AppStyle.useGoogleFont(
                const Color(0xFF424242),
                14,
                FontWeight.w500,
              ),
            ),
          ),
          Text(
            right,
            style: AppStyle.useGoogleFont(
              const Color(0xFF424242),
              14,
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1.5, color: const Color(0xFFE5E5E5));
  }
}

class _TermOption {
  final double rate;
  final int days;

  const _TermOption({required this.rate, required this.days});
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;

  const _MeasureSize({required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final renderObject = context.findRenderObject();
      if (renderObject is RenderBox && renderObject.hasSize) {
        final newSize = renderObject.size;
        if (_oldSize == newSize) return;
        _oldSize = newSize;
        widget.onChange(newSize);
      }
    });

    return widget.child;
  }
}
