// ===== all_expenses_fetcher.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import './all_expenses_list.dart';
import './expense_search.dart';

class AllExpensesFetcher extends StatefulWidget {
  const AllExpensesFetcher({super.key});

  @override
  State<AllExpensesFetcher> createState() => _AllExpensesFetcherState();
}

class _AllExpensesFetcherState extends State<AllExpensesFetcher> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllExpenses();
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = _getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allExpensesList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
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
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 280,
                      child: ExpenseChart(widget.category),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Expenses',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const ExpenseList(),
                  ],
                ),
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
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
