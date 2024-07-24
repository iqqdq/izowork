extension DateTimeExtension on DateTime {
  String? toWeekday() {
    const Map<int, String> weekdayName = {
      1: "пн",
      2: "вт",
      3: "ср",
      4: "чт",
      5: "пт",
      6: "сб",
      7: "вс",
    };

    return weekdayName[weekday];
  }
}
