//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController dependenciesController = TextEditingController();
  List<String> topologicalOrder = [];

  void addTask() {
    if (taskNameController.text.isEmpty) return;
    setState(() {
      tasks.add({
        'name': taskNameController.text,
        'dependencies': dependenciesController.text
            .split(',')
            .map((dep) => dep.trim())
            .where((dep) => dep.isNotEmpty)
            .toList(),
      });
      taskNameController.clear();
      dependenciesController.clear();
    });
  }

  void deleteTask(String taskName) {
    setState(() {
      tasks.removeWhere((task) => task['name'] == taskName);
    });
  }

  void computeTopologicalOrder() {
    Set<String> visited = {};
    Set<String> temporaryMark = {};
    List<String> result = [];

    void dfs(String taskName) {
      if (temporaryMark.contains(taskName)) {
        return;
      }
      if (!visited.contains(taskName)) {
        temporaryMark.add(taskName);
        final task = tasks.firstWhere(
              (task) => task['name'] == taskName,
          orElse: () => {'name': '', 'dependencies': []},
        );
        if (task['name'] != '') {
          for (String dep in task['dependencies']) {
            dfs(dep);
          }
        }
        temporaryMark.remove(taskName);
        visited.add(taskName);
        result.add(taskName);
      }
    }

    for (var task in tasks) {
      if (!visited.contains(task['name'])) {
        dfs(task['name']);
      }
    }

    setState(() {
      topologicalOrder = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily To-Do List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dependenciesController,
              decoration: InputDecoration(
                labelText: 'Dependencies (comma-separated)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(task['name']),
                      subtitle: Text('Depends on: ${task['dependencies'].join(', ') ?? 'None'}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(task['name']),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: computeTopologicalOrder,
              child: Text('Compute Topological Order'),
            ),
            SizedBox(height: 10),
            if (topologicalOrder.isNotEmpty)
              Text(
                'Topological Order: ${topologicalOrder.join(' -> ')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}