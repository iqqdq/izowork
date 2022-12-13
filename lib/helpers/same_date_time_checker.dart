bool isSameDate(DateTime dateTime, DateTime calendarDateTime) {
  return dateTime.year == calendarDateTime.year &&
      dateTime.month == calendarDateTime.month &&
      dateTime.day == calendarDateTime.day;
}
