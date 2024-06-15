import 'package:flutter/material.dart';
import 'package:flutter_application_18/const.dart';
import 'package:flutter_application_18/model/db.dart';
import 'package:flutter_application_18/model/reminderModel.dart';

import 'package:intl/intl.dart';

class AddReminder extends StatefulWidget {
  AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final activity = [
    'Wake up',
    'Go to gym',
    'Breakfast',
    'Meeting',
    'Lunch',
    'Quick Nap',
    'Go to Library',
    'Dinner',
    'Go to sleep'
  ];

  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String? selectedDay;
  var formattedTime;
  String? selectedActivity;

  var selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: korange,
          centerTitle: true,
          title: Text('Add Reminder'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              gap,
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month),
                    hintText: 'Select  day',
                    labelText: 'Select  day',
                    border: OutlineInputBorder()),
                items: days.map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (value) {
                  selectedDay = value as String?;
                },
              ),
              SizedBox(
                height: 15,
              ),

              //--------------------------------------------------------------------------------------
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.task_alt),
                    hintText: 'Select  Activity',
                    labelText: 'Select  Activity',
                    border: OutlineInputBorder()),
                items: activity.map((e) {
                  return DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (value) {
                  selectedActivity = value;
                  print(selectedActivity);
                },
              ),
              SizedBox(
                height: 15,
              ),

              //---------------------------------------------------------------------------------------------------
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(10),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))))),
                  onPressed: () async {
                    final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        initialEntryMode: TimePickerEntryMode.dial);
                    if (timeOfDay != null) {
                      setState(() {
                        selectedTime = timeOfDay;
                        TimeOfDay timeOfDays = TimeOfDay(
                            hour: selectedTime.hour,
                            minute: selectedTime.minute);
                        formattedTime = formatTimeOfDay(timeOfDays);
                      });
                    }
                  },
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            final timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                                initialEntryMode: TimePickerEntryMode.dial);
                            if (timeOfDay != null) {
                              setState(() {
                                selectedTime = timeOfDay;
                                TimeOfDay timeOfDays = TimeOfDay(
                                    hour: selectedTime.hour,
                                    minute: selectedTime.minute);
                                formattedTime = formatTimeOfDay(timeOfDays);
                              });
                            }
                          },
                          icon: Icon(Icons.alarm)),
                      Text('Select Time '),
                      Spacer(),
                      Text(formattedTime != null ? formattedTime : '____'),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Container(
                width: 150,
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStatePropertyAll(10),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.amber.shade500),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))))),
                    onPressed: () {
                      onAddButtonClicked();
                    },
                    child: Text(
                      'save',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onAddButtonClicked() async {
    TimeOfDay timeOfDay =
        TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute);
    String formattedTime = formatTimeOfDay(timeOfDay);
    print(formattedTime);
    final _activity = selectedActivity;
    final _day = selectedDay;
    final time = formattedTime;
    if (_activity!.isEmpty || _day!.isEmpty || time.isEmpty) {
      return;
    }
    final _reminder = ReminderModel(activity: _activity, day: _day, time: time);
    addreminder(_reminder);
  }

  //--------------------------------------------------------------------------time formating
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);

    final format = DateFormat('hh:mm a');
    return format.format(dateTime);
  }
}
