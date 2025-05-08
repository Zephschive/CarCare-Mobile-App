// Import statements for required packages and modules
import 'package:carcare/common_widgets/Navigation_Menu.dart';  // Custom navigation drawer widget
import 'package:carcare/theme_provider/themeprovider.dart';    // Theme provider for light/dark mode
import 'package:cloud_firestore/cloud_firestore.dart';        // Firestore database SDK
import 'package:firebase_auth/firebase_auth.dart';             // Firebase authentication SDK
import 'package:flutter/material.dart';                         // Flutter UI toolkit
import 'package:provider/provider.dart';                        // Provider for state management
import 'package:table_calendar/table_calendar.dart';            // Calendar widget package
import 'package:intl/intl.dart';                                // Internationalization for date formatting

// Main ReminderPage widget, stateful because it manages selected date/time and reminders
class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();  // Creates mutable state
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime _focusedDay = DateTime.now();         // Currently focused day in calendar
  DateTime? _selectedDay;                       // User-selected day (nullable)
  int selectedIndex = 3;                        // Index for side menu highlighting

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  // Firestore instance
  final FirebaseAuth _auth = FirebaseAuth.instance;                // FirebaseAuth instance

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Key to control scaffold
  final TextEditingController _titleController = TextEditingController();   // Controller for title input
  final TextEditingController _descController = TextEditingController();    // Controller for description input
  TimeOfDay _selectedTime = TimeOfDay.now();  // Initially selected time for reminder

  @override
  void dispose() {
    // Dispose controllers when widget is removed
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  /// Deletes the given reminder from Firestore and closes detail dialog
  Future<void> _deleteReminder(Map<String, dynamic> reminder) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    await userDoc.update({
      'reminders': FieldValue.arrayRemove([reminder])
    });

    Navigator.of(context).pop(); // Close the detail dialog
  }

  /// Shows a dialog with title, description, and actions (Edit, Delete, Close)
  void _showReminderDetail(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder['title']),       // Display reminder title
        content: Text(reminder['desc']),      // Display reminder description
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();     // Close detail dialog
              _showEditReminderDialog(reminder); // Open edit dialog
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () => _deleteReminder(reminder), // Delete reminder
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to add a new reminder with title, description, time, and color
  void _showAddReminderDialog() {
    // Clear any previous inputs
    _titleController.clear();
    _descController.clear();
    _selectedTime = TimeOfDay.now();
    Color selectedColor = Colors.green.shade100; // Default color

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Reminder'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Title input field
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  // Description input field
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  // Button to pick time
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) {
                        setState(() => _selectedTime = picked); // Update selected time
                      }
                    },
                    child: Text('Pick Time: ${_selectedTime.format(context)}'),
                  ),
                  const SizedBox(height: 8),
                  // Color picker circles
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildColorCircle(Colors.green.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.blue.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.red.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.yellow.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.purple.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final user = _auth.currentUser;
                  if (user != null) {
                    // Construct reminder map
                    final reminder = {
                      'title': _titleController.text,
                      'desc': _descController.text,
                      'time': _selectedTime.format(context),
                      'color': selectedColor.value,
                      'date': (_selectedDay ?? _focusedDay).toIso8601String().substring(0, 10),
                    };
                    final userDoc = _firestore.collection('users').doc(user.uid);
                    // Add reminder to Firestore array, or set array if not exists
                    await userDoc.update({
                      'reminders': FieldValue.arrayUnion([reminder])
                    }).catchError((_) async {
                      await userDoc.set({'reminders': [reminder]});
                    });
                  }
                  Navigator.of(context).pop(); // Close add dialog
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Shows a dialog to edit an existing reminder, pre-filling fields
  void _showEditReminderDialog(Map<String, dynamic> oldReminder) {
    // Pre-fill controllers and selected time/color
    _titleController.text = oldReminder['title'];
    _descController.text = oldReminder['desc'];
    final parts = oldReminder['time'].split(RegExp(r'[: ]'));
    final hour = int.parse(parts[0]) % 12 + (parts[2] == 'PM' ? 12 : 0);
    final minute = int.parse(parts[1]);
    _selectedTime = TimeOfDay(hour: hour, minute: minute);
    Color selectedColor = Color(oldReminder['color']);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Reminder'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Title input field
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  // Description input field
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  // Button to pick new time
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null) setState(() => _selectedTime = picked);
                    },
                    child: Text('Pick Time: ${_selectedTime.format(context)}'),
                  ),
                  const SizedBox(height: 8),
                  // Color picker circles
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildColorCircle(Colors.green.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.blue.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.red.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.yellow.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                      _buildColorCircle(Colors.purple.shade100, selectedColor, (c) => setState(() => selectedColor = c)),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final user = _auth.currentUser;
                  if (user != null) {
                    // Construct updated reminder map
                    final updatedReminder = {
                      'title': _titleController.text,
                      'desc': _descController.text,
                      'time': _selectedTime.format(context),
                      'color': selectedColor.value,
                      'date': (_selectedDay ?? _focusedDay).toIso8601String().substring(0, 10),
                    };
                    final userDoc = _firestore.collection('users').doc(user.uid);
                    // Replace old reminder with updated one
                    await userDoc.update({
                      'reminders': FieldValue.arrayRemove([oldReminder])
                    });
                    await userDoc.update({
                      'reminders': FieldValue.arrayUnion([updatedReminder])
                    });
                  }
                  Navigator.of(context).pop(); // Close edit dialog
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Helper widget to build a colored circle for selecting reminder color
  Widget _buildColorCircle(Color color, Color selected, ValueChanged<Color> onTap) {
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

  /// Builds a vertical timeline of reminders grouped by time
  List<Widget> _buildTimeline(List<Map<String, dynamic>> reminders) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var r in reminders) {
      // Group reminders by their 'time' field
      grouped.putIfAbsent(r['time'], () => []).add(r);
    }
    return grouped.entries.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time label column
            SizedBox(
              width: 60,
              child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            // Vertical colored bar indicating number of reminders
            Container(
              width: 6,
              height: 65 * e.value.length.toDouble(),
              color: Color(e.value.first['color']),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            // Column of reminder cards
            Expanded(
              child: Column(
                children: e.value.map((r) {
                  return GestureDetector(
                    onTap: () => _showReminderDetail(r),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(r['color']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 4),
                          Text(r['desc'], style: const TextStyle(fontSize: 12, color: Colors.black54)),
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

  @override
  Widget build(BuildContext context) {
    // Format selected or focused day to 'YYYY-MM-DD'
    final selectedKey = (_selectedDay ?? _focusedDay).toIso8601String().substring(0, 10);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;  // Current theme flag

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenuDrawer(selectedIndex: selectedIndex), // Custom side menu
      backgroundColor: isDark ? Colors.white : Colors.black87,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? Colors.black : Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display full date (e.g., May 5, 2025)
              Text(
                DateFormat('MMMM d, y').format(_focusedDay),
                style: TextStyle(fontSize: 16, color: isDark ? Colors.black : Colors.white),
              ),
              // Header text for today's reminders
              Text(
                "Today’s Reminder",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.black : Colors.white),
              ),
              const SizedBox(height: 10),
              // Calendar widget from table_calendar package
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
                onDaySelected: (d, f) => setState(() {
                  _selectedDay = d;
                  _focusedDay = f;
                }),
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  formatButtonDecoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: isDark ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? Colors.black : Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? Colors.black : Colors.white),
                  titleTextStyle: TextStyle(color: isDark ? Colors.black : Colors.white),
                  titleCentered: true,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: isDark ? Colors.black : Colors.white),
                  decoration: BoxDecoration(color: isDark ? Colors.white : Colors.black),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: isDark ? Colors.black : Colors.white),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // StreamBuilder listening to Firestore user's reminders
              StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> reminders = [];
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final raw = data.containsKey('reminders') ? data['reminders'] as List<dynamic> : <dynamic>[];
                    // Filter reminders by selected date
                    reminders = raw
                        .where((r) => (r as Map<String, dynamic>)['date'] == selectedKey)
                        .cast<Map<String, dynamic>>()
                        .toList();
                  }

                  return Container(
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display current time and count of reminders
                        Text(
                          'Time: ${DateFormat('hh:mm a').format(DateTime.now())} • ${reminders.length} reminder(s)',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        // Show timeline or no-reminder placeholder
                        if (reminders.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No reminders at the moment',
                                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ..._buildTimeline(reminders),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),  // Spacing for floating button
            ],
          ),
        ),
      ),
      // FAB to add a new reminder
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
