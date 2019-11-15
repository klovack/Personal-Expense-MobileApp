import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.red,
        fontFamily: 'MerriweatherSans',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'Merriweather', 
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'Merriweather', 
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactionList = [
    // Transaction(
    //     id: 'trx1', title: 'New shoes', amount: 68.99, time: DateTime.now()),
    // Transaction(
    //     id: 'trx2', title: 'Ointment', amount: 30.20, time: DateTime.now()),
    // Transaction(
    //     id: 'trx3', title: 'Monitor', amount: 299.00, time: DateTime.now()),
    // Transaction(
    //     id: 'trx4', title: 'iPad Air', amount: 500.20, time: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    final today = DateTime.now();
    
    return _transactionList.where((trx) {
      return trx.time.isAfter(today.subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction({title: String, amount: double, time: DateTime}) {
    final newTrx = Transaction(
      title: title,
      amount: amount,
      id: 'trx' + (this._transactionList.length + 1).toString(),
      time: time,
    );

    setState(() {
      _transactionList.add(newTrx);
    });
  }

  void _showNewTransactionInput(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(onNewTransaction: this._addNewTransaction,),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionList.removeWhere((trx) {
        return trx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Personal Expenses'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showNewTransactionInput(context),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => {},
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Chart
            Chart(this._recentTransactions),

            TransactionList(this._transactionList, this._deleteTransaction),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _showNewTransactionInput(context),
        ),
      );
  }
}
