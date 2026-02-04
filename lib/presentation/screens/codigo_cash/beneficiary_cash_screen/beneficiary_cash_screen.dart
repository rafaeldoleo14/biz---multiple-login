import 'package:biz_codigo_cash/data/codigo_cash/beneficiary.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/beneficiary_selection_sheet.dart';
import 'package:biz_codigo_cash/presentation/widget/cancel_operation_popup.dart';
import 'package:biz_codigo_cash/presentation/widget/delete_beneficiary_popup.dart';
import 'package:biz_codigo_cash/presentation/widget/new_beneficiary_sheet.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BeneficiaryCashScreen extends StatelessWidget {
  const BeneficiaryCashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return Scaffold(
      backgroundColor: Color(0XFFFAFAFA),
      appBar: AppBar(
        foregroundColor: Color(0XFFFAFAFA),
        surfaceTintColor: Color(0XFFFAFAFA),
        shadowColor: Color(0XFFFAFAFA),
        actionsPadding: EdgeInsets.all(0),
        backgroundColor: Color(0XFFFAFAFA),
        title: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (cashCodeProvider.selectedBeneficiaries.isEmpty) {
                    context.go('/generate-code');
                    return;
                  }

                  showCancelOperation(context, cashCodeProvider);
                },
                child: SvgPicture.asset('assets/icons/back2.svg'),
              ),
              Text(
                'BENEFICIARIOS CÓDIGO CASH',
                style: AppStyle.useNeoSans(
                  Color(0XFF002B49),
                  14,
                  FontWeight.w500,
                ),
              ),
              SizedBox(height: 18, width: 8),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0XFFFAFAFA),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Actions(),
              SizedBox(height: 16),
              BeneficiaryRow(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavInfo(),
    );
  }
}

class NavInfo extends StatelessWidget {
  const NavInfo({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    String formatWithCommas(double value) {
      return value
          .toStringAsFixed(2)
          .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
    }

    double totalAmount = cashCodeProvider.selectedBeneficiaries.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );

    return Container(
      height: cashCodeProvider.selectedBeneficiaries.isNotEmpty ? 190 : 124,
      decoration: BoxDecoration(
        color: Color(0XFFFAFAFA),
        border: cashCodeProvider.selectedBeneficiaries.isNotEmpty
            ? Border(top: BorderSide(color: Color(0XFFE5E5E5), width: 1))
            : null,
      ),
      child: Column(
        children: [
          cashCodeProvider.selectedBeneficiaries.isNotEmpty
              ? Container(
                  height: 66,
                  padding: EdgeInsets.only(left: 16, right: 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selección',
                            style: AppStyle.useGoogleFont(
                              Color(0XFF002B49),
                              14,
                              FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${cashCodeProvider.selectedBeneficiaries.length} / Código (s)',
                            style: AppStyle.useGoogleFont(
                              Color(0XFF9E9E9E),
                              14,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Monto total',
                                style: AppStyle.useGoogleFont(
                                  Color(0XFF002B49),
                                  14,
                                  FontWeight.w500,
                                ),
                              ),
                              Text(
                                'RD\$${formatWithCommas(totalAmount)}',
                                style: AppStyle.useGoogleFont(
                                  Color(0XFF9E9E9E),
                                  14,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 19),
                          InkWell(
                            onTap: () {
                              showBeneficiarySelectionSheet(context);
                            },
                            child: SvgPicture.asset('assets/icons/up-l.svg'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(width: 0),
          SizedBox(height: 16),
          NextButton(),
        ],
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return InkWell(
      onTap: () {
        if (cashCodeProvider.selectedBeneficiaries.isEmpty) return;

        context.go('/generate-code');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 26),
        height: 56,
        decoration: BoxDecoration(
          color: cashCodeProvider.selectedBeneficiaries.isNotEmpty
              ? Color(0XFF002B49)
              : Color(0XFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Finalizar selección',
            style: AppStyle.useGoogleFont(
              cashCodeProvider.selectedBeneficiaries.isNotEmpty
                  ? Colors.white
                  : Color(0XFF9E9E9E),
              14,
              FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class BeneficiaryRow extends StatelessWidget {
  const BeneficiaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);
    String formatWithCommas(double value) {
      return value
          .toStringAsFixed(2)
          .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
    }

    return SizedBox(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cashCodeProvider.beneficiaryCashList.length,
        itemBuilder: (context, index) {
          BeneficiaryCash beneficiaryCash =
              cashCodeProvider.beneficiaryCashList[index];

          return InkWell(
            onTap: () {
              if (cashCodeProvider.selectedBeneficiaries.contains(
                beneficiaryCash,
              )) {
                return;
              }

              cashCodeProvider.onSelectedBeneficiaries(beneficiaryCash);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.only(left: 16, right: 20),
              margin: EdgeInsets.only(bottom: 8, left: 16, right: 16),
              height:
                  cashCodeProvider.selectedBeneficiaries.contains(
                    beneficiaryCash,
                  )
                  ? 209
                  : 56,
              decoration: BoxDecoration(
                color:
                    cashCodeProvider.selectedBeneficiaries.contains(
                      beneficiaryCash,
                    )
                    ? Color(0XFFFFFAF1)
                    : Color(0XFFFFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      cashCodeProvider.selectedBeneficiaries.contains(
                        beneficiaryCash,
                      )
                      ? Color(0XFFED8B00)
                      : Color(0XFFE5E5E5),
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      cashCodeProvider.selectedBeneficiaries.contains(
                        beneficiaryCash,
                      )
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height:
                          cashCodeProvider.selectedBeneficiaries.contains(
                            beneficiaryCash,
                          )
                          ? 12
                          : 0,
                    ),
                    SizedBox(
                      height:
                          cashCodeProvider.selectedBeneficiaries.contains(
                            beneficiaryCash,
                          )
                          ? null
                          : 56,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${beneficiaryCash.name} / ${beneficiaryCash.phone}',
                            style: AppStyle.useGoogleFont(
                              Color(0XFF002B49),
                              14,
                              FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (cashCodeProvider.selectedBeneficiaries
                                  .contains(beneficiaryCash)) {
                                showDeleteBeneficiary(
                                  context,
                                  cashCodeProvider,
                                  beneficiaryCash,
                                );
                                return;
                              }

                              cashCodeProvider.onSelectedBeneficiaries(
                                beneficiaryCash,
                              );
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color:
                                    cashCodeProvider.selectedBeneficiaries
                                        .contains(beneficiaryCash)
                                    ? Color(0XFFED8B00)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(3.6),
                                border: Border.all(
                                  color: Color(0XFFED8B00),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/Checkmark.svg',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    cashCodeProvider.selectedBeneficiaries.contains(
                          beneficiaryCash,
                        )
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'Monto de retiro',
                                style: AppStyle.useGoogleFont(
                                  Color(0XFF757575),
                                  14,
                                  FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RD\$${formatWithCommas(beneficiaryCash.amount)}',
                                    style: AppStyle.useGoogleFont(
                                      Color(0XFF002B49),
                                      24,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  OperationButtons(
                                    beneficiary: beneficiaryCash,
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              CustomSlider(beneficiary: beneficiaryCash),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'RD\$200.00',
                                    style: AppStyle.useGoogleFont(
                                      Color(0XFF424242),
                                      14,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'RD\$20,000.00',
                                    style: AppStyle.useGoogleFont(
                                      Color(0XFF424242),
                                      14,
                                      FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomSlider extends StatefulWidget {
  final BeneficiaryCash beneficiary;

  const CustomSlider({super.key, required this.beneficiary});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return Padding(
      padding: EdgeInsetsGeometry.only(left: 10),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackShape: NoPaddingRoundedRectSliderTrackShape(),
          trackHeight: 4.0,
          activeTrackColor: Color(0XFF4298B5),
          inactiveTrackColor: Color(0XFFBDBDBD),
          thumbShape: const BorderedThumbShape(
            enabledThumbRadius: 14.0,
            borderWidth: 2.0,
            borderColor: Color(0XFF4298B5),
          ),
          thumbColor: Colors.white,
          inactiveTickMarkColor: Colors.transparent,
          overlayColor: Colors.transparent,
          activeTickMarkColor: Colors.transparent,
          overlayShape: SliderComponentShape.noOverlay,
          showValueIndicator: ShowValueIndicator.never,
        ),
        child: Slider(
          min: 200.0,
          max: 20000.0,
          divisions: ((20000 - 200) / 200).round(),
          value: widget.beneficiary.amount,
          label: '${widget.beneficiary.amount.toInt()}',
          onChanged: (value) {
            setState(() {
              final difference = (value - widget.beneficiary.amount)
                  .roundToDouble();
              if (difference != 0) {
                cashCodeProvider.onAmount(widget.beneficiary, difference);
              }
            });
          },
        ),
      ),
    );
  }
}

class NoPaddingRoundedRectSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    // 👇 Esta es la línea clave: eliminas el padding (pones 0)
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class BorderedThumbShape extends RoundSliderThumbShape {
  final double borderWidth;
  final Color borderColor;

  const BorderedThumbShape({
    this.borderWidth = 2.0,
    this.borderColor = Colors.black,
    super.enabledThumbRadius = 14.0,
  }) : super(
         pressedElevation: 0.0, // 👈 elimina la sombra
       );

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );

    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(center, enabledThumbRadius, paint);
  }
}

class OperationButtons extends StatelessWidget {
  final BeneficiaryCash beneficiary;

  const OperationButtons({super.key, required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            cashCodeProvider.onAmount(beneficiary, -200);
          },
          onLongPress: () {
            cashCodeProvider.onAmount(beneficiary, -200);
          },
          child: beneficiary.amount <= 20000 && beneficiary.amount > 200
              ? SvgPicture.asset('assets/icons/minus-active.svg')
              : SvgPicture.asset('assets/icons/minus.svg'),
        ),
        SizedBox(width: 32),
        GestureDetector(
          onTap: () {
            cashCodeProvider.onAmount(beneficiary, 200);
          },
          onLongPress: () {
            cashCodeProvider.onAmount(beneficiary, 200);
          },
          child: beneficiary.amount == 20000
              ? SvgPicture.asset('assets/icons/plus-disable.svg')
              : SvgPicture.asset('assets/icons/plus.svg'),
        ),
      ],
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0XFFE5E5E5), width: 1),
          bottom: BorderSide(color: Color(0XFFE5E5E5), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0XFFFFFFFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0XFFE5E5E5), width: 1.5),
            ),
            child: Center(child: SvgPicture.asset('assets/icons/search2.svg')),
          ),
          InkWell(
            onTap: () {
              showAddNewBeneficiarySheet(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: 204,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0XFFED8B00),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/icons/AgregarBeneficiario_icon2.svg',
                  ),
                  Text(
                    'Nuevo beneficiario',
                    style: AppStyle.useGoogleFont(
                      Colors.white,
                      14,
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
