import 'dart:math';

import 'package:biz_codigo_cash/data/activacion_multiple/card.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/activacion_multiple/loader_popoup.dart';
import 'package:biz_codigo_cash/presentation/widget/search_textfield.dart';
import 'package:biz_codigo_cash/provider/multiple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomFabLocation extends FloatingActionButtonLocation {
  final double xOffset, yOffset;
  CustomFabLocation(this.xOffset, this.yOffset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // scaffoldGeometry.scaffoldSize da el tamaño total
    return Offset(xOffset, scaffoldGeometry.scaffoldSize.height - yOffset);
  }
}

class ManageCardScreen extends StatelessWidget {
  const ManageCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultipleActivationProvider>(context);

    final pendingCount = provider.cards
        .where((c) => c.status == Status.activacionPendiente)
        .length;

    return Scaffold(
      backgroundColor: Color(0XFFFAFAFA),
      body: SafeArea(
        child: IgnorePointer(
          ignoring: provider.isLoadingAll,
          child: Container(
            color: Color(0XFFFAFAFA),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Header(),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0XFFE5E5E5),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MONITOR DE SERVICIOS SA',
                            style: AppStyle.useGoogleFont(
                              Color(0XFF424242),
                              14,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Center(
                        child: SearchTextfield(
                          hintText: 'Buscar tarjeta',
                          icon2: true,
                        ),
                      ),
                    ),
                    provider.isOpenContainer &&
                            !provider.isLoadingAll &&
                            !provider.multipleActivation
                        ? CardFilter()
                        : SizedBox(height: 0),
                    CardLayout(),
                  ],
                ),
                provider.isLoadingAll
                    ? Positioned(
                        bottom: 187,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SpinningWidget(
                            duration: Duration(milliseconds: 700),
                            child: SvgPicture.asset(
                              'assets/icons/Loading-x.svg',
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),

                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    // Ignora los toques cuando opacity = 0
                    ignoring:
                        provider.isLoadingAll || !provider.showScrollToTop,
                    child: AnimatedOpacity(
                      opacity:
                          (!provider.isLoadingAll && provider.showScrollToTop)
                          ? 1.0
                          : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            provider.scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          child: SvgPicture.asset('assets/icons/Swipe.svg'),
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
      bottomNavigationBar:
          !provider.isLoadingAll &&
              pendingCount >= 2 &&
              provider.isOpenContainer
          ? MultipleActivationButton()
          : null,
    );
  }
}

class CardFilter extends StatelessWidget {
  const CardFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> filterList = [
      'Advance',
      'Drive',
      'Impulsa',
      'Excelsa',
      'Otras',
      'Otras',
    ];

    return Container(
      padding: EdgeInsets.only(left: 16, top: 14, bottom: 14),
      width: double.infinity,
      height: 95,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0XFFE5E5E5), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccione la tarjeta que desea gestionar',
                style: AppStyle.useGoogleFont(
                  Color(0XFFB1B0B0),
                  13,
                  FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: filterList.length,
              itemBuilder: (context, index) {
                String filterName = filterList[index];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 13),
                  margin: EdgeInsets.only(right: 8),
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      filterName,
                      style: AppStyle.useGoogleFont(
                        Color(0XFF002B49),
                        14,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MultipleActivationButton extends StatelessWidget {
  const MultipleActivationButton({super.key});

  @override
  Widget build(BuildContext context) {
    MultipleActivationProvider provider =
        Provider.of<MultipleActivationProvider>(context);

    return SafeArea(
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 4,
              spreadRadius: 0,
              color: Color.fromRGBO(68, 68, 69, 0.06),
            ),
          ],
        ),
        child: provider.multipleActivation
            ? Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        provider.onMultipleActivation = false;
                      },
                      child: Center(
                        child: SizedBox(
                          width: 71,
                          height: 51,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/Close_icon (1).svg',
                              ),
                              Text(
                                'Cancelar',
                                style: AppStyle.useGoogleFont(
                                  Color(0XFF002B49),
                                  12,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, color: Color(0XFFE5E5E5)),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (provider.cards
                                .where((c) => c.selectedForActivation == true)
                                .toList()
                                .length <=
                            1) {
                          // Activación Simple
                          return;
                        }

                        showLoader(context);
                      },
                      child: Center(
                        child: SizedBox(
                          width: 71,
                          height: 51,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset('assets/icons/Check.svg'),
                              Text(
                                'Activar',
                                style: AppStyle.useGoogleFont(
                                  Color(0XFF002B49),
                                  12,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  InkWell(
                    onTap: () {
                      provider.onMultipleActivation = true;
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        SvgPicture.asset('assets/icons/Activar Plástico.svg'),
                        SizedBox(height: 4),
                        Text(
                          'Activación',
                          style: AppStyle.useGoogleFont(
                            Color(0XFF002B49),
                            12,
                            FontWeight.w500,
                          ),
                        ),
                        Text(
                          'múltiple',
                          style: AppStyle.useGoogleFont(
                            Color(0XFF002B49),
                            12,
                            FontWeight.w500,
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

class CardLayout extends StatefulWidget {
  const CardLayout({super.key});

  @override
  State<CardLayout> createState() => _CardLayoutState();
}

void showAutoDismissMessage(BuildContext context, String text) {
  final snackBar = SnackBar(
    elevation: 0,
    padding: EdgeInsets.zero,
    content: Container(
      padding: EdgeInsets.only(left: 8, right: 16, top: 12, bottom: 12),
      height: 96,
      decoration: BoxDecoration(color: Color(0XFFFFFAF1)),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/info.svg'),
          SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              width: 286,
              child: Text(
                'Ha alcanzado el número máximo de tarjetas que se pueden activar simultáneamente.',
                style: AppStyle.useGoogleFont(
                  Color(0XFFBB6200),
                  14,
                  FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    duration: const Duration(seconds: 5), // se auto-oculta tras 2 segundos
    behavior: SnackBarBehavior.floating, // opcional: flota sobre el contenido
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar() // opcional: cierra cualquier SnackBar anterior
    ..showSnackBar(snackBar);
}

class _CardLayoutState extends State<CardLayout> {
  late MultipleActivationProvider multipleActivationProvider;
  late VoidCallback _scrollListener; // ← 1. guarda la referencia

  @override
  void initState() {
    super.initState();

    multipleActivationProvider = Provider.of<MultipleActivationProvider>(
      context,
      listen: false,
    );

    // 2. define el callback UNA sola vez y guárdalo
    _scrollListener = () {
      final isScrolled =
          multipleActivationProvider.scrollController.offset > 100;

      if (isScrolled != multipleActivationProvider.showScrollToTop) {
        if (!mounted) return; // seguridad extra
        setState(() {
          multipleActivationProvider.showScrollToTop = isScrolled;
        });
      }
    };

    // 3. registra exactamente ese callback
    multipleActivationProvider.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // 4. remueve **la misma referencia** del paso 3
    multipleActivationProvider.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MultipleActivationProvider multipleActivationProvider =
        Provider.of<MultipleActivationProvider>(context);

    final displayCards = multipleActivationProvider.multipleActivation
        ? multipleActivationProvider.cards
              .where((c) => c.status == Status.activacionPendiente)
              .toList()
        : multipleActivationProvider.cards;

    String formatBalance(double balance) {
      // "#,##0.00" pone coma de miles y siempre dos decimales
      final formatter = NumberFormat('#,##0.00', 'en_US');
      return formatter.format(balance);
    }

    return Expanded(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(), // nada de rebote
        controller: multipleActivationProvider.scrollController,
        shrinkWrap: true,
        itemCount: cardBoxList.length,
        itemBuilder: (context, index) {
          CardBox cardItem = cardBoxList[index];
          return Column(
            children: [
              InkWell(
                onTap: () {
                  if (index != 0) return;
                  setState(() {
                    multipleActivationProvider.isOpenContainer =
                        !multipleActivationProvider.isOpenContainer;
                    multipleActivationProvider.onNotifyChanges();
                  });
                  // Cuando abrimos, lanzamos la "carga" de 4s
                  if (multipleActivationProvider.isOpenContainer) {
                    multipleActivationProvider.loadCards();
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 12),
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(0XFFF1EFEB),
                    border: Border(
                      bottom: BorderSide(color: Color(0XFFD0CBC3), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cardItem.title,
                        style: AppStyle.useGoogleFont(
                          Color(0XFF002B49),
                          14,
                          FontWeight.w600,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/${multipleActivationProvider.isOpenContainer ? 'Down-2' : 'Up-2'}.svg',
                      ),
                    ],
                  ),
                ),
              ),
              index == 0 && multipleActivationProvider.isOpenContainer
                  ? Column(
                      children: [
                        multipleActivationProvider.multipleActivation
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${multipleActivationProvider.cards.where((c) => c.selectedForActivation == true).toList().length}/20 Seleccionadas',
                                          style: AppStyle.useGoogleFont(
                                            Color(0XFF424242),
                                            12,
                                            FontWeight.w600,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (multipleActivationProvider.cards
                                                    .where(
                                                      (c) =>
                                                          c.selectedForActivation ==
                                                          true,
                                                    )
                                                    .toList()
                                                    .length <
                                                20) {
                                              multipleActivationProvider
                                                  .selectFirst20Pendings();
                                              return;
                                            }

                                            multipleActivationProvider
                                                .clearAllSelections();
                                          },
                                          child: Text(
                                            multipleActivationProvider.cards
                                                        .where(
                                                          (c) =>
                                                              c.selectedForActivation ==
                                                              true,
                                                        )
                                                        .toList()
                                                        .length <
                                                    20
                                                ? 'Seleccionar todas'
                                                : 'Deseleccionar todas',
                                            style: AppStyle.useGoogleFont(
                                              Color(0XFF4298B5),
                                              12,
                                              FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(height: 0),
                        ListView.builder(
                          physics:
                              NeverScrollableScrollPhysics(), // para que no choque con el scroll padre
                          shrinkWrap: true,
                          itemCount: displayCards.length,
                          itemBuilder: (context, index) {
                            CardI card = displayCards[index];
                            final isSelected = card.selectedForActivation;
                            final isLast =
                                multipleActivationProvider.multipleActivation
                                ? index == displayCards.length - 1
                                : index ==
                                      multipleActivationProvider.cards.length -
                                          1;
                            return GestureDetector(
                              onTap: () {
                                if (!isSelected &&
                                    multipleActivationProvider.cards
                                            .where(
                                              (c) =>
                                                  c.selectedForActivation ==
                                                  true,
                                            )
                                            .toList()
                                            .length >=
                                        20) {
                                  showAutoDismissMessage(context, 'Hello');
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: index == 0 ? 16 : 0,
                                  bottom: isLast ? 16 : 8,
                                  left: 17,
                                  right: 17,
                                ),
                                height: 72,
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0XFFE5E5E5),
                                    width: 1,
                                  ),
                                  color:
                                      !isSelected &&
                                          multipleActivationProvider.cards
                                                  .where(
                                                    (c) =>
                                                        c.selectedForActivation ==
                                                        true,
                                                  )
                                                  .toList()
                                                  .length >=
                                              20
                                      ? Color(0XFFFAFAFA)
                                      : Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          card.name,
                                          style: AppStyle.useGoogleFont(
                                            !isSelected &&
                                                    multipleActivationProvider
                                                            .cards
                                                            .where(
                                                              (c) =>
                                                                  c.selectedForActivation ==
                                                                  true,
                                                            )
                                                            .toList()
                                                            .length >=
                                                        20
                                                ? Color(0XFF9E9E9E)
                                                : Color(0XFF002B49),
                                            14,
                                            !isSelected &&
                                                    multipleActivationProvider
                                                            .cards
                                                            .where(
                                                              (c) =>
                                                                  c.selectedForActivation ==
                                                                  true,
                                                            )
                                                            .toList()
                                                            .length >=
                                                        20
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: card.isLoading ? 0 : 4,
                                        ),
                                        card.isLoading
                                            ? SizedBox(width: 0)
                                            : Text(
                                                card.status ==
                                                        Status
                                                            .activacionCompletada
                                                    ? 'Balance a la fecha: RD\$${formatBalance(card.balance)}'
                                                    : card.status.label,
                                                style: AppStyle.useGoogleFont(
                                                  Color(
                                                    !isSelected &&
                                                            multipleActivationProvider
                                                                    .cards
                                                                    .where(
                                                                      (c) =>
                                                                          c.selectedForActivation ==
                                                                          true,
                                                                    )
                                                                    .toList()
                                                                    .length >=
                                                                20 &&
                                                            multipleActivationProvider
                                                                .multipleActivation &&
                                                            card.status ==
                                                                Status
                                                                    .activacionPendiente
                                                        ? 0XFF9E9E9E
                                                        : card.status ==
                                                              Status
                                                                  .activacionPendiente
                                                        ? 0XFFD87100
                                                        : card.status ==
                                                              Status
                                                                  .activacionCompletada
                                                        ? 0XFF757575
                                                        : 0XFFC8102E,
                                                  ),
                                                  14,
                                                  FontWeight.w400,
                                                ),
                                              ),
                                      ],
                                    ),
                                    card.isLoading
                                        ? Center(
                                            child: SpinningWidget(
                                              duration: Duration(
                                                milliseconds: 700,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/Loading-2.svg',
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              if (card.status !=
                                                  Status.estatusNoValidado) {
                                                return;
                                              }

                                              multipleActivationProvider
                                                  .randomizeCardStatus(card);
                                            },
                                            child:
                                                isSelected &&
                                                        multipleActivationProvider
                                                            .multipleActivation ||
                                                    !isSelected &&
                                                        multipleActivationProvider
                                                            .multipleActivation
                                                ? InkWell(
                                                    onTap: () {
                                                      if (!isSelected &&
                                                          multipleActivationProvider
                                                                  .cards
                                                                  .where(
                                                                    (c) =>
                                                                        c.selectedForActivation ==
                                                                        true,
                                                                  )
                                                                  .toList()
                                                                  .length >=
                                                              20) {
                                                        return;
                                                      }

                                                      multipleActivationProvider
                                                          .toggleSelectedForActivation(
                                                            card,
                                                          );
                                                    },
                                                    child: Container(
                                                      height: 23.94,
                                                      width: 23.86,
                                                      decoration: BoxDecoration(
                                                        border:
                                                            !isSelected &&
                                                                multipleActivationProvider
                                                                        .cards
                                                                        .where(
                                                                          (c) =>
                                                                              c.selectedForActivation ==
                                                                              true,
                                                                        )
                                                                        .toList()
                                                                        .length <
                                                                    20
                                                            ? Border.all(
                                                                color: Color(
                                                                  0XFFED8B00,
                                                                ),
                                                                width: 2,
                                                              )
                                                            : !isSelected &&
                                                                  multipleActivationProvider
                                                                          .cards
                                                                          .where(
                                                                            (
                                                                              c,
                                                                            ) =>
                                                                                c.selectedForActivation ==
                                                                                true,
                                                                          )
                                                                          .toList()
                                                                          .length >=
                                                                      20
                                                            ? Border.all(
                                                                color: Color(
                                                                  0XFFBABABA,
                                                                ),
                                                                width: 2,
                                                              )
                                                            : null,
                                                        color:
                                                            !isSelected &&
                                                                multipleActivationProvider
                                                                        .cards
                                                                        .where(
                                                                          (c) =>
                                                                              c.selectedForActivation ==
                                                                              true,
                                                                        )
                                                                        .toList()
                                                                        .length <
                                                                    20
                                                            ? Colors.white
                                                            : !isSelected &&
                                                                  multipleActivationProvider
                                                                          .cards
                                                                          .where(
                                                                            (
                                                                              c,
                                                                            ) =>
                                                                                c.selectedForActivation ==
                                                                                true,
                                                                          )
                                                                          .toList()
                                                                          .length >=
                                                                      20
                                                            ? Colors.white
                                                            : Color(0XFFED8B00),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              3.36,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          'assets/icons/Checkmark (1).svg',
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/icons/${card.status == Status.estatusNoValidado ? 'Refresh_icon' : 'show'}.svg',
                                                  ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : SizedBox(height: 0),
            ],
          );
        },
      ),
    );
  }
}

/// Envuelve [child] y lo rota 360° de forma infinita.
class SpinningWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SpinningWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<SpinningWidget> createState() => _SpinningWidgetState();
}

class _SpinningWidgetState extends State<SpinningWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        return Transform.rotate(angle: _ctrl.value * 2 * pi, child: child);
      },
      child: widget.child,
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultipleActivationProvider>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              provider.isOpenContainer = false;
              provider.showScrollToTop = false;
              context.go('/dashboard');
            },
            child: SvgPicture.asset('assets/icons/Chevron.svg'),
          ),
          Text(
            'Gestionar Tarjetas',
            style: AppStyle.useNeoSans(Color(0XFF002B49), 14, FontWeight.w500),
          ),
          SizedBox(width: 32, height: 32),
        ],
      ),
    );
  }
}
