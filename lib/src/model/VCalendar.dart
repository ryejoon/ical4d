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
    Component comp;
     switch(lines.first.split(":")[1]) {
       case "VEVENT" :
         comp = VEvent.fromICalendarString(lines);
         break;
       case "VTODO" :
         comp = VTodo.fromICalendarString(lines);
         break;
       case "VTIMEZONE":
         comp = VTimeZone.fromICalendarString(lines);
         break;
       case "VALARM":
         comp = VAlarm.fromICalendarString(lines);
         break;
       default :
         comp = Component.fromICalendarString(lines);
     }
    return comp;
  }

  @override
  String toString() {
    return 'VCalendar{\n${super.toString()}\n, _components: ${_components.join("\n")}';
  }


}