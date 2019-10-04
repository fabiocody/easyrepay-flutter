import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/model_factory.dart';
import 'package:easyrepay/people_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


void main() => runApp(MaterialApp(
  title: "EasyRepay",
  home: PeopleList(ModelFactory.getStore()),
  theme: ThemeData(
    primarySwatch: Colors.green,
  )
));


var deleteBackground = Container(
  padding: const EdgeInsets.only(right: 8),
  color: Colors.red,
  child: Column(
    children: <Widget>[
      Text("Delete", 
        style: TextStyle(
          fontSize: 16, 
          color: Colors.white
        ),
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
  ),
);