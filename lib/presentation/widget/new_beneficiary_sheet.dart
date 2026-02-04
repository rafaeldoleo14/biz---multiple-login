import 'package:biz_codigo_cash/presentation/screens/codigo_cash/beneficiary_cash_screen/beneficiary_cash_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/cancel_new_beneficiary.dart';
import 'package:biz_codigo_cash/presentation/widget/custom_textfield.dart';
import 'package:biz_codigo_cash/presentation/widget/from_account_sheet.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

void showAddNewBeneficiarySheet(BuildContext context) {
  CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(
    context,
    listen: false,
  );

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
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              CustomDivider(),
              SizedBox(height: 26),
              Title(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      FullNameRow(cashCodeProvider: cashCodeProvider),
                      SizedBox(height: 16),
                      PhoneNumberRow(cashCodeProvider: cashCodeProvider),
                      SizedBox(height: 18),
                      IdControl(cashCodeProvider: cashCodeProvider),
                      SizedBox(height: 16),
                      SaveBeneficiaryButton(),
                      SizedBox(height: 16),
                      AmountControl(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 23),
              ActionButtons(),
              //
              SizedBox(height: 52),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    cashCodeProvider.onCancelNewBeneficiary();
  });
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    bool isActive =
        cashCodeProvider.nameController.text.isNotEmpty &&
        cashCodeProvider.nameController.text.isNotEmpty &&
        cashCodeProvider.phoneController.text.length == 8 &&
        cashCodeProvider.cedulaController.text.length == 13;
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                showCancelNewBeneficiary(context, cashCodeProvider);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                ),
                child: Center(
                  child: Text(
                    'Cancelar',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF002B49),
                      14,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                if (!isActive) return;

                cashCodeProvider.onCreateNewBeneficiary();
                Navigator.of(context).pop();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive ? Color(0XFF002B49) : Color(0XFFE0E0E0),
                  border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                ),
                child: Center(
                  child: Text(
                    'Agregar a selección',
                    style: AppStyle.useGoogleFont(
                      isActive ? Colors.white : Color(0XFF9E9E9E),
                      14,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AmountControl extends StatefulWidget {
  const AmountControl({super.key});

  @override
  State<AmountControl> createState() => _AmountControlState();
}

class _AmountControlState extends State<AmountControl> {
  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    String formatWithCommas(double value) {
      return value
          .toStringAsFixed(2)
          .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto',
          style: AppStyle.useGoogleFont(Color(0XFF002B49), 14, FontWeight.w600),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (cashCodeProvider.newBeneficiaryAmount > 200) {
                    cashCodeProvider.newBeneficiaryAmount -= 200;
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  if (cashCodeProvider.newBeneficiaryAmount > 200) {
                    cashCodeProvider.newBeneficiaryAmount -= 200;
                  }
                });
              },
              child:
                  cashCodeProvider.newBeneficiaryAmount <= 20000 &&
                      cashCodeProvider.newBeneficiaryAmount > 200
                  ? SvgPicture.asset('assets/icons/minus-active.svg')
                  : SvgPicture.asset('assets/icons/minus.svg'),
            ),

            Text(
              'RD\$${formatWithCommas(cashCodeProvider.newBeneficiaryAmount)}',
              style: AppStyle.useGoogleFont(
                Color(0XFF002B49),
                24,
                FontWeight.w500,
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  if (cashCodeProvider.newBeneficiaryAmount < 20000) {
                    cashCodeProvider.newBeneficiaryAmount += 200;
                  }
                });
                cashCodeProvider.onNotifyChanges();
              },
              onLongPress: () {
                setState(() {
                  if (cashCodeProvider.newBeneficiaryAmount <= 20000) {
                    cashCodeProvider.newBeneficiaryAmount += 200;
                  }
                });
                cashCodeProvider.onNotifyChanges();
              },
              child: cashCodeProvider.newBeneficiaryAmount == 20000
                  ? SvgPicture.asset('assets/icons/plus-disable.svg')
                  : SvgPicture.asset('assets/icons/plus.svg'),
            ),
          ],
        ),

        SizedBox(height: 24),
        CustomNewBeneficiarySlider(),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}

class CustomNewBeneficiarySlider extends StatefulWidget {
  const CustomNewBeneficiarySlider({super.key});

  @override
  State<CustomNewBeneficiarySlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomNewBeneficiarySlider> {
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
        child: Padding(
          padding: EdgeInsetsGeometry.only(left: 3),
          child: Slider(
            min: 200.0,
            max: 20000.0,
            divisions: ((20000 - 200) / 200).round(),
            value: cashCodeProvider.newBeneficiaryAmount,
            label: '${cashCodeProvider.newBeneficiaryAmount.toInt()}',
            onChanged: (value) {
              setState(() {
                final difference =
                    (value - cashCodeProvider.newBeneficiaryAmount)
                        .roundToDouble();
                if (difference != 0) {
                  cashCodeProvider.newBeneficiaryAmount += difference;
                  cashCodeProvider.onNotifyChanges();
                }

                cashCodeProvider.onNotifyChanges();
              });
            },
          ),
        ),
      ),
    );
  }
}

class SaveBeneficiaryButton extends StatefulWidget {
  const SaveBeneficiaryButton({super.key});

  @override
  State<SaveBeneficiaryButton> createState() => _SaveBeneficiaryButtonState();
}

class _SaveBeneficiaryButtonState extends State<SaveBeneficiaryButton> {
  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    bool isActive =
        cashCodeProvider.nameController.text.isNotEmpty &&
        cashCodeProvider.nameController.text.isNotEmpty &&
        cashCodeProvider.phoneController.text.length == 8 &&
        cashCodeProvider.cedulaController.text.length == 13;

    return Container(
      padding: EdgeInsets.only(left: 4),
      height: 32,
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? Color(0XFFED8B00) : Color(0XFFBABABA),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(3.6),
            ),
          ),
          SizedBox(width: 16),
          Text(
            'Guardar beneficiario',
            style: AppStyle.useGoogleFont(
              isActive ? Color(0XFF002B49) : Color(0XFF9E9E9E),
              14,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class IdControl extends StatelessWidget {
  final CashCodeProvider cashCodeProvider;

  const IdControl({super.key, required this.cashCodeProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documento de identidad',
          style: AppStyle.useGoogleFont(Color(0XFF002B49), 14, FontWeight.w600),
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0XFFED8B00),
                  borderRadius: BorderRadius.circular(350),
                ),
                child: Center(
                  child: Text(
                    'Cédula',
                    style: AppStyle.useGoogleFont(
                      Colors.white,
                      12,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(350),
                  color: Colors.white,
                  border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                ),
                child: Center(
                  child: Text(
                    'Pasaporte',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF002B49),
                      12,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                hintText: 'Digite número de documento',
                controller: cashCodeProvider.cedulaController,
                focusNode: cashCodeProvider.cedulaFocusNode,
                isCedula: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PhoneNumberRow extends StatelessWidget {
  const PhoneNumberRow({super.key, required this.cashCodeProvider});

  final CashCodeProvider cashCodeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número de teléfono',
          style: AppStyle.useGoogleFont(Color(0XFF002B49), 14, FontWeight.w600),
        ),
        SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: Row(
            children: [
              Container(
                height: 52,
                width: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '809',
                      style: AppStyle.useGoogleFont(
                        Color(0XFF002B49),
                        14,
                        FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 11),
                    SvgPicture.asset('assets/icons/down-l.svg'),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: CustomTextfield(
                  controller: cashCodeProvider.phoneController,
                  focusNode: cashCodeProvider.phoneFocusNode,
                  hintText: 'Ejemplo: 765-4321',
                  phoneNumber: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FullNameRow extends StatelessWidget {
  const FullNameRow({super.key, required this.cashCodeProvider});

  final CashCodeProvider cashCodeProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre',
                style: AppStyle.useGoogleFont(
                  Color(0XFF002B49),
                  14,
                  FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              CustomTextfield(
                controller: cashCodeProvider.nameController,
                focusNode: cashCodeProvider.nameFocusNode,
                hintText: 'Escriba un nombre',
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apellido',
                style: AppStyle.useGoogleFont(
                  Color(0XFF002B49),
                  14,
                  FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              CustomTextfield(
                controller: cashCodeProvider.lastNameController,
                focusNode: cashCodeProvider.lastNameFocusNode,
                hintText: 'Escriba un apellido',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0XFFE5E5E5), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nuevo beneficiario',
            style: AppStyle.useGoogleFont(
              Color(0XFF424242),
              16,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
