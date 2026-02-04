import 'package:biz_codigo_cash/data/codigo_cash/beneficiary.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteBeneficiary(
  BuildContext context,
  CashCodeProvider cashCodeProvider,
  BeneficiaryCash beneficiary,
) async {
  return showDialog<void>(
    animationStyle: const AnimationStyle(
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
    ),
    barrierColor: const Color.fromRGBO(0, 0, 0, 0.32),
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿Seguro que desea eliminar esta selección?',
                style: AppStyle.useGoogleFont(
                  Color(0XFF424242),
                  20,
                  FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Al eliminar este código descartará los cambios efectuados en la selección.',
                style: AppStyle.useGoogleFont(
                  Color(0XFF616161),
                  16,
                  FontWeight.w400,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ActionButton(
                    text: 'Cancelar',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Color(0XFF002B49),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 8),
                  ActionButton(
                    text: 'Eliminar',
                    onTap: () {
                      cashCodeProvider.removeBeneficiary(beneficiary);
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.white,
                    backgroundColor: Color(0XFFED8B00),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ActionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: text == 'Cancelar'
                ? Border.all(color: Color(0XFFE5E5E5), width: 1)
                : null,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: AppStyle.useGoogleFont(textColor, 14, FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
