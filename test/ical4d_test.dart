import 'package:ical4d/ical4d.dart';
import 'package:ical4d/src/model/Parameter.dart';
import 'package:ical4d/src/model/Property.dart';
import 'package:test/test.dart';
import 'package:time_machine/time_machine.dart';

void main() {
  group('ICalendar Generation Test', () {

    setUp(() async {
      Utils utils = new Utils();
      await TimeMachine.initialize();
      await utils.initialize();
    });

    test('VALUE=DATE-TIME Date Property Test', () {
      Parameter tzid = new Parameter("TZID", "Asia/Seoul");
      expect(tzid.toICalendarString(), equals("TZID=Asia/Seoul"));

      Property prop = new Property("DTSTART", "20150101T000000", [tzid]);
      expect(prop.toICalendarString(), equals("DTSTART;TZID=Asia/Seoul:20150101T000000"));

      DtStart dtStart = DtStart(prop);
      //expect(dtStart, is)
    });

    test('VALUE=DATE Date Property Test', () {
      Parameter value = new Parameter("VALUE", "DATE");
      expect(value.toICalendarString(), equals("VALUE=DATE"));

      Property prop = new Property("DTSTART", "20150101", [value]);
      expect(prop.toICalendarString(), equals("DTSTART;VALUE=DATE:20150101"));
    });
  });
}
