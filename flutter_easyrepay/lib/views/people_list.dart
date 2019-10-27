import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:easyrepay/views/person_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class PeopleList extends StatefulWidget {
  final DataStore store = DataStore.shared();
  State createState() => _PeopleListState();
}


class _PeopleListState extends State<PeopleList> {

  TextEditingController _textFieldController = TextEditingController();

  void initState() {
    super.initState();
    if (kReleaseMode) {
      widget.store.fillWithLocalData()
        .then((v) => setState(() => null));
    } else {
      widget.store.fillWithDebugData()
        .then((v) => setState(() => null));
    }
  }

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
        tooltip: 'New Person',
        child: Icon(Icons.add),
      )
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    if (widget.store.people.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.only(top: 4),
        children: widget.store.people.map(
          (person) => PersonRow(person, () => setState(() => null))
        ).toList()
      );
    } else {
      return Center(child: Row(
        children: <Widget>[
          Text(
            'Tap on ',
            style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).textTheme.caption.color),
          ),
          Icon(
            Icons.add_circle,
            color: Theme.of(context).accentColor,
            size: Theme.of(context).textTheme.headline.fontSize,
          ),
          Text(
            ' to add a person',
            style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).textTheme.caption.color)
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
          title: Text('New person'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter name'),
            autofocus: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            keyboardAppearance: Theme.of(context).brightness,
            onEditingComplete: _saveNewPerson,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                _textFieldController.clear();
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text(
                'SAVE', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: DarkColors.lightGreen,
                )
              ),
              onPressed: _saveNewPerson,
            ),
          ],
        );
      }
    );
  }

  void _saveNewPerson() {
    setState(() {
      widget.store.people.add(Person(_textFieldController.text));
      widget.store.sortPeople();
    });
    widget.store.save();
    _textFieldController.clear();
    Navigator.of(context).pop();
  }

}