import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/views/transaction_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class TransactionRow extends StatelessWidget {
  final Person person;
  final Transaction transaction;
  final bool showCompleted;
  final Function updateState;

  TransactionRow(this.person, this.transaction, this.showCompleted, this.updateState);

  Widget build(BuildContext context) {
    return ListTile(
      leading: showCompleted ? _getCompletedIcon(context) : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(transaction.description),
              Text(
                AppLocalizations.dateFormatOf(context, transaction.date),
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

  Widget _getCompletedIcon(BuildContext context) {
    return transaction.completed 
      ? Icon(Icons.check_circle_outline, color: DarkColors.lightGreen)
      : Icon(Icons.panorama_fish_eye, color: Theme.of(context).textTheme.caption.color);
  }

  void _showMenu(BuildContext context) async {
    vibrate(FeedbackType.heavy);
    final menuItems = [
      ListTile(
        title: Text(BottomSheetItems.getShared(context).completed),
        leading: Icon(Icons.check_circle),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).completed, context),
      ),
      ListTile(
        title: Text(BottomSheetItems.getShared(context).delete, style: TextStyle(color: DarkColors.orange)),
        leading: Icon(Icons.delete_forever, color: DarkColors.orange,),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).delete, context),
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
    if (action == BottomSheetItems.getShared(context).completed) {
      transaction.completed = true;
    } else if (action == BottomSheetItems.getShared(context).delete) {
      person.transactions.remove(transaction);
    }
    DataStore.shared().save();
    updateState();
    Navigator.of(context).pop();
  }
}