import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TransactionDetail extends StatefulWidget {
  final PBTransaction transaction;
  TransactionDetail(this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  PBTransactionType _type;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  bool _completed;
  DateTime _date;

  void initState() {
    super.initState();
    _type = widget.transaction.type;
    _amountController.text = amountTextFieldFormatter.format(widget.transaction.amount);
    _noteController.text = widget.transaction.note;
    _completed = widget.transaction.completed;
    _date = DateTime.fromMillisecondsSinceEpoch(widget.transaction.timestamp.toInt() * 100);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction")
      ),
      body: _buildTransactionDetail()
    );
  }

  Widget _buildTransactionDetail() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.account_balance_wallet),
                  labelText: "Type"
                ),
                isEmpty: widget.transaction.type == null,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: widget.transaction.type,
                    isDense: true,
                    onChanged: (PBTransactionType newValue) {
                      setState(() {
                        widget.transaction.type = newValue;
                      });
                    },
                    items: PBTransactionType.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(() {
                          switch (value) {
                            case PBTransactionType.CREDIT:
                              return "Credit";
                            case PBTransactionType.DEBT:
                              return "Debt";
                            case PBTransactionType.SETTLE_CREDIT:
                              return "Settle credit";
                            case PBTransactionType.SETTLE_DEBT:
                              return "Settle debt";
                            default:
                              return "";
                          }
                        }())
                      );
                    }).toList(),
                  )
                )
              );
            },
          ),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.attach_money),
              labelText: "Amount",
              hintText: "Enter the amount"
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              /*TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  double value = double.tryParse(newValue.text);
                  if (value == null)
                    return oldValue;
                  var newFormatted = TextEditingValue(text: amountTextFieldFormatter.format(value));
                  print(newFormatted);
                  return newFormatted;
                }
              )*/
              WhitelistingTextInputFormatter.digitsOnly
            ],
            onChanged: (String text) {
              print("text = $text");
              var value = double.tryParse(text);
              if (value != null) {
                value /= 100;
                _amountController.text = amountTextFieldFormatter.format(value);
              }
            },
          ),
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.label),
              labelText: "Note",
              hintText: "Enter the note"
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.check_circle_outline),
                  labelText: "Completed"
                ),
                //isEmpty: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: widget.transaction.completed,
                    isDense: true,
                    onChanged: (bool value) {
                      setState(() {
                        widget.transaction.completed = value;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: true,
                        child: const Text("Yes")
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: const Text("No")
                      )
                    ],
                    /*items: PBTransactionType.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text("$value")
                      );
                    }).toList(),*/
                  )
                )
              );
            },
          ),
          /*TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.check_circle_outline),
              labelText: "Completed",
            ),
          ),*/
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: "Date",
            ),
          ),
        ],
      ),
    );
  }

  double getAmount(String text) {
    var value = double.tryParse(text);
    if (value != null) value /= 100;
    return value;
  }

  void _save() {
    var t = widget.transaction;
    t.type = _type;
    // TODO: finish 
  }

}