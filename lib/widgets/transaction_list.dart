import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function(String id) onDelete;

  TransactionList(this.transactionList, this.onDelete);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: transactionList.isEmpty
            ? Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/no_money.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                // Item Builder
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Spend Amount
                        Container(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '€${this.transactionList[index].amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: this.transactionList[index].amount < 50
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: this.transactionList[index].amount < 50
                                    ? Theme.of(context)
                                        .primaryColorDark
                                        .withOpacity(.5)
                                    : Theme.of(context)
                                        .accentColor
                                        .withOpacity(.5),
                                width: 3,
                              )),
                          height: 50,
                          width: 70,
                          alignment: Alignment.center,
                        ),

                        // Body
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.transactionList[index].title,
                                style: Theme.of(context).textTheme.title,
                              ),
                              FittedBox(
                                child: Text(
                                  DateFormat.yMMMMEEEEd()
                                      .format(this.transactionList[index].time),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Delete
                        IconButton(
                          color: Colors.redAccent,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            onDelete(this.transactionList[index].id);
                          },
                        ),
                      ],
                    ),
                  );
                },
                itemCount: transactionList.length,
              ),
      );
  }
}
