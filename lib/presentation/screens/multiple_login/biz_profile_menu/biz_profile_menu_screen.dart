import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/multiple_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BizProfileMenuScreen extends StatelessWidget {
  const BizProfileMenuScreen({super.key});

  static const navy = Color(0xFF002B49);
  static const titleNavy = Color(0xFF012169);
  static const bg = Color(0xFFFAFAFA);
  static const line = Color(0xFFEDEDED);
  static const orange = Color(0xFFED8B00);

  static const iconBg = Color(0xFFE9F4FF); // azul clarito del icon container

  @override
  Widget build(BuildContext context) {
    MultipleLoginProvider multipleLoginProvider =
        Provider.of<MultipleLoginProvider>(context);
    // Ejemplo (puedes pasar esto por params)
    final initials = "UP";
    final fullName = "Usuario Prueba";

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =======================
              // Header: back + pill btn
              // =======================
              SizedBox(
                height: 72,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: SvgPicture.asset(
                          'assets/icons/Chevron_icon (5).svg', // <-- tu back
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24),
                        child: _PillButton(text: "Editar perfil", onTap: () {}),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // =======================
              // Avatar + nombre
              // =======================
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDCF3FF),
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    initials,
                    style: AppStyle.useNeoSans(
                      titleNavy,
                      24,
                      FontWeight.w500,
                    ).copyWith(height: 0),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  fullName,
                  textAlign: TextAlign.center,
                  style: AppStyle.useNeoSans(
                    const Color(0xFF002B49),
                    20,
                    FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // =======================
              // Card 1 (5 items)
              // =======================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _MenuCard(
                  children: [
                    _MenuItem(
                      iconAsset: 'assets/icons/Button_menu.svg', // <-- cambia
                      title: "Centro de mensajes",
                      onTap: () {
                        // context.push('/messages-center');
                      },
                    ),
                    _MenuDivider(),
                    _MenuItem(
                      iconAsset:
                          'assets/icons/Button_menu (1).svg', // <-- cambia
                      title: "Empresas",
                      onTap: () {
                        context.push('/companies');
                      },
                    ),
                    _MenuDivider(),
                    _MenuItem(
                      iconAsset:
                          'assets/icons/Button_menu (2).svg', // <-- cambia
                      title: "Token Popular",
                      onTap: () {
                        // context.push('/token-popular');
                      },
                    ),
                    _MenuDivider(),
                    _MenuItem(
                      iconAsset:
                          'assets/icons/Documents_icon.svg', // <-- cambia
                      title: "Documentos legales",
                      onTap: () {
                        // context.push('/legal-documents');
                      },
                    ),
                    _MenuDivider(),
                    _MenuItem(
                      iconAsset:
                          'assets/icons/Button_menu (3).svg', // <-- cambia
                      title: "Configurar",
                      onTap: () {
                        context.push('/biometric-settings');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =======================
              // Card 2 (2 items)
              // =======================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _MenuCard(
                  children: [
                    _MenuItem(
                      iconAsset:
                          'assets/icons/Button_menu (4).svg', // <-- cambia
                      title: "Desvincular cuenta",
                      onTap: () {},
                    ),
                    _MenuDivider(),
                    _MenuItem(
                      iconAsset:
                          'assets/icons/Button_menu (5).svg', // <-- cambia
                      title: "Salir",
                      onTap: () {
                        multipleLoginProvider.logout();
                        context.go('/welcome');
                      },
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

class _PillButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
        ),
        child: Text(
          text,
          style: AppStyle.useGoogleFont(
            const Color(0xFF424242),
            14,
            FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;

  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
            color: Color.fromRGBO(1, 32, 105, 0.08),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: children),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.iconAsset,
    required this.title,
    required this.onTap,
  });

  static const navy = Color(0xFF002B49);
  static const orange = Color(0xFFED8B00);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 16,
          bottom: 16,
          right: 20,
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppStyle.useGoogleFont(navy, 16, FontWeight.w400),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/Chevron_icon (6).svg', // <-- chevron derechodd
              colorFilter: const ColorFilter.mode(orange, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: const Color(0xFFE5E5E5),
    );
  }
}
