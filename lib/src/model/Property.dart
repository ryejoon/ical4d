import 'package:ical4d/src/model/Parameter.dart';
import 'package:time_machine/time_machine.dart';

class Property {
  String _name;
  String _value;

  List<Parameter> _parameters = new List();

  String get name => _name;

  String get value => _value;

  List<Parameter> get parameters => _parameters;

}

/**
 * DTSTART, DTEND, MODIFIED, EXDATE, RECURRENCE-ID etc..
 */
abstract class DateTimeProperty extends Property {
  LocalDate _localDate;
  ZonedDateTime _zonedDateTime;

  DateTimeProperty(Parameter valueParameter, String value) {

  }
}

class DtStart extends DateTimeProperty {

}

