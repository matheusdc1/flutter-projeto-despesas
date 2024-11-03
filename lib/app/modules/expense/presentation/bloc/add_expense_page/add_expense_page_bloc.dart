import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/modules/expense/application/usecases/expense/create_expense.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_expense_page_event.dart';

part 'add_expense_page_state.dart';

class AddExpensePageBloc
    extends Bloc<AddExpensePageEvent, AddExpensePageState> {
  final CreateExpense _createExpense;

  AddExpensePageBloc({required CreateExpense createExpense})
      : _createExpense = createExpense,
        super(AddExpensePageInitial()) {
    on<AddExpensePageSubmitButtonClicked>(_onAddExpensePageSubmitButtonClicked);
  }

  Future<void> _onAddExpensePageSubmitButtonClicked(
    AddExpensePageSubmitButtonClicked event,
    Emitter<AddExpensePageState> emit,
  ) async {
    emit(const AddExpensePageLoading());
    final output = await _createExpense.execute(
      CreateExpenseParams(
        title: event.title,
        value: event.value,
        category: event.category.name,
        date: event.date,
        userId: event.userId,
      ),
    );
    output.fold(
      (expense) => emit(const AddExpensePageSuccess()),
      (failure) => emit(
        AddExpensePageError(failure.message),
      ),
    );
  }
}
