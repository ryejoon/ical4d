import 'package:ical4d/ical4d.dart';
import 'package:ical4d/src/model/Component.dart';
import 'package:ical4d/src/model/Parameter.dart';
import 'package:ical4d/src/model/Property.dart';
import 'package:ical4d/src/model/VCalendar.dart';
import 'package:test/test.dart';
import 'package:time_machine/time_machine.dart';

void main() {
  group('VCalendar Parse Test', () {

    setUp(() async {
      Utils utils = new Utils();
      await TimeMachine.initialize();
      await utils.initialize();
    });

    test('VCalendar String', () {
      String stringValue = r"""
BEGIN:VCALENDAR
PRODID:-//xyz Corp//NONSGML PDA Calendar Version 1.0//EN
VERSION:2.0
BEGIN:VEVENT
DTSTAMP:19960704T120000Z
UID:uid1@example.com
ORGANIZER:mailto:jsmith@example.com
DTSTART:19960918T143000Z
DTEND:19960920T220000Z
STATUS:CONFIRMED
CATEGORIES:CONFERENCE
SUMMARY:Networld+Interop Conference
DESCRIPTION:Networld+Interop Conference
  and Exhibit\nAtlanta World Congress Center\n
 Atlanta\, Georgia
END:VEVENT
END:VCALENDAR""";
      var split = stringValue.split("\n");
      VCalendar vcal = new VCalendar.fromICalendarString(split);

      var ev = vcal.getFirstEvent().value;
      expect(ev.getDtStart().toICalendarString(), equals("DTSTART:19960918T143000Z"));
      expect(ev.getDescription(), equals("Networld+Interop Conference and Exhibit\nAtlanta World Congress Center\nAtlanta, Georgia"), reason : "Line breaks, colon escapes");

    });

    test('VCalendar String With Parameter', () {
      String stringValue = r"""
BEGIN:VCALENDAR
PRODID:-//xyz Corp//NONSGML PDA Calendar Version 1.0//EN
VERSION:2.0
BEGIN:VEVENT
DTSTAMP:19960704T120000Z
UID:uid1@example.com
ORGANIZER:mailto:jsmith@example.com
DTSTART;TZID=Asia/Seoul:19960918T143000
DTEND;TZID=Asia/Seoul:19960920T220000
SUMMARY:Networld+Interop Conference
END:VEVENT
END:VCALENDAR""";
      var split = stringValue.split("\n");
      VCalendar vcal = new VCalendar.fromICalendarString(split);

      var firstEvent = vcal.getFirstEvent();
      expect(firstEvent.map((ev) => ev.getDtStart()).value.toICalendarString(), equals("DTSTART;TZID=Asia/Seoul:19960918T143000"));

    });
  });
}
