import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/views/transaction_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CompletedTransactionsList extends StatelessWidget {
  final Store<AppState> store;
  final Person person;
  CompletedTransactionsList(this.store, this.person);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Completed transactions')),
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
          ],
        ),
      ),
      body: _buildTransactionsList(context),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    return StoreConnector<AppState, List<Transaction>>(
        converter: (store) => store.state.getCompletedTransactionsOf(person),
        builder: (context, transactions) {
          Future.delayed(Duration(milliseconds: 1)).then((value) {
            if (store.state.getCompletedTransactionsCountOf(person) <= 0) Navigator.of(context).pop();
          });
          return ListView(
            padding: const EdgeInsets.only(top: 4),
            children: [
              Card(
                  child: AnimatedList(
                key: completedTransactionsListKey,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                initialItemCount: transactions.length,
                itemBuilder: (context, index, animation) =>
                    TransactionRow(store, person, transactions[index], animation),
              )),
            ],
          );
        });
  }
}
