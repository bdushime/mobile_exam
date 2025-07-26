// ===== expense_list.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import './expense_card.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var exList = db.expenses;
        return exList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exList.length,
                itemBuilder: (_, i) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpenseCard(exList[i]),
                ),
              )
            : Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(40),
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
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Expenses Added',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start adding expenses to this category',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
