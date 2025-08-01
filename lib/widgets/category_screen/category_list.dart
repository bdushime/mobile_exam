// ===== category_list.dart =====
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';
import './category_card.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.categories;
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: list.length,
          padding: const EdgeInsets.only(bottom: 80),
          itemBuilder: (_, i) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: CategoryCard(list[i]),
          ),
        );
      },
    );
  }
}
