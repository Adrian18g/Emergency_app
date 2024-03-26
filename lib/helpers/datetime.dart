import 'package:intl/intl.dart';

String getDate() {
  DateTime now = DateTime.now();
  String dateFormateada = DateFormat('d/M/y').format(now);
  return dateFormateada;
}
