import 'dart:collection';

import 'package:ical4d/src/model/Property.dart';
import 'package:optional/optional.dart';

class Component {
  String name;
  Map<String, List<Property>> properties = HashMap();

  Component(this.name);

  List<Property> getProperties(String name) {
    return properties[name];
  }

  Property getFirstProperty(String name) {
    var mapper = (l) => l.first;
    return Optional.ofNullable(getProperties(name))
        .map(mapper).orElse(null);
  }

  String getFirstPropertyValue(String name) {
    var p = getFirstProperty(name);
    return (p == null) ? null : p.value;
  }

  void addProperty(Property property) {
    properties.update(property.name, (List<Property> l) {
        l.add(property);
        return l;
  }, ifAbsent: () => [property]);
  }

  String toICalendarString() {
    return "BEGIN:${name}\n" +
        contentToICalendarString() +
        "END:${name}";
  }

  String contentToICalendarString() => properties.values.toList().expand((l) => l).map((p) => p.toICalendarString()).join("\n") + "\n";

  Component.fromICalendarString(List<String> lines) {
    Property begin = Property.fromICalendarString(lines.first);
    Property end = Property.fromICalendarString(lines.last);
    if (begin.name != "BEGIN" || end.name != "END" || begin.value != end.value) {
      throw new Exception("$begin, $end");
    }
    name = begin.value;
    int lastBeginPropertyIndex = -1;
    bool subComponentParsingState = false;
    int currentIndex = 0;
    Property lastAddedProperty;
    lines.sublist(1, lines.length - 1).forEach((l) {
      currentIndex++;
      if (l.startsWith(" ") || l.startsWith("\t")) {
        lastAddedProperty.appendValue(l.substring(1));
        return;
      }

      Property p = Property.fromICalendarString(l);
      if (p.name == "BEGIN") {
        subComponentParsingState = true;
        lastBeginPropertyIndex = currentIndex;
      } else if (p.name == "END") {
        subComponentParsingState = false;
        parseSubComponent(lines.sublist(lastBeginPropertyIndex, currentIndex + 1));
      } else if (!subComponentParsingState) {
        addProperty(p);
        lastAddedProperty = p;
      }
    });
  }

  @override
  String toString() {
    return 'Component{name: $name, properties: $properties}';
  }

  void parseSubComponent(List<String> lines) {
    // do nothing
  }
}

class CalendarComponent extends Component {
  List<VAlarm> alarms = List();

  CalendarComponent(String name) : super(name);

  CalendarComponent.fromICalendarString(List<String> lines): super.fromICalendarString(lines);
}

class VEvent extends CalendarComponent {
  VEvent() : super("VEVENT");

  String getSummary() {
    return getFirstPropertyValue("SUMMARY");
  }

  String getUid() {
    return getFirstPropertyValue("UID");
  }

  DtStart getDtStart() {
    return getFirstProperty("DTSTART");
  }


  VEvent.fromICalendarString(List<String> lines): super.fromICalendarString(lines);

}

class VTodo extends CalendarComponent {
  VTodo() : super("VTODO");

  VTodo.fromICalendarString(List<String> lines): super.fromICalendarString(lines);

}

class VAlarm extends Component {
  VAlarm() : super("VALARM");

  VAlarm.fromICalendarString(List<String> lines): super.fromICalendarString(lines);
}

class VTimeZone extends Component {
  VTimeZone() : super("VTIMEZONE");

  VTimeZone.fromICalendarString(List<String> lines): super.fromICalendarString(lines);
}