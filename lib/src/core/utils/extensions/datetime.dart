import 'package:intl/intl.dart';

extension ReportFromMillisecondsSinceEpochX on int {
  DateTime get asDateTime => DateTime.fromMillisecondsSinceEpoch(this);
}

extension ReportDateTimeX on DateTime {
  String get ddMMyy => DateFormat('dd.MM.yy').format(this);
}
