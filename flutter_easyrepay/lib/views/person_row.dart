import 'package:easyrepay/model.dart';
import 'package:easyrepay/views/transactions_list.dart';
import 'package:flutter/material.dart';

class PersonRow extends StatelessWidget {
  final Person person;

  PersonRow(this.person);

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
                  '${person.transactions.length} ' + (person.transactions.length == 1 ? 'transaction' : 'transactions'),
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
      ),
    );
  }
}