import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/reducers.dart';
import 'package:flutter_test/flutter_test.dart';


Person _getTestPerson(AppState state) {
  return state.people
    .firstWhere((p) => p.name == 'Arthur Ford');
}


String _getTestPersonName() {
  return 'John Appleseed';
}


void main() {
  group('Reducers |', () {

    test('init', () {
      final AppState initialState = AppState.initial();
      expect(initialState.people.length, 5);
      expect(initialState.transactions.length, 9);
    });

    test('add person', () {
      final AppState initialState = AppState.initial();
      final Person person = Person.initial(_getTestPersonName());
      final action = AddPersonAction(person);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length + 1);
      expect(state.transactions.length, initialState.transactions.length);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
      for (Transaction t in initialState.transactions)
        expect(state.transactions.contains(t), true);
    });

    test('remove person', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final action = RemovePersonAction(person);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length - 1);
      for (Person p in state.people)
        expect(initialState.people.contains(p), true);
      for (Transaction t in state.transactions)
        expect(t.personID != person.id, true);
    });

    test('edit person', () {
      final AppState initialState = AppState.initial();
      final Person oldPerson = _getTestPerson(initialState);
      final Person newPerson = oldPerson.copyWith(name: _getTestPersonName());
      final action = EditPersonAction(oldPerson, newPerson);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      expect(state.transactions.length, initialState.transactions.length);
      for (Person p in initialState.people)
        expect(state.people.contains(p), p == oldPerson ? false : true);
      for (Transaction t in initialState.transactions)
        expect(state.transactions.contains(t), true);
    });

    test('add transaction', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final Transaction transaction = Transaction.initial()
        .copyWith(personID: person.id);
      final action = AddTransactionAction(transaction);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      expect(state.transactions.length, initialState.transactions.length + 1);
      for (Transaction t in initialState.transactions)
        expect(state.transactions.contains(t), true);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
    });

    test('remove transaction', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final Transaction transaction = initialState.transactions
        .firstWhere((t) => t.personID == person.id);
      final action = RemoveTransactionAction(transaction);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      expect(state.transactions.length, initialState.transactions.length - 1);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
      for (Transaction t in state.transactions)
        expect(initialState.transactions.contains(t), true);
    });

    test('edit transaction', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final Transaction oldTransaction = initialState.transactions
        .firstWhere((t) => t.personID == person.id);
      final Transaction newTransaction = oldTransaction
        .copyWith(amount: oldTransaction.amount + 42);
      final action = EditTransactionAction(oldTransaction, newTransaction);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      expect(state.transactions.length, initialState.transactions.length);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
      for (Transaction t in initialState.transactions)
        expect(state.transactions.contains(t), t == oldTransaction ? false : true);
    });

    test('all transactions completed', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final action = AllTransactionsCompletedAction(person);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      expect(state.transactions.length, initialState.transactions.length);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
      for (Transaction t in state.transactions)
        if (t.personID == person.id)
          expect(t.completed, true);
        else
          expect(initialState.transactions.contains(t), true);
    });

    test('transaction completed', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final Transaction transaction = initialState.transactions
        .firstWhere((t) => t.personID == person.id);
      final action = TransactionCompletedAction(transaction);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      expect(state.transactions.length, initialState.transactions.length);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
      for (Transaction t in initialState.transactions)
        expect(state.transactions.contains(t), true);
    });

    test('remove completed transactions', () {
      final AppState initialState = AppState.initial();
      final Person person = _getTestPerson(initialState);
      final action = RemoveCompletedTransactionsAction(person);
      final AppState state = appReducer(initialState, action);
      expect(state.people.length, initialState.people.length);
      for (Person p in initialState.people)
        expect(state.people.contains(p), true);
      for (Transaction t in state.transactions)
        if (t.personID == person.id)
          expect(t.completed, false);
        else
          expect(initialState.transactions.contains(t), true);
    });
  });
}