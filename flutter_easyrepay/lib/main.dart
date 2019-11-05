import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/persistence.dart';
import 'package:easyrepay/redux/reducers.dart';
import 'package:easyrepay/views/app.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';


void main() async {
  final persistor = Persistor<AppState>(
    storage: FlutterStorage(
      key: 'easyrepay_datastore.pb',
      location: FlutterSaveLocation.documentFile
    ),
    serializer: ProtobufSerializer(),
  );
  final initialState = await persistor.load();
  final store = Store<AppState>(
    appReducer,
    middleware: [persistor.createMiddleware()],
    initialState: initialState,
  );
  runApp(App(store));
}