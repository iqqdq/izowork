bool isSameDate(
  DateTime dateTime,
  DateTime calendarDateTime,
) =>
    dateTime.year == calendarDateTime.year &&
    dateTime.month == calendarDateTime.month &&
    dateTime.day == calendarDateTime.day;
