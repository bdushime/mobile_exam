// ===== confirm_box.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import '../../models/expense.dart';

class ConfirmBox extends StatelessWidget {
  const ConfirmBox({
    super.key,
    required this.exp,
  });

  final Expense exp;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Expense',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  exp.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to delete this expense? This action cannot be undone.',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style: TextButton.styleFrom(
            foregroundColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            provider.deleteExpense(exp.id, exp.category, exp.amount as double);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Delete',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
