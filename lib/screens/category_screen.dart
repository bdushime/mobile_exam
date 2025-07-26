// ===== category_screen.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/category_screen/category_fetcher.dart';
import '../widgets/expense_form.dart';
import '../models/theme_provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  static const name = '/category_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      key: ValueKey(themeProvider.isDarkMode),
                      color: themeProvider.isDarkMode
                          ? Colors.amber
                          : Colors.indigo,
                    ),
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme(!themeProvider.isDarkMode);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: const CategoryFetcher(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withBlue(255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const ExpenseForm(),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add_rounded,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
