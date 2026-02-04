import 'package:biz_codigo_cash/data/codigo_cash/beneficiary.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/delete_beneficiary_popup.dart';
import 'package:biz_codigo_cash/presentation/widget/from_account_sheet.dart';
import 'package:biz_codigo_cash/presentation/widget/new_beneficiary_sheet.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GenerateCodeScreen extends StatelessWidget {
  const GenerateCodeScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Color(0XFFE8E6DF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                cashCodeProvider.selectedAccount = null;
                cashCodeProvider.selectedBeneficiaries = [];
                cashCodeProvider.beneficiaryCashList.removeWhere(
                  (beneficiary) => beneficiary.type != 'Beneficiario cash',
                );
                context.go('/dashboard');
              },
              child: SvgPicture.asset('assets/icons/back2.svg'),
            ),
            Text(
              'GENERAR CÓDIGO CASH',
              style: AppStyle.useNeoSans(
                Color(0XFF002B49),
                14,
                FontWeight.w500,
              ),
            ),
            SizedBox(height: 18, width: 8),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0XFFFAFAFA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text(
              'Desde cuenta',
              style: AppStyle.useGoogleFont(
                Color(0XFF002B49),
                14,
                FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            FromAccountContainer(),
            SizedBox(height: 24),
            Text(
              'Seleccionar',
              style: AppStyle.useGoogleFont(
                Color(0XFF002B49),
                14,
                FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            SelectBeneficiaryContainer(),
            SizedBox(height: 24),
            AddDescription(),
            SizedBox(
              height: cashCodeProvider.selectedBeneficiaries.isEmpty ? 0 : 24,
            ),

            cashCodeProvider.selectedBeneficiaries.isEmpty
                ? WithOutBeneficiary()
                : Expanded(
                    child: Consumer<CashCodeProvider>(
                      builder: (_, provider, __) =>
                          BeneficiaryBox(cashCodeProvider: provider),
                    ),
                  ),
            cashCodeProvider.selectedBeneficiaries.isEmpty
                ? NextButton()
                : SizedBox(height: 0),
            SizedBox(
              height: cashCodeProvider.selectedBeneficiaries.isEmpty ? 52 : 0,
            ),
          ],
        ),
      ),
      bottomNavigationBar: cashCodeProvider.selectedBeneficiaries.isEmpty
          ? null
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 164,
              color: Color(0XFFFAFAFA),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total a pagar (${cashCodeProvider.selectedBeneficiaries.length}):',
                        style: AppStyle.useGoogleFont(
                          Color(0XFF757575),
                          14,
                          FontWeight.w500,
                        ),
                      ),

                      Text(
                        'RD\$${formatWithCommas(totalAmount)}',
                        style: AppStyle.useGoogleFont(
                          Color(0XFF757575),
                          14,
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  NextButton(),
                ],
              ),
            ),
    );
  }
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
            margin: EdgeInsets.only(bottom: 8),
            height: 100,
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
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'RD\$${formatWithCommas(beneficiary.amount)}',
                                          style: AppStyle.useGoogleFont(
                                            Color(0XFF757575),
                                            14,
                                            FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 14.5),
                                        SvgPicture.asset(
                                          'assets/icons/edit.svg',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          showDeleteBeneficiary(
                            context,
                            cashCodeProvider,
                            beneficiary,
                          );
                        },
                        child: SvgPicture.asset('assets/icons/delete.svg'),
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

class WithOutBeneficiary extends StatelessWidget {
  const WithOutBeneficiary({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/Empty box.svg'),
              SizedBox(height: 12),
              Text(
                'No ha seleccionado',
                style: AppStyle.useGoogleFont(
                  Color(0XFFA2988D),
                  13,
                  FontWeight.w300,
                ),
              ),
              Text(
                'ningún beneficiario.',
                style: AppStyle.useGoogleFont(
                  Color(0XFFA2988D),
                  13,
                  FontWeight.w300,
                ),
              ),
            ],
          ),
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

    bool isActive =
        cashCodeProvider.selectedBeneficiaries.isNotEmpty &&
        cashCodeProvider.selectedAccount != null;

    return InkWell(
      onTap: () {
        if (!isActive) return;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 56,
        decoration: BoxDecoration(
          color: isActive ? Color(0XFF002B49) : Color(0XFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Continuar',
            style: AppStyle.useGoogleFont(
              isActive ? Colors.white : Color(0XFF9E9E9E),
              14,
              FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class AddDescription extends StatelessWidget {
  const AddDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4),
      height: 32,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.6),
              border: Border.all(color: Color(0XFFED8B00), width: 2),
            ),
          ),
          SizedBox(width: 14),
          Text(
            'Añadir descripción',
            style: AppStyle.useGoogleFont(
              Color(0XFF002B49),
              14,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectBeneficiaryContainer extends StatelessWidget {
  const SelectBeneficiaryContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Row(
        children: [
          BeneficiaryOption(
            onTap: () {
              context.go('/beneficiary-cash');
            },
            iconName: 'Beneficiarios_icon',
            text: 'Beneficiario Cash',
          ),
          SizedBox(width: 8),
          BeneficiaryOption(
            onTap: () {
              showAddNewBeneficiarySheet(context);
            },
            iconName: 'AgregarBeneficiario_icon',
            text: 'Nuevo beneficiario',
          ),
        ],
      ),
    );
  }
}

class BeneficiaryOption extends StatelessWidget {
  final String text;
  final String iconName;
  final VoidCallback onTap;

  const BeneficiaryOption({
    super.key,
    required this.text,
    required this.iconName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0XFFFFFFFF),
            border: Border.all(color: Color(0XFFE5E5E5), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/$iconName.svg'),
              SizedBox(height: 8),
              Text(
                text,
                style: AppStyle.useGoogleFont(
                  Color(0XFF002B49),
                  14,
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FromAccountContainer extends StatelessWidget {
  const FromAccountContainer({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return InkWell(
      onTap: () {
        showFromAccountSheet(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 24.12),
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0XFFFFFFFF),
          border: Border.all(color: Color(0XFFE5E5E5), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cashCodeProvider.selectedAccount == null
                ? Text(
                    'Seleccione',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF002B49),
                      14,
                      FontWeight.w500,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashCodeProvider.selectedAccount?.name ?? '',
                        style: AppStyle.useGoogleFont(
                          Color(0XFF002B49),
                          14,
                          FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Disponible: ${cashCodeProvider.selectedAccount?.coin} ${cashCodeProvider.selectedAccount?.avaliableBalance}',
                        style: AppStyle.useGoogleFont(
                          Color(0XFF757575),
                          14,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
            SvgPicture.asset('assets/icons/right.svg'),
          ],
        ),
      ),
    );
  }
}
