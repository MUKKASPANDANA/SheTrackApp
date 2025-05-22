import 'package:flutter/material.dart';
import 'package:shetrackv1/screens/anxiety.dart';
import 'package:shetrackv1/screens/exam_stress.dart';
import 'package:shetrackv1/screens/family_pressure.dart';
import 'package:shetrackv1/screens/financial_pressure.dart';
import 'package:shetrackv1/screens/social_pressure.dart';
import 'package:shetrackv1/screens/work_pressure.dart';

class StressManagementPage extends StatelessWidget {
  const StressManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Stress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Settings functionality would go here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Relief Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need Quick Relief?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Try a 2-minute breathing exercise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to breathing exercise
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BreathingExercisePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF673AB7),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Begin Now'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Stress Categories Title
              const Text(
                'Stress Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Stress Categories Grid
              StressCategoryGrid(),

              const SizedBox(height: 25),
              
              // Stats Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('12', 'Days Streak'),
                        _buildStatItem('85%', 'Less Stressed'),
                        _buildStatItem('24', 'Sessions'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Daily Tip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber[700],
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Daily Tip',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Taking short walks throughout your day can significantly reduce stress levels and improve mood.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5C6BC0),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Stress Category Grid
class StressCategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Exam Stress',
      'description': 'Plan a study schedule and tame regular dreads',
      'color': const Color(0xFFFFF0F0),
      'textColor': const Color(0xFFE57373),
      'icon': Icons.school_outlined,
    },
    {
      'title': 'Work Pressure',
      'description': 'Manage deadlines and workplace anxiety',
      'color': const Color(0xFFE8F5E9),
      'textColor': const Color(0xFF66BB6A),
      'icon': Icons.work_outline,
    },
    {
      'title': 'Family Issues',
      'description': 'Communicate needs and set boundaries',
      'color': const Color(0xFFE3F2FD),
      'textColor': const Color(0xFF42A5F5),
      'icon': Icons.family_restroom,
    },
    {
      'title': 'Financial Stress',
      'description': 'Create budgets and reduce money anxiety',
      'color': const Color(0xFFFFF8E1),
      'textColor': const Color(0xFFFFB74D),
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Health Anxiety',
      'description': 'Manage worry about health concerns',
      'color': const Color(0xFFF3E5F5),
      'textColor': const Color(0xFFAB47BC),
      'icon': Icons.favorite_border,
    },
    {
      'title': 'Social Pressure',
      'description': 'Navigate social situations with confidence',
      'color': const Color(0xFFE0F7FA),
      'textColor': const Color(0xFF26C6DA),
      'icon': Icons.people_outline,
    },
  ];

  StressCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return StressCategoryCard(
          title: categories[index]['title'],
          description: categories[index]['description'],
          color: categories[index]['color'],
          textColor: categories[index]['textColor'],
          icon: categories[index]['icon'],
          onTap: () {
            // Navigate based on the category title
            String categoryTitle = categories[index]['title'];
            
            if (categoryTitle == 'Exam Stress') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamStressPage(),
                ),
              );
            } else if (categoryTitle == 'Work Pressure') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkPressurePage(),
                ),
              );
            } else if (categoryTitle == 'Family Issues') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FamilyPressurePage(),
                ),
              );
            } else if (categoryTitle == 'Financial Stress') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinancialWellnessPage(),
                ),
              );
            } else if (categoryTitle == 'Health Anxiety') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnxietyContentPage(),
                ),
              );
            } else if (categoryTitle == 'Social Pressure') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialPressurePage(),
                ),
              );
            }
          },
        );
      },
    );
  }
}

// Stress Category Card Widget
class StressCategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final Color textColor;
  final IconData icon;
  final VoidCallback onTap;

  const StressCategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder page for stress categories - replace with your actual pages later
class StressCategoryDetailPage extends StatelessWidget {
  final String title;
  final Color color;
  final String route;

  const StressCategoryDetailPage({
    super.key,
    required this.title,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withOpacity(0.8),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForRoute(route),
              size: 100,
              color: color,
            ),
            const SizedBox(height: 20),
            Text(
              'This is a placeholder for $title page',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Route: $route',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getIconForRoute(String route) {
    switch (route) {
      case '/exam_stress':
        return Icons.school_outlined;
      case '/work_pressure':
        return Icons.work_outline;
      case '/family_pressure':
        return Icons.family_restroom;
      case '/financial_pressure':
        return Icons.account_balance_wallet_outlined;
      case '/health_anxiety':
        return Icons.favorite_border;
      case '/social_pressure':
        return Icons.people_outline;
      default:
        return Icons.help_outline;
    }
  }
}

// Example of a breathing exercise page
class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  BreathingExercisePageState createState() => BreathingExercisePageState();
}

class BreathingExercisePageState extends State<BreathingExercisePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _instruction = "Breathe In";
  int _secondsRemaining = 120; // 2 minutes
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = Tween<double>(begin: 100, end: 200).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _instruction = "Hold";
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _instruction = "Breathe Out";
            });
            _controller.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          setState(() {
            _instruction = "Hold";
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _instruction = "Breathe In";
            });
            _controller.forward();
          });
        }
      });
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
      _secondsRemaining = 120;
    });
    _controller.forward();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRunning && _secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
        _startTimer();
      } else if (_secondsRemaining <= 0) {
        _stopExercise();
      }
    });
  }

  void _stopExercise() {
    setState(() {
      _isRunning = false;
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF673AB7).withOpacity(0.1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Breathing Exercise',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF673AB7),
              ),
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value,
                  height: _animation.value,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9C27B0),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                color: Color(0xFF673AB7),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            if (!_isRunning)
              ElevatedButton(
                onPressed: _startExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF673AB7),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Start Exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: _stopExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Stop Exercise'),
              ),
          ],
        ),
      ),
    );
  }
}

// Example usage in your app:
/*
void main() {
  runApp(
    MaterialApp(
      title: 'Stress Management',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      home: const StressManagementPage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
*/