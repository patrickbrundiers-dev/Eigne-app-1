import 'package:intl/intl.dart';

final _n0 = NumberFormat.decimalPattern('de_DE')..maximumFractionDigits = 0;
final _n1 = NumberFormat.decimalPattern('de_DE')
  ..minimumFractionDigits = 1
  ..maximumFractionDigits = 1;
final _n1opt = NumberFormat.decimalPattern('de_DE')..maximumFractionDigits = 1;

String n0(num v) => _n0.format(v.round());
String n1(num v) => _n1.format(v);
String n1opt(num v) => _n1opt.format(v);

String kcal(num v) => '${n0(v)} kcal';
String grams(num v) => '${v.abs() < 10 && v != v.roundToDouble() ? n1opt(v) : n0(v)} g';
String kg(num v) => '${n1(v)} kg';

String amountWithUnit(double amount, String unit) => '${n1opt(amount)} $unit';

final _dateLong = DateFormat('EEEE, d. MMMM', 'de_DE');
final _dateShort = DateFormat('d. MMM yyyy', 'de_DE');
final _dateTiny = DateFormat('d.M.', 'de_DE');
final _weekday = DateFormat('EEE d.M.', 'de_DE');

String dateLong(DateTime d) => _dateLong.format(d);
String dateShort(DateTime d) => _dateShort.format(d);
String dateTiny(DateTime d) => _dateTiny.format(d);
String weekdayShort(DateTime d) => _weekday.format(d);

String timeOfDay(int? minuteOfDay) {
  if (minuteOfDay == null) return '';
  final h = (minuteOfDay ~/ 60).toString().padLeft(2, '0');
  final m = (minuteOfDay % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

/// Parses German or English decimal input ("72,5" or "72.5"). Returns null if empty/invalid.
double? parseNum(String? s) {
  if (s == null) return null;
  final t = s.trim().replaceAll(' ', '').replaceAll(',', '.');
  if (t.isEmpty) return null;
  return double.tryParse(t);
}

String numField(num? v) => v == null ? '' : n1opt(v).replaceAll('.', '');
