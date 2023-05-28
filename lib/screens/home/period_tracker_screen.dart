import 'package:flutter/material.dart';
import 'package:happy_home/config/color_constants.dart';
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
    String? periodShelfImg;

    return StreamBuilder<List<PeriodLog>>(
        stream: databaseService.periodLog,
        builder: (context, mealSnapshot) {
          if (mealSnapshot.hasData) {
            List<PeriodLog> periodInfos = mealSnapshot.data!;
            PeriodLog _periodLog = periodInfos[0];

            if (_periodLog.duration == 0) {
              periodShelfImg = "assets/period_shelf_0.png";
            } else if (_periodLog.duration == 1) {
              periodShelfImg = "assets/period_shelf_1.png";
            } else if (_periodLog.duration == 2) {
              periodShelfImg = "assets/period_shelf_2.png";
            } else if (_periodLog.duration == 3) {
              periodShelfImg = "assets/period_shelf_3.png";
            } else if (_periodLog.duration == 4) {
              periodShelfImg = "assets/period_shelf_4.png";
            } else if (_periodLog.duration == 5) {
              periodShelfImg = "assets/period_shelf_5.png";
            } else if (_periodLog.duration == 6) {
              periodShelfImg = "assets/period_shelf_6.png";
            } else if (_periodLog.duration == 7) {
              periodShelfImg = "assets/period_shelf_7.png";
            } else {
              periodShelfImg = "assets/period_shelf_8.png";
            }

            return Column(children: [
              SizedBox(height: 24),
              Center(
                child: Text(
                  "${_periodLog.duration} Day(s) So Far",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 100),
                child:
                    Image.asset(periodShelfImg ?? 'assets/period_shelf+0.png'),
              ),
              SizedBox(height: 8),
              TextButton(
                  onPressed: () async => {
                        await DatabaseService().updatePeriodLogData(
                            widget._uid, DateTime.now(),
                            currently: true)
                      },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    backgroundColor: ColorConstants.happyhomeGreenLight,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    "Period Today",
                    style: TextStyle(fontSize: 18),
                  )),
            ]);
          } else {
            return SizedBox(height: 0);
          }
        });
  }
}
