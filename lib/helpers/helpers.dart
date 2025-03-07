import 'package:intl/intl.dart' show DateFormat;

String formatDateTime(DateTime dateTime) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
}
