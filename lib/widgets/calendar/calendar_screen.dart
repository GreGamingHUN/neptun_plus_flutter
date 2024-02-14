import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:neptun_plus_flutter/widgets/calendar/calendar_details_screen.dart';
import 'package:neptun_plus_flutter/src/api_calls.dart' as api_calls;
import 'package:neptun_plus_flutter/src/logic.dart' as logic;

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  @override
  void initState() {
    super.initState();
  }

  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyDateTimeLine(

          initialDate: selectedDate,
          onDateChange: (date) {
            setState(() {
              selectedDate = date;
            });
          },

          activeColor: Theme.of(context).colorScheme.primary,
          dayProps: EasyDayProps(
            todayStyle: DayStyle(
                dayNumStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20)),
            landScapeMode: true,
            inactiveDayStyle: DayStyle(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border(
                        bottom: BorderSide(color: Colors.grey),
                        top: BorderSide(color: Colors.grey),
                        left: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey))),
                dayNumStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20)),
            activeDayStyle: DayStyle(
                borderRadius: 48.0,
                dayNumStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            dayStructure: DayStructure.monthDayNumDayStr,
          ),
          headerProps: const EasyHeaderProps(
            selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: api_calls.getCalendarData(selectedDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('hiba');
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nincs esemény ezen a napon!'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data![index]['title']),
                        subtitle: Text(
                            '${logic.formatDate(snapshot.data![index]['start'], forceTime: true)} - ${logic.formatDate(snapshot.data![index]['end'], forceTime: true)}'),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarDetailsScreen(
                                  allDayLong: snapshot.data![index]
                                      ['allDayLong'],
                                  description: snapshot.data![index]
                                      ['description'],
                                  startDate: snapshot.data![index]['start'],
                                  endDate: snapshot.data![index]['end'],
                                  location: snapshot.data![index]['location'],
                                  title: snapshot.data![index]['title']),
                            )),
                      ),
                      const Divider(
                        height: 1,
                      )
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }
}
