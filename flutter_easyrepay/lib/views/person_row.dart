import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/views/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:vibrate/vibrate.dart';

class PersonRow extends StatelessWidget {
  final Store<AppState> store;
  final Person person;

  PersonRow(this.store, this.person);

  Widget build(BuildContext context) {
    var nameSplit = person.name.split(' ');
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        leading: CircleAvatar(
          child: Text(nameSplit.sublist(0, nameSplit.length > 3 ? 3 : nameSplit.length).map((s) => s[0]).join(''))
        ),
        title: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(person.name),
                Text(
                  '${person.transactionsCount} ' + (person.transactions.length == 1
                    ? AppLocalizations.of(context).translate('transaction')
                    : AppLocalizations.of(context).translate('transactions')),
                  style: Theme.of(context).textTheme.caption
                )
              ],
            ),
            Spacer(),
            person.getTotalAmountTextTile(context)
          ],
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: Theme.of(context).textTheme.caption.color
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TransactionsList(store, person)
            )
          );
        },
        onLongPress: () => _showMenu(context)
      ),
    );
  }

  void _showMenu(BuildContext context) async {
    vibrate(FeedbackType.heavy);
    final menuItems = [
      ListTile(
        title: Text(BottomSheetItems.getShared(context).rename),
        leading: Icon(Icons.edit),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).rename, context),
      ),
      ListTile(
        title: Text(BottomSheetItems.getShared(context).allCompleted),
        leading: Icon(Icons.check_circle),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).allCompleted, context),
      ),
      ListTile(
        title: Text(BottomSheetItems.getShared(context).removeAllCompleted),
        leading: Icon(Icons.clear_all),
        onTap: () => _menuAction(BottomSheetItems.getShared(context).removeAllCompleted, context),

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
    if (action == BottomSheetItems.getShared(context).rename) {
      await _editPersonDialog(context);
    } else if (action == BottomSheetItems.getShared(context).allCompleted) {
      store.dispatch(AllTransactionsCompletedAction(person));
      //person.transactions.forEach((t) => t.completed = true);
    } else if (action == BottomSheetItems.getShared(context).removeAllCompleted) {
      person.transactions.removeWhere((t) => t.completed);
    } else if (action == BottomSheetItems.getShared(context).delete) {
      store.dispatch(RemovePersonAction(person));
      //DataStore.shared().people.remove(person);
    }
    Navigator.of(context).pop();
  }

  _editPersonDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController(text: person.name);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('Edit name')),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: AppLocalizations.of(context).translate('Enter name')),
            autofocus: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            keyboardAppearance: Theme.of(context).brightness,
            onEditingComplete: () => _saveEditedPerson(controller, context),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                controller.clear();
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('SAVE'), 
                style: TextStyle(fontWeight: FontWeight.bold)
              ),
              onPressed: () => _saveEditedPerson(controller, context),
            ),
          ],
        );
      }
    );
  }

  void _saveEditedPerson(TextEditingController controller, BuildContext context) {
    store.dispatch(EditPersonAction(person, person.copyWith(name: controller.text)));
    controller.clear();
    Navigator.of(context).pop();
  }
}