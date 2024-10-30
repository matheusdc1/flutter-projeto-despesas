import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/expense/presentation/bloc/add_expense_page/add_expense_page_bloc.dart';
import 'package:controle_despesas/app/expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/shared/ui/widgets/app_bottom_app_bar.dart';
import 'package:controle_despesas/app/shared/ui/widgets/app_bottom_app_bar_floating_button.dart';
import 'package:controle_despesas/app/shared/ui/widgets/app_button.dart';
import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final authBloc = autoInjector.get<AuthBloc>();
  final addExpenseBloc = autoInjector<AddExpensePageBloc>();
  final expenseBloc = autoInjector<ExpenseBloc>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  CategoryType? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _getUserId() {
    final state = authBloc.state;
    if (state is Authenticated) {
      return state.user.id;
    }
    throw Exception("Usuário não autenticado");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text.trim();
      final double value = double.parse(_valueController.text.trim());
      final CategoryType category = _selectedCategory!;
      final DateTime date = _selectedDate ?? DateTime.now();

      addExpenseBloc.add(
        AddExpensePageSubmitButtonClicked(
          title: title,
          value: value,
          category: category,
          date: date,
          userId: _getUserId(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppBottomAppBarFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const AppBottomAppBar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => {
                expenseBloc.add(ExpenseEnteredHomePage(userId: _getUserId())),
                context.go("/home")
              },
              child:
                  Icon(Icons.chevron_left, size: 24, color: Colors.teal[500]),
            ),
            const SizedBox(width: Spacing.defaultSpacing / 2),
            Text(
              "Adicionar Despesa",
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AddExpensePageBloc, AddExpensePageState>(
        bloc: addExpenseBloc,
        listener: (context, state) {
          if (state is AddExpensePageSuccess) {
            context.go("/home");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              expenseBloc.add(ExpenseReloadRequested(userId: _getUserId()));
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(Spacing.defaultSpacing),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira o título da despesa.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.defaultSpacing),
                  TextFormField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      labelText: 'Valor (R\$)',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, insira o valor da despesa.';
                      }
                      final parsedValue = double.tryParse(value.trim());
                      if (parsedValue == null || parsedValue <= 0) {
                        return 'Por favor, insira um valor válido.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.defaultSpacing),
                  DropdownButtonFormField<CategoryType>(
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
                    items: CategoryType.values.map((category) {
                      final categoryData = Category.getByType(category);
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(categoryData.icon, color: categoryData.color),
                            const SizedBox(width: 8),
                            Text(categoryData.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) => setState(() {
                      _selectedCategory = newValue;
                    }),
                    validator: (value) => value == null
                        ? 'Por favor, selecione uma categoria.'
                        : null,
                  ),
                  const SizedBox(height: Spacing.defaultSpacing),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, selecione uma data.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Spacing.defaultSpacing * 2),
                  SizedBox(
                    width: double.infinity,
                    child: state is AddExpensePageLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : AppButton(
                            name: "ADICIONAR DESPESA",
                            padding:
                                const EdgeInsets.all(Spacing.defaultSpacing),
                            buttonColor: Colors.teal[600]!,
                            shadowColor: Colors.teal[800]!,
                            icon: Icons.add_circle_outline,
                            onTap: () => _submitForm(context),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
