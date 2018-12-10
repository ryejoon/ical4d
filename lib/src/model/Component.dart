import 'dart:collection';

import 'package:ical4d/src/model/Property.dart';
import 'package:optional/optional.dart';

class Component {
  String name;
  Map<String, List<Property>> properties = HashMap();

  Component(this.name);

  Optional<List<Property>> getProperties(String name) {
    return Optional.ofNullable(properties[name]);
  }

  Optional<Property> getFirstProperty(String name) {
    return getProperties(name).flatMap((pl) =>
    (pl.isEmpty) ? Optional.empty() : Optional.of(pl.first)
    );
  }

  String getFirstPropertyValue(String name) {
    return getFirstProperty(name).map((p) => p.value).orElse(null);
  }

  void addProperty(Property property) {
    properties.update(property.value, (List<Property> l) {
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
}

class VEvent extends CalendarComponent {
  VEvent() : super("VEVENT");

  String getSummary() {
    return getFirstPropertyValue("SUMMARY");
  }

  String getUid() {
    return getFirstPropertyValue("UID");
  }

  DateTime getDtStart() {

  }

}

class VTodo extends CalendarComponent {
  VTodo() : super("VTODO");

}

class VAlarm extends Component {
  VAlarm() : super("VALARM");

}

class VTimeZone extends Component {
  VTimeZone() : super("VTIMEZONE");

}