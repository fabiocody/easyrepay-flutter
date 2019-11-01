import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:redux/redux.dart';


class LoadDataAction {
  final Store<AppState> store;
  LoadDataAction(this.store);
}


class LoadingFinishedAction {
  final AppState state;
  LoadingFinishedAction(this.state);
}


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
  AddTransactionAction(this.transaction);
}


class RemoveTransactionAction {
  final Transaction transaction;
  RemoveTransactionAction(this.transaction);
}


class EditTransactionAction {
  final Transaction oldTransaction;
  final Transaction newTransaction;
  EditTransactionAction(this.oldTransaction, this.newTransaction);
}


class AllTransactionsCompletedAction {
  final Person person;
  AllTransactionsCompletedAction(this.person);
}


class TransactionCompletedAction {
  final Transaction transaction;
  TransactionCompletedAction(this.transaction);
}


class RemoveCompletedTransactionsAction {
  final Person person;
  RemoveCompletedTransactionsAction(this.person);
}


class ToggleShowCompletedAction {}


class UndoAction {}