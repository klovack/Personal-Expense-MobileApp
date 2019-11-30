import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';

void main() {
  // Set the default orientation to portrait
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

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
                    fontSize: 18),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

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
          child: NewTransaction(
            onNewTransaction: this._addNewTransaction,
          ),
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
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildNavigationBarIOS(context)
        : _buildAppBarAndroid(context);

    final trxListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .7,
        child: TransactionList(this._transactionList, this._deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Landscape Layout
            if (isLandscape)
              ..._buildLandscapeLayout(
                  context, mediaQuery, appBar, trxListWidget),

            // Portrait Layout
            if (!isLandscape)
              ..._buildPortraitLayout(mediaQuery, appBar, trxListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _showNewTransactionInput(context),
                  ),
          );
  }

  AppBar _buildAppBarAndroid(BuildContext context) {
    return AppBar(
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
        );
  }

  CupertinoNavigationBar _buildNavigationBarIOS(BuildContext context) {
    return CupertinoNavigationBar(
          middle: Text('Personal Expenses'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _showNewTransactionInput(context),
              )
            ],
          ),
        );
  }

  List<Widget> _buildPortraitLayout(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Widget trxListWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              .3,
          child: Chart(this._recentTransactions)),
      trxListWidget
    ];
  }

  List<Widget> _buildLandscapeLayout(BuildContext context,
      MediaQueryData mediaQuery, AppBar appBar, Widget trxListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).primaryColor,
            value: this._showChart,
            onChanged: (val) {
              setState(() {
                this._showChart = val;
              });
            },
          )
        ],
      ),
      this._showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  .7,
              child: Chart(this._recentTransactions))
          : trxListWidget
    ];
  }
}
