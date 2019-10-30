import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:flutter/foundation.dart';


AppState appReducers(AppState state, dynamic action) {
  if (action is FetchDataAction) {
    if (kReleaseMode)
      return AppState.debug();
    return state;   // TODO Remove
  } else if (action is AddPersonAction) {
    List<Person> ppl = List.from(state.people);
    return state.copyWith(people: ppl..add(Person.initial(action.name)));
  } else if (action is RemovePersonAction) {
    List<Person> ppl = List.from(state.people);
    return state.copyWith(people: ppl..remove(action.person));
  } else if (action is EditPersonAction) {
    List<Person> ppl = List.from(state.people);
    return state.copyWith(people: ppl..remove(action.oldPerson)..add(action.newPerson));
  } else if (action is AddTransactionAction) {
    var tt = List.from(action.person.transactions)
      ..add(action.transaction);
    var p = action.person.copyWith(transactions: tt);
    var ppl = List.from(state.people)
      ..remove(action.person)
      ..add(p);
    return state.copyWith(people: ppl);
  }
  // TODO
  return state;
}