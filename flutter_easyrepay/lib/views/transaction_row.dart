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
  final Animation<double> animation;

  TransactionRow(this.store, this.person, this.transaction, this.animation);

  Widget build(BuildContext context) =>
    SlideTransition(
      position: animation.drive(Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset.zero,
      )),
      child: ListTile(
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
      ),
    );

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
      final List<Transaction> transactions = store.state.getTransactionsOf(person);
      final int index = transactions.indexOf(transaction);
      store.dispatch(TransactionCompletedAction(transaction));
      transactionsListKey.currentState.removeItem(index, (context, animation) => TransactionRow(store, person, transaction, animation));
    } else if (action == BottomSheetItems.getShared(context).notCompleted) {
      List<Transaction> transactions = store.state.getCompletedTransactionsOf(person);
      int index = transactions.indexOf(transaction);
      store.dispatch(TransactionNotCompletedAction(transaction));
      completedTransactionsListKey.currentState.removeItem(index, (context, animation) => TransactionRow(store, person, transaction, animation));
      transactions = store.state.getTransactionsOf(person);
      index = transactions.indexOf(transaction);
      transactionsListKey.currentState.insertItem(index);
    } else if (action == BottomSheetItems.getShared(context).delete) {
      final List<Transaction> transactions = transaction.completed ? store.state.getCompletedTransactionsOf(person) : store.state.getTransactionsOf(person);
      final int index = transactions.indexOf(transaction);
      store.dispatch(RemoveTransactionAction(transaction));
      GlobalKey<AnimatedListState> listKey = transaction.completed ? completedTransactionsListKey : transactionsListKey;
      listKey.currentState.removeItem(index, (context, animation) => TransactionRow(store, person, transaction, animation));
    }
    Navigator.of(context).pop();
  }
}