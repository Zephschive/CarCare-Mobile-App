import 'package:carcare/common_widgets/Navigation_Menu.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedIndex = 3;
  Color _selectedColor = Colors.green.shade100;

  DateTime _parseTime(String timeStr) {
  final now = DateTime.now();
  final format = DateFormat.jm(); // e.g., 1:00 PM
  return format.parse(timeStr);
}


  final Map<String, List<Map<String, dynamic>>> _reminders = {
    "2025-04-07": [
      {
        "time": "10:00 AM",
        "title": "Insurance Renewal",
        "desc": "Your insurance will be..",
        "color": Colors.blue,
      },
      {
        "time": "1:00 PM",
        "title": "Insurance Renewal Reminder",
        "desc": "Please don't forget to renew it",
        "color": Colors.red.shade100,
      },
      {
        "time": "1:00 PM",
        "title": "Urgent Insurance Renewal",
        "desc": "Consider updating your policy",
        "color": Colors.red.shade100,
      },
      {
        "time": "4:00 PM",
        "title": "Renewal Notification",
        "desc": "Protect yourself and your car",
        "color": Colors.yellow.shade100,
      },
      {
        "time": "4:00 PM",
        "title": "Insurance Renewal Alert",
        "desc": "Stay secure and renew now",
        "color": Colors.yellow.shade100,
      },
    ]
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    String selectedKey = (_selectedDay ?? _focusedDay).toIso8601String().substring(0, 10);
    final dayReminders = _reminders[selectedKey] ?? [];

    return Scaffold(
      drawer: SideMenuDrawer(selectedIndex: selectedIndex),
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM d, y').format(_focusedDay),
                style: TextStyle(fontSize: 16),
              ),
              Text("Today’s Reminder", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time: ${DateFormat('hh:mm a').format(DateTime.now())} • ${dayReminders.length} reminder(s)",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (dayReminders.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            "No reminders at the moment",
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ..._buildTimeline(dayReminders),
                  ],
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildTimeline(List<Map<String, dynamic>> reminders) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in reminders) {
      grouped.putIfAbsent(item['time'], () => []).add(item);
    }

    return grouped.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              width: 6.0 , 
              height: 65.0 * entry.value.length,
              color: entry.value.first['color'],
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            Expanded(
              child: Column(
                children: entry.value.map((reminder) {
                  return GestureDetector(
                    onTap: () => _showReminderDetail(reminder),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: reminder['color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reminder['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(reminder['desc'], style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _showReminderDetail(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder['title']),
        content: Text(reminder['desc'].toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  void _showAddReminderDialog() {
  showDialog(
    context: context,
    builder: (context) {
      Color dialogSelectedColor = _selectedColor; // Local state

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Add Reminder"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                    child: Text("Pick Time: ${_selectedTime.format(context)}"),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Pick a color:"),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildColorCircle(Colors.green.shade100, dialogSelectedColor, (color) {
                        setState(() => dialogSelectedColor = color);
                      }),
                      _buildColorCircle(Colors.blue.shade100, dialogSelectedColor, (color) {
                        setState(() => dialogSelectedColor = color);
                      }),
                      _buildColorCircle(Colors.red.shade100, dialogSelectedColor, (color) {
                        setState(() => dialogSelectedColor = color);
                      }),
                      _buildColorCircle(Colors.yellow.shade100, dialogSelectedColor, (color) {
                        setState(() => dialogSelectedColor = color);
                      }),
                      _buildColorCircle(Colors.purple.shade100, dialogSelectedColor, (color) {
                        setState(() => dialogSelectedColor = color);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  String key = (_selectedDay ?? _focusedDay).toIso8601String().substring(0, 10);
                  setState(() {
                    _reminders.putIfAbsent(key, () => []).add({
                      "time": _selectedTime.format(context),
                      "title": _titleController.text,
                      "desc": _descController.text,
                      "color": dialogSelectedColor, // use dialogSelectedColor
                    });
                    _selectedColor = dialogSelectedColor; // Save to outer state if needed
                  });
                  _titleController.clear();
                  _descController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}



Widget _buildColorCircle(Color color, Color selected, Function(Color) onTap) {
  return GestureDetector(
    onTap: () => onTap(color),
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: selected == color ? Border.all(color: Colors.black, width: 2) : null,
      ),
    ),
  );
}

}
