import 'package:biz_codigo_cash/data/codigo_cash/beneficiary.dart';
import 'package:biz_codigo_cash/presentation/screens/codigo_cash/beneficiary_cash_screen/beneficiary_cash_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/delete_beneficiary_popup.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

void showBeneficiarySelectionSheet(BuildContext context) {
  showModalBottomSheet(
    barrierColor: Color.fromRGBO(0, 0, 0, 0.32),
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 92,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0XFFFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<CashCodeProvider>(
                builder: (_, provider, __) =>
                    Header(cashCodeProvider: provider),
              ),
              SizedBox(height: 6),
              Flexible(
                fit: FlexFit.loose,
                child: Consumer<CashCodeProvider>(
                  builder: (_, provider, __) =>
                      BeneficiaryBox(cashCodeProvider: provider),
                ),
              ),
              SizedBox(height: 24),
              NextButton(),
              SizedBox(height: 52),
            ],
          ),
        ),
      );
    },
  );
}

class BeneficiaryBox extends StatelessWidget {
  final CashCodeProvider cashCodeProvider;

  const BeneficiaryBox({super.key, required this.cashCodeProvider});

  String formatWithCommas(double value) {
    return value
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cashCodeProvider.selectedBeneficiaries.length,
        itemBuilder: (context, index) {
          BeneficiaryCash beneficiary =
              cashCodeProvider.selectedBeneficiaries[index];

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(bottom: 8),
            height: 136,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 20,
                      decoration: BoxDecoration(
                        color: beneficiary.type == 'Beneficiario cash'
                            ? Color(0XFFE8E6DF)
                            : Color(0XFF004F71),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Beneficiario cash',
                          style: AppStyle.useGoogleFont(
                            beneficiary.type == 'Beneficiario cash'
                                ? Color(0XFF746456)
                                : Colors.white,
                            12,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 116,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      SizedBox(
                        height: 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${beneficiary.name} / ${beneficiary.phone}',
                              style: AppStyle.useGoogleFont(
                                Color(0XFF002B49),
                                14,
                                FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                showDeleteBeneficiary(
                                  context,
                                  cashCodeProvider,
                                  beneficiary,
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/delete.svg',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monto de retiro',
                                  style: AppStyle.useGoogleFont(
                                    Color(0XFF757575),
                                    12,
                                    FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'RD\$${formatWithCommas(beneficiary.amount)}',
                                      style: AppStyle.useGoogleFont(
                                        Color(0XFF002B49),
                                        16,
                                        FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 13.5),
                                    SvgPicture.asset('assets/icons/edit.svg'),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Consumer<CashCodeProvider>(
                                  builder: (_, provider, __) => AmountButtons(
                                    cashCodeProvider: provider,
                                    beneficiary: beneficiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AmountButtons extends StatelessWidget {
  const AmountButtons({
    super.key,
    required this.cashCodeProvider,
    required this.beneficiary,
  });

  final CashCodeProvider cashCodeProvider;
  final BeneficiaryCash beneficiary;

  @override
  Widget build(BuildContext context) {
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

class Header extends StatelessWidget {
  final CashCodeProvider cashCodeProvider;

  const Header({super.key, required this.cashCodeProvider});

  @override
  Widget build(BuildContext context) {
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
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset('assets/icons/down-l.svg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
