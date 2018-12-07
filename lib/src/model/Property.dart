import 'package:ical4d/src/model/Parameter.dart';
import 'package:optional/optional.dart';
import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';

class Property {
  String _name;
  String _value;

  Property(this._name, this._value, this._parameters);

  List<Parameter> _parameters = new List();

  String get name => _name;

  String get value => _value;

  List<Parameter> get parameters => _parameters;

  Optional<String> getFirstParamValue(String parameterName) {
    return Optional.ofNullable(_parameters.where((p) => p.name == parameterName).first).map((p) => p.value);
  }

  toICalendarString() {
    if (parameters.isEmpty) {
      return '$_name:$_value';
    } else {
      String params = _parameters.map((p) => p.toICalendarString()).join(";");
      return '$_name;$params:$_value';
    }
  }

  @override
  String toString() {
    return 'Property{$_name:$_value, _parameters: $_parameters}';
  }
}

/**
 * DTSTART, DTEND, MODIFIED, EXDATE, RECURRENCE-ID etc..
 */
abstract class DateTimeProperty extends Property {
  LocalDate _localDate;
  ZonedDateTime _zonedDateTime;

  DateTimeProperty(Property dateTimeProperty) : super(dateTimeProperty.name, dateTimeProperty.value, dateTimeProperty.parameters) {
    var valueParameterValue = dateTimeProperty.parameters.firstWhere((p) => p.name == "VALUE", orElse: () => Parameter("", "DATE-TIME")).value;
    switch (valueParameterValue) {
      case "DATE" :
        _localDate = LocalDatePattern.createWithCurrentCulture("yyyyMMdd").parse(dateTimeProperty.value).value;
        return;
      case "DATE-TIME":
      default:
        var tzid = dateTimeProperty.getFirstParamValue("TZID").orElse("UTC");
        var tz = new Utils().getTimeZone(tzid);
        _zonedDateTime = ZonedDateTimePattern.createWithCurrentCulture("yyyyMMdd'T'HHmmss")
            .parse(dateTimeProperty.value).value.withZone(tz);
    }
  }

  ZonedDateTime get zonedDateTime => _zonedDateTime;

  LocalDate get localDate => _localDate;


}

class DtStart extends DateTimeProperty {
  DtStart(Property property) : super(property);



}

class Utils {
  static final Utils _singleton = new Utils._internal();
  factory Utils() {
    return _singleton;
  }
  DateTimeZoneProvider dateTimeZoneProvider;

  Utils._internal() {
  }

  Future<Null> initialize() async {
    dateTimeZoneProvider = await DateTimeZoneProviders.tzdb;
    return null;
  }

  DateTimeZone getTimeZone(String tzid) {
    return dateTimeZoneProvider.getDateTimeZoneSync(tzid);
  }



}