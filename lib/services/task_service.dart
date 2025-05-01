import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_collaboration/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  late List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  bool isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchTasksForCurrentUser() async {
    isLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('responses') // Or your collection name
        .where('userId', isEqualTo: user.uid)
        .get();

    _tasks = snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _tasks.add(task);
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toJson());

    notifyListeners();
  }

  Future<void> updateTask(int index, Task updatedTask) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final tasksSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();

    final docId = tasksSnapshot.docs[index].id;

    _tasks[index] = updatedTask;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(docId)
        .update(updatedTask.toJson());

    notifyListeners();
  }
}

