/// Pure date helpers shared by the domain and presentation layers.
///
/// All helpers work on calendar days (time part is ignored) so that habit
/// completions are always compared day by day.
library;

const List<String> _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

const List<String> _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Returns [date] with the time component removed.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Returns `true` when both values fall on the same calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Returns `today` with the time component removed.
DateTime today() => dateOnly(DateTime.now());

/// Adds [days] calendar days to [date].
DateTime addDays(DateTime date, int days) =>
    DateTime(date.year, date.month, date.day + days);

/// Number of calendar days between [from] and [to] (`to - from`).
int daysBetween(DateTime from, DateTime to) =>
    dateOnly(to).difference(dateOnly(from)).inDays;

/// `Monday` .. `Sunday` name for the weekday of [date].
String weekdayName(DateTime date) => _weekdayNames[date.weekday - 1];

/// Single letter weekday label for compact history cells.
String weekdayLetter(DateTime date) => _weekdayLetters[date.weekday - 1];

/// `18 October 2026` style label.
String formatDayLabel(DateTime date) =>
    '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

/// `Sunday, 18 October 2026` style label.
String formatFullDate(DateTime date) =>
    '${weekdayName(date)}, ${formatDayLabel(date)}';

/// `18 Oct` style label used in tight spaces.
String formatShortDate(DateTime date) =>
    '${date.day} ${_monthNames[date.month - 1].substring(0, 3)}';
