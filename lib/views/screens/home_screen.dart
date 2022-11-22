import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoa_app/models/database_provider.dart';
import 'package:todoa_app/models/task.dart';
import 'package:todoa_app/models/user.dart';
import 'package:todoa_app/views/screens/new_task_screen.dart';
import 'package:todoa_app/views/widgets/search_text_field.dart';
import 'package:todoa_app/views/widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late User _user;
  List<Task> _tasks = [];
  String? searchValue;

  @override
  void initState() {
    Provider.of<DatabaseProvider>(context, listen: false).getAllTasks();
    super.initState();
  }

  List<Task> _getTasks() {
    _tasks = Provider.of<DatabaseProvider>(context, listen: false)
        .tasks
        .reversed
        .toList();
    List<Task> tasks = [];
    // When the user navigate to tasks
    if (_currentIndex == 0) {
      tasks = _tasks
          .where((element) => element.status != Status.completed.name)
          .toList();
    }
    // When the user navigate to Completed task
    else {
      tasks = _tasks
          .where((element) => element.status == Status.completed.name)
          .toList();
    }
    // when the user search for a value
    if (searchValue != null && searchValue!.isNotEmpty) {
      tasks = tasks
          .where((element) => element.title.contains(searchValue!))
          .toList();
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<DatabaseProvider>(context).user;
    final tasks = _getTasks();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(NewTaskScreen.route)
                .then((_) => setState(() {})),
            backgroundColor: Colors.indigo,
            child: const FaIcon(FontAwesomeIcons.plus, color: Colors.white)),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: FaIcon(FontAwesomeIcons.list),
                  ),
                  label: 'Task'),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Icon(FontAwesomeIcons.listCheck),
                  ),
                  label: 'Completed Task'),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Icon(FontAwesomeIcons.gear),
                  ),
                  label: 'Settings')
            ]),
        appBar: AppBar(
          title: Text('Welcome ${_user.name}'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: SearchTextField(onChanged: (value) {
              setState(() {
                searchValue = value;
              });
            }),
          ),
        ),
        body: _currentIndex != 2
            ? TaskList(tasks, _currentIndex)
            : const Center(),
      ),
    );
  }
}
