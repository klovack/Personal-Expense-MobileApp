import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: 6 - index));
      double totalSum = 0;

      for (var trx in recentTransactions) {
        if (trx.time.day == weekday.day &&
            trx.time.month == weekday.month &&
            trx.time.year == weekday.year) {
          totalSum += trx.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get totalSpending {
    // Alternative
    // double totalSpending = 0;
    // for (var trx in this.recentTransactions) {
    //   totalSpending += trx.amount;
    // }

    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // Total Sum
            Text('Total spent this week: €${totalSpending.toStringAsFixed(2)}'),

            // Actual Chart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: groupedTransactionValues.map((data) {
                return ChartBar(
                  label: data['day'],
                  spendingAmount: data['amount'],
                  spendingPctOfTotal: totalSpending > 0
                      ? (data['amount'] as double) / totalSpending
                      : 0,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
