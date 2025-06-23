import 'package:flutter/material.dart';

extension DateTimeConverter on DateTime {
  String extractTime() {
    String hourString = hour >= 10 ? hour.toString() : '0$hour';
    String minuteString = minute >= 10 ? minute.toString() : '0$minute';
    return '$hourString:$minuteString';
  }

  String toDateTimeWithDots() {
    String monthString = month >= 10 ? month.toString() : '0$month';
    String dayString = day >= 10 ? day.toString() : '0$day';
    return "$dayString.$monthString.$year";
  }

  String toDateTimeEIthHourMinuteFormat() {
    String monthString = month >= 10 ? month.toString() : '0$month';
    String dayString = day >= 10 ? day.toString() : '0$day';
    String hourString = hour >= 10 ? hour.toString() : '0$hour';
    String minuteString = minute >= 10 ? minute.toString() : '0$minute';
    return "$dayString.$monthString.$year, $hourString:$minuteString";
  }

  String toStorageApiDateFormat() {
    String monthString = month >= 10 ? month.toString() : '0$month';
    String dayString = day >= 10 ? day.toString() : '0$day';
    return "$year-$monthString-$dayString";
  }

  String toApiDateFormatWithTime() {
    String monthString = month >= 10 ? month.toString() : '0$month';
    String dayString = day >= 10 ? day.toString() : '0$day';
    String hourString = hour >= 10 ? hour.toString() : '0$hour';
    String minuteString = minute >= 10 ? minute.toString() : '0$minute';
    String secondString = second >= 10 ? second.toString() : '0$second';
    return "$dayString-$monthString-$year $hourString:$minuteString:$secondString";
  }

  String toApiDateFormat() {
    String monthString = month >= 10 ? month.toString() : '0$month';
    String dayString = day >= 10 ? day.toString() : '0$day';
    return "$year-$monthString-$dayString";
  }

  String toDateTimeWithSlahFormat() {
    return "$year/$month/$day";
  }

  String toDateTimeWithdashFormat() {
    return "$year-$month-$day";
  }
}

DateTime combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}
