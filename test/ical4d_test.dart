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

      DateTimeZone timeZone = new Utils().getTimeZone(tzid.value);
      var zonedDateTime = new ZonedDateTime.atLeniently(LocalDateTime(2015, 1, 1, 0, 0, 0), timeZone);

      Property prop = new Property("DTSTART", zonedDateTime.toString("yyyyMMdd'T'HHmmss"), [tzid]);
      expect(prop.toICalendarString(), equals("DTSTART;TZID=Asia/Seoul:20150101T000000"));

      DtStart dtStart = DtStart(prop);
      expect(dtStart.localDate, isNull);
      expect(dtStart.zonedDateTime, equals(zonedDateTime));
      expect(prop.toICalendarString(), equals("DTSTART;TZID=Asia/Seoul:20150101T000000"));
    });

    test('VALUE=DATE Date Property Test', () {
      LocalDate localDate = LocalDate(2015, 1, 1);
      Parameter value = new Parameter("VALUE", "DATE");
      expect(value.toICalendarString(), equals("VALUE=DATE"));

      Property prop = new Property("DTSTART", localDate.toString("yyyyMMdd"), [value]);
      expect(prop.toICalendarString(), equals("DTSTART;VALUE=DATE:20150101"));

      DtStart dtStart = DtStart(prop);
      expect(dtStart.localDate, equals(localDate));
      expect(dtStart.zonedDateTime, isNull);
      expect(dtStart.toICalendarString(), equals("DTSTART;VALUE=DATE:20150101"));
    });
  });
}
