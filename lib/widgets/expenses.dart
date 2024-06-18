import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_lists/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    _registeredExpenses.remove(expense);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        content: const Text(
          'The expense has been deleted',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // print(MediaQuery.of(context).size.height);
    Widget mainContent = const Center(
      child: Text('no expenses found, try adding some (:'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
        appBar: AppBar(title: const Text('flutter expenseTracker'), actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ]),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ));
  }
}
