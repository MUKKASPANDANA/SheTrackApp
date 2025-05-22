import 'package:flutter/material.dart';
import 'package:shetrackv1/screens/easyexercise.dart';
import 'package:shetrackv1/screens/mediumexercise.dart';
import 'hardexercise.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Choose Your Level',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ExerciseLevelCard(
                  title: 'Easy',
                  description: 'Beginner friendly exercises',
                  color: Colors.green[100]!,
                  imagePath: 'assets/images/easy_exercise.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  EasyExercisePage()),
                  ),
                ),
                const SizedBox(height: 16),
                ExerciseLevelCard(
                  title: 'Medium',
                  description: 'Intermediate level workouts',
                  color: Colors.blue[100]!,
                  imagePath: 'assets/images/medium_exercise.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MediumExercisePage()),
                  ),
                ),
                const SizedBox(height: 16),
                ExerciseLevelCard(
                  title: 'Hard',
                  description: 'Advanced exercise routines',
                  color: Colors.purple[100]!,
                  imagePath: 'assets/images/hard_exercise.png',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HardExercisePage()),
                  ),
                ),
                const SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () {
                    // Custom workout feature
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Custom workout feature coming soon!')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Create Custom Workout',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Fixed: Changed L10 to a proper number
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Including the ExerciseLevelCard class definition here
class ExerciseLevelCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final String imagePath;
  final VoidCallback onTap;

  const ExerciseLevelCard({
    Key? key,
    required this.title,
    required this.description,
    required this.color,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start Now →',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.fitness_center,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}