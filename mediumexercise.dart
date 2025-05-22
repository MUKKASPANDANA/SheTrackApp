import 'package:flutter/material.dart';
import 'dart:async';
class MediumExercisePage extends StatelessWidget {
  const MediumExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medium Exercises'),
        backgroundColor: Colors.blue[400],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[50]!],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'Intermediate Level Exercises',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'For those with some fitness experience',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              _buildExerciseItem(
                context,
                'Dynamic Stretching',
                '8 minutes',
                '25 calories',
                'Active stretches to prepare your body for more intense activity',
                Icons.accessibility_new,
                [
                  ExercisePose(
                    name: 'Arm Circles',
                    image: 'assets/images/arm_circles.png',
                    instructions: 'Stand with feet shoulder-width apart. Extend arms to sides at shoulder height. Make small circles with your arms, gradually increasing the size. Reverse direction after 30 seconds.',
                    duration: '60 seconds',
                  ),
                  ExercisePose(
                    name: 'Leg Swings',
                    image: 'assets/images/leg_swings.png',
                    instructions: 'Stand on one leg, holding onto a wall for support. Swing the other leg forward and backward in a controlled motion. Switch legs after 30 seconds.',
                    duration: '60 seconds',
                  ),
                  ExercisePose(
                    name: 'Walking Lunges with Twist',
                    image: 'assets/images/lunges_twist.png',
                    instructions: 'Step forward into a lunge, then twist your torso toward the front leg. Return to center, push back up and repeat with the other leg.',
                    duration: '90 seconds',
                  ),
                ],
              ),
              
              _buildExerciseItem(
                context,
                'Bodyweight Circuit',
                '20 minutes',
                '150 calories',
                'Series of exercises using your body weight for resistance',
                Icons.fitness_center,
                [
                  ExercisePose(
                    name: 'Push-ups',
                    image: 'assets/images/pushups.png',
                    instructions: 'Start in a plank position with hands slightly wider than shoulders. Lower your body until your chest nearly touches the floor, then push back up. Keep your core tight and back flat throughout the movement.',
                    duration: '45 seconds work, 15 seconds rest',
                  ),
                  ExercisePose(
                    name: 'Squats',
                    image: 'assets/images/squats.png',
                    instructions: 'Stand with feet shoulder-width apart. Lower your body by bending knees and pushing hips back as if sitting in a chair. Keep chest up and knees behind toes. Return to standing.',
                    duration: '45 seconds work, 15 seconds rest',
                  ),
                  ExercisePose(
                    name: 'Mountain Climbers',
                    image: 'assets/images/mountain_climbers.png',
                    instructions: 'Start in a plank position. Alternately drive knees toward chest in a running motion while maintaining a stable upper body and core.',
                    duration: '45 seconds work, 15 seconds rest',
                  ),
                ],
              ),
              
              _buildExerciseItem(
                context,
                'Cardio Intervals',
                '15 minutes',
                '120 calories',
                'Alternating periods of moderate and high intensity movement',
                Icons.directions_run,
                [
                  ExercisePose(
                    name: 'High Knees',
                    image: 'assets/images/high_knees.png',
                    instructions: 'Run in place, lifting knees toward chest. Keep your core engaged and maintain an upright posture. Pump arms for added intensity.',
                    duration: '30 seconds high intensity, 30 seconds rest',
                  ),
                  ExercisePose(
                    name: 'Jumping Jacks',
                    image: 'assets/images/jumping_jacks.png',
                    instructions: 'Start with feet together and arms at sides. Jump while spreading legs and raising arms overhead. Return to starting position in one fluid motion.',
                    duration: '30 seconds high intensity, 30 seconds rest',
                  ),
                  ExercisePose(
                    name: 'Burpees',
                    image: 'assets/images/burpees.png',
                    instructions: 'Start standing, drop into a squat position, kick feet back into a plank, perform a push-up, jump feet back to squat, then explosively jump up with arms overhead.',
                    duration: '30 seconds high intensity, 30 seconds rest',
                  ),
                ],
              ),
              
              _buildExerciseItem(
                context,
                'Intermediate Yoga Flow',
                '25 minutes',
                '100 calories',
                'Connected yoga poses with moderate difficulty',
                Icons.self_improvement,
                [
                  ExercisePose(
                    name: 'Sun Salutation B',
                    image: 'assets/images/sun_salutation_b.png',
                    instructions: 'A flowing sequence including Chair pose, Forward Fold, Plank, Chaturanga, Upward Dog, Downward Dog, and Warrior I poses on each side.',
                    duration: '5 minutes',
                  ),
                  ExercisePose(
                    name: 'Warrior II Sequence',
                    image: 'assets/images/warrior_two.png',
                    instructions: 'From Warrior II, flow into Extended Side Angle, Reverse Warrior, and Peaceful Warrior poses, holding each for several breaths before switching sides.',
                    duration: '8 minutes',
                  ),
                  ExercisePose(
                    name: 'Balance Series',
                    image: 'assets/images/tree_pose.png',
                    instructions: 'A series of balance poses including Tree Pose, Eagle Pose, and Dancer Pose, focusing on concentration and stability.',
                    duration: '6 minutes',
                  ),
                ],
              ),
              
              _buildExerciseItem(
                context,
                'Core Strengthening',
                '12 minutes',
                '80 calories',
                'Focused exercises for abdominal and back muscles',
                Icons.airline_seat_flat,
                [
                  ExercisePose(
                    name: 'Plank Variations',
                    image: 'assets/images/plank.png',
                    instructions: 'Hold a forearm plank with body in a straight line from head to heels. Engage core and keep hips from sagging. Try side planks and plank shoulder taps as variations.',
                    duration: '45 seconds work, 15 seconds rest',
                  ),
                  ExercisePose(
                    name: 'Russian Twists',
                    image: 'assets/images/russian_twists.png',
                    instructions: 'Sit with knees bent and feet lifted slightly off the floor. Lean back slightly to engage core, then rotate torso side to side, touching hands to the floor beside hips.',
                    duration: '45 seconds work, 15 seconds rest',
                  ),
                  ExercisePose(
                    name: 'Bicycle Crunches',
                    image: 'assets/images/bicycle_crunches.png',
                    instructions: 'Lie on your back with hands behind head. Lift shoulders off the ground and bring opposite elbow to opposite knee while extending the other leg, alternating sides.',
                    duration: '45 seconds work, 15 seconds rest',
                  ),
                ],
              ),
              
              _buildWorkoutPlan(),
              
              const SizedBox(height: 20),
              _buildProgressTracker(),
              
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Start workout button action
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Start Workout'),
                      content: const Text('Ready to challenge yourself with this medium intensity workout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Not now'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to workout player screen logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WorkoutPlayerScreen(
                                  workoutName: 'Medium Workout',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Let\'s go!'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Start Medium Workout',
                  style: TextStyle(fontSize: 18),
                ),
              ),
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
    IconData icon,
    List<ExercisePose> poses,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: 20,
                  child: Icon(
                    icon,
                    color: Colors.blue[700],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 4),
                          Text(duration),
                          const SizedBox(width: 12),
                          Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(calories,
                          overflow : TextOverflow.visible,),
                        ],
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Show detailed instructions with diagrams
                    _showInstructionsModal(context, title, poses);
                  },
                  icon: Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                  label: Text(
                    'Instructions',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // Show exercise variations
                  },
                  icon: Icon(Icons.swap_horiz, size: 16, color: Colors.blue[700]),
                  label: Text(
                    'Variations',
                    style: TextStyle(color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInstructionsModal(BuildContext context, String title, List<ExercisePose> poses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$title Instructions',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Follow the diagrams and instructions below for each exercise',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: poses.length,
                  itemBuilder: (context, index) {
                    final pose = poses[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pose image
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                            child: Image.asset(
                              pose.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 40, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text(
                                        pose.name,
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pose.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        pose.duration,
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  pose.instructions,
                                  style: const TextStyle(
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Start this specific pose exercise
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WorkoutPlayerScreen(
                                          workoutName: pose.name,
                                          poses: [pose],
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: const Size(double.infinity, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Try This Exercise'),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildWorkoutPlan() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 8),
                const Text(
                  'Weekly Workout Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildWorkoutDay('Day 1', 'Cardio Intervals + Core Strengthening'),
            _buildWorkoutDay('Day 2', 'Bodyweight Circuit'),
            _buildWorkoutDay('Day 3', 'Intermediate Yoga Flow'),
            _buildWorkoutDay('Day 4', 'Active Recovery (walking or light stretching)'),
            _buildWorkoutDay('Day 5', 'Cardio Intervals + Core Strengthening'),
            _buildWorkoutDay('Day 6', 'Bodyweight Circuit + Dynamic Stretching'),
            _buildWorkoutDay('Day 7', 'Rest and Recovery'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Save to calendar feature
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue[700]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        const SizedBox(width: 8),
                        Text('Save', style: TextStyle(color: Colors.blue[700])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Schedule adjustment feature
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue[700]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        const SizedBox(width: 8),
                        Text('Adjust Plan', style: TextStyle(color: Colors.blue[700])),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTracker() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressItem('Workouts', '12', Icons.fitness_center),
                _buildProgressItem('Calories', '1,450', Icons.local_fire_department),
                _buildProgressItem('Minutes', '180', Icons.timer),
              ],
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              'Level Progress: 65%',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Navigate to detailed progress page
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text('Detailed Statistics'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
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
}

// New data model for exercise poses
class ExercisePose {
  final String name;
  final String image;
  final String instructions;
  final String duration;

  ExercisePose({
    required this.name,
    required this.image,
    required this.instructions,
    required this.duration,
  });
}

// New Workout Player Screen with timer controls
class WorkoutPlayerScreen extends StatefulWidget {
  final String workoutName;
  final List<ExercisePose>? poses;

  const WorkoutPlayerScreen({
    Key? key,
    required this.workoutName,
    this.poses,
  }) : super(key: key);

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  int _currentPoseIndex = 0;
  int _timeRemaining = 60; // Default 60 seconds
  bool _isPlaying = false;
  bool _isWorkoutComplete = false;

  // Timer object
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.poses != null && widget.poses!.isNotEmpty) {
      // Parse duration from the first pose
      _parseDuration(widget.poses![0].duration);
    }
  }

  void _parseDuration(String durationText) {
    // Simple parser for durations like "45 seconds" or "60 seconds work, 15 seconds rest"
    final RegExp regExp = RegExp(r'(\d+)\s*seconds?');
    final match = regExp.firstMatch(durationText);
    if (match != null) {
      setState(() {
        _timeRemaining = int.parse(match.group(1)!);
      });
    }
  }

  void _startTimer() {
    setState(() {
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          // Move to next pose or complete workout
          if (widget.poses != null && _currentPoseIndex < widget.poses!.length - 1) {
            _currentPoseIndex++;
            _parseDuration(widget.poses![_currentPoseIndex].duration);
            _startTimer(); // Auto-start next pose
          } else {
            _isPlaying = false;
            _isWorkoutComplete = true;
          }
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _isPlaying = false;
      if (widget.poses != null && widget.poses!.isNotEmpty) {
        _parseDuration(widget.poses![_currentPoseIndex].duration);
      } else {
        _timeRemaining = 60; // Default reset time
      }
    });
  }

  void _skipToNextPose() {
    if (widget.poses != null && _currentPoseIndex < widget.poses!.length - 1) {
      _timer.cancel();
      setState(() {
        _currentPoseIndex++;
        _isPlaying = false;
        _parseDuration(widget.poses![_currentPoseIndex].duration);
      });
    }
  }

  void _goToPreviousPose() {
    if (widget.poses != null && _currentPoseIndex > 0) {
      _timer.cancel();
      setState(() {
        _currentPoseIndex--;
        _isPlaying = false;
        _parseDuration(widget.poses![_currentPoseIndex].duration);
      });
    }
  }

  @override
  void dispose() {
    if (_isPlaying) {
      _timer.cancel();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ExercisePose? currentPose = widget.poses != null && widget.poses!.isNotEmpty 
        ? widget.poses![_currentPoseIndex] 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        backgroundColor: Colors.blue[400],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress bar showing which exercise in the series
              if (widget.poses != null && widget.poses!.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Exercise ${_currentPoseIndex + 1}/${widget.poses!.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            currentPose?.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (widget.poses!.length > 1) 
                            ? (_currentPoseIndex + 1) / widget.poses!.length 
                            : 1.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                ),
              
              // Exercise image and instructions
              Expanded(
                child: _isWorkoutComplete 
                    ? _buildWorkoutCompleteView() 
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Pose image
                            Container(
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: currentPose != null 
                                  ? Image.asset(
                                      currentPose.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.fitness_center, size: 60, color: Colors.grey[400]),
                                              const SizedBox(height: 8),
                                              Text(
                                                currentPose.name,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.fitness_center, size: 60, color: Colors.grey[400]),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'No exercise selected',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Timer display
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                _formatTime(_timeRemaining),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Exercise instructions
                            if (currentPose != null)
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Instructions',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        currentPose.instructions,
                                        style: const TextStyle(
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.timer, size: 20, color: Colors.blue[700]),
                                            const SizedBox(width: 8),
                                            Text(
                                              currentPose.duration,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
              
              // Controls
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: _isWorkoutComplete 
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Finish Workout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Previous button (only if not first exercise)
                          if (widget.poses != null && widget.poses!.length > 1)
                            IconButton(
                              onPressed: _currentPoseIndex > 0 ? _goToPreviousPose : null,
                              icon: const Icon(Icons.skip_previous),
                              color: _currentPoseIndex > 0 ? Colors.blue : Colors.grey,
                              iconSize: 36,
                            ),
                            
                          // Reset button
                          IconButton(
                            onPressed: _resetTimer,
                            icon: const Icon(Icons.restart_alt),
                            color: Colors.orange,
                            iconSize: 36,
                          ),
                          
                          // Play/Pause button
                          FloatingActionButton(
                            onPressed: _isPlaying ? _pauseTimer : _startTimer,
                            backgroundColor: _isPlaying ? Colors.red : Colors.green,
                            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          ),
                          
                          // Next button (only if not last exercise)
                          if (widget.poses != null && widget.poses!.length > 1)
                            IconButton(
                              onPressed: _currentPoseIndex < widget.poses!.length - 1 ? _skipToNextPose : null,
                              icon: const Icon(Icons.skip_next),
                              color: _currentPoseIndex < widget.poses!.length - 1 ? Colors.blue : Colors.grey,
                              iconSize: 36,
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

  Widget _buildWorkoutCompleteView() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 80,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          const Text(
            'Workout Complete!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Great job completing the ${widget.workoutName}!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          // Stats summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCompletionStat('Exercises', widget.poses != null ? widget.poses!.length.toString() : '1', Icons.fitness_center),
                    _buildCompletionStat('Calories', '120', Icons.local_fire_department),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCompletionStat('Time', '15:00', Icons.timer),
                    _buildCompletionStat('Level', 'Medium', Icons.trending_up),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}