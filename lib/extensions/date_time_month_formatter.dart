import 'dart:io';
import 'package:intl/intl.dart';

extension DateTimeMonthFormatter on DateTime {
  String toMonth() => Platform.localeName.contains('ru')
      ? month == 3 || month == 8
          ? '${DateFormat.MMMM(Platform.localeName).format(this)}a'
          : DateFormat.MMMM(Platform.localeName).format(this).replaceAll(
                month == 5 ? 'й' : 'ь',
                month == 3 || month == 8 ? 'а' : 'я',
              )
      : DateFormat.MMMM(Platform.localeName).format(this);
}
