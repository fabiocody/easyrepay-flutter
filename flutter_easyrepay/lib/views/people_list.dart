import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model.dart';
import 'package:easyrepay/views/person_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';


class PeopleList extends StatelessWidget {

  final Store<AppState> store;
  final TextEditingController _textFieldController = TextEditingController();

  PeopleList(this.store);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EasyRepay',
          textScaleFactor: 1.2,
        ),
      ),
      body: _buildPeopleList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newPersonDialog(context),
        tooltip: AppLocalizations.of(context).translate('Add person'),
        child: Icon(Icons.add),
      )
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    if (store.state.people.isNotEmpty) {
      return StoreConnector<AppState, List<Person>>(
        converter: (store) => store.state.people,
        builder: (context, people) => ListView(
          padding: const EdgeInsets.only(top: 4),
          children: people.map(
            (person) => PersonRow(person)
          ).toList()
        ),
      );
    } else {
      return Center(child: Row(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Tap on '),
            style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).textTheme.caption.color),
          ),
          Icon(
            Icons.add_circle,
            color: Theme.of(context).accentColor,
            size: Theme.of(context).textTheme.title.fontSize,
          ),
          Text(
            AppLocalizations.of(context).translate(' to add a person'),
            style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).textTheme.caption.color)
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }
  }

  void _newPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('New person')),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: AppLocalizations.of(context).translate('Enter name')),
            autofocus: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            keyboardAppearance: Theme.of(context).brightness,
            onEditingComplete: () => _saveNewPerson(context),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
              onPressed: () {
                _textFieldController.clear();
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('SAVE'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: DarkColors.lightGreen,
                )
              ),
              onPressed: () => _saveNewPerson(context),
            ),
          ],
        );
      }
    );
  }

  void _saveNewPerson(BuildContext context) {
    store.dispatch(SaveNewPersonAction(_textFieldController.text));
    _textFieldController.clear();
    Navigator.of(context).pop();
  }

}