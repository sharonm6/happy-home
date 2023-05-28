import 'package:flutter/material.dart';
import 'package:happy_home/models/period_log.dart';
import 'package:happy_home/components/loading.dart';
import 'package:happy_home/services/database.dart';

class PeriodTrackerScreen extends StatefulWidget {
  PeriodTrackerScreen({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  late final DatabaseService databaseService;

  @override
  void initState() {
    databaseService = DatabaseService(uid: widget._uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PeriodLog>>(
        stream: databaseService.periodLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<PeriodLog> periodInfos = mealSnapshot.data!;
            PeriodLog _periodLog = periodInfos[0];

            return Column(children: [
              Text('Period Tracker', style: TextStyle(fontSize: 30)),
              ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.brown[400],
                ),
                title: Text(_periodLog.date.toString()),
                subtitle: Text('${_periodLog.uid} uid\n'
                    '${_periodLog.date} date\n'
                    '${_periodLog.currently} currently having period\n'
                    '${_periodLog.duration} days so far\n'),
              ),
              TextButton(
                  onPressed: () async => {
                        await DatabaseService().updatePeriodLogData(
                            widget._uid, DateTime.now(),
                            currently: true)
                      },
                  child: Text(
                    "Toggle currently: ${_periodLog?.currently}\n"
                    "Current duration: ${_periodLog?.duration}",
                  )),
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
