import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_18/add_reminder.dart';
import 'package:flutter_application_18/const.dart';
import 'package:flutter_application_18/local.dart';
import 'package:flutter_application_18/model/db.dart';
import 'package:flutter_application_18/model/reminderModel.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final player = AudioPlayer();
  bool _eventTriggered = false;
  DateTime now = DateTime.now();
  late DateTime _currentDateTime;
  late Timer _timer;
  @override
  void initState() {
    _currentDateTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 4), _updateDateTime);
    super.initState();
  }

//-----------------------------------------------------------update time
  void _updateDateTime(Timer timer) {
    setState(() {
      _currentDateTime = DateTime.now();
    });
  }

//------------------------------------------------------audio player
  Future<void> playSound() async {
    String audioPath = 'iphone.mp3';
    await player.play(AssetSource(audioPath));
  }

  @override
  Widget build(BuildContext context) {
    getAllReminder();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return AddReminder();
              },
            )).then((value) {
              setState(() {});
            });
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: korange,
          centerTitle: true,
          title: Text('Reminder App'),
        ),
        body: ValueListenableBuilder(
          valueListenable: reminderNotifier,
          builder: (BuildContext context, List<ReminderModel> reminderList,
              Widget? child) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  final data = reminderList[index];
                  //---------------------------------------------------------------------------------

                  final timeString = data.time.toString();

                  DateFormat outputFormat = DateFormat('hh:mm a');
                  String formattedTime = outputFormat.format(_currentDateTime);

                  if (formattedTime == timeString &&
                      now.weekday == daysMap[data.day.toString()]) {
                    if (!_eventTriggered) {
                      sendNotification(data);
                      playSound();
                      _eventTriggered = true;
                    }
                  }

                  //--------------------------------------------------------------------------------------------------
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: ListTile(
                        tileColor: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        onTap: () {},
                        trailing: IconButton(
                            onPressed: () {
                              deleteindex(index);
                            },
                            icon: Icon(Icons.delete)),
                        title: Text(
                          data.day.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(data.time.toString()),
                        leading: Text(
                          data.activity.toString(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 0,
                  );
                },
                itemCount: reminderList.length);
          },
        ),
      ),
    );
  }

  //------------------------------------------------------- send notification

  sendNotification(data) {
    Localnotification.ShowSimpleNotification(
        title: '${data.activity}', body: 'Reminder', payload: '');
  }
}
