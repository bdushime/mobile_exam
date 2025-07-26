// ===== all_expenses_list.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../expense_screen/expense_card.dart';

class AllExpensesList extends StatelessWidget {
  const AllExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.expenses;
        return list.isNotEmpty
            ? ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                padding: const EdgeInsets.only(bottom: 80),
                itemBuilder: (_, i) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpenseCard(list[i]),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        size: 48,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Expenses Found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking your expenses by adding your first entry',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
      },
    );
  }
}
