import 'package:controle_despesas/app/expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppBottomAppBar extends StatelessWidget {
  const AppBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = autoInjector.get<AuthBloc>();
    final expenseBloc = autoInjector.get<ExpenseBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is Authenticated)
          return BottomAppBar(
            height: 64,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            color: Colors.green[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    expenseBloc
                        .add(ExpenseEnteredHomePage(userId: state.user.id));
                    context.go('/home');
                  },
                  tooltip: 'Ir para Home',
                ),
                IconButton(
                  icon: const Icon(Icons.list, color: Colors.white),
                  onPressed: () {
                    context.go('/expense-list');
                  },
                  tooltip: 'Ir para Lista de Despesas',
                ),
              ],
            ),
          );
        else
          return Container();
      },
    );
  }
}
