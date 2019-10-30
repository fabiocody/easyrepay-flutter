import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/reducers.dart';
import 'package:easyrepay/views/app.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


void main() {
  final store = Store<AppState>(appReducers, initialState: AppState.initial());
  runApp(App(store));
}