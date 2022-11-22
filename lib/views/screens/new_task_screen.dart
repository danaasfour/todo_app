import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoa_app/models/database_provider.dart';
import 'package:todoa_app/models/notification_service.dart';
import 'package:todoa_app/models/task.dart';

import '../widgets/date_time_textfield.dart';

class NewTaskScreen extends StatefulWidget {
  static const String route = '/new-task';
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  Task? _task;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final NotificationService service;

  @override
  void initState() {
    super.initState();
    service = NotificationService();
    // check if there is a task sent from previous screen to update it
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _task = ModalRoute.of(context)!.settings.arguments as Task?;
      if (_task != null) {
        _dateController.text = _task!.date;
        _timeController.text = _task!.time;
        _titleController.text = _task!.title;
        _descriptionController.text = _task!.description;
        setState(() {});
      }
    });
  }

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = selectedTime.format(context);
      });
    }
  }

  _createTask() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final dateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    await Provider.of<DatabaseProvider>(context, listen: false).addNewTask(
        title: _titleController.text,
        date: _dateController.text,
        time: _timeController.text,
        description: _descriptionController.text);

    // show local notification based on selected date and time
    await NotificationService.showNotification(
        title: 'Complete your task!',
        body: _titleController.text,
        dateTime: dateTime,
        payload: _titleController.text);
    Navigator.pop(context);
  }

  _updateTask() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    _task = Task(
      id: _task!.id,
      userId: _task!.userId,
      title: _titleController.text,
      date: _dateController.text,
      time: _timeController.text,
      description: _descriptionController.text,
    );
    await Provider.of<DatabaseProvider>(context, listen: false)
        .updateTask(_task!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_task == null ? 'Let\'s Create Your Task' : 'Edit Your Task'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ElevatedButton(
            onPressed: _task == null ? _createTask : _updateTask,
            child: Text(_task == null ? 'CREATE TASK' : 'UPDATE TASK')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Type Something',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please type something';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              const Text('When',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: DateTimeTextField(
                          onPressed: _selectDate,
                          controller: _dateController,
                          hint: 'Date',
                          icon: FontAwesomeIcons.calendarPlus)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: DateTimeTextField(
                          onPressed: _selectTime,
                          controller: _timeController,
                          hint: 'Time',
                          icon: Icons.timer_outlined)),
                ],
              ),
              const SizedBox(height: 25),
              const Text('Description',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 10),
              TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Colors.black),
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black54),
                          borderRadius: BorderRadius.circular(20)))),
            ],
          ),
        ),
      ),
    );
  }
}
