import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:task_collaboration/services/task_service.dart';
import 'package:task_collaboration/views/user_list_screen.dart';
import 'package:task_collaboration/views/widgets/textform_widget.dart';
import 'package:task_collaboration/views/widgets/wave.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool register = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (register) {
        // Register (create user)
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registered Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Login (sign in)
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Provider.of<TaskProvider>(context, listen: false)
            .fetchTasksForCurrentUser();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserResponsesScreen()),
      );
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Wave(),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  TextFormFieldWidget(
                    icon: Icons.email,
                    label: 'Email',
                    textEditingController: _emailController,
                  ),
                  TextFormFieldWidget(
                    icon: Icons.vpn_key,
                    label: 'Password',
                    textEditingController: _passwordController,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text(register == true ? 'Register' : 'Login'),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      setState(() => register = !register);
                      _formKey.currentState?.reset();
                    },
                    child: Text(
                      register == true ? 'Login instead' : 'Register instead',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> createUserProfile(User user) async {
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'email': user.email,
    'createdAt': FieldValue.serverTimestamp(),
    // Add more custom user data here
  });
}
