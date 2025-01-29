import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_firebase/View/login_screen.dart';
import 'package:new_firebase/ViewModel/auth_viewmodel.dart';
import 'package:new_firebase/ViewModel/notes_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => NotesViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Note Taking App',
        theme: ThemeData(primarySwatch: Colors.blue),
        //home: const HomeScreen(),
        home: const LoginScreen(),
      ),
    );
  }
}
