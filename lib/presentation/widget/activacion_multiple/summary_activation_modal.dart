import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/activacion_multiple/loader_popoup.dart';
import 'package:biz_codigo_cash/provider/multiple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

void openSummaryActivationModal(
  BuildContext context,
  List<CardI> cardList, {
  bool hasbutton = false,
}) {
  showModalBottomSheet(
    barrierColor: Color(0XFFFAFAFA),
    context: context,
    isScrollControlled: true, // permite que el builder use toda la pantalla
    enableDrag: false, // cancela el gesto de arrastre para cerrar
    isDismissible: false, // evita el tap fuera para cerrar
    backgroundColor: Colors.transparent, // quita el color gris de fondo
    useSafeArea: true,
    builder: (context) {
      MultipleActivationProvider provider =
          Provider.of<MultipleActivationProvider>(context);
      return FractionallySizedBox(
        // altura = 100 % de la pantalla
        heightFactor: 1, // 1 == 100 %
        child: Scaffold(
          // Si quieres esquinas cuadradas usa un Scaffold; si prefieres
          // redondeadas coloca tu propio Container con borderRadius.
          body: ModalContent(cardList: cardList),
          bottomNavigationBar:
              provider.selectedCards
                      .where((card) => card.status == Status.activacionFallida)
                      .toList()
                      .isNotEmpty &&
                  hasbutton
              ? SafeArea(
                  child: Container(
                    color: Color(0XFFFAFAFA),
                    height: 80,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            showLoader(context, again: true);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0XFF002B49),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Reintentar',
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
                )
              : null,
        ),
      );
    },
  );
}

class ModalContent extends StatelessWidget {
  final List<CardI> cardList;

  const ModalContent({super.key, required this.cardList});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23),
        color: Color(0XFFFAFAFA),
        child: Column(
          children: [
            SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset('assets/icons/Close_icon (2).svg'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tarjetas activadas',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF002B49),
                      16,
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 13),
              height: 14,
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    'Total: ${cardList.length}',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF424242),
                      12,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cardList.length,
                itemBuilder: (context, index) {
                  CardI card = cardList[index];

                  return Container(
                    padding: EdgeInsets.only(
                      left: 13,
                      right: 8.89,
                      top: 4,
                      bottom: 4,
                    ),
                    height: 72,
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.name,
                              style: AppStyle.useGoogleFont(
                                Color(0XFF002B49),
                                14,
                                FontWeight.w500,
                              ),
                            ),
                            Text(
                              card.status == Status.activacionCompletada
                                  ? 'Balance a la fecha: RD\$${card.balance}'
                                  : 'Tarjeta no activada',
                              style: AppStyle.useGoogleFont(
                                card.status == Status.activacionCompletada
                                    ? Color(0XFF757575)
                                    : Color(0XFFC8102E),
                                14,
                                FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: SvgPicture.asset(
                            'assets/icons/${card.status == Status.activacionCompletada ? 'show' : 'Alerta_icon'}.svg',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
