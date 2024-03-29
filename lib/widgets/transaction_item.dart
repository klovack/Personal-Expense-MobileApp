import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.onDelete,
  }) : super(key: key);

  final Transaction transaction;
  final Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
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
                  '€${this.transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: this.transaction.amount < 50
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
                  color: this.transaction.amount < 50
                      ? Theme.of(context).primaryColorDark.withOpacity(.5)
                      : Theme.of(context).accentColor.withOpacity(.5),
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
                  this.transaction.title,
                  style: Theme.of(context).textTheme.title,
                ),
                FittedBox(
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(this.transaction.time),
                  ),
                ),
              ],
            ),
          ),

          // Delete
          MediaQuery.of(context).size.width > 360
              ? FlatButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  textColor: Theme.of(context).errorColor,
                  onPressed: () {
                    onDelete(this.transaction.id);
                  },
                )
              : IconButton(
                  color: Colors.redAccent,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    onDelete(this.transaction.id);
                  },
                ),
        ],
      ),
    );
  }
}
