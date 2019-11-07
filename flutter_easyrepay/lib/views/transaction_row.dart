import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/views/transaction_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:vibrate/vibrate.dart';

import 'theme.dart';


class TransactionRow extends StatelessWidget {
  final Store<AppState> store;
  final Person person;
  final Transaction transaction;

  TransactionRow(this.store, this.person, this.transaction);

  Widget build(BuildContext context) {
    return ListTile(
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
            builder: (BuildContext context) => TransactionDetail(store, person, transaction)
          )
        );
      },
      onLongPress: () => _showMenu(context),
    );
  }

  void _showMenu(BuildContext context) async {
    vibrate(FeedbackType.heavy);
    final menuItems = [
      if (!transaction.completed) ListTile(
        title: Text(BottomSheetItems.getShared(context).completed),
        leading: Icon(Icons.check_circle),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).completed, context),
      ),
      if (transaction.completed) ListTile(
        title: Text(BottomSheetItems.getShared(context).notCompleted),
        leading: Icon(Icons.panorama_fish_eye),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).notCompleted, context),
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
        physics: NeverScrollableScrollPhysics(),
      )
    );
  }

  void _menuAction(String action, BuildContext context) async {
    if (action == BottomSheetItems.getShared(context).completed) {
      store.dispatch(TransactionCompletedAction(transaction));
    } else if (action == BottomSheetItems.getShared(context).notCompleted) {
      store.dispatch(TransactionNotCompletedAction(transaction));
    } else if (action == BottomSheetItems.getShared(context).delete) {
      store.dispatch(RemoveTransactionAction(transaction));
    }
    Navigator.of(context).pop();
  }
}