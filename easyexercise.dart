import 'package:flutter/material.dart';
import 'dart:async'; // Added this import for Timer

class EasyExercisePage extends StatelessWidget {
  const EasyExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Exercises'),
        backgroundColor: Colors.green[400],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[100]!, Colors.green[50]!],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text(
                'Beginner Friendly Exercises',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Perfect for those starting their fitness journey',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              _buildExerciseItem(
                context,
                'Gentle Stretching',
                '5 minutes',
                '10 calories',
                'Full body gentle stretches to improve flexibility',
                Icons.accessibility_new,
                [
                  ExerciseStep(
                    'Neck Stretches', 
                    '30 seconds',
                    'assets/images/neck_stretch.png',
                    'Gently tilt your head to each side, holding for 5 seconds.'
                  ),
                  ExerciseStep(
                    'Shoulder Rolls', 
                    '30 seconds',
                    'assets/images/shoulder_rolls.png',
                    'Roll shoulders forward and backward in a circular motion.'
                  ),
                  ExerciseStep(
                    'Arm Stretches', 
                    '1 minute',
                    'assets/images/arm_stretches.png',
                    'Extend one arm across your chest and hold with the opposite hand.'
                  ),
                  ExerciseStep(
                    'Torso Twists', 
                    '1 minute',
                    'assets/images/torso_twists.png',
                    'Gently twist your upper body from side to side while seated.'
                  ),
                  ExerciseStep(
                    'Calf Stretches', 
                    '1 minute',
                    'assets/images/calf_stretches.png',
                    'Place hands on wall and extend one leg back, pressing heel down.'
                  ),
                  ExerciseStep(
                    'Ankle Rotations', 
                    '1 minute',
                    'assets/images/ankle_rotations.png',
                    'Rotate each ankle clockwise and counterclockwise while seated.'
                  ),
                ]
              ),
              
              _buildExerciseItem(
                context,
                'Basic Yoga Poses',
                '10 minutes',
                '30 calories',
                'Simple yoga poses focusing on breathing and balance',
                Icons.self_improvement,
                [
                  ExerciseStep(
                    'Mountain Pose', 
                    '1 minute',
                    'assets/images/mountain_pose.png',
                    'Stand tall with feet together, arms at sides, focusing on posture.'
                  ),
                  ExerciseStep(
                    'Child\'s Pose', 
                    '2 minutes',
                    'assets/images/childs_pose.png',
                    'Kneel and fold forward with arms extended, resting forehead on mat.'
                  ),
                  ExerciseStep(
                    'Cat-Cow Stretch', 
                    '2 minutes',
                    'assets/images/cat_cow.png',
                    'On hands and knees, alternate between arching and rounding back.'
                  ),
                  ExerciseStep(
                    'Downward Dog', 
                    '2 minutes',
                    'assets/images/downward_dog.png',
                    'Form an inverted V-shape with body, hands and feet on floor.'
                  ),
                  ExerciseStep(
                    'Warrior I', 
                    '2 minutes',
                    'assets/images/warrior_one.png',
                    'Lunge forward with one leg, arms extended overhead.'
                  ),
                  ExerciseStep(
                    'Corpse Pose', 
                    '1 minute',
                    'assets/images/corpse_pose.png',
                    'Lie flat on back with arms at sides, focusing on relaxation.'
                  ),
                ]
              ),
              
              _buildExerciseItem(
                context,
                'Walking in Place',
                '15 minutes',
                '50 calories',
                'Low impact cardio to get your heart rate up slightly',
                Icons.directions_walk,
                [
                  ExerciseStep(
                    'Warm-up March', 
                    '2 minutes',
                    'assets/images/march.png',
                    'Gently march in place lifting knees to waist height.'
                  ),
                  ExerciseStep(
                    'Basic Walk', 
                    '5 minutes',
                    'assets/images/basic_walk.png',
                    'Walk in place at a comfortable pace, swinging arms naturally.'
                  ),
                  ExerciseStep(
                    'Side Steps', 
                    '3 minutes',
                    'assets/images/side_steps.png',
                    'Step side to side, tapping foot and moving arms for balance.'
                  ),
                  ExerciseStep(
                    'High Knees', 
                    '2 minutes',
                    'assets/images/high_knees.png',
                    'March in place lifting knees higher to increase intensity.'
                  ),
                  ExerciseStep(
                    'Heel Taps', 
                    '2 minutes',
                    'assets/images/heel_taps.png',
                    'Alternately extend legs forward, tapping heels on the ground.'
                  ),
                  ExerciseStep(
                    'Cool Down', 
                    '1 minute',
                    'assets/images/cool_down.png',
                    'Return to gentle walking pace, gradually slowing down.'
                  ),
                ]
              ),
              
              _buildExerciseItem(
                context,
                'Seated Exercises',
                '10 minutes',
                '25 calories',
                'Chair-based movements for those with mobility issues',
                Icons.event_seat,
                [
                  ExerciseStep(
                    'Seated Marching', 
                    '2 minutes',
                    'assets/images/seated_marching.png',
                    'While seated, lift knees alternately as if marching.'
                  ),
                  ExerciseStep(
                    'Arm Circles', 
                    '2 minutes',
                    'assets/images/arm_circles.png',
                    'Extend arms and make small circular motions, gradually increasing size.'
                  ),
                  ExerciseStep(
                    'Seated Twists', 
                    '2 minutes',
                    'assets/images/seated_twists.png',
                    'Place hands on knees and gently twist torso from side to side.'
                  ),
                  ExerciseStep(
                    'Ankle Rotations', 
                    '1 minute',
                    'assets/images/seated_ankle.png',
                    'Lift foot slightly and rotate ankle in both directions.'
                  ),
                  ExerciseStep(
                    'Seated Leg Extensions', 
                    '2 minutes',
                    'assets/images/leg_extensions.png',
                    'Extend one leg at a time, holding briefly before lowering.'
                  ),
                  ExerciseStep(
                    'Shoulder Shrugs', 
                    '1 minute',
                    'assets/images/shoulder_shrugs.png',
                    'Lift shoulders toward ears, hold briefly, then release.'
                  ),
                ]
              ),
              
              _buildExerciseItem(
                context,
                'Light Resistance Bands',
                '12 minutes',
                '40 calories',
                'Gentle resistance training using elastic bands',
                Icons.fitness_center,
                [
                  ExerciseStep(
                    'Seated Bicep Curls', 
                    '2 minutes',
                    'assets/images/band_bicep.png',
                    'Secure band under feet and curl arms upward with resistance.'
                  ),
                  ExerciseStep(
                    'Chest Press', 
                    '2 minutes',
                    'assets/images/band_chest.png',
                    'Wrap band around back and push arms forward against resistance.'
                  ),
                  ExerciseStep(
                    'Seated Rows', 
                    '2 minutes',
                    'assets/images/band_rows.png',
                    'Extend arms and pull band toward torso, squeezing shoulder blades.'
                  ),
                  ExerciseStep(
                    'Lateral Raises', 
                    '2 minutes',
                    'assets/images/band_lateral.png',
                    'Stand on band and raise arms out to sides against resistance.'
                  ),
                  ExerciseStep(
                    'Leg Press', 
                    '2 minutes',
                    'assets/images/band_leg.png',
                    'While seated, loop band around one foot and press forward.'
                  ),
                  ExerciseStep(
                    'Hip Abduction', 
                    '2 minutes',
                    'assets/images/band_hip.png',
                    'Loop band around thighs and gently press legs apart.'
                  ),
                ]
              ),
              
              _buildWorkoutPlan(),
              
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Start workout button action
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Start Workout'),
                      content: const Text('Ready to begin your easy workout session?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Not now'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigate to workout player screen logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Let\'s go!'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Start Easy Workout',
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
    List<ExerciseStep> steps,
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
                  backgroundColor: Colors.green[100],
                  radius: 25,
                  child: Icon(
                    icon,
                    color: Colors.green[700],
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
                          Icon(Icons.timer, size: 16, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(duration),
                          const SizedBox(width: 12),
                          Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(calories),
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
            TextButton(
              onPressed: () {
                _showExerciseDetails(context, title, steps);
              },
              child: Text(
                'View Instructions',
                style: TextStyle(color: Colors.green[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseDetails(BuildContext context, String title, List<ExerciseStep> steps) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseInstructionsPage(title: title, steps: steps),
      ),
    );
  }

  Widget _buildWorkoutPlan() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.green[700],
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recommended Workout Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildWorkoutDay('Day 1', 'Gentle Stretching + Walking'),
            _buildWorkoutDay('Day 2', 'Rest or Light Activity'),
            _buildWorkoutDay('Day 3', 'Basic Yoga Poses'),
            _buildWorkoutDay('Day 4', 'Rest or Light Activity'),
            _buildWorkoutDay('Day 5', 'Light Resistance Bands + Seated Exercises'),
            _buildWorkoutDay('Day 6', 'Walking in Place'),
            _buildWorkoutDay('Day 7', 'Rest and Recovery'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                // Save to calendar feature
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green[700]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, color: Colors.green[700], size: 16),
                  const SizedBox(width: 8),
                  Text('Save to Calendar', style: TextStyle(color: Colors.green[700])),
                ],
              ),
            ),
          ],
        ),
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
}

// Model class for exercise steps
class ExerciseStep {
  final String name;
  final String duration;
  final String imageAsset;
  final String instructions;

  ExerciseStep(this.name, this.duration, this.imageAsset, this.instructions);
}

// New page for detailed exercise instructions with controls
class ExerciseInstructionsPage extends StatefulWidget {
  final String title;
  final List<ExerciseStep> steps;

  const ExerciseInstructionsPage({
    Key? key,
    required this.title,
    required this.steps,
  }) : super(key: key);

  @override
  State<ExerciseInstructionsPage> createState() => _ExerciseInstructionsPageState();
}

class _ExerciseInstructionsPageState extends State<ExerciseInstructionsPage> {
  int _currentStep = 0;
  bool _isWorkoutActive = false;
  int _secondsElapsed = 0;
  late PageController _pageController;
  Timer? _timer; // Changed to nullable Timer
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    if (_isWorkoutActive) {
      _timer?.cancel(); // Safely cancel if timer exists
    }
    super.dispose();
  }
  
  void _startWorkout() {
    setState(() {
      _isWorkoutActive = true;
      _secondsElapsed = 0;
    });
    
    // Create a periodic timer that fires every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }
  
  void _pauseWorkout() {
    _timer?.cancel(); // Cancel the timer safely
    setState(() {
      _isWorkoutActive = false;
    });
  }
  
  void _resumeWorkout() {
    _startWorkout();
  }
  
  void _resetWorkout() {
    if (_isWorkoutActive) {
      _timer?.cancel(); // Cancel the timer safely
    }
    
    setState(() {
      _currentStep = 0;
      _isWorkoutActive = false;
      _secondsElapsed = 0;
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
  
  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      // Workout completed
      if (_isWorkoutActive) {
        _timer?.cancel(); // Cancel the timer safely
        setState(() {
          _isWorkoutActive = false;
        });
      }
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Workout Complete!'),
          content: Text('You\'ve completed all ${widget.steps.length} exercises.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetWorkout();
              },
              child: const Text('Do it again'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Finish'),
            ),
          ],
        ),
      );
    }
  }
  
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }
  
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[400],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / widget.steps.length,
            backgroundColor: Colors.green[100],
            color: Colors.green,
            minHeight: 8,
          ),
          
          // Exercise step counter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${_currentStep + 1} of ${widget.steps.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatTime(_secondsElapsed),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Exercise instructions and images
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.steps.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              itemBuilder: (context, index) {
                final step = widget.steps[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Exercise name and duration
                      Text(
                        step.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Duration: ${step.duration}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Exercise image
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.shade200, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              step.imageAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getIconForExercise(step.name),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Exercise illustration',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Exercise instructions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instructions:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              step.instructions,
                              style: const TextStyle(fontSize: 16),
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
          
          // Navigation and control buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Workout control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!_isWorkoutActive)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isWorkoutActive ? null : _startWorkout,
                          icon: const Icon(Icons.play_arrow),
                          label: Text(_secondsElapsed > 0 ? 'Resume' : 'Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pauseWorkout,
                          icon: const Icon(Icons.pause),
                          label: const Text('Pause'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _resetWorkout,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Reset',
                      color: Colors.red[400],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _currentStep > 0 ? _previousStep : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _nextStep,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(_currentStep < widget.steps.length - 1 ? 'Next' : 'Finish'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForExercise(String name) {
    // Map exercise names to appropriate icons
    if (name.contains('Yoga') || name.contains('Pose')) {
      return Icons.self_improvement;
    } else if (name.contains('Walk') || name.contains('March')) {
      return Icons.directions_walk;
    } else if (name.contains('Stretch')) {
      return Icons.accessibility_new;
    } else if (name.contains('Seated')) {
      return Icons.event_seat;
    } else if (name.contains('Band') || name.contains('Resistance')) {
      return Icons.fitness_center;
    }
    return Icons.directions_run;
  }
}