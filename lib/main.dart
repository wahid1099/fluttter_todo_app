import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo[800],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> todoList = []; // Explicitly specify the type
   final TextEditingController _taskController = TextEditingController();

  void _addTask(String task, DateTime dueDateTime) {
    setState(() {
      todoList.add({
        "title": task,
        "due": dueDateTime,
      });
    });
    // Debugging statement
    print(todoList);
  }

    void _deleteItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTask = '';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('New Task', style: TextStyle(color: Colors.indigo[900])),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      labelStyle: TextStyle(color: Colors.indigo[800]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo[800]!),
                      ),
                    ),
                    onChanged: (value) => newTask = value,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.calendar_today, size: 18, color: Colors.indigo[800]),
                          label: Text(
                            selectedDate == null
                                ? 'Select Date'

                                : DateFormat('MMM dd, yyyy').format(selectedDate!),
                            style: TextStyle(color: Colors.indigo[800]),
                          ),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setStateDialog(() => selectedDate = date);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.access_time, size: 18, color: Colors.indigo[800]),
                          label: Text(
                            selectedTime == null
                                ? 'Select Time'
                                : DateFormat('HH:mm').format(
                              DateTime(2023, 1, 1, selectedTime!.hour, selectedTime!.minute),
                            ),
                            style: TextStyle(color: Colors.indigo[800]),
                          ),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setStateDialog(() => selectedTime = time);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.indigo[800])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[800]),
                  onPressed: () {
                    if (newTask.isNotEmpty && selectedDate != null && selectedTime != null) {
                      final dueDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      Navigator.pop(context);
                      _addTask(newTask, dueDateTime);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        elevation: 2,
        backgroundColor: Colors.indigo[800],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final task = todoList[index];
            return Dismissible(
              key: Key(task['due'].toString()),
              background: Container(color: Colors.red),
              onDismissed: (direction) => _deleteItem(index),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Icon(Icons.task_alt_rounded, color: Colors.indigo[800]),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Due: ${DateFormat.yMMMd().add_jm().format(task['due'])}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[300]),
                    onPressed: () => _deleteItem(index),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}