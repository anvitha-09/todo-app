import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_collaboration/services/task_service.dart';
import 'package:task_collaboration/views/auth/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: ScreenUtilInit(
        useInheritedMediaQuery: true,
        child: MaterialApp(
          title: 'Collaborative Tasks',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.cyan),
          home: AuthScreen(),
        ),
      ),
    );
  }
}
