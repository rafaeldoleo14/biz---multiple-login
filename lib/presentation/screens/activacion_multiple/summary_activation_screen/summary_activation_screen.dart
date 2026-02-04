import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/presentation/widget/activacion_multiple/summary_activation_modal.dart';
import 'package:biz_codigo_cash/provider/multiple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SummaryActivationScreen extends StatelessWidget {
  const SummaryActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MultipleActivationProvider provider =
        Provider.of<MultipleActivationProvider>(context);

    return Scaffold(
      backgroundColor: Color(0XFFFAFAFA),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: Color(0XFFFAFAFA),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Header(),
              SvgPicture.asset('assets/icons/CONGRATS.svg'),
              SizedBox(height: 32),
              Text(
                '¡Activación completada!',
                style: AppStyle.useNeoSans(
                  Color(0XFF002B49),
                  20,
                  FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Acceda a “Tarjetas no activadas” para reintentar la',
                textAlign: TextAlign.center,
                style: AppStyle.useNeoSans(
                  Color(0XFF424242),
                  12,
                  FontWeight.w400,
                ),
              ),
              Text(
                'activación de manera ágil.',
                textAlign: TextAlign.center,
                style: AppStyle.useNeoSans(
                  Color(0XFF424242),
                  12,
                  FontWeight.w400,
                ),
              ),
              SizedBox(height: 24),
              SummaryBox(),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  provider.resetFlow();
                  context.go('/manage-card');
                },
                child: Container(
                  height: 56,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0XFF002B49),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Ir a gestionar tarjetas',
                      style: AppStyle.useGoogleFont(
                        Colors.white,
                        14,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryBox extends StatelessWidget {
  const SummaryBox({super.key});

  @override
  Widget build(BuildContext context) {
    MultipleActivationProvider provider =
        Provider.of<MultipleActivationProvider>(context);

    return Container(
      height:
          provider.selectedCards
              .where((card) => card.status == Status.activacionFallida)
              .toList()
              .isEmpty
          ? 140
          : 204,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0XFFE5E5E5), width: 1),
      ),
      child: Column(
        children: [
          SizedBox(height: 16),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 20.5),
            child: Column(
              children: [
                Text(
                  'Empresa',
                  style: AppStyle.useGoogleFont(
                    Color(0XFF002B49),
                    14,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Monitor de Servicios SA',
                  style: AppStyle.useGoogleFont(
                    Color(0XFF002B49),
                    14,
                    FontWeight.w400,
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  height: 1,
                  color: Color(0XFFE5E5E5),
                  margin: EdgeInsets.symmetric(horizontal: 21.5),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
          RowCount(
            onTap: () {
              openSummaryActivationModal(
                context,
                provider.selectedCards
                    .where((card) => card.status == Status.activacionCompletada)
                    .toList(),
              );
            },
            text:
                'Tarjetas activadas:  ${provider.selectedCards.where((card) => card.status == Status.activacionCompletada).toList().length}',
          ),
          provider.selectedCards
                  .where((card) => card.status == Status.activacionFallida)
                  .toList()
                  .isEmpty
              ? SizedBox(height: 0)
              : SizedBox(height: 16),
          provider.selectedCards
                  .where((card) => card.status == Status.activacionFallida)
                  .toList()
                  .isEmpty
              ? SizedBox(height: 0)
              : Container(height: 1, color: Color(0XFFE5E5E5)),
          provider.selectedCards
                  .where((card) => card.status == Status.activacionFallida)
                  .toList()
                  .isEmpty
              ? SizedBox(height: 0)
              : SizedBox(height: 16),
          provider.selectedCards
                  .where((card) => card.status == Status.activacionFallida)
                  .toList()
                  .isEmpty
              ? SizedBox(height: 0)
              : RowCount(
                  onTap: () {
                    openSummaryActivationModal(
                      context,
                      provider.selectedCards
                          .where(
                            (card) => card.status == Status.activacionFallida,
                          )
                          .toList(),
                      hasbutton: true,
                    );
                  },
                  text:
                      'Tarjetas no activadas:  ${provider.selectedCards.where((card) => card.status == Status.activacionFallida).toList().length}',
                ),
        ],
      ),
    );
  }
}

class RowCount extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const RowCount({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 10),
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: AppStyle.useGoogleFont(
              Color(0XFF002B49),
              14,
              FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Ver',
                  style: AppStyle.useGoogleFont(
                    Color(0XFF002B49),
                    14,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                SvgPicture.asset('assets/icons/Right-3.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: double.infinity,
      child: Center(
        child: Text(
          'Activación múltiple',
          style: AppStyle.useNeoSans(Color(0XFF002B49), 14, FontWeight.w500),
        ),
      ),
    );
  }
}
