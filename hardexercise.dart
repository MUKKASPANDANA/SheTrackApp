import 'package:flutter/material.dart';

class HardExercisePage extends StatelessWidget {
  const HardExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hard Exercises'),
        backgroundColor: Colors.purple[600],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.purple[50]!],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'Advanced Exercise Routines',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Challenge yourself with high-intensity workouts',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange[800],
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'These exercises are designed for experienced fitness enthusiasts. Consult a healthcare professional before starting.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _buildExerciseItem(
                context,
                'HIIT Training',
                '30 minutes',
                '400 calories',
                'High-intensity interval training to maximize calorie burn',
                Icons.whatshot,
                difficulty: 5,
                exercises: hiitExercises,
              ),
              
              _buildExerciseItem(
                context,
                'Advanced Strength Circuit',
                '40 minutes',
                '350 calories',
                'Challenging bodyweight exercises with minimal rest periods',
                Icons.fitness_center,
                difficulty: 5,
                exercises: strengthExercises,
              ),
              
              _buildExerciseItem(
                context,
                'Plyometric Drills',
                '25 minutes',
                '300 calories',
                'Explosive jumping exercises to build power and strength',
                Icons.directions_run,
                difficulty: 4,
                exercises: plyometricExercises,
              ),
              
              _buildExerciseItem(
                context,
                'Advanced Core Workout',
                '20 minutes',
                '180 calories',
                'Intensive abdominal and back exercises for core strength',
                Icons.accessibility_new,
                difficulty: 4,
                exercises: coreExercises,
              ),
              
              _buildExerciseItem(
                context,
                'Power Yoga',
                '45 minutes',
                '250 calories',
                'Challenging yoga poses with focus on strength and balance',
                Icons.self_improvement,
                difficulty: 3,
                exercises: yogaExercises,
              ),
              
              const SizedBox(height: 24),
              
              _buildWeeklyPlan(),
              
              const SizedBox(height: 24),
              
              _buildTips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
    BuildContext context,
    String title,
    String duration,
    String calories,
    String description,
    IconData icon, {
    required int difficulty,
    required List<Exercise> exercises,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.purple[400],
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              duration,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              calories,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 16,
                        color: index < difficulty ? Colors.amber : Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              description,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailPage(
                      title: title,
                      exercises: exercises,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[300],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyPlan() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.purple[700]),
              const SizedBox(width: 8),
              Text(
                'Weekly Workout Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildWorkoutDay('Monday', 'HIIT Training + Core Workout'),
          _buildWorkoutDay('Tuesday', 'Advanced Strength Circuit'),
          _buildWorkoutDay('Wednesday', 'Power Yoga + Light Cardio'),
          _buildWorkoutDay('Thursday', 'Plyometric Drills'),
          _buildWorkoutDay('Friday', 'Full Body Strength + HIIT'),
          _buildWorkoutDay('Saturday', 'Advanced Core + Flexibility'),
          _buildWorkoutDay('Sunday', 'Active Recovery or Rest'),
        ],
      ),
    );
  }

  Widget _buildWorkoutDay(String day, String workout) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(workout),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
              const SizedBox(width: 8),
              Text(
                'Advanced Training Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTip(
            'Proper warm-up is crucial for these intense workouts to prevent injury.',
          ),
          _buildTip(
            'Focus on maintaining good form rather than maximizing reps.',
          ),
          _buildTip(
            'Stay hydrated and consume adequate protein for muscle recovery.',
          ),
          _buildTip(
            'Incorporate 1-2 rest days weekly to allow your body to recover.',
          ),
          _buildTip(
            'Track your progress to stay motivated and adjust intensity as needed.',
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green[400], size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(tip),
          ),
        ],
      ),
    );
  }
}

// Exercise details page
class ExerciseDetailPage extends StatefulWidget {
  final String title;
  final List<Exercise> exercises;

  const ExerciseDetailPage({
    Key? key,
    required this.title,
    required this.exercises,
  }) : super(key: key);

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  int currentExerciseIndex = 0;
  bool isRunning = false;
  int secondsRemaining = 0;
  int totalSeconds = 0;
  late Exercise currentExercise;

  @override
  void initState() {
    super.initState();
    currentExercise = widget.exercises[currentExerciseIndex];
    totalSeconds = currentExercise.durationInSeconds;
    secondsRemaining = totalSeconds;
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    _startCountdown();
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      secondsRemaining = currentExercise.durationInSeconds;
    });
  }

  void resetWorkout() {
    setState(() {
      isRunning = false;
      currentExerciseIndex = 0;
      currentExercise = widget.exercises[currentExerciseIndex];
      totalSeconds = currentExercise.durationInSeconds;
      secondsRemaining = totalSeconds;
    });
  }

  void _startCountdown() async {
    while (isRunning && secondsRemaining > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (isRunning) {
        setState(() {
          secondsRemaining--;
        });

        if (secondsRemaining == 0) {
          if (currentExerciseIndex < widget.exercises.length - 1) {
            // Move to next exercise
            setState(() {
              currentExerciseIndex++;
              currentExercise = widget.exercises[currentExerciseIndex];
              totalSeconds = currentExercise.durationInSeconds;
              secondsRemaining = totalSeconds;
            });
            if (isRunning) {
              _startCountdown();
            }
          } else {
            // Workout complete
            setState(() {
              isRunning = false;
            });
            _showCompletionDialog();
          }
          break;
        }
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Complete!'),
        content: const Text('Congratulations! You have completed the workout.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetWorkout();
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void nextExercise() {
    if (currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        isRunning = false;
        currentExerciseIndex++;
        currentExercise = widget.exercises[currentExerciseIndex];
        totalSeconds = currentExercise.durationInSeconds;
        secondsRemaining = totalSeconds;
      });
    }
  }

  void previousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        isRunning = false;
        currentExerciseIndex--;
        currentExercise = widget.exercises[currentExerciseIndex];
        totalSeconds = currentExercise.durationInSeconds;
        secondsRemaining = totalSeconds;
      });
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double progress = secondsRemaining / totalSeconds;
    if (progress.isNaN) progress = 0.0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.purple[600],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.purple[50]!],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.purple[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exercise ${currentExerciseIndex + 1}/${widget.exercises.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    formatTime(secondsRemaining),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.purple[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentExercise.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${currentExercise.reps} • ${formatTime(currentExercise.durationInSeconds)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: currentExercise.imageAsset != null
                              ? Image.asset(
                                  currentExercise.imageAsset!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  currentExercise.icon ?? Icons.fitness_center,
                                  size: 120,
                                  color: Colors.purple[300],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...currentExercise.instructions.asMap().entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.purple[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${entry.key + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      const SizedBox(height: 16),
                      if (currentExercise.tips.isNotEmpty) ...[
                        Text(
                          'Tips',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...currentExercise.tips.map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.amber[700],
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: previousExercise,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.purple[200],
                        ),
                        child: const Icon(Icons.skip_previous, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isRunning ? pauseTimer : startTimer,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: isRunning ? Colors.orange : Colors.green,
                        ),
                        child: Icon(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: resetTimer,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.red[300],
                        ),
                        child: const Icon(Icons.refresh, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: nextExercise,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.purple[200],
                        ),
                        child: const Icon(Icons.skip_next, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: resetWorkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Reset Entire Workout'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Exercise model
class Exercise {
  final String name;
  final String reps;
  final int durationInSeconds;
  final List<String> instructions;
  final List<String> tips;
  final String? imageAsset;
  final IconData? icon;

  Exercise({
    required this.name,
    required this.reps,
    required this.durationInSeconds,
    required this.instructions,
    this.tips = const [],
    this.imageAsset,
    this.icon,
  });
}

// Sample exercise data
final List<Exercise> hiitExercises = [
  Exercise(
    name: 'Burpees',
    reps: '10 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Start in a standing position with feet shoulder-width apart.',
      'Drop into a squat position and place hands on the floor.',
      'Kick feet back into a plank position.',
      'Perform a push-up (optional).',
      'Return feet to squat position.',
      'Jump up from squat position with arms extended overhead.',
    ],
    tips: [
      'Keep your core engaged throughout the movement.',
      'Land softly when jumping to protect your knees.',
    ],
    icon: Icons.directions_run,
  ),
  Exercise(
    name: 'Mountain Climbers',
    reps: '30 seconds × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Start in a high plank position with hands beneath shoulders.',
      'Keeping core tight, drive right knee toward chest.',
      'Return right foot to starting position and immediately drive left knee toward chest.',
      'Continue alternating knees at a quick pace.',
    ],
    tips: [
      'Keep your hips level throughout the exercise.',
      'Focus on quick, controlled movements.',
    ],
    icon: Icons.terrain,
  ),
  Exercise(
    name: 'High Knees',
    reps: '30 seconds × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Stand with feet hip-width apart.',
      'Run in place, bringing knees up to hip level.',
      'Pump arms up and down in rhythm with knees.',
      'Keep core engaged and maintain an upright posture.',
    ],
    tips: [
      'Focus on bringing knees to hip height for maximum benefit.',
      'Land on the balls of your feet to minimize impact.',
    ],
    icon: Icons.directions_walk,
  ),
  Exercise(
    name: 'Jumping Jacks',
    reps: '30 seconds × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Start standing with feet together and arms at sides.',
      'Jump feet out wide while raising arms overhead.',
      'Jump feet back together while lowering arms to sides.',
      'Repeat at a rapid pace.',
    ],
    tips: [
      'Keep your movements smooth and controlled.',
      'To modify, step out instead of jumping.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'Plank to Push-up',
    reps: '8 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Start in a forearm plank position.',
      'Place one hand on the ground, then the other to push up into a high plank.',
      'Lower back down one arm at a time to return to forearm plank.',
      'Alternate which arm leads on each repetition.',
    ],
    tips: [
      'Keep your core tight and hips level throughout the movement.',
      'Focus on maintaining a straight line from head to heels.',
    ],
    icon: Icons.fitness_center,
  ),
];

final List<Exercise> strengthExercises = [
  Exercise(
    name: 'Push-ups',
    reps: '15 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Start in a high plank position with hands shoulder-width apart.',
      'Lower your chest toward the floor by bending your elbows.',
      'Keep your core engaged and body in a straight line.',
      'Push back up to the starting position.',
    ],
    tips: [
      'Keep elbows at a 45-degree angle to your body.',
      'For an easier version, perform push-ups on your knees.',
    ],
    icon: Icons.fitness_center,
  ),
  Exercise(
    name: 'Bulgarian Split Squats',
    reps: '12 reps per leg × 3 sets',
    durationInSeconds: 90,
    instructions: [
      'Stand about 2 feet in front of a bench or chair.',
      'Place the top of one foot on the bench behind you.',
      'Lower your body until your front thigh is parallel to the ground.',
      'Push through the heel of your front foot to return to starting position.',
      'Complete all reps on one leg before switching.',
    ],
    tips: [
      'Keep your front knee aligned with your toe.',
      'Hold dumbbells for added resistance if available.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'Pull-ups',
    reps: '8 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Hang from a pull-up bar with palms facing away from you.',
      'Engage your upper back and arm muscles to pull your body up.',
      'Continue until your chin clears the bar.',
      'Lower with control to starting position.',
    ],
    tips: [
      'Focus on using your back muscles, not just your arms.',
      'If unable to complete full pull-ups, try assisted variations.',
    ],
    icon: Icons.fitness_center,
  ),
  Exercise(
    name: 'Pistol Squats',
    reps: '6 reps per leg × 3 sets',
    durationInSeconds: 90,
    instructions: [
      'Stand on one leg with the other leg extended forward.',
      'Lower your body by bending your supporting knee.',
      'Keep your extended leg parallel to the ground.',
      'Return to standing by pushing through your heel.',
      'Complete all reps on one leg before switching.',
    ],
    tips: [
      'Hold arms forward for balance.',
      'Use a wall or pole for support if needed.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'Handstand Wall Walks',
    reps: '5 reps × 3 sets',
    durationInSeconds: 120,
    instructions: [
      'Start in a push-up position with feet against a wall.',
      'Walk feet up the wall while walking hands toward the wall.',
      'When comfortable, walk hands away from wall and feet down.',
      'Return to starting position.',
    ],
    tips: [
      'Keep core tight and shoulders engaged throughout.',
      'Start with shorter distances until you build strength.',
    ],
    icon: Icons.accessibility_new,
  ),
];

final List<Exercise> plyometricExercises = [
  Exercise(
   name: 'Box Jumps',
    reps: '10 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Stand facing a sturdy box or platform.',
      'Lower into a quarter squat position.',
      'Swing arms and explosively jump onto the box.',
      'Land softly in a slight squat position.',
      'Step back down and repeat.',
    ],
    tips: [
      'Choose an appropriate box height for your fitness level.',
      'Focus on landing softly with bent knees to absorb impact.',
    ],
    icon: Icons.height,
  ),
  Exercise(
    name: 'Jump Squats',
    reps: '15 reps × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Stand with feet shoulder-width apart.',
      'Lower into a squat position.',
      'Explosively jump upward, extending legs fully.',
      'Land softly back in the squat position.',
      'Immediately repeat the movement.',
    ],
    tips: [
      'Drive through heels when jumping.',
      'Keep chest up and back straight throughout.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'Plyo Push-ups',
    reps: '8 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Start in a push-up position.',
      'Lower chest toward the ground.',
      'Push up explosively so hands leave the ground.',
      'Land softly and immediately go into the next repetition.',
    ],
    tips: [
      'Focus on explosive power from the chest and triceps.',
      'For a modified version, perform from knees.',
    ],
    icon: Icons.fitness_center,
  ),
  Exercise(
    name: 'Skater Jumps',
    reps: '20 reps × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Stand on one leg with the opposite leg slightly behind.',
      'Jump laterally onto the opposite foot.',
      'Bring the non-landing foot behind you.',
      'Continue jumping side to side in a skating motion.',
    ],
    tips: [
      'Land softly and maintain balance before the next jump.',
      'Swing arms for momentum and balance.',
    ],
    icon: Icons.directions_run,
  ),
  Exercise(
    name: 'Broad Jumps',
    reps: '8 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Stand with feet hip-width apart.',
      'Lower into a quarter squat position.',
      'Swing arms and jump forward as far as possible.',
      'Land softly with bent knees.',
      'Reset position and repeat.',
    ],
    tips: [
      'Focus on distance rather than height.',
      'Use arm swing to increase momentum.',
    ],
    icon: Icons.directions_run,
  ),
];

final List<Exercise> coreExercises = [
  Exercise(
    name: 'Hollow Hold',
    reps: '30 seconds × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Lie on your back with arms extended overhead.',
      'Lift shoulders and legs off the ground.',
      'Create a "dish" shape with your body.',
      'Hold this position with lower back pressed into the floor.',
    ],
    tips: [
      'Focus on pressing lower back into the floor throughout.',
      'To modify, bend knees or keep arms by your sides.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'Russian Twists',
    reps: '20 reps × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Sit on the floor with knees bent and feet elevated.',
      'Lean back to create a 45-degree angle with torso.',
      'Clasp hands together and rotate torso to touch the ground on each side.',
      'Keep core engaged throughout the movement.',
    ],
    tips: [
      'Hold a weight to increase difficulty.',
      'Keep chest up and back straight to engage core properly.',
    ],
    icon: Icons.rotate_90_degrees_ccw,
  ),
  Exercise(
    name: 'Dragon Flags',
    reps: '8 reps × 3 sets',
    durationInSeconds: 90,
    instructions: [
      'Lie on your back on a bench or floor.',
      'Grip a sturdy object behind your head.',
      'Raise legs and lower back off the surface, keeping body straight.',
      'Lower body slowly back to starting position without touching floor.',
    ],
    tips: [
      'Focus on controlled lowering rather than raising.',
      'Begin with bent knees if the full movement is too challenging.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'L-Sit',
    reps: '20 seconds × 3 sets',
    durationInSeconds: 30,
    instructions: [
      'Sit on the floor with legs extended.',
      'Place hands on the floor beside your hips.',
      'Press down to lift your entire body off the floor.',
      'Hold with legs parallel to the ground.',
    ],
    tips: [
      'Start with bent knees if unable to lift legs straight.',
      'Focus on pushing shoulders down away from ears.',
    ],
    icon: Icons.accessibility_new,
  ),
  Exercise(
    name: 'Ab Wheel Rollout',
    reps: '10 reps × 3 sets',
    durationInSeconds: 60,
    instructions: [
      'Kneel on the floor holding an ab wheel in front of you.',
      'Slowly roll the wheel forward, extending your body as far as possible.',
      'Use core strength to roll back to the starting position.',
      'Keep back flat throughout the movement.',
    ],
    tips: [
      'Begin with small movements and gradually increase distance.',
      'Avoid arching your lower back.',
    ],
    icon: Icons.circle,
  ),
];

final List<Exercise> yogaExercises = [
  Exercise(
    name: 'Warrior III',
    reps: 'Hold 30 seconds per side',
    durationInSeconds: 45,
    instructions: [
      'Begin in a standing position.',
      'Shift weight onto one leg while lifting the other behind you.',
      'Hinge forward at the hips until torso is parallel to the floor.',
      'Extend arms forward in line with your torso.',
      'Maintain balance while holding the position.',
    ],
    tips: [
      'Focus on keeping hips level and squared to the floor.',
      'Gaze at a fixed point on the floor for balance.',
    ],
    icon: Icons.self_improvement,
  ),
  Exercise(
    name: 'Crow Pose',
    reps: 'Hold for 20 seconds × 3 sets',
    durationInSeconds: 30,
    instructions: [
      'Begin in a squat position with hands on the floor.',
      'Place knees on the backs of your upper arms.',
      'Shift weight forward and lift feet off the floor.',
      'Balance on your hands with arms bent.',
    ],
    tips: [
      'Look slightly forward rather than down to help balance.',
      'Use a yoga block or cushion in front of you when learning.',
    ],
    icon: Icons.self_improvement,
  ),
  Exercise(
    name: 'Side Plank with Leg Lift',
    reps: '30 seconds per side × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Start in a side plank position with feet stacked.',
      'Ensure elbow is directly under shoulder.',
      'Lift top leg as high as possible while maintaining form.',
      'Hold position while breathing steadily.',
    ],
    tips: [
      'Keep hips lifted and body in a straight line.',
      'For an easier version, place bottom knee on the floor.',
    ],
    icon: Icons.self_improvement,
  ),
  Exercise(
    name: 'Boat Pose',
    reps: 'Hold for 30 seconds × 3 sets',
    durationInSeconds: 45,
    instructions: [
      'Sit on the floor with knees bent and feet flat.',
      'Lean back slightly and lift feet off the floor.',
      'Straighten legs to create a V-shape with your body.',
      'Extend arms parallel to the floor.',
    ],
    tips: [
      'Keep spine straight and chest lifted.',
      'Bend knees if needed to maintain form.',
    ],
    icon: Icons.self_improvement,
  ),
  Exercise(
    name: 'Handstand Prep',
    reps: '3 attempts × 30 seconds',
    durationInSeconds: 120,
    instructions: [
      'Start in downward dog position near a wall.',
      'Walk feet toward hands and shift weight onto hands.',
      'Kick one leg up followed by the other toward the wall.',
      'Find balance with heels against the wall.',
      'Focus on alignment and steady breathing.',
    ],
    tips: [
      'Engage core and press firmly through shoulders.',
      'Practice against a wall before attempting freestanding.',
    ],
    icon: Icons.self_improvement,
  ),
];