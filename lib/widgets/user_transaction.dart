/**
 * This file is now deprecated and not used anymore.
 * Because all the logics are moved to the `main.dart`
 */

import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './new_transaction.dart';
import './transaction_list.dart';

class UserTransaction extends StatefulWidget {
  @override
  _UserTransactionState createState() => _UserTransactionState();
}

class _UserTransactionState extends State<UserTransaction> {
  final List<Transaction> _transactionList = [
    Transaction(
        id: 'trx1', title: 'New shoes', amount: 68.99, time: DateTime.now()),
    Transaction(
        id: 'trx2', title: 'Ointment', amount: 30.20, time: DateTime.now()),
    Transaction(
        id: 'trx3', title: 'Monitor', amount: 299.00, time: DateTime.now()),
    Transaction(
        id: 'trx4', title: 'iPad Air', amount: 500.20, time: DateTime.now()),
  ];

  void _addNewTransaction(String title, double amount) {
    final newTrx = Transaction(
      title: title,
      amount: amount,
      id: 'trx' + (this._transactionList.length + 1).toString(),
      time: DateTime.now(),
    );

    setState(() {
      _transactionList.add(newTrx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransaction(
          onNewTransaction: this._addNewTransaction,
        ),

        TransactionList(_transactionList, null),
      ],
    );
  }
}
