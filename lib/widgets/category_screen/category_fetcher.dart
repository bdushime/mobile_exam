// ===== category_fetcher.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import './total_chart.dart';
import './category_list.dart';
import '../../screens/all_expenses.dart';

class CategoryFetcher extends StatefulWidget {
  const CategoryFetcher({super.key});

  @override
  State<CategoryFetcher> createState() => _CategoryFetcherState();
}

class _CategoryFetcherState extends State<CategoryFetcher> {
  late Future _categoryList;

  Future _getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    _categoryList = _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryList,
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
                    const SizedBox(
                      height: 280,
                      child: TotalChart(),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AllExpenses.name);
                              },
                              icon: Icon(
                                Icons.visibility_rounded,
                                size: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text(
                                'View All',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const CategoryList(),
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
                  'Loading categories...',
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
