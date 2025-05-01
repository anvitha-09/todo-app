import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:task_collaboration/models/task_model.dart';
import 'package:task_collaboration/services/task_service.dart';
import 'package:task_collaboration/views/user_list_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddTaskScreen({super.key,this.task,this.index});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
   TextEditingController _titleController = TextEditingController();
   TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _contentController = TextEditingController(text: widget.task?.content ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Task Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final content = _contentController.text.trim();

                    if (title.isNotEmpty && content.isNotEmpty) {
                      final task = Task(title: title, content: content);
                      final provider = Provider.of<TaskProvider>(context, listen: false);

                      if (widget.index != null) {
                        provider.updateTask(widget.index!, task); // Editing
                      } else {
                        provider.addTask(task); // New
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
