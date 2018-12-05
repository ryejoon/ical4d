import 'package:ical4d/ical4d.dart';
import 'package:ical4d/src/model/Property.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    DtStart dtStart;

    setUp(() {
      dtStart = DtStart();
    });

    test('First Test', () {
      DateTime dt = DateTime.now();
      print(dt.timeZoneName);
      print(dt);
      //expect(awesome.isAwesome, isTrue);
    });
  });
}
