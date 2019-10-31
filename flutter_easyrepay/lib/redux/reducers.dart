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
    List<Person> ppl = List.from(state.people)
      ..add(Person.initial(action.name));
    return state.copyWith(people: ppl);
  }
  return state;
}