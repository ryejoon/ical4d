import 'package:ical4d/src/model/Parameter.dart';
import 'package:optional/optional.dart';
import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_text_patterns.dart';


//typedef Predicate<E> = bool Function(E element);

class Property {
  String _name;
  String _value;

  Property(this._name, this._value, [this._parameters]);

  List<Parameter> _parameters = new List();

  String get name => _name;

  String get value => _value;

  List<Parameter> get parameters => _parameters;

  void appendValue(String newLine) {
    _value = _value + newLine;
  }

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

  static Property fromICalendarString(String icalendarLine) {
    int firstColonIndex = icalendarLine.indexOf(":");
    if (firstColonIndex == -1) {
      throw new Exception(icalendarLine);
    }
    String propertyValue = icalendarLine.substring(firstColonIndex + 1);
    List<String> paramTokens = icalendarLine.substring(0, firstColonIndex).split(";");
    String propertyName = paramTokens[0];

    List<Parameter> parameters = paramTokens.sublist(1).map((ps) => Parameter.fromICalendarString(ps)).toList();

    switch(propertyName) {
      case "DTSTART" :
        return new DtStart(propertyName, propertyValue, parameters);
      case "DTEND" :
        return new DtEnd(propertyName, propertyValue, parameters);
      case "EXDATE" :
        return new ExDate(propertyName, propertyValue, parameters);
      case "RECURRENCE-ID" :
        return new RecurrenceId(propertyName, propertyValue, parameters);
      default :
        return new Property(propertyName, propertyValue, parameters);
    }

  }


  @override
  String toString() {
    return 'Property{_name: $_name, _value: $_value, _parameters: $_parameters}';
  }

  void addParameter(Parameter param) {
    parameters.add(param);
  }

  void removeParameterWhere(bool cond(Parameter element)) {
    parameters.removeWhere(cond);
  }
}

/**
 * DTSTART, DTEND, MODIFIED, EXDATE, RECURRENCE-ID etc..
 */
abstract class DateTimeProperty extends Property {
  LocalDate _localDate;
  ZonedDateTime _zonedDateTime;

  DateTimeProperty.withProp(Property property) : this(property.name, property.value, property.parameters);

  DateTimeProperty(String name, String value, List<Parameter> parameters) : super(name, value, parameters) {
    var valueParameterValue = parameters.firstWhere((p) => p.name == "VALUE", orElse: () => Parameter("", "DATE-TIME")).value;
    switch (valueParameterValue) {
      case "DATE" :
        _localDate = LocalDatePattern.createWithCurrentCulture("yyyyMMdd").parse(value).value;
        return;
      case "DATE-TIME":
      default:
      var tzidParam = parameters.firstWhere((p) => p.name == "TZID", orElse: () => null);
      var tzidValue = tzidParam == null ? "UTC" : tzidParam.value;
      var tz = new Utils().getTimeZone(tzidValue);
      String pattern = "yyyyMMdd'T'HHmmss";
      if (value.endsWith("Z")) {
        pattern = pattern + "'Z'";
      }
      _zonedDateTime = LocalDateTimePattern.createWithInvariantCulture(pattern).parse(value).value.inZoneLeniently(tz);
    }
  }

  ZonedDateTime get zonedDateTime => _zonedDateTime;

  LocalDate get localDate => _localDate;

  bool isLocal() {
    return localDate != null;
  }
}

class DtStart extends DateTimeProperty {
  DtStart(String name, String value, List<Parameter> parameters) : super(name, value, parameters);
}

class DtEnd extends DateTimeProperty {
  DtEnd(String name, String value, List<Parameter> parameters) : super(name, value, parameters);
}

class ExDate extends DateTimeProperty {
  ExDate(String name, String value, List<Parameter> parameters) : super(name, value, parameters);
}

class RecurrenceId extends DateTimeProperty {
  RecurrenceId(String name, String value, List<Parameter> parameters) : super(name, value, parameters);
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