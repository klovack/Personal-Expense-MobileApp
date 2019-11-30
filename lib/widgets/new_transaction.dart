import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function onNewTransaction;

  NewTransaction({@required this.onNewTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _openDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime(2019),
    ).then((pickedDate) {
      // If user pressed cancel
      if (pickedDate == null) {
        return;
      }

      setState(() {
        this._selectedDate = pickedDate;
      });
    });
  }

  void _submitDate() {
    final enteredName = _nameController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredName.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.onNewTransaction(
      title: enteredName,
      amount: enteredAmount,
      time: _selectedDate,
    );
    // Close the modal
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // Name (Title)
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Platform.isIOS ? CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Laptop',
                  prefix: Icon(CupertinoIcons.shopping_cart),
                ) : TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Laptop',
                  ),

                  // Useful, but in this case we can use other variant
                  // onChanged: (value) => inputName = value,
                ),
              ),

              // Amount
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Platform.isIOS ? CupertinoTextField(
                  controller: _nameController,
                  placeholder: '879.99',
                  prefix: Text('  € ', style: TextStyle(fontSize: 18),),
                ) : TextField(
                  keyboardType: TextInputType.phone,
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: '€ 879.99',
                  ),

                  // Useful, but in this case we can use other variant
                  // onChanged: (value) => inputAmount = value
                ),
              ),

              Row(
                children: <Widget>[
                  Text(
                    _selectedDate == null
                        ? 'Choose Date!'
                        : DateFormat.yMMMd().format(_selectedDate),
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _openDatePicker(context);
                    },
                  )
                ],
              ),

              RaisedButton(
                child: Text('Add Transaction'),
                onPressed: () {
                  _submitDate();
                },
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
