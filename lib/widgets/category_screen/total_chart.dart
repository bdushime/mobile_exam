// ===== total_chart.dart =====
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/database_provider.dart';

class TotalChart extends StatefulWidget {
  const TotalChart({super.key});

  @override
  State<TotalChart> createState() => _TotalChartState();
}

class _TotalChartState extends State<TotalChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (_, db, __) {
      var list = db.categories;
      var total = db.calculateTotalExpenses();
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Total Expenses',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      NumberFormat.currency(
                              locale: 'fr_RW', symbol: 'FRw', decimalDigits: 0)
                          .format(total),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...list.map(
                    (e) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            Colors.primaries[list.indexOf(e)].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.primaries[list.indexOf(e)],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              e.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.primaries[list.indexOf(e)]
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              total == 0
                                  ? '0%'
                                  : '${((e.totalAmount / total) * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.primaries[list.indexOf(e)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 40,
              child: Container(
                height: 160,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 30,
                    sectionsSpace: 4,
                    sections: total != 0
                        ? list
                            .map(
                              (e) => PieChartSectionData(
                                showTitle: false,
                                value: e.totalAmount,
                                color: Colors.primaries[list.indexOf(e)],
                                radius: 40,
                              ),
                            )
                            .toList()
                        : list
                            .map(
                              (e) => PieChartSectionData(
                                showTitle: false,
                                color: Colors.primaries[list.indexOf(e)]
                                    .withOpacity(0.3),
                                radius: 40,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
