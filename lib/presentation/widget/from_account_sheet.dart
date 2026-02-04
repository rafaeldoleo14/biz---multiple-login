import 'package:biz_codigo_cash/data/codigo_cash/from_account.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/search_textfield.dart';
import 'package:biz_codigo_cash/provider/cash_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

void showFromAccountSheet(BuildContext context) {
  showModalBottomSheet(
    barrierColor: Color.fromRGBO(0, 0, 0, 0.32),
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 92,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            CustomDivider(),
            SizedBox(height: 18),
            SearchTextfield(),
            SizedBox(height: 8),
            Text(
              'Seleccione la cuenta origen para realizar la transacción',
              style: AppStyle.useGoogleFont(
                Color(0XFF808080),
                12,
                FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: fromAccountList.length,
                itemBuilder: (context, index) {
                  FromAccount product = fromAccountList[index];

                  return FromAccountExpandable(
                    index: index,
                    text: product.type,
                    isOpen: product.isOpen,
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class FromAccountExpandable extends StatelessWidget {
  final int index;
  final String text;
  final bool isOpen;

  const FromAccountExpandable({
    super.key,
    required this.index,
    required this.text,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: 56,
          decoration: BoxDecoration(
            color: Color(0XFFE8E6DF),
            border: Border(
              top: BorderSide(color: Color(0XFFD0CBC3), width: 1),
              bottom: BorderSide(color: Color(0XFFD0CBC3), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppStyle.useNeoSans(
                  Color(0XFF002B49),
                  14,
                  FontWeight.w500,
                ),
              ),
              isOpen
                  ? SvgPicture.asset('assets/icons/up-blue.svg')
                  : SvgPicture.asset('assets/icons/down-blue.svg'),
            ],
          ),
        ),
        isOpen
            ? Column(children: [FromAccountProductIteration()])
            : SizedBox(height: 0),
      ],
    );
  }
}

class FromAccountProductIteration extends StatefulWidget {
  const FromAccountProductIteration({super.key});

  @override
  State<FromAccountProductIteration> createState() => _ProductIterationState();
}

class _ProductIterationState extends State<FromAccountProductIteration> {
  String activeProduct = 'Resumen';

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return Container(
      color: Colors.white,
      height: 288,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: fromAccountList[0].list?.length,
            itemBuilder: (context, index) {
              FromAccountList product = fromAccountList[0].list![index];

              return InkWell(
                onTap: () {
                  if (index != 0) return;

                  cashCodeProvider.onSelectedAccount = product;
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  height: 72,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0XFFE5E5E5),
                        width: index == 3 ? 0 : 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: AppStyle.useGoogleFont(
                              index != 0
                                  ? Color(0XFF9E9E9E)
                                  : Color(0XFF002B49),
                              14,
                              FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Disponible: ${product.coin} ${product.currentBalance}',
                            style: AppStyle.useGoogleFont(
                              index != 0
                                  ? Color(0XFFBDBDBD)
                                  : Color(0XFF616161),
                              14,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      index != 0
                          ? SvgPicture.asset('assets/icons/Unselected.svg')
                          : RadioButton(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RadioButton extends StatelessWidget {
  const RadioButton({super.key});

  @override
  Widget build(BuildContext context) {
    CashCodeProvider cashCodeProvider = Provider.of<CashCodeProvider>(context);

    return Container(
      margin: EdgeInsets.only(right: 4),
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: Color(0XFFED8B00), width: 2),
      ),
      child: Center(
        child: Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
            color: cashCodeProvider.selectedAccount == null
                ? Colors.white
                : Color(0XFFED8B00),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color: Color(0XFFE8E6DF),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
