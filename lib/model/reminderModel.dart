import 'package:hive/hive.dart';
part 'reminderModel.g.dart';

@HiveType(typeId: 1)
class ReminderModel {
  @HiveField(0)
  final String? activity;
  @HiveField(1)
  final String? day;
  @HiveField(2)
  final time;
  @HiveField(3)
  int? id;
  ReminderModel(
      {required this.activity, required this.day, required this.time, this.id});
}
