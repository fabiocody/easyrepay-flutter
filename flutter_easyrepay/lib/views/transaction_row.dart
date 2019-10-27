import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:easyrepay/views/transaction_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionRow extends StatelessWidget {
  final Person person;
  final Transaction transaction;
  final Function updateState;

  TransactionRow(this.person, this.transaction, this.updateState);

  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(transaction.note),
              Text(
                dateFormatter.format(transaction.date),
                style: Theme.of(context).textTheme.caption,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          transaction.getAmountText(context),
        ],
      ),
      trailing: Icon(
        Icons.navigate_next,
        color: Theme.of(context).textTheme.caption.color
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TransactionDetail(person, transaction)
          )
        );
      },
      onLongPress: () => _showMenu(context),
    );
  }

  void _showMenu(BuildContext context) async {
    final menuItems = [
      ListTile(
        title: Text(BottomSheetItems.completed),
        leading: Icon(Icons.check_circle),
        onTap: () => _menuAction(BottomSheetItems.completed, context),
      ),
      ListTile(
        title: Text(BottomSheetItems.delete, style: TextStyle(color: DarkColors.orange)),
        leading: Icon(Icons.delete_forever, color: DarkColors.orange,),
        onTap: () => _menuAction(BottomSheetItems.delete, context),
      ),
    ];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: menuItems,
        shrinkWrap: true,
      )
    );
  }

  void _menuAction(String action, BuildContext context) async {
    if (action == BottomSheetItems.completed) {
      transaction.completed = true;
    } else if (action == BottomSheetItems.delete) {
      DataStore.shared().people.remove(person);
    }
    DataStore.shared().save();
    updateState();
    Navigator.of(context).pop();
  }
}