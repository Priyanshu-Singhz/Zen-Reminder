import 'package:flutter/material.dart';
import 'package:zenreminder/controllers/authentication_controller.dart';
import 'package:zenreminder/constants.dart';
import 'package:zenreminder/services/notification_service.dart';
import 'package:zenreminder/view/screens/about_page.dart';
import 'package:zenreminder/view/screens/contribute_page.dart';
import 'package:zenreminder/view/screens/donate_page.dart';

class Reminder {
  final String title;
  final String body;
  final DateTime dateTime;

  Reminder({
    required this.title,
    required this.body,
    required this.dateTime,
  });
}

class MainScreen extends StatefulWidget {
  final String username; // Add username as a parameter to MainScreen

  MainScreen({required this.username}); // Update constructor to accept username

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Reminder> reminders = [];

  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  // Listen to any notification clicked or not
  listenToNotifications() {
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.pushNamed(context, '/another', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reminders',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
            fontFamily: 'Roboto', // Roboto font
            fontSize: 20, // Adjust font size as needed
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                Theme.of(context).brightness == Brightness.dark ? AppColors.darkPrimaryColor : AppColors.lightPrimaryColor,
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor, // Drawer background color
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).brightness == Brightness.dark ? AppColors.darkPrimaryColor : AppColors.lightPrimaryColor,
                      Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
                    ],
                  ),
                ),
                child: Text(
                  'Welcome, ${widget.username}!',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'About',
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Donate',
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonatePage()),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Contribute to App',
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContributePage()),
                  );
                },
              ),
              Divider(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                ),
                onTap: () {
                  // Perform logout operation
                  Navigator.pop(context); // Close the drawer
                  // You can implement the logout logic here
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
              Theme.of(context).brightness == Brightness.dark ? AppColors.darkPrimaryColor : AppColors.lightPrimaryColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              reminders[index].title,
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showAddReminderDialog(context, reminders[index]);
                              } else if (value == 'delete') {
                                setState(() {
                                  reminders.removeAt(index);
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      subtitle: Text(
                        formattedDateTime(reminders[index].dateTime, context),
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                        ),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkButtonColor : AppColors.lightButtonColor, // Slightly lighter color
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                reminders[index].body,
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Material(
  elevation: Theme.of(context).brightness == Brightness.dark ? 10 : 6, // Adjust elevation for dark theme
  shadowColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : null, // Apply shadow color for dark theme
  borderRadius: BorderRadius.circular(28.0), // Adjust border radius as needed
  child: FloatingActionButton(
    onPressed: () {
      _showAddReminderDialog(context, null);
    },
    child: Icon(Icons.add),
    backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkButtonColor : null, // Apply button color for dark theme
    foregroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : null, // Apply text color for dark theme
  ),
),


    );
  }

  String formattedDateTime(DateTime dateTime, BuildContext context) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  void _showAddReminderDialog(BuildContext context, [Reminder? reminderToEdit]) async {
    TextEditingController titleController = TextEditingController(text: reminderToEdit?.title ?? '');
    TextEditingController bodyController = TextEditingController(text: reminderToEdit?.body ?? '');
    DateTime selectedDate = reminderToEdit?.dateTime ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Center(
            child: Text(
              'Add Reminder',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: bodyController,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                ),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                  ),
                ),
                trailing: Icon(Icons.calendar_today, color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor, // background color of date picker
                          scaffoldBackgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor, // background color of the surrounding dialog
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Time: ${selectedTime.format(context)}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor,
                  ),
                ),
                trailing: Icon(Icons.access_time, color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor),
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor, // background color of time picker
                          scaffoldBackgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor, // background color of the surrounding dialog
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.lightTextColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                String reminderTitle = titleController.text.isNotEmpty ? titleController.text : 'Reminder';
                String reminderBody = bodyController.text.isNotEmpty ? bodyController.text : '';
                DateTime scheduledDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                Reminder newReminder = Reminder(title: reminderTitle, body: reminderBody, dateTime: scheduledDateTime);
                if (reminderToEdit == null) {
                  reminders.add(newReminder);
                } else {
                  int index = reminders.indexOf(reminderToEdit);
                  reminders[index] = newReminder;
                }
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
