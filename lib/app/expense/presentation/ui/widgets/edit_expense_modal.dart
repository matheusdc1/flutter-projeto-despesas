import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExpenseModal extends StatefulWidget {
  final Expense expense;

  const EditExpenseModal({super.key, required this.expense});

  @override
  State<EditExpenseModal> createState() => _EditExpenseModalState();
}

class _EditExpenseModalState extends State<EditExpenseModal> {
  final authBloc = autoInjector.get<AuthBloc>();
  final expenseBloc = autoInjector.get<ExpenseBloc>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _valueController;
  late TextEditingController _dateController;
  CategoryType? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _valueController =
        TextEditingController(text: widget.expense.value.toString());
    _dateController =
        TextEditingController(text: _formatDate(widget.expense.date));
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  void _submitForm(BuildContext context, String userId) {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text.trim();
      final double value = double.parse(_valueController.text.trim());
      final CategoryType category = _selectedCategory!;
      final DateTime date = _selectedDate ?? DateTime.now();

      expenseBloc.add(
        ExpenseEditExpenseButtonClicked(
          id: widget.expense.id,
          title: title,
          value: value,
          category: category,
          date: date,
          userId: userId,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is Authenticated) {
          final userId = state.user.id;

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Por favor, insira o título.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _valueController,
                    decoration: const InputDecoration(
                      labelText: 'Valor (R\$)',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) =>
                        value == null || double.tryParse(value) == null
                            ? 'Insira um valor válido.'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CategoryType>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                    ),
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
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _submitForm(context, userId),
                    child: const Text("Salvar Alterações"),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
