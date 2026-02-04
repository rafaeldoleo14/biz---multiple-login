import 'package:biz_codigo_cash/data/codigo_cash/dashboard.dart';
import 'package:biz_codigo_cash/presentation/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Color(0XFFE8E6DF),
      body: SafeArea(
        child: Container(
          color: Color(0XFFFFFFFF),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Header(),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      Product product = productList[index];

                      return Expandable(
                        index: index,
                        text: product.type,
                        isOpen: product.isOpen,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -4),
                color: Color.fromRGBO(0, 0, 0, 0.05),
                spreadRadius: 0,
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            children: [
              BottomOption(
                text: 'CONSULTA',
                iconName: 'consult',
                isActive: true,
              ),
              BottomOption(
                text: 'AUTORIZACIONES',
                text2: 'PENDIENTES',
                iconName: 'wait',
                isActive: false,
              ),
              BottomOption(
                text: 'ESTATUS DE',
                text2: 'TRANSACCIONES',
                iconName: 'aprobaciones',
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .85,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // 👈 Esto quita el radius
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              Container(
                padding: EdgeInsets.only(left: 12, bottom: 14),
                height: 112,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0XFF002B49),
                          ),
                          child: Center(
                            child: Text(
                              'U',
                              style: AppStyle.useGoogleFont(
                                Color(0XFFFFFFFF),
                                20,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Samira Larissa',
                          style: AppStyle.useNeoSans(
                            Color(0XFF002B49),
                            18,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DrawerOptions(
                isExpandable: false,
                text: 'Inicio',
                iconName: 'home',
              ),
              DrawerOptions(
                isExpandable: true,
                text: 'Transferencias',
                iconName: 'transfer',
              ),
              DrawerOptions(
                isExpandable: true,
                text: 'Pagos',
                iconName: 'pays',
              ),
              // DrawerOptions(
              //   isExpandable: true,
              //   text: 'Código cash',
              //   iconName: 'code',
              // ),
              DrawerOptions(
                isExpandable: false,
                text: 'Cambio de divisas',
                iconName: 'TasaCambio_icon',
              ),
              DrawerOptions(
                isExpandable: false,
                text: 'Desembolsos',
                iconName: 'desem',
              ),
              DrawerOptions(
                isExpandable: false,
                text: 'Depósito a plazo',
                iconName: 'Certificados',
              ),
              DrawerOptions(
                isExpandable: false,
                text: 'Autorizaciones pendientes',
                iconName: 'auth',
              ),
              DrawerOptions(
                isExpandable: true,
                text: 'Tarjetas',
                iconName: 'cards',
              ),
              DrawerOptions(
                isExpandable: false,
                text: 'Mis beneficiarios',
                iconName: 'bene',
              ),
              SizedBox(height: 200),
            ],
          ),
          ExitButton(),
        ],
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 20, top: 16),
        height: 76,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/icons/exit.svg'),
                SizedBox(width: 20),
                Text(
                  'Salir',
                  style: AppStyle.useGoogleFont(
                    Color(0XFFED8B00),
                    14,
                    FontWeight.w500,
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

class DrawerOptions extends StatefulWidget {
  final String text;
  final String iconName;
  final bool isExpandable;

  const DrawerOptions({
    super.key,
    required this.text,
    required this.iconName,
    required this.isExpandable,
  });

  @override
  State<DrawerOptions> createState() => _DrawerOptionsState();
}

class _DrawerOptionsState extends State<DrawerOptions> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (widget.text == 'Depósito a plazo') {
          context.push('/deposit-info');
          return;
        }

        if (!widget.isExpandable) {
          return;
        }

        setState(() {
          isOpen = !isOpen;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12, right: 31),
            height: 72,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0XFFE5E5E5)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0XFFE8E6DF),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/${widget.iconName}.svg',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      widget.text,
                      style: AppStyle.useGoogleFont(
                        Color(0XFF002B49),
                        14,
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                widget.isExpandable && !isOpen
                    ? SvgPicture.asset('assets/icons/down2.svg')
                    : widget.isExpandable && isOpen
                    ? SvgPicture.asset('assets/icons/up.svg')
                    : SizedBox(width: 0),
              ],
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            height:
                widget.isExpandable && isOpen && widget.text == 'Código cash'
                ? 100
                : widget.isExpandable && isOpen && widget.text == 'Tarjetas'
                ? 50
                : !widget.isExpandable
                ? 0
                : 0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0XFFE5E5E5)),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.text == 'Tarjetas') {
                        context.go('/manage-card');
                        return;
                      }

                      // context.go('/loader');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 52),
                      child: Row(
                        children: [
                          Text(
                            widget.text == 'Tarjetas'
                                ? 'Gestionar tarjetas'
                                : 'Generar código',
                            style: AppStyle.useGoogleFont(
                              Color(0XFF002B49),
                              14,
                              FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                widget.text != 'Tarjetas'
                    ? Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 52),
                          child: Row(
                            children: [
                              Text(
                                'Consultar historial',
                                style: AppStyle.useGoogleFont(
                                  Color(0XFF002B49),
                                  14,
                                  FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(width: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomOption extends StatelessWidget {
  final String text;
  final String? text2;
  final String iconName;
  final bool? isActive;

  const BottomOption({
    super.key,
    required this.text,
    required this.iconName,
    this.isActive,
    this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 4.57),
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive! ? Color(0XFF012169) : Colors.white,
              ),
            ),
            SizedBox(
              height: text == 'AUTORIZACIONES'
                  ? 4
                  : text == 'ESTATUS DE'
                  ? 4
                  : 10,
            ),
            SvgPicture.asset('assets/icons/$iconName.svg'),
            SizedBox(
              height: text == 'AUTORIZACIONES'
                  ? 2
                  : text == 'ESTATUS DE'
                  ? 0
                  : 6,
            ),
            Text(
              text,
              style: AppStyle.useGoogleFont(
                Color(0XFF012169),
                10,
                FontWeight.w500,
              ),
            ),
            text2 != null
                ? Text(
                    text2 ?? '',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF012169),
                      10,
                      FontWeight.w500,
                    ),
                  )
                : SizedBox(width: 0),
            text2 == null ? Expanded(child: Container()) : SizedBox(width: 0),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

class Expandable extends StatelessWidget {
  final int index;
  final String text;
  final bool isOpen;

  const Expandable({
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
          height: 48,
          color: Color(0XFF012169),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppStyle.useNeoSans(Colors.white, 14, FontWeight.w500),
              ),
              isOpen
                  ? SvgPicture.asset('assets/icons/up-white.svg')
                  : SvgPicture.asset('assets/icons/down.svg'),
            ],
          ),
        ),
        isOpen ? Column(children: [ProductIteration()]) : SizedBox(height: 0),
      ],
    );
  }
}

class ProductIteration extends StatefulWidget {
  const ProductIteration({super.key});

  @override
  State<ProductIteration> createState() => _ProductIterationState();
}

class _ProductIterationState extends State<ProductIteration> {
  String activeProduct = 'Depósito a plazo';

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          SizedBox(
            height: 32,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: filterList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                FilterProduct filters = filterList[index];

                return InkWell(
                  onTap: () {
                    setState(() {
                      // activeProduct = filters.title;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: filters.title == activeProduct
                          ? Color(0XFF002B49)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: filters.title == activeProduct
                          ? null
                          : Border.all(color: Color(0XFFE5E5E5), width: 1),
                    ),
                    child: Center(
                      child: Text(
                        filters.title,
                        style: AppStyle.useGoogleFont(
                          filters.title == activeProduct
                              ? Colors.white
                              : Color(0XFF002B49),
                          14,
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productList[0].list?.length,
            itemBuilder: (context, index) {
              ProductList product = productList[0].list![index];

              return Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
                margin: EdgeInsets.only(left: 24, right: 26, bottom: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0XFFE5E5E5), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: AppStyle.useGoogleFont(
                            Color(0XFF002B49),
                            14,
                            FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Balance actual: ${product.coin} ${product.currentBalance}',
                          style: AppStyle.useGoogleFont(
                            Color(0XFF757575),
                            14,
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset('assets/icons/Chevron_icon.svg'),
                  ],
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () {
              context.push('/deposit-info');
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              margin: EdgeInsets.symmetric(horizontal: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0XFFE5E5E5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Abrir Depósito a Plazo',
                    style: AppStyle.useGoogleFont(
                      Color(0XFF002B49),
                      14,
                      FontWeight.w600,
                    ),
                  ),
                  SvgPicture.asset('assets/icons/AddSubtract_icon.svg'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 24),
      height: 72,
      color: const Color(0XFFE8E6DF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Scaffold.maybeOf(context)?.openDrawer();
            },
            child: SvgPicture.asset('assets/icons/Menu_icon.svg'),
          ),
          Text(
            'IMPORTADORA DLF',
            style: AppStyle.useNeoSans(
              const Color(0XFF002B49),
              14,
              FontWeight.w500,
            ),
          ),
          SvgPicture.asset('assets/icons/Salir_icon.svg'),
        ],
      ),
    );
  }
}
