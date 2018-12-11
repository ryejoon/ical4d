import 'package:ical4d/src/model/Component.dart';
import 'package:optional/optional.dart';

class VCalendar extends Component {
  VCalendar() : super("VCALENDAR");

  List<Component> _components = [];

  @override
  String contentToICalendarString() {
    return super.contentToICalendarString() + _components.map((c) => c.toICalendarString()).join("\n") + "\n";
  }

  VCalendar.fromICalendarString(List<String> lines):super.fromICalendarString(lines);
  
  Optional<VEvent> getFirstEvent() {
    return Optional.ofNullable(_components.firstWhere((c) => c is VEvent, orElse: null));
  }

  @override
  void parseSubComponent(List<String> lines) {
    try {
       _components.add(buildComponent(lines));
    } catch (e) {
      throw new Exception(e.toString() + ", component lines : " + lines.toString());
    }
  }

  Component buildComponent(List<String> lines) {
     switch(lines.first.split(":")[1]) {
       case "VEVENT" :
         return VEvent.fromICalendarString(lines);
       case "VTODO" :
         return VTodo.fromICalendarString(lines);
       case "VTIMEZONE":
         return VTimeZone.fromICalendarString(lines);
       case "VALARM":
         return VAlarm.fromICalendarString(lines);
       default :
         return Component.fromICalendarString(lines);
     }
  }

  @override
  String toString() {
    return 'VCalendar{\n${super.toString()}\n, _components: ${_components.join("\n")}';
  }


}