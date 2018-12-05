import 'package:ical4d/src/model/Parameter.dart';

class Property {
  String name;
  String value;

  List<Parameter> parameters;

  @override
  String toString() {
    return 'Property{$name:$value, parameters: $parameters}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Property &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              value == other.value &&
              parameters == other.parameters;

  @override
  int get hashCode =>
      name.hashCode ^
      value.hashCode ^
      parameters.hashCode;
}

/**
 * DTSTART, DTEND, MODIFIED, EXDATE, RECURRENCE-ID etc..
 */
class DateTimeProperty extends Property {
  DateTime dt = DateTime.

}

