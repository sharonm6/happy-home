import 'package:flutter/material.dart';
import 'dart:async';

import 'package:happy_home/models/meal_log.dart';
import 'package:happy_home/services/database.dart';

const MONTH_NAMES = [
  'JANUARY',
  'FEBRUARY',
  'MARCH',
  "APRIL",
  "MAY",
  "JUNE",
  "JULY",
  "AUGUST",
  "SEPTEMBER",
  "OCTOBER",
  "NOVEMBER",
  "DECEMBER"
];

// Shows the showering calendar
class FoodCalendar extends StatelessWidget {
  final String uid;
  final List<MealLog> mealLogs;
  //final DatabaseService databaseService;

  const FoodCalendar({Key? key, required this.uid, required this.mealLogs})
      : super(key: key);

  int daysInCurrentMonth() {
    final start = firstDayOfCurrMonth();
    return DateTimeRange(
            start: start, end: DateTime(start.year, start.month + 1))
        .duration
        .inDays;
  }

  DateTime firstDayOfCurrMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final days = <String>["Su", "M", "T", "W", "Th", "F", "S"];
    int logsIndex = 0;
    // generate widget list of all days of the week
    final List<Widget> daysList = List.generate(7, (index) {
      return Center(
          child: Text(
        // can't render text, has to be a widget
        days[index],
        textAlign: TextAlign.center,
      ));
    });
    final List<Widget> dayOffset =
        List.generate(firstDayOfCurrMonth().weekday % 7, (index) {
      return const Center(
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "", // don't fill in dates of previous month
            textAlign: TextAlign.left,
          ),
        ),
      );
    });

    final List<Widget> calendarGridCells =
        List.generate(daysInCurrentMonth(), <Widget>(index) {
      final firstDayOfMonth = firstDayOfCurrMonth();
      Image img = Image.asset("assets/meal_table_000.png");
      //Color background;
      bool mealLogExists = false;
      // print("mealLogs length ${mealLogs.length}");
      // print("mealLog index ${mealLogs[logsIndex].date}");
      // print("firstDayOfMonth ${firstDayOfMonth.add(Duration(days: index))}");
      if (logsIndex < mealLogs.length) {
        DateTime day = mealLogs[logsIndex].date;
        DateTime currDay = firstDayOfMonth.add(Duration(days: index));
        // print(DateTime(day.year, day.month, day.day) == DateTime(currDay.year, currDay.month, currDay.day));
        if (DateTime(day.year, day.month, day.day) ==
            DateTime(currDay.year, currDay.month, currDay.day)) {
          mealLogExists = true;
        }
      }

      if (mealLogExists) {
        MealLog mealLog = mealLogs[logsIndex];
        if (logsIndex + 1 < mealLogs.length) {
          logsIndex++;
        }
        // print('mealLog: ${[
        //   mealLog.date,
        //   mealLog.ateBreakfast,
        //   mealLog.ateLunch,
        //   mealLog.ateDinner
        // ]}');
        if (mealLog.date.isBefore(firstDayOfMonth.add(Duration(days: index)))) {
          img = Image.asset("assets/empty.png",
              height: 200); // empty if past today, no data would exist
          //background = Colors.transparent;
        }
        if (!mealLog.ateBreakfast && !mealLog.ateLunch && !mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_000.png", height: 200);
        } else if (mealLog.ateBreakfast &&
            !mealLog.ateLunch &&
            !mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_100.png", height: 200);
        } else if (!mealLog.ateBreakfast &&
            mealLog.ateLunch &&
            !mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_010.png", height: 200);
        } else if (!mealLog.ateBreakfast &&
            !mealLog.ateLunch &&
            mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_001.png", height: 200);
        } else if (mealLog.ateBreakfast &&
            mealLog.ateLunch &&
            !mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_110.png", height: 200);
        } else if (mealLog.ateBreakfast &&
            !mealLog.ateLunch &&
            mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_101.png", height: 200);
        } else if (!mealLog.ateBreakfast &&
            mealLog.ateLunch &&
            mealLog.ateDinner) {
          img = Image.asset("assets/meal_table_011.png", height: 200);
        } else {
          img = Image.asset("assets/meal_table_111.png", height: 200);
        }
      } else if (firstDayOfMonth
          .add(Duration(days: index))
          .isAfter(DateTime.now())) {
        img = Image.asset("assets/empty.png", height: 200);
        //background = Colors.transparent;
      } else {
        img = Image.asset("assets/meal_table_000.png", height: 200);
      }

      return Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: 4,
              top: 4,
              child: Text(
                (index + 1).toString(), // indexing starts at 0
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 11),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 13, 3, 0),
              child: img,
            ),
          ],
        ),
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Text(
            MONTH_NAMES[firstDayOfCurrMonth().month - 1],
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // Generate # of days in month widgets
          children: (daysList + dayOffset + calendarGridCells)
              .map((w) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: w,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
