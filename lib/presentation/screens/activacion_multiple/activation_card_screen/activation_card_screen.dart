import 'package:biz_codigo_cash/presentation/screens/activacion_multiple/manage_card_screen/manage_card_screen.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:biz_codigo_cash/provider/multiple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActivationCardScreen extends StatelessWidget {
  const ActivationCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 16),
              Expanded(child: CardIteration()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomProgressIndicator(),
    );
  }
}

class BottomProgressIndicator extends StatelessWidget {
  const BottomProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MultipleActivationProvider>();
    final total = provider.selectedCards.length;
    final completed = provider.selectedCards.where((c) => !c.isLoading).length;
    final progress = total > 0 ? completed / total : 0.0;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 96,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 8,
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.10),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            provider.selectedCards.every((card) => !card.isLoading) &&
                    provider.selectedCards.any(
                      (card) => card.status == Status.activacionFallida,
                    )
                ? InkWell(
                    onTap: () {
                      context.go('/summary-activation');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0XFF002B49),
                      ),
                      child: Center(
                        child: Text(
                          'Continuar',
                          style: AppStyle.useGoogleFont(
                            Colors.white,
                            14,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      // Animamos el LinearProgressIndicator sin cambiar tu layout
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: progress),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, animatedValue, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: animatedValue,
                              minHeight: 56,
                              backgroundColor: const Color(0xffD1D1D1),
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0XFF4298B5),
                              ),
                            ),
                          );
                        },
                      ),
                      // Tu texto centrado encima de la barra
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '$completed / $total tarjetas activadas',
                            style: AppStyle.useGoogleFont(
                              Colors.white,
                              14,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class CardIteration extends StatefulWidget {
  const CardIteration({super.key});

  @override
  State<CardIteration> createState() => _CardIterationState();
}

class _CardIterationState extends State<CardIteration> {
  late MultipleActivationProvider provider;
  bool navigated = false;

  @override
  void initState() {
    super.initState();
    // Obtenemos el provider sin suscribir el build
    provider = context.read<MultipleActivationProvider>();
    // Nos suscribimos a sus cambios
    provider.addListener(_checkAndNavigate);
  }

  void _checkAndNavigate() {
    final allDone =
        provider.selectedCards.every((c) => !c.isLoading) &&
        !provider.selectedCards.any(
          (card) => card.status == Status.activacionFallida,
        );
    if (!navigated && allDone) {
      navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/summary-activation');
      });
    }
  }

  @override
  void dispose() {
    provider.removeListener(_checkAndNavigate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MultipleActivationProvider provider =
        Provider.of<MultipleActivationProvider>(context);

    final cards = provider.selectedCards;

    return ListView.builder(
      shrinkWrap: true,
      itemCount:
          provider.cards
              .where((card) => card.selectedForActivation == true)
              .isNotEmpty
          ? cards.length
          : 2,
      itemBuilder: (context, index) {
        CardI card =
            provider.cards
                .where((card) => card.selectedForActivation == true)
                .isNotEmpty
            ? cards[index]
            : [
                CardI(
                  name: 'Tarjeta de crédito / *1234',
                  balance: 20,
                  coin: 'RD',
                  status: Status.activacionPendiente,
                  isLoading: true,
                ),
                CardI(
                  name: 'Tarjeta de crédito / *5678',
                  balance: 20,
                  coin: 'RD',
                  status: Status.activacionPendiente,
                  isLoading: true,
                ),
              ][index];

        return Container(
          padding: EdgeInsets.only(left: 13, right: 8.89, top: 4, bottom: 4),
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
                    card.isLoading == true
                        ? 'Activando tarjeta...'
                        : card.status == Status.activacionCompletada
                        ? card.status.label
                        : card.status == Status.activacionFallida
                        ? 'Tarjeta no activada'
                        : card.status.label,
                    style: AppStyle.useGoogleFont(
                      card.isLoading == true
                          ? Color(0XFFD87100)
                          : card.status == Status.activacionCompletada &&
                                card.isLoading == false
                          ? Color(0XFF4298B5)
                          : card.status == Status.activacionFallida &&
                                card.isLoading == false
                          ? Color(0XFFC8102E)
                          : Color(0XFFD87100),
                      14,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Center(
                child: card.isLoading == true
                    ? SpinningWidget(
                        duration: Duration(milliseconds: 700),
                        child: SvgPicture.asset('assets/icons/Loading-2.svg'),
                      )
                    : card.status == Status.activacionCompletada &&
                          card.isLoading != true
                    ? SvgPicture.asset('assets/icons/Check_circle_icon (1).svg')
                    : card.status == Status.activacionFallida &&
                          card.isLoading != true
                    ? SvgPicture.asset('assets/icons/Alerta_icon.svg')
                    : SpinningWidget(
                        duration: Duration(milliseconds: 700),
                        child: SvgPicture.asset('assets/icons/Loading-2.svg'),
                      ),
              ),
            ],
          ),
        );
      },
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
