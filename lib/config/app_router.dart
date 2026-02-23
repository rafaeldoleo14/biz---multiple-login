import 'package:biz_codigo_cash/presentation/screens/activacion_multiple/manage_card_screen/manage_card_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/activacion_multiple/activation_card_screen/activation_card_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/activacion_multiple/summary_activation_screen/summary_activation_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/codigo_cash/beneficiary_cash_screen/beneficiary_cash_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/codigo_cash/dashboard_screen/dashboard_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/codigo_cash/generate_code_screen/generate_code_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/codigo_cash/loader_screen/loader_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_amount_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_create_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_flow_args.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_info_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_interest_destination_account_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_interest_type_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_select_account_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_submitted_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_validating_token_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/deposit/deposit_verification_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/biz_companies/biz_companies_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/biz_company_for_login/biz_company_for_login_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/biz_company_login/biz_company_login_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/biz_profile_menu/biz_profile_menu_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/biz_welcome_back/biz_welcome_back_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/configure_biometrics/configure_biometrics_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/install_token_popular/install_token_popular_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/login/login_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/new_dashboard/new_dashboard.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/splash/splash_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/terms_and_conditions/terms_and_conditions_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/token_popular/token_popular_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/validating_route/validating_route_screen.dart';
import 'package:biz_codigo_cash/presentation/screens/multiple_login/validating_token_popular/validating_token_popular_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRoute _animatedRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    ),
  );
}

GoRoute _animatedBuilderRoute(
  String path,
  Widget Function(BuildContext context, GoRouterState state) builder,
) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: builder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
          child: child,
        );
      },
    ),
  );
}

final appRouter = GoRouter(
  initialLocation: '/new-dashboard',

  routes: [
    // Múltiple login
    _animatedRoute('/splash', const SplashScreen()),
    _animatedRoute('/login', const LoginScreen()),
    _animatedRoute('/token-popular', const TokenPopularScreen()),
    _animatedRoute('/token-install', const InstallTokenPopularScreen()),
    _animatedRoute('/token-validating', const ValidatingTokenPopularScreen()),
    _animatedRoute('/biometrics', const ConfigureBiometricsScreen()),
    _animatedRoute('/terms', const TermsAndConditionsScreen()),
    _animatedBuilderRoute('/new-dashboard', (context, state) {
      final args =
          (state.extra as NewDashboardArgs?) ??
          const NewDashboardArgs(showTokenPopup: true); // default
      return NewDashboardScreen(args: args);
    }),

    // Log in - Single RNC
    _animatedRoute('/welcome', const BizWelcomeBackScreen()),
    _animatedRoute('/add-company', const BizCompanyLoginScreen()),
    _animatedRoute('/companies', const BizCompaniesScreen()),
    _animatedRoute('/profile-menu', const BizProfileMenuScreen()),
    _animatedBuilderRoute('/company-login', (context, state) {
      final companyName = state.extra as String?;
      return BizCompanyForLoginScreen(companyName: companyName ?? '');
    }),
    _animatedBuilderRoute('/validating-generic', (context, state) {
      final args =
          (state.extra as ValidatingRouteArgs?) ??
          const ValidatingRouteArgs(nextRoute: '/biometrics');

      return ValidatingRouteScreen(args: args);
    }),

    // Codigo Cash
    _animatedRoute('/dashboard', const DashboardScreen()),
    _animatedRoute('/loader', const LoaderScreen()),
    _animatedRoute('/generate-code', const GenerateCodeScreen()),
    _animatedRoute('/beneficiary-cash', const BeneficiaryCashScreen()),

    // Activación Múltiple
    _animatedRoute('/manage-card', const ManageCardScreen()),
    _animatedRoute('/activation-card', const ActivationCardScreen()),
    _animatedRoute('/summary-activation', const SummaryActivationScreen()),

    // Apertura de Depósito a plazo
    _animatedRoute('/deposit-info', const DepositInfoScreen()),
    _animatedRoute('/deposit-create', const DepositCreateScreen()),
    _animatedRoute(
      '/deposit-select-account',
      const DepositSelectAccountScreen(),
    ),
    _animatedBuilderRoute('/deposit-amount', (context, state) {
      final args = state.extra as DepositAccountArgs;
      return DepositAmountScreen(args: args);
    }),
    _animatedBuilderRoute('/deposit-interest-type', (context, state) {
      final args = state.extra as DepositDraftArgs;
      return DepositInterestTypeScreen(args: args);
    }),

    _animatedBuilderRoute('/deposit-interest-destination-account', (
      context,
      state,
    ) {
      final args = state.extra as DepositInterestDestinationArgs;
      return DepositInterestDestinationAccountScreen(args: args);
    }),

    _animatedBuilderRoute('/deposit-verification', (context, state) {
      final args = state.extra as DepositVerificationArgs;
      return DepositVerificationScreen(args: args);
    }),

    _animatedBuilderRoute('/deposit-validating-token', (context, state) {
      final args = state.extra as DepositValidatingArgs;
      return DepositValidatingTokenScreen(args: args);
    }),

    _animatedBuilderRoute('/deposit-submitted', (context, state) {
      final args = state.extra as DepositSubmittedArgs;
      return DepositSubmittedScreen(args: args);
    }),
  ],
);
