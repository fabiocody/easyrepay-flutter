import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model_factory.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/views/transactions_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class PeopleList extends StatefulWidget {
  final PBDataStore store = ModelFactory.getStore();
  State createState() => _PeopleListState();
}


class _PeopleListState extends State<PeopleList> {

  TextEditingController _textFieldController = TextEditingController();

  void initState() {
    super.initState();
    if (kReleaseMode) {
      // RELEASE
    } else {
      // DEBUG
      ModelFactory.getDebugData(widget.store);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EasyRepay"),
      ),
      drawer: _buildDrawer(),
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
      final Iterable<Widget> tiles = widget.store.people.map(
        (PBPerson person) => _buildPersonRow(person)
      );
      final List<Widget> rows = ListTile.divideTiles(
        context: context,
        tiles: tiles
      ).toList();
      return ListView(children: rows);
    } else {
      return Center(child: Row(
        children: <Widget>[
          Text("Tap on ", textScaleFactor: 1.1),
          Icon(Icons.add_circle, color: accentColor),
          Text(" to add a person", textScaleFactor: 1.1)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }
  }

  Widget _buildPersonRow(PBPerson person) {
    return Dismissible(
      key: Key(person.id),
      onDismissed: (direction) {
        setState(() {
          widget.store.people.remove(person);
        });
      },
      background: deleteBackground,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        leading: CircleAvatar(
          child: Text(person.name.split(" ").map((s) => s[0]).join("")),
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
        title: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(person.name),
                Text(
                  "${person.transactions.length} " + (person.transactions.length == 1 ? "transaction" : "transactions"),
                  textScaleFactor: 0.8,
                  style: TextStyle(color: secondaryColor)
                )
              ],
            ),
            Spacer(),
            getTotalAmountText(person, false)
          ],
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: Colors.grey[300]
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TransactionsList(person)
            )
          );
        },
      )
    );
  }

  _newPersonDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New person'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter name"),
            autofocus: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            keyboardAppearance: Brightness.dark,
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
              child: Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _saveNewPerson,
            ),
          ],
        );
      }
    );
  }

  void _saveNewPerson() {
    setState(() {
      widget.store.people.add(ModelFactory.newPerson(name: _textFieldController.text));
      ModelFactory.sortPeople();
    });
    _textFieldController.clear();
    Navigator.of(context).pop();
  }

  Widget _buildDrawer() =>
    Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            height: 100,
            child: DrawerHeader(
              child: Text("EasyRepay", 
                textScaleFactor: 3,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.brightness_4,
              //color: secondaryColor,
            ),
            title: Text("Toggle dark mode (${widget.store.settings.dark})", textScaleFactor: 1.1,),
            onTap: () {
              setState(() {
                widget.store.settings.dark = !widget.store.settings.dark;
              });
              print(widget.store.settings.dark);
            },
          )
        ],
      )
    );

}