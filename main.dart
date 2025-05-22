import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_page.dart';
import 'firebase_options.dart'; // Ensure this import is correct
import 'package:shetrackv1/screens/sleep.dart';
import '/screens/Exercise.dart';
import 'package:shetrackv1/screens/track_period.dart';
import 'screens/Dite_menu.dart';
import 'screens/mindfull_page.dart';
import 'screens/health_insights.dart';
import 'screens/home_screen.dart';
import 'screens/symtoms.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'screens/steps_count.dart';
import 'screens/emergency.dart';
import 'screens/Tips_stress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
final appDocumentDirectory = 
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  
  // Register Hive adapters
  
  // Open Hive box
  await Hive.openBox('moods');

  await Hive.initFlutter();
  await Hive.openBox('hydrationBox');
  
  // For Android and iOS
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/TrackScreen': (context) =>  TrackScreen(),
        '/PeriodNutritionPlanPage': (context) => const PeriodNutritionPlanPage(),
        '/mindfulness': (context) => const MindfulnessPage(),
        '/health_insights': (context) => const HealthInsightScreen(),
        '/symptoms': (context) =>  SymptomsTrackerPage(),
        '/stress': (context) => const StressManagementPage(),
        '/emergency': (context) =>  EmergencyWhatsAppPage(),
      },
      home: AuthGate(), // This will decide whether to show the login screen or MainScreen
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    final user = FirebaseAuth.instance.currentUser;

    // If the user is not logged in, show the login screen
    if (user == null) {
      return const LoginScreen();
    } else {
      // If the user is logged in, navigate to the main screen
      return  MainScreen();  // Ensure MainScreen is a valid widget
    }
  }
}
