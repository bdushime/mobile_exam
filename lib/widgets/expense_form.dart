// ===== expense_form.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/database_provider.dart';
import '../constants/icons.dart';
import '../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;
  const ExpenseForm({super.key, this.expense});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm>
    with TickerProviderStateMixin {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _date;
  String _initialValue = 'Other';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    if (widget.expense != null) {
      _title.text = widget.expense!.title;
      _amount.text = widget.expense!.amount.toString();
      _date = widget.expense!.date;
      _initialValue = widget.expense!.category;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.expense == null
                            ? Icons.add_rounded
                            : Icons.edit_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.expense == null
                          ? 'Add New Expense'
                          : 'Edit Expense',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Title Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _title,
                        decoration: InputDecoration(
                          hintText: 'Enter expense title',
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Amount Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount (FRw)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.attach_money_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Date Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pickDate,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _date != null
                                        ? DateFormat('MMMM dd, yyyy')
                                            .format(_date!)
                                        : 'Select Date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _date != null
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Category Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _initialValue,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            icons[_initialValue],
                            color: Theme.of(context).primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        items: icons.keys
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Row(
                                  children: [
                                    Icon(
                                      icons[e],
                                      size: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(e),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _initialValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withBlue(255),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_title.text.isNotEmpty && _amount.text.isNotEmpty) {
                          final file = Expense(
                            id: widget.expense?.id ?? 0,
                            title: _title.text,
                            amount: int.parse(_amount.text),
                            date: _date ?? DateTime.now(),
                            category: _initialValue,
                          );
                          if (widget.expense == null) {
                            provider.addExpense(file);
                          } else {
                            provider.updateExpense(file);
                          }
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Please fill in all required fields'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Icon(
                        widget.expense == null
                            ? Icons.add_rounded
                            : Icons.check_rounded,
                        size: 24,
                      ),
                      label: Text(
                        widget.expense == null
                            ? 'Add Expense'
                            : 'Update Expense',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
