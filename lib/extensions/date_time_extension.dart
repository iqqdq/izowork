extension DateTimeExtension on DateTime {
  String getDayShortName() {
    switch (month) {
      case 1:
        return 'ПН';
      case 2:
        return 'ВТ.';
      case 3:
        return 'СР';
      case 4:
        return 'ЧТ';
      case 5:
        return 'ПТ';
      case 6:
        return 'СБ';
      case 7:
        return 'ВС';
      default:
        return 'Unknown day';
    }
  }

  String getMonthName() {
    switch (month) {
      case 1:
        return 'Янв';
      case 2:
        return 'Фев';
      case 3:
        return 'Мар';
      case 4:
        return 'Апр';
      case 5:
        return 'Мая';
      case 6:
        return 'Июн';
      case 7:
        return 'Июл';
      case 8:
        return 'Авг';
      case 9:
        return 'Сен';
      case 10:
        return 'Окт';
      case 11:
        return 'Ноя';
      case 12:
        return 'Дек';
      default:
        return 'Unknown month';
    }
  }
}
