import 'package:controle_despesas/app/core/constants/category_constants.dart';
import 'package:controle_despesas/app/expense/domain/entities/expense.dart';
import 'package:controle_despesas/app/expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:controle_despesas/app/expense/presentation/ui/widgets/section_title_header.dart';
import 'package:controle_despesas/app/modules/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:controle_despesas/app/shared/ui/widgets/app_bottom_app_bar.dart';
import 'package:controle_despesas/app/shared/ui/widgets/app_bottom_app_bar_floating_button.dart';
import 'package:controle_despesas/app/theme/spacing.dart';
import 'package:controle_despesas/injection_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:collection/collection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = false;
  final authBloc = autoInjector.get<AuthBloc>();
  final expenseBloc = autoInjector.get<ExpenseBloc>();
  final _addExpenseRoute = "/add-expense";
  final _skeletonBaseColor = const Color(0xFFDEEAF3);
  final _skeletonHighlightColor = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      expenseBloc.add(const ExpenseEnteredHomePage(userId: ''));
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      bloc: expenseBloc,
      listener: (context, state) {
        if (state is ExpenseReloadRequested) {
          expenseBloc.add(const ExpenseEnteredHomePage(userId: ''));
        }
      },
      builder: (context, state) {
        List<Expense> expenses = [];
        double totalValue = 0.0;
        bool isLoading = false;
        bool isError = false;
        String errorMessage = 'Erro desconhecido.';

        if (state is ExpenseLoading) {
          isLoading = true;
          expenses = _generateFakeExpenseList();
        }
        if (state is ExpenseSuccess) {
          expenses = state.expenses;
          totalValue =
              expenses.fold(0.0, (sum, expense) => sum + expense.value);
        }
        if (state is ExpenseError) {
          isError = true;
          errorMessage = state.message;
        }

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
                          authBloc.add(AuthLogoutButtonPressed());
                          context.go("/login");
                        },
                        child: Icon(Icons.logout,
                            size: 20, color: Colors.teal[500])),
                    const SizedBox(width: Spacing.defaultSpacing / 2),
                    if (state is Authenticated)
                      Flexible(
                        child: Text(
                          "Bem-vindo ${state.user.firstName} ${state.user.lastName}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.teal[800],
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                  ],
                ),
              ),
              floatingActionButton: const AppBottomAppBarFloatingButton(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: const AppBottomAppBar(),
              body: ListView(
                padding: const EdgeInsets.all(Spacing.defaultSpacing),
                children: [
                  _buildPieChart(isLoading, isError, expenses, totalValue),
                  const SizedBox(height: Spacing.defaultSpacing * 3),
                  _buildMonthExpenses(
                      expenses, totalValue, isLoading, isError, errorMessage),
                  const SizedBox(height: Spacing.defaultSpacing),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Skeletonizer _buildSkeletonTitleHeader(bool hasLast) {
    return Skeletonizer(
      effect: ShimmerEffect(
        baseColor: _skeletonBaseColor,
        highlightColor: _skeletonHighlightColor,
        duration: const Duration(seconds: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Bone.square(
                size: 28,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              SizedBox(width: Spacing.defaultSpacing / 2),
              Bone.text(width: 128),
            ],
          ),
          if (hasLast) const Bone.text(width: 64),
        ],
      ),
    );
  }

  // Pie Chart
  SizedBox _buildPieChart(
      bool isLoading, bool isError, List<Expense> expenses, double totalValue) {
    return SizedBox(
      height: 300,
      child: Skeletonizer(
        enabled: isLoading,
        effect: ShimmerEffect(
          baseColor: _skeletonBaseColor,
          highlightColor: _skeletonHighlightColor,
          duration: const Duration(seconds: 2),
        ),
        child: isLoading
            ? _buildSkeletonPieChart()
            : isError
                ? _buildPlaceholderPieChart()
                : PieChart(
                    PieChartData(
                      sections: _buildPieChartSections(expenses, totalValue),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                    swapAnimationCurve: Curves.linear,
                    swapAnimationDuration: const Duration(milliseconds: 150),
                  ),
      ),
    );
  }

  Widget _buildMonthExpenses(
    List<Expense> expenses,
    double totalValue,
    bool isLoading,
    bool isError,
    String errorMessage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthExpensesHeader(totalValue, isLoading, isError),
        const SizedBox(height: Spacing.defaultSpacing / 2),
        if (isError) _buildErrorMessageRow(errorMessage),
        const SizedBox(height: Spacing.defaultSpacing / 2),
        _buildMonthlyExpensesContent(expenses, totalValue, isLoading, isError),
      ],
    );
  }

  CircleAvatar _buildPlaceholderPieChart() {
    return CircleAvatar(
      backgroundColor: Colors.teal[50],
      radius: 100,
      child: const CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40,
      ),
    );
  }

  Widget _buildMonthlyExpensesContent(
    List<Expense> expenses,
    double totalValue,
    bool isLoading,
    bool isError,
  ) {
    if (isLoading) return _buildSkeletonExpenseList();
    if (isError) return const SizedBox.shrink();
    if (expenses.isEmpty) return _buildNoExpenseFoundContainer();

    final groupedExpenses =
        groupBy(expenses, (Expense expense) => expense.category);

    const sortedCategories = CategoryType.values;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final categoryType = sortedCategories[index];
        final expensesByCategory = groupedExpenses[categoryType] ?? [];

        if (expensesByCategory.isEmpty) {
          return const SizedBox.shrink();
        }

        final category = Category.getByType(categoryType);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Spacing.defaultSpacing / 2),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    color: category.color,
                  ),
                  const SizedBox(width: Spacing.defaultSpacing / 2),
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: category.color,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expensesByCategory.length,
              itemBuilder: (context, expenseIndex) {
                final expense = expensesByCategory[expenseIndex];
                return _buildExpenseCard(expense, category);
              },
            ),
            const SizedBox(height: Spacing.defaultSpacing / 2),
          ],
        );
      },
    );
  }

  Widget _buildNoExpenseFoundContainer() {
    return Center(
      child: Text(
        "Nenhuma despesa encontrada.",
        style: TextStyle(color: Colors.grey[600], fontSize: 16),
      ),
    );
  }

  Widget _buildMonthExpensesHeader(
      double totalValue, bool isLoading, bool isError) {
    return isLoading
        ? _buildSkeletonTitleHeader(true)
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionTitleHeader(
                title: "Gastos do Mês",
                color: Colors.green[600]!,
                icon: Icons.calendar_month,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Spacing.defaultSpacing / 4,
                        horizontal: Spacing.defaultSpacing / 2,
                      ),
                      child: Text(
                        'R\$ ${isError ? '0.00' : totalValue.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget _buildErrorMessageRow(String message) {
    return Column(
      children: [
        const SizedBox(height: Spacing.defaultSpacing / 2),
        Container(
          padding: const EdgeInsets.all(Spacing.defaultSpacing),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F5FF),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.teal[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: Spacing.defaultSpacing / 2),
                  InkWell(
                    onTap: () {
                      context.go(_addExpenseRoute);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              color: Colors.teal[800]!,
                              blurRadius: 0.0,
                            ),
                          ],
                          color: Colors.teal[600],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Spacing.defaultSpacing / 2,
                          horizontal: Spacing.defaultSpacing,
                        ),
                        child: Text(
                          "REGISTRAR NOVA DESPESA",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseCard(Expense expense, Category category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.defaultSpacing / 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
          color: category.color.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.defaultSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    category.icon,
                    color: category.color,
                  ),
                  const SizedBox(width: Spacing.defaultSpacing / 2),
                  Text(
                    expense.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                'R\$ ${expense.value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: category.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      List<Expense> expenses, double totalValue) {
    if (totalValue == 0) return [];
    final categorySums = <CategoryType, double>{};
    for (var expense in expenses) {
      categorySums[expense.category] =
          (categorySums[expense.category] ?? 0) + expense.value;
    }
    return categorySums.entries.map((entry) {
      final category = Category.getByType(entry.key);
      final percentage = (entry.value / totalValue) * 100;
      return PieChartSectionData(
        color: category.color,
        value: entry.value,
        radius: 60,
        title: '${percentage.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, size: 18, color: Colors.white),
          ),
        ),
        badgePositionPercentageOffset: 1.5,
      );
    }).toList();
  }

  Stack _buildSkeletonPieChart() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 60,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonExpenseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildSkeletonExpenseCard();
      },
    );
  }

  Widget _buildSkeletonExpenseCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: _skeletonBaseColor,
          highlightColor: _skeletonHighlightColor,
          duration: const Duration(seconds: 2),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _skeletonBaseColor.withOpacity(0.35),
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(Spacing.defaultSpacing / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Bone.circle(size: 24),
                    SizedBox(width: Spacing.defaultSpacing / 2),
                    Bone.text(width: 100),
                  ],
                ),
                Bone.text(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Expense> _generateFakeExpenseList() {
    return List.generate(
      5,
      (index) => Expense(
        id: '',
        title: '',
        value: 0.0,
        category: CategoryType.values[index % CategoryType.values.length],
        date: DateTime.now(),
        userId: '',
      ),
    );
  }
}
