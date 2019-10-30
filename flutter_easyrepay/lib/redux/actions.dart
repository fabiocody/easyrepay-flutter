import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';


class FetchDataAction {}


class AddPersonAction {
  final String name;
  AddPersonAction(this.name);
}


class RemovePersonAction {
  final Person person;
  RemovePersonAction(this.person);
}


class EditPersonAction {
  final Person oldPerson;
  final Person newPerson;
  EditPersonAction(this.oldPerson, this.newPerson);
}


class AddTransactionAction {
  final Transaction transaction;
  final Person person;
  AddTransactionAction(this.transaction, this.person);
}


class RemoveTransactionAction {
  final Transaction transactions;
  final Person person;
  RemoveTransactionAction(this.transactions, this.person);
}


class EditTransactionAction {
  final Transaction oldTransaction;
  final Transaction newTransaction;
  final Person person;
  EditTransactionAction(this.oldTransaction, this.newTransaction, this.person);
}


class AllTransactionsCompletedAction {
  final Person person;
  AllTransactionsCompletedAction(this.person);
}


class TransactionCompletedAction {
  final Transaction transaction;
  TransactionCompletedAction(this.transaction);
}


class ToggleShowCompletedAction {}