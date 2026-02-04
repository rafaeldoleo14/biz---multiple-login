import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool? phoneNumber;
  final bool? isCedula;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.phoneNumber = false,
    this.isCedula,
  });

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);
    final bool isNameField =
        hintText == 'Escriba un nombre' || hintText == 'Escriba un apellido';

    // Formatter que fuerza: Primera letra en MAYÚSCULA, resto en minúscula
    final normalizeFormatter = TextInputFormatter.withFunction((
      oldValue,
      newValue,
    ) {
      final text = newValue.text;
      if (text.isEmpty) return newValue;
      final first = text.substring(0, 1).toUpperCase();
      final rest = text.length > 1 ? text.substring(1).toLowerCase() : '';
      final newText = first + rest;
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    });

    // Formatter phone: XXX-XXXX
    final phoneFormatter = TextInputFormatter.withFunction((
      oldValue,
      newValue,
    ) {
      // Extrae solo dígitos
      String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
      if (digits.length > 7) digits = digits.substring(0, 7);
      String formatted;
      if (digits.length <= 3) {
        formatted = digits;
      } else {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });

    // 3. Cédula: 123-4567890-0 (3-7-1)
    final cedulaFormatter = TextInputFormatter.withFunction((
      oldValue,
      newValue,
    ) {
      var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
      if (digits.length > 11) digits = digits.substring(0, 11);
      String formatted;
      if (digits.length <= 3) {
        formatted = digits;
      } else if (digits.length <= 10) {
        formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
      } else {
        formatted =
            '${digits.substring(0, 3)}-${digits.substring(3, 10)}-${digits.substring(10)}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });

    // Selección de formatters según el tipo
    List<TextInputFormatter>? formatters;
    if (isNameField) {
      formatters = [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
        normalizeFormatter,
      ];
    } else if (phoneNumber == true) {
      formatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(7),
        phoneFormatter,
      ];
    } else if (isCedula == true) {
      formatters = [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
        cedulaFormatter,
      ];
    }

    // Teclado según el tipo
    final keyboardType = isCedula == true || phoneNumber == true
        ? TextInputType.number
        : TextInputType.text;

    // Longitud máxima para mostrar contador
    final maxLen = phoneNumber == true
        ? 8
        : isCedula == true
        ? 13
        : null;

    return SizedBox(
      height: 56,
      child: TextFormField(
        cursorColor: Color(0XFFED8B00),
        controller: controller,
        focusNode: focusNode,
        style: AppStyle.useGoogleFont(Color(0XFF002B49), 14, FontWeight.w400),
        // Si es phoneNumber, teclado numérico
        keyboardType: keyboardType,
        inputFormatters: formatters,
        maxLength: maxLen,
        buildCounter: maxLen != null
            ? (
                _, {
                required int currentLength,
                int? maxLength,
                required bool isFocused,
              }) => null
            : null,

        onChanged: (value) {
          cashCodeProvider.onNotifyChanges();
        },
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        onTapUpOutside: (event) {
          focusNode.unfocus();
        },
        onEditingComplete: () {
          focusNode.unfocus();

          if (hintText == 'Escriba un nombre') {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.lastNameFocusNode);
          }

          if (hintText == 'Escriba un apellido') {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.phoneFocusNode);
          }

          if (phoneNumber == true) {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.cedulaFocusNode);
          }
        },
        onSaved: (newValue) {
          focusNode.unfocus();
          if (hintText == 'Escriba un nombre') {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.lastNameFocusNode);
          }

          if (hintText == 'Escriba un apellido') {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.phoneFocusNode);
          }

          if (phoneNumber == true) {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.cedulaFocusNode);
          }
        },
        onFieldSubmitted: (value) {
          focusNode.unfocus();
          if (hintText == 'Escriba un nombre') {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.lastNameFocusNode);
          }

          if (hintText == 'Escriba un apellido') {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.phoneFocusNode);
          }

          if (phoneNumber == true) {
            FocusScope.of(
              context,
            ).requestFocus(cashCodeProvider.cedulaFocusNode);
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyle.useGoogleFont(
            Color(0XFF9E9E9E),
            14,
            FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE5E5E5), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE5E5E5), width: 1),

            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE5E5E5), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
