// ===== database_provider.dart =====
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/icons.dart';
import './ex_category.dart';
import './expense.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  List<Expense> _expenses = [];
  List<Expense> get expenses {
    return _searchText != ''
        ? _expenses
            .where((e) =>
                e.title.toLowerCase().contains(_searchText.toLowerCase()))
            .toList()
        : _expenses;
  }

  Database? _database;
  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();
    const dbName = 'expense_tc.db';
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return _database!;
  }

  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''CREATE TABLE $cTable(
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
      )''');
      await txn.execute('''CREATE TABLE $eTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT,
        category TEXT
      )''');

      for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }
    });
  }

  Future<List<ExpenseCategory>> fetchCategories() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(cTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<ExpenseCategory> nList = List.generate(converted.length,
            (index) => ExpenseCategory.fromString(converted[index]));
        _categories = nList;
        return _categories;
      });
    });
  }

  Future<void> updateCategory(
    String category,
    int nEntries,
    double nTotalAmount,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .update(
        cTable,
        {
          'entries': nEntries,
          'totalAmount': nTotalAmount.toString(),
        },
        where: 'title == ?',
        whereArgs: [category],
      )
          .then((_) {
        var file =
            _categories.firstWhere((element) => element.title == category);
        file.entries = nEntries;
        file.totalAmount = nTotalAmount;
        notifyListeners();
      });
    });
  }

  Future<void> addExpense(Expense exp) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(
        eTable,
        exp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((generatedId) {
        final file = Expense(
            id: generatedId,
            title: exp.title,
            amount: exp.amount,
            date: exp.date,
            category: exp.category);

        _expenses.add(file);
        notifyListeners();
        var ex = findCategory(exp.category);

        updateCategory(
            exp.category, ex.entries + 1, ex.totalAmount + exp.amount);
      });
    });
  }

  Future<void> deleteExpense(int expId, String category, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(eTable, where: 'id == ?', whereArgs: [expId]).then((_) {
        _expenses.removeWhere((element) => element.id == expId);
        notifyListeners();

        var ex = findCategory(category);
        updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
      });
    });
  }

  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable,
          where: 'category == ?', whereArgs: [category]).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(eTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;
    var list = _expenses.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  double calculateTotalExpenses() {
    return _categories.fold(
        0.0, (previousValue, element) => previousValue + element.totalAmount);
  }

  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 7; i++) {
      double total = 0.0;
      final weekDay = DateTime.now().subtract(Duration(days: i));

      for (int j = 0; j < _expenses.length; j++) {
        if (_expenses[j].date.year == weekDay.year &&
            _expenses[j].date.month == weekDay.month &&
            _expenses[j].date.day == weekDay.day) {
          total += _expenses[j].amount;
        }
      }

      data.add({'day': weekDay, 'amount': total});
    }
    return data;
  }

  Future<void> updateExpense(Expense exp) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(
        eTable,
        exp.toMap(),
        where: 'id == ?',
        whereArgs: [exp.id],
      ).then((_) {
        int index = _expenses.indexWhere((element) => element.id == exp.id);
        if (index != -1) {
          Expense oldExp = _expenses[index];
          _expenses[index] = exp;
          notifyListeners();

          var oldCategory = findCategory(oldExp.category);
          var newCategory = findCategory(exp.category);

          if (oldExp.category == exp.category) {
            int diff = exp.amount - oldExp.amount;
            updateCategory(exp.category, newCategory.entries, newCategory.totalAmount + diff);
          } else {
            updateCategory(oldExp.category, oldCategory.entries - 1, oldCategory.totalAmount - oldExp.amount);
            updateCategory(exp.category, newCategory.entries + 1, newCategory.totalAmount + exp.amount);
          }
        }
      });
    });
  }
}
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  ExpenseSearch(),
                  Expanded(child: AllExpensesList()),
                ],
              ),
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading expenses...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
