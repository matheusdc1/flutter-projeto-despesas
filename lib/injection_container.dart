import 'package:auto_injector/auto_injector.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/get_is_authenticated.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/get_user.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/login.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/logout.dart';
import 'package:controle_despesas/app/modules/auth/application/usecases/register.dart';
import 'package:controle_despesas/app/modules/auth/data/datasources/auth_remote_datasource.dart';
import 'package:controle_despesas/app/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:controle_despesas/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/create_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/delete_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/edit_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/filter_sort_expenses.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/get_expense.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/get_expenses.dart';
import 'package:controle_despesas/app/modules/expense/data/datasources/expense_remote_datasource.dart';
import 'package:controle_despesas/app/modules/expense/data/repositories/expense_repository_impl.dart';
import 'package:controle_despesas/app/modules/expense/domain/repositories/expense_repository.dart';
import 'package:controle_despesas/app/modules/expense/presentation/bloc/add_expense_page/add_expense_page_bloc.dart';
import 'package:controle_despesas/app/modules/expense/presentation/bloc/expense/expense_bloc.dart';

final autoInjector = AutoInjector();

diSetup() {
  // Datasources
  // Auth
  autoInjector
      .addLazySingleton<AuthRemoteDatasource>(AuthRemoteDatasourceImpl.new);
  // Expense
  autoInjector.addLazySingleton<ExpenseRemoteDatasource>(
      ExpenseRemoteDatasourceImpl.new);
  // Repositories
  // Auth
  autoInjector.addLazySingleton<AuthRepository>(AuthRepositoryImpl.new);
  // Expense
  autoInjector.addLazySingleton<ExpenseRepository>(ExpenseRepositoryImpl.new);

  // UseCases
  // Auth
  autoInjector.addLazySingleton<Register>(Register.new);
  autoInjector.addLazySingleton<Login>(Login.new);
  autoInjector.addLazySingleton<Logout>(Logout.new);
  autoInjector.addLazySingleton<GetIsAuthenticated>(GetIsAuthenticated.new);
  autoInjector.addLazySingleton<GetUser>(GetUser.new);

  // Expense
  autoInjector.addLazySingleton<CreateExpense>(CreateExpense.new);
  autoInjector.addLazySingleton<GetExpenses>(GetExpenses.new);
  autoInjector.addLazySingleton<GetExpense>(GetExpense.new);
  autoInjector.addLazySingleton<DeleteExpense>(DeleteExpense.new);
  autoInjector.addLazySingleton<EditExpense>(EditExpense.new);
  autoInjector.addLazySingleton<FilterSortExpenses>(FilterSortExpenses.new);

  // Blocs & Cubits
  autoInjector.addLazySingleton<AuthBloc>(AuthBloc.new);
  autoInjector.addLazySingleton<ExpenseBloc>(ExpenseBloc.new);
  autoInjector.addLazySingleton<AddExpensePageBloc>(AddExpensePageBloc.new);

  // Inject everything
  autoInjector.commit();
}
