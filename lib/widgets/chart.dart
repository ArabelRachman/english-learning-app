import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chart_bar.dart';


class Chart extends StatelessWidget{
  final List<int> recentTimes;

  Chart(this.recentTimes);

  List<Map<String, Object>> get groupedTimes {
    return List.generate(7, (index) {
      return {
        'day': DateFormat.E().format(DateTime.now().subtract(Duration(days: index))),
        'total' : recentTimes[index]
      };

    }).reversed.toList();
  }

  int get totalTime {
    return groupedTimes.fold(0, (sum, item) {
      return sum + (item['total'] as int);
    });
  }

  @override
  Widget build(BuildContext context) {

      return Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChartBar(groupedTimes[0]['day'] as String, groupedTimes[0]['total'] as int,totalTime == 0 ? 1 : (groupedTimes[0]['total'] as int)/totalTime),
              ChartBar(groupedTimes[1]['day'] as String, groupedTimes[1]['total'] as int, totalTime == 0 ? 1 : (groupedTimes[1]['total'] as int)/totalTime),
              ChartBar(groupedTimes[2]['day'] as String, groupedTimes[2]['total'] as int, totalTime == 0 ? 1 :(groupedTimes[2]['total'] as int)/totalTime),
              ChartBar(groupedTimes[3]['day'] as String, groupedTimes[3]['total'] as int, totalTime == 0 ? 1 :(groupedTimes[3]['total'] as int)/totalTime),
              ChartBar(groupedTimes[4]['day'] as String, groupedTimes[4]['total'] as int,totalTime == 0 ? 1 : (groupedTimes[4]['total'] as int)/totalTime),
              ChartBar(groupedTimes[5]['day'] as String, groupedTimes[5]['total'] as int, totalTime == 0 ? 1 :(groupedTimes[5]['total'] as int)/totalTime),
              ChartBar(groupedTimes[6]['day'] as String, groupedTimes[6]['total'] as int, totalTime == 0 ? 1 :(groupedTimes[6]['total'] as int)/totalTime),

            ],
          ),
        ),
      );
  }

}