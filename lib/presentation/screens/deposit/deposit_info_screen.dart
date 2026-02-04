import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DepositInfoScreen extends StatelessWidget {
  const DepositInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 12, bottom: 16, left: 24, right: 24),
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/deposit-create');
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0XFF002B49),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Aperturar Depósito a plazo',
                      style: AppStyle.useGoogleFont(
                        Colors.white,
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8E6DF), Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  width: double.infinity,
                  height: 72,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            final router = GoRouter.of(context);

                            if (router.canPop()) {
                              router.pop();
                            } else {
                              context.go('/dashboard');
                            }
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/Chevron_icon (1).svg',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'BENEFICIOS DEL PRODUCTO',
                          style: TextStyle(
                            fontFamily: 'Neo Sans Std',
                            color: Color(0xFF002B49),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
                  child: const _MainCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainCard extends StatelessWidget {
  const _MainCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card principal
        Container(
          padding: const EdgeInsets.fromLTRB(16, 73, 16, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(68, 68, 69, 0.06),
                blurRadius: 4,
                offset: Offset(0, -1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Depósito a plazo',
                  style: AppStyle.useGoogleFont(
                    Color(0xFF002B49),
                    24,
                    FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Es un instrumento de inversión diseñado para ofrecerle un interés anual a una tasa altamente competitiva, garantizando así un mayor rendimiento de sus ahorros.',
                style: AppStyle.useGoogleFont(
                  Color(0xFF424242),
                  16,
                  FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              const _BenefitItem(
                iconName: 'TasaRendimiento_icon (1)',
                icon: Icons.percent,
                title: 'Tasas preferenciales',
                description:
                    'Acceda a tasas competitivas diseñadas para maximizar el rendimiento de su inversión.',
              ),
              const _DividerLine(),
              const SizedBox(height: 16),

              const _BenefitItem(
                iconName: 'Recurrentes Copy 2',
                icon: Icons.phone_android,
                title: 'Inversión cómoda y accesible',
                description:
                    'Realice sus inversiones de manera eficiente y segura en tan solo minutos.',
              ),
              const _DividerLine(),
              const SizedBox(height: 16),

              const _BenefitItem(
                iconName: 'AccesoaDinero',
                icon: Icons.flash_on,
                title: 'Acceso inmediato',
                description:
                    'Disponga de sus fondos el mismo día de su cancelación.',
              ),
              const _DividerLine(),
              const SizedBox(height: 16),

              const _BenefitItem(
                iconName: 'Cerdito',
                icon: Icons.savings,
                title: 'Inversión en múltiples monedas',
                description:
                    'Haga crecer su capital en pesos, dólares o euros.',
              ),

              // // // // //
              const SizedBox(height: 24),

              Text(
                'Monto mínimo de inversión',
                style: AppStyle.useGoogleFont(
                  Color(0XFF002B49),
                  18,
                  FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              const _AmountRow(label: 'Pesos', value: 'RD\$ 10,000.00'),
              const _AmountRow(label: 'Dólares', value: 'US\$ 3,000.00'),
              const _AmountRow(
                label: 'Euros',
                value: 'EU\$ 3,000.00',
                showDivider: false,
              ),
            ],
          ),
        ),

        // Icono flotante superior
        Positioned(
          top: -44,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/icons/Group 9.png'),
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String iconName;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/$iconName.svg'),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyle.useGoogleFont(
                    Color(0XFF002B49),
                    16,
                    FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppStyle.useGoogleFont(
                    Color(0XFF424242),
                    16,
                    FontWeight.w400,
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

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1.5, thickness: 1.5, color: Color(0xFFEBEBEB));
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _AmountRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyle.useGoogleFont(Color(0XFF002B49), 16, FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppStyle.useGoogleFont(Color(0XFF3B4559), 16, FontWeight.w400),
        ),
        const SizedBox(height: 10),
        if (showDivider)
          const Divider(height: 1.5, thickness: 1.5, color: Color(0xFFEBEBEB)),
      ],
    );
  }
}
