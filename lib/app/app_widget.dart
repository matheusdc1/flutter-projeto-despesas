import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:controle_despesas/router.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final authBloc = autoInjector.get<AuthBloc>();

  @override
  void initState() {
    super.initState();
    authBloc.add(AppInitializing());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: buildTheme(Brightness.light),
      debugShowCheckedModeBanner: false,
      title: 'Controle Despesas',
      routerConfig: router,
    );
  }
}
