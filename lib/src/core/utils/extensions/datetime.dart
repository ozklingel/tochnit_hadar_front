import 'package:hadar_program/src/core/constants/consts.dart';
import 'package:intl/intl.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:timeago/timeago.dart';

extension ReportFromMillisecondsSinceEpochX on int {
  DateTime get asDateTime => DateTime.fromMillisecondsSinceEpoch(this);
}

extension ReportDateTimeX on DateTime? {
  String get asDayMonthYearShortDot => DateFormat('dd.MM.yy').format(this!);
  String get asDayMonthYearShortSlash => DateFormat('dd/MM/yy').format(this!);
  String get asDayMonth => DateFormat('dd.MM').format(this!);
  String get asTimeAgo {
    return format(
      this!,
      locale: Consts.defaultLocale.languageCode,
      allowFromNow: true,
    );
  }

  String get he {
    final hdf = HebrewDateFormatter();
    hdf.hebrewFormat = true;
    final jewishDateTime = JewishDate.fromDateTime(this!);
    return hdf.format(jewishDateTime);
  }
}
