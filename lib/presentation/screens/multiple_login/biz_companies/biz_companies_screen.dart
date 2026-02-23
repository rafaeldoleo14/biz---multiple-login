import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/multiple_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BizCompaniesScreen extends StatefulWidget {
  const BizCompaniesScreen({super.key});

  @override
  State<BizCompaniesScreen> createState() => _BizCompaniesScreenState();
}

class _BizCompaniesScreenState extends State<BizCompaniesScreen>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _barrierEntry;
  OverlayEntry? _toastEntry;
  AnimationController? _toastCtrl;
  int toastSeq = 0;
  late final MultipleLoginProvider multipleLoginProvider;

  @override
  void initState() {
    super.initState();
    multipleLoginProvider = Provider.of<MultipleLoginProvider>(
      context,
      listen: false,
    );
  }

  void _clearToastOverlay() {
    _barrierEntry?.remove();
    _toastEntry?.remove();
    _barrierEntry = null;
    _toastEntry = null;

    _toastCtrl?.dispose();
    _toastCtrl = null;
  }

  void _removeToastOverlay() {
    toastSeq++; // invalida cualquier delayed anterior
    _clearToastOverlay();
  }

  @override
  void dispose() {
    _removeToastOverlay();
    super.dispose();
  }

  static const navy = Color(0xFF002B49);
  static const line = Color(0xFFE5E5E5);
  static const bg = Color(0XFFFAFAFA);
  static const orange = Color(0xFFED8B00);

  bool _unlinkMode = false;
  final Set<int> _selectedIndexes = {};

  // ✅ NEW: evita taps/navegación mientras se procesa eliminar (y evita taps “en cola”)
  bool _busy = false;

  bool get _canUnlink => _selectedIndexes.isNotEmpty;

  void _enterUnlinkMode() {
    if (_busy) return;
    setState(() {
      _unlinkMode = true;
      _selectedIndexes.clear();
    });
  }

  void _exitUnlinkMode() {
    if (_busy) return;
    setState(() {
      _unlinkMode = false;
      _selectedIndexes.clear();
    });
  }

  void _toggle(int i) {
    if (_busy) return;
    setState(() {
      if (_selectedIndexes.contains(i)) {
        _selectedIndexes.remove(i);
      } else {
        _selectedIndexes.add(i);
      }
    });
  }

  int _toastSeq = 0; // ponlo en tu State (arriba)

  void _showToastCards({
    List<String> successTexts = const [],
    List<String> errorTexts = const [],
  }) {
    if (!mounted) return;

    _toastSeq++;
    final mySeq = _toastSeq;

    // ✅ Importante: mostrarlo después del frame donde hiciste setState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (mySeq != _toastSeq) return;

      await showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'toast',
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (ctx, anim1, anim2) {
          // auto-close (con token para no cerrar uno nuevo por error)
          Future.delayed(const Duration(seconds: 3), () {
            if (!mounted) return;
            if (mySeq != _toastSeq) return;

            final nav = Navigator.of(ctx, rootNavigator: true);
            if (nav.canPop()) nav.pop();
          });

          return SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                child: Material(
                  color: Colors.transparent,
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      decorationColor: Colors.transparent,
                    ),
                    child: _buildToastStack(
                      successTexts: successTexts,
                      errorTexts: errorTexts,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (ctx, anim, _, child) {
          final curve = CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );

          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            ),
          );
        },
      );
    });
  }

  // ✅ helper para no tocar tu UI (mismos widgets que ya tienes)
  Widget _buildToastStack({
    required List<String> successTexts,
    required List<String> errorTexts,
  }) {
    final items = <Widget>[
      for (final t in successTexts) _ToastCard(text: t, isSuccess: true),
      for (final t in errorTexts) _ToastCard(text: t, isSuccess: false),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Future<void> _unlinkSelected() async {
    if (!_canUnlink || _busy) return;

    setState(() => _busy = true);

    // ✅ Simulación (tú lo conectas a API)
    //    even => success, odd => fail
    final selected = _selectedIndexes.toList()..sort();
    final selectedNames = selected
        .map((i) => multipleLoginProvider.companies[i])
        .toList();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final success = <String>[];
    final failed = <String>[];

    for (int k = 0; k < selectedNames.length; k++) {
      if (k.isEven) {
        success.add(selectedNames[k]);
      } else {
        failed.add(selectedNames[k]);
      }
    }

    // ✅ Remueve las que fueron éxito (opcional, pero suele ser lo esperado)
    setState(() {
      // eliminar por nombre para no romper índices
      for (final s in success) {
        multipleLoginProvider.companies.remove(s);
      }
      _unlinkMode = false;
      _selectedIndexes.clear();
      _busy = false; // ✅ libera taps después de actualizar estado
    });

    final successTexts = <String>[];
    final errorTexts = <String>[];

    if (success.isNotEmpty) {
      successTexts.add(
        success.length == 1
            ? "Empresa desvinculada\nsatisfactoriamente."
            : "Empresas desvinculadas\nsatisfactoriamente.",
      );
    }

    if (failed.isNotEmpty) {
      errorTexts.add(
        failed.length == 1
            ? "La empresa no ha podido ser\ndesvinculada en estos momentos."
            : "Las empresas no han podido ser\ndesvinculadas en estos momentos.",
      );
    }

    _showToastCards(successTexts: successTexts, errorTexts: errorTexts);
  }

  void _onBack(BuildContext context) {
    if (_busy) return;

    // ✅ si está en modo desvincular, vuelve al modo normal
    if (_unlinkMode) {
      _exitUnlinkMode();
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _unlinkMode
        ? "Seleccione la cuenta con la que desea desvincular"
        : "Seleccione la cuenta con la que desea acceder";

    final MultipleLoginProvider multipleLoginProvider =
        Provider.of<MultipleLoginProvider>(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
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
                      onPressed: () => _onBack(context),
                      icon: SvgPicture.asset(
                        'assets/icons/Chevron_icon (5).svg',
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Empresas",
                      style: AppStyle.useNeoSans(
                        const Color(0xFF012169),
                        16,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                subtitle,
                style: AppStyle.useGoogleFont(navy, 14, FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: multipleLoginProvider.companies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final name = multipleLoginProvider.companies[i];
                  final selected = _selectedIndexes.contains(i);

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (_busy) return; // ✅ NEW: evita navegación accidental

                      if (_unlinkMode) {
                        _toggle(i);
                      } else {
                        context.push('/company-login', extra: name);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 19,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: line),
                      ),
                      child: Row(
                        children: [
                          if (_unlinkMode) ...[
                            // ✅ Checkbox estilo mock
                            SizedBox(
                              height: 31.81,
                              width: 31.81,
                              child: Center(
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: selected ? orange : Colors.white,
                                    borderRadius: BorderRadius.circular(3.6),
                                    border: Border.all(color: orange, width: 2),
                                  ),
                                  child: selected
                                      ? Center(
                                          child: SizedBox(
                                            width: 12.92,
                                            height: 9.97,
                                            child: SvgPicture.asset(
                                              'assets/icons/Checkmark2.svg',
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyle.useGoogleFont(
                                navy,
                                14,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // ✅ Solo chevron en modo normal
                          if (!_unlinkMode)
                            SvgPicture.asset(
                              'assets/icons/Chevron_icon (6).svg',
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // =========================
      // Bottom bar cambia por modo
      // =========================
      bottomNavigationBar: _unlinkMode
          ? _UnlinkBottomBar(
              onCancel: _exitUnlinkMode,
              onConfirm: _canUnlink ? _unlinkSelected : null,
            )
          : _NormalBottomBar(
              onAddCompany: () => context.push('/add-company'),
              onUnlink: _enterUnlinkMode,
            ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  final String text;
  final bool isSuccess;

  const _ToastCard({required this.text, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    // Colores del mock
    final bg = isSuccess ? const Color(0xFFD9F0FF) : const Color(0xFFFFF0D9);
    final textColor = isSuccess
        ? const Color(0xFF002B49)
        : const Color(0xFF3D3D3D);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Icon (6).svg',
            colorFilter: ColorFilter.mode(
              isSuccess ? const Color(0xFF002B49) : const Color(0xFFED8B00),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyle.useGoogleFont(textColor, 14, FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// Bottom bar normal: Agregar / Desvincular
// =====================================================
class _NormalBottomBar extends StatelessWidget {
  final VoidCallback onAddCompany;
  final VoidCallback onUnlink;

  const _NormalBottomBar({required this.onAddCompany, required this.onUnlink});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF002B49);
    const line = Color(0xFFE5E5E5);

    return SafeArea(
      child: Container(
        height: 110,
        decoration: const BoxDecoration(
          color: Color(0XFFFAFAFA),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
              color: Color.fromRGBO(68, 68, 69, 0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onAddCompany,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/AddSubtract_icon (3).svg'),
                    const SizedBox(height: 4),
                    Text(
                      "Agregar\nempresa",
                      textAlign: TextAlign.center,
                      style: AppStyle.useGoogleFont(
                        navy,
                        14,
                        FontWeight.w500,
                      ).copyWith(height: 1.2),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, height: double.infinity, color: line),
            Expanded(
              child: InkWell(
                onTap: onUnlink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/Desvincular_icon (1).svg'),
                    const SizedBox(height: 4),
                    Text(
                      "Desvincular",
                      textAlign: TextAlign.center,
                      style: AppStyle.useGoogleFont(navy, 14, FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// Bottom bar unlink: Cancelar / Eliminar (habilitado)
// =====================================================
class _UnlinkBottomBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;

  const _UnlinkBottomBar({required this.onCancel, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    const line = Color(0xFFE5E5E5);
    const navy = Color(0xFF002B49);

    final enabled = onConfirm != null;

    return SafeArea(
      child: Container(
        height: 110,
        decoration: const BoxDecoration(
          color: Color(0XFFFAFAFA),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
              color: Color.fromRGBO(68, 68, 69, 0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onCancel,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/Close_icon.svg'),
                    const SizedBox(height: 4),
                    Text(
                      "Cancelar",
                      style: AppStyle.useGoogleFont(navy, 14, FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Container(width: 1, height: double.infinity, color: line),
            Expanded(
              child: InkWell(
                onTap: enabled ? onConfirm : null,
                child: Opacity(
                  opacity: enabled ? 1 : 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      enabled
                          ? SvgPicture.asset('assets/icons/Check2.svg')
                          : SvgPicture.asset(
                              'assets/icons/Desvincular_icon (2).svg',
                            ),
                      const SizedBox(height: 4),
                      Text(
                        enabled ? "Eliminar" : 'Desvincular',
                        style: AppStyle.useGoogleFont(
                          enabled ? Color(0XFFC8102E) : Color(0XFF9E9E9E),
                          14,
                          FontWeight.w500,
                        ),
                      ),
                    ],
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
