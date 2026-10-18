/// Route paths used across the app.
abstract final class AppRoutes {
  static const String today = '/';
  static const String addHabit = '/add-habit';
  static const String habitDetail = '/habits/:habitId';
  static const String editHabit = '/habits/:habitId/edit';

  static String habitDetailPath(String habitId) => '/habits/$habitId';

  static String editHabitPath(String habitId) => '/habits/$habitId/edit';
}
