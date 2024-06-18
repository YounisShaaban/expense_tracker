import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/rendering.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showdialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Title(
            color: Colors.red,
            child: const Text('invalid input'),
          ),
          content:
              const Text('please make sure you enterd everything correctly '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Title(
            color: Colors.red,
            child: const Text('invalid input'),
          ),
          content:
              const Text('please make sure you enterd everything correctly '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('okay'),
            )
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);

    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showdialog();

      return;
    }

    setState(() {
      widget.onAddExpense(
        Expense(
            title: _titleController.text,
            amount: enteredAmount,
            date: _selectedDate!,
            category: _selectedCategory),
      );
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: ((ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
                child: Column(
                  children: [
                    if (width >= 600)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              maxLength: 50,
                              decoration: const InputDecoration(
                                label: Text('Title'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              decoration: const InputDecoration(
                                  prefixText: '\$ ', label: Text('Amount')),
                            ),
                          ),
                        ],
                      )
                    else
                      TextField(
                        controller: _titleController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                      ),
                    if (width >= 600)
                      Row(
                        children: [
                          DropdownButton(
                              value: _selectedCategory,
                              items: Category.values
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name.toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? 'No Date Selected'
                                      : formatter.format(_selectedDate!),
                                ), // place holder for now
                                IconButton(
                                    onPressed: _presentDatePicker,
                                    icon: const Icon(
                                      Icons.calendar_month,
                                    ))
                              ],
                            ),
                          )
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              maxLength: 5,
                              decoration: const InputDecoration(
                                  prefixText: '\$ ', label: Text('Amount')),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? 'No Date Selected'
                                      : formatter.format(_selectedDate!),
                                ), // place holder for now
                                IconButton(
                                    onPressed: _presentDatePicker,
                                    icon: const Icon(
                                      Icons.calendar_month,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (width >= 600)
                      Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'cancel',
                            ),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: _submitExpenseData,
                            child: const Text(
                              'Save Expense',
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          DropdownButton(
                              value: _selectedCategory,
                              items: Category.values
                                  .map(
                                    (category) => DropdownMenuItem(
                                      value: category,
                                      child: Text(
                                        category.name.toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'cancel',
                            ),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: _submitExpenseData,
                            child: const Text(
                              'Save Expense',
                            ),
                          ),
                        ],
                      ),
                  ],
                )),
          ),
        );
      }),
    );
  }
}

//alt approach below (on changed...)

// import 'package:flutter/material.dart';

// class NewExpense extends StatefulWidget {
//   const NewExpense({super.key});

//   @override
//   State<NewExpense> createState() {
//     return _NewExpenseState();
//   }
// }

// class _NewExpenseState extends State<NewExpense> {
//   var _enteredTitle = '';

//   void _saveTitleValue(String inputValue) {
//     _enteredTitle = inputValue;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               onChanged: _saveTitleValue,
//               maxLength: 50,
//               decoration: const InputDecoration(
//                 label: Text('Title'),
//               ),
//             ),
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     print(_enteredTitle);
//                   },
//                   child: const Text(
//                     'Save Expense',
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ));
//   }
// }
