import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
// uuid.v4() generates a unique id
//and assigns it to id when ever the expense class is initialized also used initializer lists
final formatter = DateFormat.yMd();

enum Category { work, food, travel, leisure }

const categoryIcons = {
  Category.work: Icons.work,
  Category.travel: Icons.flight_takeoff,
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});
// filtering lists
  ExpenseBucket.forCategory(
      List<Expense> allExpenses, this.category) //alt constructor functions
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
