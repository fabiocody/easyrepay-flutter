import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/views/completed_transactions_list.dart';
import 'package:easyrepay/views/transaction_detail.dart';
import 'package:easyrepay/views/transaction_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:vibrate/vibrate.dart';

class TransactionsList extends StatelessWidget {
  final Store<AppState> store;
  final Person person;

  TransactionsList(this.store, this.person);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 12,
            ),
            IconButton(
              icon: Icon(Icons.undo),
              tooltip: AppLocalizations.of(context).translate('Undo'),
              onPressed: store.state.canUndo ? () => store.dispatch(UndoAction()) : null,
            ),
            Spacer(),
            StoreConnector<AppState, bool>(
              converter: (store) => store.state.getCompletedTransactionsCountOf(person) > 0,
              builder: (context, value) => IconButton(
                icon: Icon(value ? Icons.check_circle : Icons.check_circle_outline),
                tooltip: AppLocalizations.of(context).translate('Show completed'),
                onPressed: value
                    ? () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => CompletedTransactionsList(store, person)))
                    : null,
              ),
            ),
            IconButton(
                icon: Icon(Icons.add_alert),
                tooltip: AppLocalizations.of(context).translate('Reminder'),
                onPressed: () {
                  vibrate(FeedbackType.error);
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context).translate('Work in progress')),
                            content:
                                Text(AppLocalizations.of(context).translate('This feature is not implemented yet.')),
                          ));
                }),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: AppLocalizations.of(context).translate('Add transaction'),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) => TransactionDetail(store, person, Transaction.initial()))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _buildTransactionsList(context),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    final double dividerIndent = 4;
    return StoreConnector<AppState, List<Transaction>>(
        converter: (store) => store.state.getTransactionsOf(person),
        builder: (context, transactions) {
          if (transactions.isNotEmpty) {
            return ListView(
              padding: const EdgeInsets.only(top: 4),
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Card(
                            child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context).translate('Total'),
                              style: Theme.of(context).textTheme.headline6),
                          store.state.getTotalAmountText(person, context)
                        ],
                      ),
                    ))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: Card(
                            child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context).translate('Debt'),
                              style: Theme.of(context).textTheme.headline6),
                          store.state.getDebtAmountText(person, context)
                        ],
                      ),
                    ))),
                    Expanded(
                        child: Card(
                            child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context).translate('Credit'),
                              style: Theme.of(context).textTheme.headline6),
                          store.state.getCreditAmountText(person, context)
                        ],
                      ),
                    ))),
                  ],
                ),
                Divider(
                    indent: dividerIndent, endIndent: dividerIndent, color: Theme.of(context).textTheme.caption.color),
                Card(
                    child: AnimatedList(
                  key: transactionsListKey,
                  physics: NeverScrollableScrollPhysics(),
                  initialItemCount: transactions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index, animation) =>
                      TransactionRow(store, person, transactions[index], animation),
                )),
              ],
            );
          } else {
            return Center(
                child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('Tap on '),
                  style:
                      Theme.of(context).textTheme.headline6.copyWith(color: Theme.of(context).textTheme.caption.color),
                ),
                Icon(
                  Icons.add_circle,
                  color: Theme.of(context).accentColor,
                  size: Theme.of(context).textTheme.headline6.fontSize,
                ),
                Text(AppLocalizations.of(context).translate(' to add a transaction'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).textTheme.caption.color))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ));
          }
        });
  }
}
