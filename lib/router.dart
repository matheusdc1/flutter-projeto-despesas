import 'dart:async';
import 'package:controle_despesas/app/expense/presentation/ui/pages/add_expense_page.dart';
import 'package:controle_despesas/app/expense/presentation/ui/pages/expense_list_page.dart';
import 'package:controle_despesas/app/expense/presentation/ui/pages/home_page.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:controle_despesas/app/modules/auth/presentation/ui/pages/login_page.dart';
import 'package:controle_despesas/app/modules/auth/presentation/ui/pages/register_page.dart';
import 'package:controle_despesas/injection_container.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final goRouterNotifier = GoRouterNotifier(autoInjector.get<AuthBloc>());

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/', builder: (context, state) => const _PlaceholderBlankPage()),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-expense',
      builder: (context, state) => const AddExpensePage(),
    ),
    GoRoute(
      path: '/expense-list',
      builder: (context, state) => const ExpenseListPage(),
    ),
  ],
  refreshListenable: goRouterNotifier,
  redirect: _authGuardRedirect,
  navigatorKey: navigatorKey,
);

FutureOr<String?> _authGuardRedirect(
  BuildContext context,
  GoRouterState state,
) {
  final authState = autoInjector.get<AuthBloc>().state;
  if (authState is AuthInitial || authState is AuthLoading) return null;
  final bool isAuthenticated = authState is Authenticated;
  final bool isLoggingIn =
      state.matchedLocation == '/login' || state.matchedLocation == '/register';
  final bool isRoot = state.matchedLocation == '/';
  if (isRoot) return isAuthenticated ? '/home' : '/login';
  if (!isAuthenticated && !isLoggingIn) return '/login';
  if (isAuthenticated && isLoggingIn) return '/home';
  return null;
}

class GoRouterNotifier extends ChangeNotifier {
  final AuthBloc authBloc;

  GoRouterNotifier(this.authBloc) {
    authBloc.stream.listen((state) {
      notifyListeners();
    });
  }
}

class _PlaceholderBlankPage extends StatelessWidget {
  const _PlaceholderBlankPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}
