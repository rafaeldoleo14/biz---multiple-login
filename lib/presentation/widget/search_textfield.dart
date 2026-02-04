import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchTextfield extends StatefulWidget {
  final String? hintText;
  final bool? icon2;

  const SearchTextfield({
    super.key,
    this.hintText = 'Buscar',
    this.icon2 = false,
  });

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: 40,
      child: TextFormField(
        cursorColor: Color(0XFFED8B00),
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        onTapUpOutside: (event) {
          focusNode.unfocus();
        },
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(
            minWidth: 18, // 👈 ajusta ancho mínimo
            minHeight: 18,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 11,
              right: 8,
            ), // 👈 separa del borde izquierdo
            child: SvgPicture.asset(
              'assets/icons/${widget.icon2 == true ? 'search-2' : 'search'}.svg',
            ),
          ),
          hintText: widget.hintText,
          hintStyle: AppStyle.useGoogleFont(
            Color(0XFFBDBDBD),
            14,
            FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE5E5E5), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE5E5E5), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE5E5E5), width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
