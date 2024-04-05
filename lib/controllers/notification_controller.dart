// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   List<String> reminders = [];
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   @override
//   void initState() {
//     super.initState();
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     _initializeNotifications();
//   }

//   Future<void> _initializeNotifications() async {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Reminders',
//           style: TextStyle(
//             color: Color(0xFFF5F5F5), // Slightly less than white color
//             fontFamily: 'Roboto', // Robot font
//             fontSize: 20, // Adjust font size as needed
//           ),
//         ),
//         centerTitle: true, // Center the title
//         backgroundColor: Colors.black,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [
//                 Colors.grey[900]!,
//                 Colors.black,
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.grey[900]!, Colors.black],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: reminders.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(
//                         reminders[index],
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddReminderDialog(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }

//   void _showAddReminderDialog(BuildContext context) async {
//     TextEditingController titleController = TextEditingController();
//     DateTime selectedDate = DateTime.now();
//     TimeOfDay selectedTime = TimeOfDay.now();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color.fromARGB(255, 39, 40, 45),
//           elevation: 10,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           title: Center(
//             child: Text(
//               'Add Reminder',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: titleController,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   labelText: 'Title',
//                   labelStyle: TextStyle(color: Colors.white),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 title: Text(
//                   'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 trailing: Icon(Icons.calendar_today, color: Colors.white),
//                 onTap: () async {
//                   final DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate,
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2100),
//                     builder: (BuildContext context, Widget? child) {
//                       return Theme(
//                         data: ThemeData.dark().copyWith(
//                           backgroundColor: Colors
//                               .grey[800], // background color of date picker
//                           scaffoldBackgroundColor: Colors.grey[
//                               800], // background color of the surrounding dialog
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       selectedDate = pickedDate;
//                     });
//                   }
//                 },
//               ),
//               ListTile(
//                 title: Text(
//                   'Time: ${selectedTime.format(context)}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 trailing: Icon(Icons.access_time, color: Colors.white),
//                 onTap: () async {
//                   final TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: selectedTime,
//                     builder: (BuildContext context, Widget? child) {
//                       return Theme(
//                         data: ThemeData.dark().copyWith(
//                           backgroundColor: Colors
//                               .grey[800], // background color of time picker
//                           scaffoldBackgroundColor: Colors.grey[
//                               800], // background color of the surrounding dialog
//                         ),
//                         child: child!,
//                       );
//                     },
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       selectedTime = pickedTime;
//                     });
//                   }
//                 },
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel', style: TextStyle(color: Colors.white)),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 String reminder = titleController.text.isNotEmpty
//                     ? titleController.text
//                     : 'Reminder';
//                 String dateTime =
//                     '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.format(context)}';
//                 reminders.add('$reminder - $dateTime');
//                 _scheduleNotification(reminder, selectedDate, selectedTime);
//                 setState(() {});
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _scheduleNotification(
//       String title, DateTime date, TimeOfDay time) async {
//     var scheduledDateTime = tz.TZDateTime(
//       tz.local,
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );

//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'reminders_channel',
//       'Reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       title,
//       'Scheduled Body',
//       scheduledDateTime,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }
