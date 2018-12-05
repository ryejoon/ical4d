import 'package:ical4d/src/model/Property.dart';
import 'package:optional/optional.dart';

class Component {
  Map<String, List<Property>> properties;

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

}

class CalendarComponent extends Component {
  List<VAlarm> alarms;
}

class VEvent extends CalendarComponent {
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

}

class VAlarm extends Component {

}

class VTimeZone extends Component {

}