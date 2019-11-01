import 'package:easyrepay/redux/model/app_state.dart';


class TimeTravel {
  List<AppState> _undoStack = [];

  static TimeTravel _shared = TimeTravel();
  static TimeTravel get shared => _shared;

  bool get canUndo => _undoStack.isNotEmpty;

  void record(AppState state) =>
    _undoStack.add(state);

  AppState undo(AppState state) =>
    canUndo ? _undoStack.removeLast() : state;
}