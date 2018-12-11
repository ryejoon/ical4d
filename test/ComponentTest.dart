import 'package:ical4d/ical4d.dart';
import 'package:ical4d/src/model/Component.dart';
import 'package:ical4d/src/model/Parameter.dart';
import 'package:ical4d/src/model/Property.dart';
import 'package:test/test.dart';
import 'package:time_machine/time_machine.dart';

void main() {
  group('ICalendar Component Test', () {

    setUp(() async {
      Utils utils = new Utils();
      await TimeMachine.initialize();
      await utils.initialize();
    });

    test('Component Property Test', () {
      VEvent ev = new VEvent();
      ev.addProperty(new Property("DTSTART", "20110101", [new Value("DATE")]));
      expect(ev.toICalendarString(), equals("BEGIN:VEVENT\nDTSTART;VALUE=DATE:20110101\nEND:VEVENT"));
    });
  });
}
