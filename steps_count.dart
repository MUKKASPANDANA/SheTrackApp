import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:flutter/animation.dart';

class StepTrackerScreen extends StatefulWidget {
  const StepTrackerScreen({super.key});

  @override
  State createState() => _StepTrackerScreenState();
}

class _StepTrackerScreenState extends State<StepTrackerScreen> with SingleTickerProviderStateMixin {
  late Stream _stepCountStream;
  int _stepsToday = 0;
  int _initialSteps = 0;
  int _goalSteps = 10000; // Default goal
  late AnimationController _animationController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _requestPermissionAndStartTracking();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future _requestPermissionAndStartTracking() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      await _loadInitialStepCount();
      _startStepTracking();
    } else {
      setState(() {
        _isLoading = false;
      });
      // Show dialog to explain why permission is needed
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
                'Step counting requires activity recognition permission to track your steps accurately.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future _loadInitialStepCount() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('step_date');
    final currentDate = DateTime.now().toIso8601String().substring(0, 10);
    final savedGoal = prefs.getInt('step_goal');
    
    if (savedGoal != null) {
      _goalSteps = savedGoal;
    }

    if (savedDate != currentDate) {
      // New day, reset
      await prefs.setString('step_date', currentDate);
      await prefs.setInt('initial_step_count', 0);
      _initialSteps = 0;
    } else {
      _initialSteps = prefs.getInt('initial_step_count') ?? 0;
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _startStepTracking() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (event) async {
        final prefs = await SharedPreferences.getInstance();

        // If initial steps not set, store them
        if (_initialSteps == 0) {
          _initialSteps = event.steps;
          await prefs.setInt('initial_step_count', _initialSteps);
        }

        setState(() {
          _stepsToday = event.steps - _initialSteps;
        });
        
        // Animate progress based on step count
        final progress = _stepsToday / _goalSteps;
        _animationController.animateTo(progress.clamp(0.0, 1.0));
      },
      onError: (err) {
        print("Step count error: $err");
      },
      cancelOnError: true,
    );
  }

  void _updateGoal() {
    showDialog(
      context: context,
      builder: (context) {
        int newGoal = _goalSteps;
        return AlertDialog(
          title: const Text('Set Step Goal'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Daily Step Goal',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                newGoal = int.parse(value);
              }
            },
            controller: TextEditingController(text: _goalSteps.toString()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt('step_goal', newGoal);
                setState(() {
                  _goalSteps = newGoal;
                });
                
                // Update animation to reflect new goal
                final progress = _stepsToday / _goalSteps;
                _animationController.animateTo(progress.clamp(0.0, 1.0));
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  String _formatSteps(int steps) {
    if (steps < 1000) return steps.toString();
    return '${(steps / 1000).toStringAsFixed(1)}k';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _stepsToday / _goalSteps;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step Tracker"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            tooltip: 'Set Goal',
            onPressed: _updateGoal,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withOpacity(0.5),
                    colorScheme.background,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Main step counter with animation
                              AspectRatio(
                                aspectRatio: 1,
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      painter: StepProgressPainter(
                                        progress: _animationController.value,
                                        backgroundColor: colorScheme.surfaceVariant,
                                        progressColor: colorScheme.primary,
                                        strokeWidth: 20,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _stepsToday.toString(),
                                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              'steps today',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Step goal indicator
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Daily Goal',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        Text(
                                          '${(progress * 100).toInt()}% complete',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: colorScheme.primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${_formatSteps(_stepsToday)}/${_formatSteps(_goalSteps)}',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit, size: 16),
                                          onPressed: _updateGoal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Step statistics
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                'Calories',
                                '${((_stepsToday * 0.04).toInt())}',
                                Icons.local_fire_department,
                                colorScheme.error,
                              ),
                              _buildStatItem(
                                context,
                                'Distance',
                                '${((_stepsToday * 0.0008).toStringAsFixed(2))} km',
                                Icons.straighten,
                                colorScheme.tertiary,
                              ),
                              _buildStatItem(
                                context,
                                'Time',
                                '${((_stepsToday * 0.01).toInt())} min',
                                Icons.timer,
                                colorScheme.secondary,
                              ),
                            ],
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class StepProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  StepProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // How much to draw
      false,
      progressPaint,
    );

    // Add decoration dots along the circle
    if (progress > 0.05) {
      final dotPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.fill;

      for (int i = 0; i < 12; i++) {
        final angle = i * (2 * math.pi / 12) - math.pi / 2;
        final dotRadius = i % 3 == 0 ? 4.0 : 2.0;
        
        // Only draw dots if we've progressed past them
        if (angle <= (2 * math.pi * progress - math.pi / 2)) {
          final dotPosition = Offset(
            center.dx + (radius) * math.cos(angle),
            center.dy + (radius) * math.sin(angle),
          );
          canvas.drawCircle(dotPosition, dotRadius, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(StepProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}