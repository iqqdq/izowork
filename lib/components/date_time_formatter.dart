import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  String formatDateTimeToString({
    required DateTime dateTime,
    required bool? showTime,
    required bool? showMonthName,
  }) {
    String localeName = Platform.localeName;

    initializeDateFormatting(
      localeName,
      null,
    );

    String dateTimeString = '';

    bool isToday = dateTime.year == DateTime.now().year &&
        dateTime.month == DateTime.now().month &&
        dateTime.day == DateTime.now().day;

    bool isYesterday = dateTime.year ==
            DateTime.now().subtract(const Duration(days: 1)).year &&
        dateTime.month ==
            DateTime.now().subtract(const Duration(days: 1)).month &&
        dateTime.day == DateTime.now().subtract(const Duration(days: 1)).day;

    final day = isYesterday
        ? localeName.contains('en')
            ? 'Yesterday'
            : 'Вчера'
        : isToday
            ? localeName.contains('en')
                ? 'Today'
                : 'Сегодня'
            : dateTime.day.toString().length == 1
                ? '0${dateTime.day}'
                : '${dateTime.day}';

    final month = showMonthName == true
        ? DateFormat.MMM(localeName).format(dateTime).replaceFirst('.', '')
        : dateTime.month.toString().length == 1
            ? '0${dateTime.month}'
            : '${dateTime.month}';

    final year = '${dateTime.year}';

    final hour = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : '${dateTime.hour}';

    final minute = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : '${dateTime.minute}';

    dateTimeString = isYesterday || isToday
        ? showTime == true
            ? '$day, $hour:$minute'
            : day
        : showTime == true
            ? showMonthName == true
                ? '$day $month $year, $hour:$minute'
                : '$day.$month.$year, $hour:$minute'
            : showMonthName == true
                ? '$day $month $year'
                : '$day.$month.$year';

    return dateTimeString;
  }
}
