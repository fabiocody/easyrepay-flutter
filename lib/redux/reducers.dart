import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:redux/redux.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, AddPersonAction>(_onAddPerson),
  TypedReducer<AppState, RemovePersonAction>(_onRemovePerson),
  TypedReducer<AppState, EditPersonAction>(_onEditPerson),
  TypedReducer<AppState, AddTransactionAction>(_onAddTransaction),
  TypedReducer<AppState, RemoveTransactionAction>(_onRemoveTransaction),
  TypedReducer<AppState, EditTransactionAction>(_onEditTransaction),
  TypedReducer<AppState, AllTransactionsCompletedAction>(_onAllTransactionsCompleted),
  TypedReducer<AppState, TransactionCompletedAction>(_onTransactionCompleted),
  TypedReducer<AppState, TransactionNotCompletedAction>(_onTransactionNotCompleted),
  TypedReducer<AppState, RemoveCompletedTransactionsAction>(_onRemoveCompletedTransactions),
  TypedReducer<AppState, UndoAction>(_onUndo),
]);

AppState _onAddPerson(AppState state, AddPersonAction action) {
  final List<Person> ppl = List.from(state.people)
    ..add(action.person)
    ..sort((p1, p2) => p1.name.compareTo(p2.name));
  return state.copyWith(people: ppl);
}

AppState _onRemovePerson(AppState state, RemovePersonAction action) {
  final List<Person> ppl = List.from(state.people)..remove(action.person);
  final List<Transaction> tt = List.from(state.transactions)..removeWhere((t) => t.personID == action.person.id);
  return state.copyWith(people: ppl, transactions: tt);
}

AppState _onEditPerson(AppState state, EditPersonAction action) {
  final List<Person> ppl = List.from(state.people)
    ..remove(action.oldPerson)
    ..add(action.newPerson)
    ..sort((p1, p2) => p1.name.compareTo(p2.name));
  return state.copyWith(people: ppl);
}

AppState _onAddTransaction(AppState state, AddTransactionAction action) {
  final List<Transaction> tt = List.from(state.transactions)
    ..add(action.transaction)
    ..sort((t1, t2) => t1.date.compareTo(t2.date));
  return state.copyWith(transactions: tt);
}

AppState _onRemoveTransaction(AppState state, RemoveTransactionAction action) {
  final List<Transaction> tt = List.from(state.transactions)..remove(action.transaction);
  return state.copyWith(transactions: tt);
}

AppState _onEditTransaction(AppState state, EditTransactionAction action) {
  final List<Transaction> tt = List.from(state.transactions)
    ..remove(action.oldTransaction)
    ..add(action.newTransaction)
    ..sort((t1, t2) => t1.date.compareTo(t2.date));
  return state.copyWith(transactions: tt);
}

AppState _onAllTransactionsCompleted(AppState state, AllTransactionsCompletedAction action) {
  final List<Transaction> tt =
      state.transactions.map((t) => t.personID == action.person.id ? t.copyWith(completed: true) : t).toList();
  return state.copyWith(transactions: tt);
}

AppState _onTransactionCompleted(AppState state, TransactionCompletedAction action) {
  final List<Transaction> tt = List.from(state.transactions)
    ..remove(action.transaction)
    ..add(action.transaction.copyWith(completed: true));
  return state.copyWith(transactions: tt);
}

AppState _onTransactionNotCompleted(AppState state, TransactionNotCompletedAction action) {
  final List<Transaction> tt = List.from(state.transactions)
    ..remove(action.transaction)
    ..add(action.transaction.copyWith(completed: false));
  return state.copyWith(transactions: tt);
}

AppState _onRemoveCompletedTransactions(AppState state, RemoveCompletedTransactionsAction action) {
  final List<Transaction> tt = List.from(state.transactions)
    ..removeWhere((t) => t.personID == action.person.id && t.completed);
  return state.copyWith(transactions: tt);
}

AppState _onUndo(AppState state, UndoAction action) {
  return state.canUndo ? state.prevState : state;
}
