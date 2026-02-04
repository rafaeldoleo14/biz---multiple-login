import 'package:flutter/material.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NewDashboardArgs {
  final bool showTokenPopup;
  const NewDashboardArgs({required this.showTokenPopup});
}

class NewDashboardScreen extends StatefulWidget {
  final NewDashboardArgs args;
  const NewDashboardScreen({super.key, required this.args});

  @override
  State<NewDashboardScreen> createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen> {
  int _selectedTab = 0;
  int _selectedBottom = 0;

  final _tabs = const [
    'Resumen',
    'Cuentas',
    'Tarjetas',
    'Préstamos',
    'Certificados',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;

      if (widget.args.showTokenPopup) {
        _showInstallTokenPopupAnimated();
      }
    });
  }

  Future<void> _showInstallTokenPopupAnimated() async {
    const orange = Color(0xFFED8B00);
    const navy = Color(0xFF002B49);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'token_popup',
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim1, anim2) {
        return SafeArea(
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Dialog(
                backgroundColor: Colors.white,
                insetPadding: const EdgeInsets.symmetric(horizontal: 23.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "¿Desea instalar el Token Popular?",
                        style: AppStyle.useGoogleFont(
                          const Color(0xFF424242),
                          20,
                          FontWeight.w700,
                        ).copyWith(height: 1.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "¿Desea instalar el Token Popular?",
                        style: AppStyle.useGoogleFont(
                          const Color(0xFF424242),
                          16,
                          FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.5),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pop();
                              context.push('/token-install');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: orange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Instalar ahora",
                              style: AppStyle.useGoogleFont(
                                Colors.white,
                                16,
                                FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.5),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE5E5E5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Cancelar",
                              style: AppStyle.useGoogleFont(
                                navy,
                                16,
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
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);

        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFAFAFA);
    const navy = Color(0xFF002B49);
    const orange = Color(0xFFED8B00);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== HEADER =====
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                height: 70,
                child: Row(
                  children: [
                    _CircleInitials(
                      size: 40,
                      text: "NF",
                      bg: Color(0XFF002B49),
                      border: Color(0XFF002B49),
                      textColor: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.push('/profile-menu');
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hola Nicole',
                                style: AppStyle.useNeoSans(
                                  navy,
                                  20,
                                  FontWeight.w500,
                                ),
                              ),
                              Text(
                                '22 de septiembre, 2025',
                                style: AppStyle.useGoogleFont(
                                  const Color(0xFF424242),
                                  12,
                                  FontWeight.w500,
                                ).copyWith(height: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _HeaderIconButton(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/icons/CentroMensajes_icon.svg',
                      ),
                    ),
                    const SizedBox(width: 8),
                    _HeaderIconButton(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/icons/AyudaSoporteV2_icon.svg',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(8.32),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'MONITOR DE SERVICIOS SA',
                          style: AppStyle.useNeoSans(
                            Colors.white,
                            14,
                            FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset('assets/icons/Switch.svg'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ===== TABS =====
              SizedBox(
                height: 33,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    final selected = _selectedTab == i;
                    return InkWell(
                      onTap: () => setState(() => _selectedTab = i),
                      borderRadius: BorderRadius.circular(350),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7.5,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? orange : Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: selected ? orange : Color(0XFFE5E5E5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _tabs[i],
                              style: AppStyle.useGoogleFont(
                                selected ? Colors.white : navy,
                                14,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: _tabs.length,
                ),
              ),

              const SizedBox(height: 16),

              // ===== SUMMARY (horizontal scroll) =====
              SizedBox(
                height: 154.36, // ajusta según tu card
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final items = [
                      const _MiniSummaryCard(
                        title: "Cuentas",
                        iconAsset: "assets/icons/Cuenta_icon.svg",
                        amounts: [
                          "RD\$ 20,182,372.99",
                          "US\$ 20,000.00",
                          "EU\$ 3,576.02",
                        ],
                      ),
                      const _MiniSummaryCard(
                        title: "Préstamos",
                        iconAsset: "assets/icons/Préstamos_icon.svg",
                        amounts: [
                          "RD\$ 20,182,372.99",
                          "US\$ 20,000.00",
                          "EU\$ 3,576.02",
                        ],
                      ),
                      const _MiniSummaryCard(
                        title: "Tarjetas",
                        iconAsset: "assets/icons/Tarjetas.svg",
                        amounts: [
                          "RD\$ 20,182,372.99",
                          "US\$ 20,000.00",
                          "EU\$ 3,576.02",
                        ],
                      ),
                      const _MiniSummaryCard(
                        title: "Depósito a\nplazo",
                        iconAsset: "assets/icons/Certificados (1).svg",
                        amounts: ["RD\$ 20,182,372.99", "US\$ 20,000.00"],
                      ),
                    ];

                    return SizedBox(width: 142, child: items[i]);
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ===== QUICK ACCESS =====
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Accesos rápidos",
                        style: AppStyle.useGoogleFont(
                          Color(0XFF424242),
                          20,
                          FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "Agregar",
                            style: AppStyle.useGoogleFont(
                              Color(0XFF012169),
                              12,
                              FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/icons/AddSubtract_icon (1).svg',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    _QuickAccessTile(
                      label: "Adición de\nbeneficiario",
                      iconAsset: "assets/icons/Frame 4.svg",
                    ),
                    SizedBox(width: 8),
                    _QuickAccessTile(
                      label: "Pago\nempleados",
                      iconAsset: "assets/icons/Frame 4 (1).svg",
                    ),
                    SizedBox(width: 8),
                    _QuickAccessTile(
                      label: "Código\nCash",
                      iconAsset: "assets/icons/Frame 4 (2).svg",
                    ),
                    SizedBox(width: 8),
                    _QuickAccessTile(
                      label: "Pago\nTarjetas de\ncrédito",
                      iconAsset: "assets/icons/Frame 4 (3).svg",
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ===== RECOMMENDED =====
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Recomendados para ti",
                        style: AppStyle.useGoogleFont(
                          Color(0XFF424242),
                          20,
                          FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ver más",
                            style: AppStyle.useGoogleFont(
                              Color(0XFF012169),
                              12,
                              FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          SvgPicture.asset('assets/icons/Chevron_icon (2).svg'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Container(
                height: 312 + 24,
                clipBehavior: Clip.none,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final items = _recommendedCards();
                    final data = items[i];
                    return _RecommendedCard(
                      title: data.title,
                      desc: data.desc,
                      leftBtn: data.leftBtn,
                      rightBtn: data.rightBtn,
                      iconAsset: data.iconAsset,
                    );
                  },
                ),
              ),

              const SizedBox(height: 31),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BizBottomBar(
        selectedIndex: _selectedBottom,
        onSelect: (i) => setState(() => _selectedBottom = i),
        onCenterTap: () {},
      ),
    );
  }
}

class _CircleInitials extends StatelessWidget {
  final String text;
  final Color bg;
  final Color border;
  final Color textColor;
  final double? size;

  const _CircleInitials({
    required this.text,
    required this.bg,
    required this.border,
    required this.textColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/profile-menu');
      },
      child: Container(
        width: size ?? 40,
        height: size ?? 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyle.useNeoSans(textColor, 18, FontWeight.w400),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _HeaderIconButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFDCF3FF),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _MiniSummaryCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final List<String> amounts;

  const _MiniSummaryCard({
    required this.title,
    required this.iconAsset,
    required this.amounts,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const line = Color(0xFFE5E5E5);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconAsset),
          const SizedBox(height: 4.6),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppStyle.useNeoSans(
                    navy,
                    16,
                    FontWeight.w500,
                  ).copyWith(height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final a in amounts)
                  Text.rich(
                    TextSpan(
                      children: _moneySpan(a),
                      style: AppStyle.useNeoSans(
                        const Color(0xFF002B49),
                        12,
                        FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<InlineSpan> _moneySpan(String value) {
  // Ej: "RD$ 20,182,372.99" => moneda="RD$" resto="20,182,372.99"
  final parts = value.trim().split(RegExp(r'\s+'));
  final currency = parts.isNotEmpty ? parts.first : '';
  final rest = parts.length > 1 ? parts.sublist(1).join(' ') : '';

  return [
    TextSpan(
      text: currency,
      style: AppStyle.useNeoSans(const Color(0xFF002B49), 12, FontWeight.w700),
    ),
    const TextSpan(text: ' '),
    TextSpan(
      text: rest,
      style: AppStyle.useNeoSans(const Color(0xFF002B49), 12, FontWeight.w400),
    ),
  ];
}

class _QuickAccessTile extends StatelessWidget {
  final String label;
  final String iconAsset;

  const _QuickAccessTile({required this.label, required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {},
      child: Container(
        width: 89,
        height: 102,
        decoration: BoxDecoration(
          color: const Color(0xFFDCF3FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const SizedBox(height: 6),
            SvgPicture.asset(iconAsset),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppStyle.useGoogleFont(
                Color(0XFF012169),
                12,
                FontWeight.w600,
              ).copyWith(height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedCardData {
  final String title;
  final String desc;
  final String leftBtn;
  final String rightBtn;
  final String iconAsset;

  const _RecommendedCardData({
    required this.title,
    required this.desc,
    required this.leftBtn,
    required this.rightBtn,
    required this.iconAsset,
  });
}

List<_RecommendedCardData> _recommendedCards() => const [
  _RecommendedCardData(
    title: 'Depósito a Plazo Fijo + Pagos',
    desc:
        'Maximiza tu dinero con tasas competitivas. Abre tu cuenta de ahorro a plazo fijo y disfruta de la tranquilidad financiera.',
    leftBtn: 'Beneficios',
    rightBtn: 'Abrir depósito',
    iconAsset: 'assets/icons/Frame 427318227.svg',
  ),
  _RecommendedCardData(
    title: 'Cuenta Digital Libre + Tarjeta\nde Débito Digital',
    desc:
        'Tu dinero, libre y sin vueltas. Abre tu cuenta sin costo, maneja todo desde tu celular y disfruta de tus beneficios al instante.',
    leftBtn: 'Beneficios',
    rightBtn: 'Solicitar ahora',
    iconAsset: 'assets/icons/Frame 427318227 (1).svg',
  ),
  _RecommendedCardData(
    title: 'Préstamo',
    desc:
        'Haz realidad eso que vienes postergando. Solicita tu préstamo fácil, rápido y sin complicaciones.',
    leftBtn: 'Beneficios',
    rightBtn: 'Solicitar ahora',
    iconAsset: 'assets/icons/Frame 427318227 (2).svg',
  ),
  _RecommendedCardData(
    title: 'Tarjeta de Crédito',
    desc:
        'Disfruta de compras sin límites. Obtén tu tarjeta de crédito y accede a promociones exclusivas y financiamiento flexible.',
    leftBtn: 'Beneficios',
    rightBtn: 'Adquirir ahora',
    iconAsset: 'assets/icons/Frame 427318227 (3).svg',
  ),
];

class _RecommendedCard extends StatelessWidget {
  final String title;
  final String desc;
  final String leftBtn;
  final String rightBtn;
  final String iconAsset;

  const _RecommendedCard({
    required this.title,
    required this.desc,
    required this.leftBtn,
    required this.rightBtn,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 312,
      width: 342,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
            color: Color.fromRGBO(1, 32, 105, 0.08),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconAsset),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppStyle.useGoogleFont(
                    Color(0XFF002B49),
                    18,
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Color(0XFFE5E5E5)),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              desc,
              style: AppStyle.useGoogleFont(
                const Color(0xFF3B4559),
                14,
                FontWeight.w400,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _OutlineSmallButton(text: leftBtn, onTap: () {}),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PrimarySmallButton(text: rightBtn, onTap: () {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlineSmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OutlineSmallButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const line = Color(0xFFE5E5E5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: line),
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyle.useGoogleFont(navy, 16, FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _PrimarySmallButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PrimarySmallButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: navy,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyle.useGoogleFont(Colors.white, 17, FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class BizBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCenterTap;

  const BizBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);

    Widget navItem({
      required int index,
      required Widget icon,
      required String label,
      required String iconPath,
    }) {
      final selected = selectedIndex == index;
      return Expanded(
        child: InkWell(
          onTap: () => onSelect(index),
          child: SizedBox(
            height: 85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                SvgPicture.asset(
                  'assets/icons/$iconPath.svg',
                  colorFilter: ColorFilter.mode(
                    selected ? navy : Color(0XFF5E5F60),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w500,
                    color: selected ? navy : Color(0XFF5E5F60),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: 85,
        child: Stack(
          clipBehavior: Clip.none, // ✅ para que no se corte el círculo
          children: [
            // ===== Barra blanca con sombra y esquinas redondeadas =====
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(1, 32, 105, 0.16),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    navItem(
                      index: 0,
                      icon: const Icon(Icons.home_rounded),
                      label: "Inicio",
                      iconPath: 'IraInicio_icon',
                    ),
                    navItem(
                      index: 1,
                      icon: const Icon(Icons.access_time_rounded),
                      label: "Autorizaciones",
                      iconPath: 'AutorizacionesPendientes_icon (1)',
                    ),

                    const SizedBox(width: 70),

                    navItem(
                      index: 3,
                      icon: const Icon(Icons.handshake_outlined),
                      label: "Pago\nempleados",
                      iconPath: 'Desembolsos_icon',
                    ),
                    navItem(
                      index: 4,
                      icon: const Icon(Icons.add_rounded),
                      label: "Más",
                      iconPath: 'AddSubtract_icon (2)',
                    ),
                  ],
                ),
              ),
            ),

            // ===== Botón central (aro blanco + círculo naranja) =====
            Positioned(
              top: -26,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onCenterTap,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFED8B00),
                        shape: BoxShape.circle,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color.fromRGBO(1, 32, 105, 0.16),
                        //     blurRadius: 12,
                        //     offset: const Offset(0, 4),
                        //     spreadRadius: 0,
                        //   ),
                        // ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/Transferir_icon.svg',
                        ),
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
