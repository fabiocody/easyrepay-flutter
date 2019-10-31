import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:flutter/foundation.dart';


AppState appReducers(AppState state, dynamic action) {
  if (action is FetchDataAction) {
    if (kReleaseMode)
      return AppState.initial();
    else
      return AppState.debug();
  } else if (action is AddPersonAction) {
    List<Person> ppl = List.from(state.people)
      ..add(Person.initial(action.name))
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    return state.copyWith(people: ppl);
  } else if (action is RemovePersonAction) {
    List<Person> ppl = List.from(state.people)
      ..remove(action.person);
    List<Transaction> tt = List.from(state.transactions)
      ..removeWhere((t) => t.personID == action.person.id);
    return state.copyWith(people: ppl, transactions: tt);
  } else if (action is EditPersonAction) {
    List<Person> ppl = List.from(state.people)
      ..remove(action.oldPerson)
      ..add(action.newPerson)
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    return state.copyWith(people: ppl);
  } else if (action is AddTransactionAction) {
    List<Transaction> tt = List.from(state.transactions)
      ..add(action.transaction)
      ..sort((t1, t2) => t1.date.compareTo(t2.date));
    return state.copyWith(transactions: tt);
  } else if (action is RemoveTransactionAction) {
    List<Transaction> tt = List.from(state.transactions)
      ..remove(action.transaction);
    return state.copyWith(transactions: tt);
  } else if (action is EditTransactionAction) {
    List<Transaction> tt = List.from(state.transactions)
      ..remove(action.oldTransaction)
      ..add(action.newTransaction)
      ..sort((t1, t2) => t1.date.compareTo(t2.date));
    return state.copyWith(transactions: tt);
  } else if (action is AllTransactionsCompletedAction) {
    List<Transaction> tt = List.from(state.transactions);
    List<Transaction> personTransactions = List.from(state.getTransactionsOf(action.person));
    tt.removeWhere((t) => personTransactions.contains(t));
    personTransactions.map((t) => t.copyWith(completed: true)).toList();
    tt.addAll(personTransactions);
    return state.copyWith(transactions: tt);
  } else if (action is TransactionCompletedAction) {
    List<Transaction> tt = List.from(state.transactions)
      ..remove(action.transaction)
      ..add(action.transaction.copyWith(completed: true));
    return state.copyWith(transactions: tt);
  } else if (action is RemoveCompletedTransactionsAction) {
    List<Transaction> tt = List.from(state.transactions);
    tt.removeWhere((t) => t.personID == action.person.id && t.completed);
    return state.copyWith(transactions: tt);
  } else if (action is ToggleShowCompletedAction) {
    return state.copyWith(showCompleted: !state.showCompleted);
  }
  return state;
}