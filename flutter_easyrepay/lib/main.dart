import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/persistence.dart';
import 'package:easyrepay/redux/reducers.dart';
import 'package:easyrepay/views/app.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


void main() async {
  final initialState = await persistor.load();
  final store = Store<AppState>(
    appReducer,
    middleware: [persistor.createMiddleware()],
    initialState: initialState,
  );
  runApp(App(store));
}