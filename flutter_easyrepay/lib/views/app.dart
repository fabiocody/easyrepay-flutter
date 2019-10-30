import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model.dart';
import 'package:easyrepay/views/people_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class App extends StatelessWidget {
  final Store<AppState> store;

  App(this.store);

  Widget build(BuildContext context) =>
    StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'EasyRepay',
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(FetchItemsAction()),
          builder: (context, store) => PeopleList(store),
        ),
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('it', 'IT'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales)
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode)
              return supportedLocale;
          return supportedLocales.first;
        },
      ),
    );
}


var primarySwatch = Colors.green;

var lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: primarySwatch,
);

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColorDark: DarkColors.lightGreen,
  accentColor: DarkColors.lightGreen,
  toggleableActiveColor: DarkColors.lightGreen,
  canvasColor: DarkColors.darkGrey,
  cardColor: DarkColors.surfaceOverlay,
  dialogBackgroundColor: DarkColors.surfaceOverlay,
);