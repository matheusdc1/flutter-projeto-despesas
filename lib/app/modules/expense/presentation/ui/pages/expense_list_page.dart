import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/modules/auth/presentation/ui/pages/login_page.dart';
import 'package:controle_despesas/app/modules/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/modules/expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:controle_despesas/app/modules/expense/presentation/ui/widgets/edit_expense_modal.dart';
import 'package:controle_despesas/app/modules/shared/ui/widgets/app_bottom_app_bar.dart';
import 'package:controle_despesas/app/modules/shared/ui/widgets/app_bottom_app_bar_floating_button.dart';
import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final AuthBloc authBloc = autoInjector<AuthBloc>();
  final ExpenseBloc expenseBloc = autoInjector<ExpenseBloc>();
  CategoryType? _selectedCategory;
  String _sortBy = 'date';

  @override
  void initState() {
    super.initState();
    expenseBloc.add(ExpenseEnteredListPage(userId: _getUserId()));
  }

  String _getUserId() {
    final state = authBloc.state;
    if (state is Authenticated) {
      return state.user.id;
    }
    throw Exception("Usuário não autenticado");
  }

  void _applyFilters() {
    expenseBloc.add(
      ExpenseFilterChanged(
        category: _selectedCategory,
        sortBy: _sortBy,
        userId: _getUserId(),
      ),
    );
  }

  void _deleteExpense(String id) {
    expenseBloc
        .add(ExpenseDeleteExpenseButtonClicked(id: id, userId: _getUserId()));
  }

  void _showEditExpenseModal(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => EditExpenseModal(expense: expense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    expenseBloc.add(
                      ExpenseEnteredHomePage(
                        userId: _getUserId(),
                      ),
                    );
                    context.go("/home");
                  },
                  child: Icon(Icons.chevron_left,
                      size: 24, color: Colors.teal[500]),
                ),
                const SizedBox(width: Spacing.defaultSpacing / 2),
                Text(
                  "Lista de Despesas",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: _showFilterDialog,
                child: Icon(Icons.filter_alt, color: Colors.teal[800]),
              ),
              const SizedBox(width: Spacing.defaultSpacing / 2),
              InkWell(
                onTap: _showSortDialog,
                child: Icon(Icons.sort, color: Colors.teal[800]),
              ),
              const SizedBox(width: Spacing.defaultSpacing),
            ],
          ),
          floatingActionButton: const AppBottomAppBarFloatingButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const AppBottomAppBar(),
          body: BlocBuilder<ExpenseBloc, ExpenseState>(
            bloc: expenseBloc,
            builder: (context, state) {
              if (state is ExpenseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExpenseSuccess) {
                return _buildExpenseList(state.expenses);
              } else if (state is ExpenseError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.defaultSpacing),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildExpenseList(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return const Center(
        child:
            Text("Nenhuma despesa encontrada.", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.defaultSpacing),
      itemCount: expenses.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final category = Category.getByType(expense.category);

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: category.color.withOpacity(0.2),
            child: Icon(category.icon, color: category.color),
          ),
          title: Text(
            expense.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("${category.name} • ${_formatDate(expense.date)}"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "R\$ ${expense.value.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showEditExpenseModal(context, expense),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context, expense.id),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String expenseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text("Tem certeza que deseja excluir esta despesa?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteExpense(expenseId);
                Navigator.of(context).pop();
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        CategoryType? tempSelectedCategory = _selectedCategory;
        return AlertDialog(
          title: const Text("Filtrar por Categoria"),
          content: DropdownButtonFormField<CategoryType>(
            value: tempSelectedCategory,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<CategoryType>(
                value: null,
                child: Text("Todas"),
              ),
              ...CategoryType.values.map((category) {
                final categoryData = Category.getByType(category);
                return DropdownMenuItem<CategoryType>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(categoryData.icon, color: categoryData.color),
                      const SizedBox(width: 8),
                      Text(categoryData.name),
                    ],
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() => tempSelectedCategory = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _selectedCategory = tempSelectedCategory);
                _applyFilters();
                Navigator.of(context).pop();
              },
              child: const Text("Aplicar"),
            ),
          ],
        );
      },
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempSortBy = _sortBy;
        return AlertDialog(
          title: const Text("Ordenar Por"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text("Data"),
                value: 'date',
                groupValue: tempSortBy,
                onChanged: (value) {
                  setState(() => tempSortBy = value!);
                },
              ),
              RadioListTile<String>(
                title: const Text("Valor"),
                value: 'value',
                groupValue: tempSortBy,
                onChanged: (value) {
                  setState(() => tempSortBy = value!);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _sortBy = tempSortBy);
                _applyFilters();
                Navigator.of(context).pop();
              },
              child: const Text("Aplicar"),
            ),
          ],
        );
      },
    );
  }
}
