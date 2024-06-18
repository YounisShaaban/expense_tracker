import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_lists/expense_item.dart';
import 'package:flutter/material.dart';
// use ListView  insted of a colmun when you don't know what length the list will be,
// + it's a scrollable list , we used the .builder to create the items only
// when they are visible.

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final void Function(Expense expense) onRemoveExpense;

  final List<Expense> expenses;
  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(1),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        key: UniqueKey(),
        onDismissed: (dirction) {
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          (expenses[index]),
        ),
      ),
    );
  }
}
