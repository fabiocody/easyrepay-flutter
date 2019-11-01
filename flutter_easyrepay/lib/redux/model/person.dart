import 'package:uuid/uuid.dart';


class Person {
  final String id;
  final String name;
  final bool reminderActive;
  final DateTime reminderDate;

  Person(this.id, this.name, this.reminderActive, this.reminderDate);

  factory Person.initial(String name) => 
    Person(Uuid().v4(), name, false, null);

  Person copyWith({String name, bool reminderActive, DateTime reminderDate}) =>
    Person(this.id, name ?? this.name, reminderActive ?? this.reminderActive, reminderDate ?? this.reminderDate);

  bool operator ==(o) => o is Person && id == o.id;
  int get hashCode => id.hashCode;
}