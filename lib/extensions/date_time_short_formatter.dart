extension DateTimeShortFormatter on DateTime {
  String toShortDate() {
    final day =
        this.day.toString().length == 1 ? '0${this.day}' : this.day.toString();
    final month = this.month.toString().length == 1
        ? '0${this.month}'
        : this.month.toString();
    final year = this.year.toString();

    return '$day.$month.$year';
  }
}
