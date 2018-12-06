import 'package:ical4d/ical4d.dart';
import 'package:ical4d/src/model/Parameter.dart';
import 'package:ical4d/src/model/Property.dart';
import 'package:test/test.dart';
import 'package:time_machine/time_machine.dart';

void main() {
  group('A group of tests', () {
    DtStart dtStart;

    setUp(() {
    });

    test('First Test', () async {
      Utils utils = new Utils();
      await TimeMachine.initialize();
      await utils.initialize();
      Parameter tzid = new Parameter("TZID", "Asia/Seoul");
      Property prop = new Property("DTSTART", "20150101T000000", [tzid]);

      DtStart dts = new DtStart(prop);

      print(dts);


      DateTime dt = DateTime.now();
      print(dt.timeZoneName);
      print(dt);

    });
  });
}
