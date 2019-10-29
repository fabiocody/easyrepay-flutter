import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:easyrepay/views/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class PersonRow extends StatelessWidget {
  final Person person;
  final Function updateState;

  PersonRow(this.person, this.updateState);

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
              builder: (BuildContext context) => TransactionsList(person)
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
        title: Text(BottomSheetItems.rename),
        leading: Icon(Icons.edit),
        onTap: () => _menuAction(BottomSheetItems.rename, context),
      ),
      ListTile(
        title: Text(BottomSheetItems.allCompleted),
        leading: Icon(Icons.check_circle),
        onTap: () => _menuAction(BottomSheetItems.allCompleted, context),
      ),
      ListTile(
        title: Text(BottomSheetItems.removeAllCompleted),
        leading: Icon(Icons.clear_all),
        onTap: () => _menuAction(BottomSheetItems.removeAllCompleted, context),

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
    if (action == BottomSheetItems.rename) {
      await _editPersonDialog(context);
    } else if (action == BottomSheetItems.allCompleted) {
      person.transactions.forEach((t) => t.completed = true);
    } else if (action == BottomSheetItems.removeAllCompleted) {
      person.transactions.removeWhere((t) => t.completed);
    } else if (action == BottomSheetItems.delete) {
      DataStore.shared().people.remove(person);
    }
    DataStore.shared().save();
    updateState();
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
    person.name = controller.text;
    DataStore.shared().sortPeople();
    DataStore.shared().save();
    controller.clear();
    Navigator.of(context).pop();
  }
}