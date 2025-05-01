import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:task_collaboration/services/task_service.dart';
import 'package:task_collaboration/views/auth/login_view.dart';
import 'package:task_collaboration/views/add_task.dart';

class UserResponsesScreen extends StatefulWidget {
  const UserResponsesScreen({super.key});

  @override
  State<UserResponsesScreen> createState() => _UserResponsesScreenState();
}

class _UserResponsesScreenState extends State<UserResponsesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    Provider.of<TaskProvider>(context, listen: false)
        .fetchTasksForCurrentUser();

    // TODO: implement initState
    super.initState();
  }

  Future<void> _shareTask() async {
    final String emailBody = '''
You have a new task assigned!           

Shared by: ${_auth.currentUser?.email ?? 'Unknown User'}
''';

    await Share.share(emailBody, subject: 'New Task Assigned');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hi ${user?.email ?? "Unknown"}',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                })
          ],
        ),
        body: taskProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : tasks.isEmpty
                ? Center(child: Text("No tasks found."))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      if (tasks.isEmpty) {
                        Text("List not fond");
                      }
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Title: ${task.title}"),
                                  Text("Content: ${task.content}")
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _shareTask,
                              icon: const Icon(Icons.share),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddTaskScreen(task: task, index: index),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            }));
  }
}
