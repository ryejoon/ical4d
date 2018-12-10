import 'package:ical4d/src/model/Component.dart';

class VCalendar extends Component {
  VCalendar() : super("VCALENDAR");

  List<Component> _components = [];

  @override
  String contentToICalendarString() {
    return super.contentToICalendarString() + _components.map((c) => c.toICalendarString()).join("\n") + "\n";
  }

  VCalendar.fromICalendarString(List<String> lines):super.fromICalendarString(lines);

  @override
  void parseSubComponent(List<String> lines) {
    try {
      _components.add(Component.fromICalendarString(lines));
    } catch (e) {
      throw new Exception(e.toString() + ", component lines : " + lines.toString());
    }
  }

  @override
  String toString() {
    return 'VCalendar{\n${super.toString()}\n, _components: ${_components.join("\n")}';
  }


}