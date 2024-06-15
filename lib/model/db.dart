import 'package:flutter/material.dart';
import 'package:flutter_application_18/model/reminderModel.dart';
import 'package:hive_flutter/adapters.dart';

ValueNotifier<List<ReminderModel>> reminderNotifier = ValueNotifier([]);
Future<void> addreminder(ReminderModel value) async {
  final reminderDB = await Hive.openBox<ReminderModel>('reminderdb');
  final _id = await reminderDB.add(value);
  value.id = _id;
  reminderNotifier.value.add(value);
  reminderNotifier.notifyListeners();
}

Future<void> getAllReminder() async {
  final reminderDB = await Hive.openBox<ReminderModel>('reminderdb');
  reminderNotifier.value.clear();
  reminderNotifier.value.addAll(reminderDB.values);
  reminderNotifier.notifyListeners();
}

Future<void> deleteReminder(int? id) async {
  final reminderDB = await Hive.openBox<ReminderModel>('reminderdb');
  await reminderDB.delete(id);
  getAllReminder();
}

Future<void> deleteindex(index) async {
  final reminderDB = await Hive.openBox<ReminderModel>('reminderdb');
  await reminderDB.deleteAt(index);
  getAllReminder();
}
