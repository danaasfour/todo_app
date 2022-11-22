import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoa_app/models/database_provider.dart';
import 'package:todoa_app/models/task.dart';
import 'package:todoa_app/views/screens/new_task_screen.dart';

class TaskList extends StatefulWidget {
  final int currentIndex;
  final List<Task> tasks;
  const TaskList(this.tasks, this.currentIndex, {Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Widget _circleIconButton(
      {required Color color,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(50)),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  _editTask(Task task) async {
    Navigator.of(context)
        .pushNamed(NewTaskScreen.route, arguments: task)
        .then((_) => setState(() {}));
  }

  _deleteTask(int id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete task'),
              content: const Text('Are you sure you want to delete this task?'),
              contentTextStyle: const TextStyle(color: Colors.black),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL')),
                TextButton(
                    onPressed: () async {
                      await Provider.of<DatabaseProvider>(context,
                              listen: false)
                          .deleteTask(id);
                      Navigator.pop(context);
                    },
                    child: const Text('YES'))
              ],
            ));
  }

  _completeTask(Task task) async {
    task.status = Status.completed.name;
    await Provider.of<DatabaseProvider>(context, listen: false)
        .updateTask(task);
  }

  Widget _placeholder() => Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty.png', height: 150),
          const SizedBox(height: 20),
          Text(
              widget.currentIndex == 0
                  ? 'You don\'t have any tasks'
                  : 'You don\'t have any completed tasks',
              style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20))
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return widget.tasks.isEmpty
        ? _placeholder()
        : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: widget.tasks.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 2.0,
                        ),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.tasks[index].title,
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${widget.tasks[index].date} ${widget.tasks[index].time}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(widget.tasks[index].description,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(children: [
                        if (widget.currentIndex != 1)
                          _circleIconButton(
                              color: Colors.pinkAccent,
                              icon: Icons.edit,
                              onTap: () => _editTask(widget.tasks[index])),
                        _circleIconButton(
                            color: Colors.indigo,
                            icon: FontAwesomeIcons.solidTrashCan,
                            onTap: () => _deleteTask(widget.tasks[index].id)),
                        _circleIconButton(
                            color: Colors.amber,
                            icon: Icons.share,
                            onTap: () {}),
                        const Spacer(),
                        if (widget.currentIndex == 0)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () =>
                                  _completeTask(widget.tasks[index]),
                              child: const Text('Complete'))
                        else if (widget.currentIndex == 1)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {},
                              child: const Text('Completed'))
                      ])
                    ],
                  ));
            });
  }
}
