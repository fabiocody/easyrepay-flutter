import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

final GlobalKey<AnimatedListState> peopleListKey = GlobalKey<AnimatedListState>();
final GlobalKey<AnimatedListState> transactionsListKey = GlobalKey<AnimatedListState>();
final GlobalKey<AnimatedListState> completedTransactionsListKey = GlobalKey<AnimatedListState>();

void vibrate(FeedbackType type) async {
  if (await Vibrate.canVibrate) Vibrate.feedback(type);
}
