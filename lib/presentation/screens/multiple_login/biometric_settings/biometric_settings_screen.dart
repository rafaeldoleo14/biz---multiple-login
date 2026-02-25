import 'package:biz_codigo_cash/provider/multiple_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BiometricSettingsScreen extends StatelessWidget {
  const BiometricSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF012169);
    const line = Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: Colors.white,

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
                      onPressed: () => context.pop(),
                      icon: SvgPicture.asset(
                        'assets/icons/Chevron_icon (5).svg', // <-- tu back
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            Container(height: 1, color: line),

            Consumer<MultipleLoginProvider>(
              builder: (_, provider, __) {
                final user = provider.loggedUser;

                final enabled = user?.biometricsEnabled ?? false;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Acceso con Rostro / Huella",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF002B49),
                        ),
                      ),
                      Switch(
                        value: enabled,
                        activeThumbColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFFED8B00),
                        inactiveTrackColor: Color.fromRGBO(120, 120, 128, 0.16),
                        padding: EdgeInsets.zero,
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        trackOutlineWidth: WidgetStateProperty.all(0),
                        onChanged: user == null
                            ? null
                            : (value) async {
                                if (!value) {
                                  provider.setBiometricsEnabled(
                                    company: user.company,
                                    username: user.username,
                                    enabled: false,
                                  );
                                  return;
                                }

                                final ok = await showEnableBiometricsDialog(
                                  context,
                                );

                                if (!ok) {
                                  return;
                                }

                                provider.setBiometricsEnabled(
                                  company: user.company,
                                  username: user.username,
                                  enabled: true,
                                );
                              },
                      ),
                    ],
                  ),
                );
              },
            ),

            Container(height: 1, color: line),
          ],
        ),
      ),
    );
  }
}

Future<bool> showEnableBiometricsDialog(BuildContext context) async {
  const navy = Color(0xFF002B49);
  const orange = Color(0xFFED8B00);
  const border = Color(0xFFE5E5E5);

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.32),
    builder: (ctx) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "¿Desea configurar sus datos biométricos para esta empresa?",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Solo puede activar el acceso rápido con datos biométricos en una empresa a la vez.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Activar (naranja)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 13.5),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(
                      "Activar",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Cancelar (blanco borde)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 13.5),
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: navy,
                      side: const BorderSide(color: border, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(
                      "Cancelar",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF002B49),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  return result ?? false;
}
