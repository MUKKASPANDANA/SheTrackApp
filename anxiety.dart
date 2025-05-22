import 'package:flutter/material.dart';

class AnxietyManagementPage extends StatelessWidget {
  const AnxietyManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Managing Anxiety',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD81B60), // Pink color for She Track
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const AnxietyContentPage(),
    );
  }
}

class AnxietyContentPage extends StatelessWidget {
  const AnxietyContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Section
          Container(
            height: 200,
            color: const Color(0xFFF8BBD0), // Light pink background
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.spa, // Wellness icon
                    size: 80,
                    color: const Color(0xFFC2185B), // Darker pink
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Cycle & Anxiety Management",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC2185B), // Darker pink
                    ),
                  ),
                  const Text(
                    "Tools to help balance your mind & emotions",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC2185B), // Darker pink
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Tips Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '15 Tips to Manage Hormonal Anxiety',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC2185B), // Darker pink
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Tips List
          const CycleAnxietyTipsList(),
          
          // Breathing Exercise Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const BreathingExerciseDialog();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD81B60), // Pink
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 3,
              ),
              child: const Text(
                'Start Breathing Exercise',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 16),
          
          // Footer with Support information
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFFF8BBD0), // Light pink background
            child: const Column(
              children: [
                Text(
                  'Remember',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC2185B), // Darker pink
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hormonal fluctuations during your cycle can affect anxiety levels. These tips may help manage symptoms, but please consult a healthcare professional for persistent concerns.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFC2185B)), // Darker pink
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BreathingExerciseDialog extends StatefulWidget {
  const BreathingExerciseDialog({Key? key}) : super(key: key);

  @override
  State<BreathingExerciseDialog> createState() => _BreathingExerciseDialogState();
}

class _BreathingExerciseDialogState extends State<BreathingExerciseDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _breathingText = "Inhale...";
  int _cycleCount = 0;
  static const int _totalCycles = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 50.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _controller.addListener(() {
      setState(() {
        if (_controller.value < 0.5) {
          _breathingText = "Inhale...";
        } else {
          _breathingText = "Exhale...";
        }
      });
    });
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _cycleCount++;
        if (_cycleCount < _totalCycles) {
          _controller.forward();
        }
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Breathing Exercise', textAlign: TextAlign.center),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _breathingText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (_, child) {
                return Container(
                  width: _animation.value,
                  height: _animation.value,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8BBD0).withOpacity(0.7), // Light pink
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: _animation.value * 0.6,
                    color: const Color(0xFFC2185B), // Darker pink
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Text(
              'Cycle ${_cycleCount + 1} of $_totalCycles',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Follow the rhythm to breathe deeply',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Color(0xFFC2185B)), // Darker pink
          ),
        ),
      ],
    );
  }
}

class CycleAnxietyTipsList extends StatelessWidget {
  const CycleAnxietyTipsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> anxietyTips = [
      {
        'title': '1. Track Your Cycle & Emotions',
        'description':
            'Log symptoms daily to identify patterns. Many women experience heightened anxiety before or during menstruation due to hormonal fluctuations.',
        'icon': Icons.calendar_month
      },
      {
        'title': '2. Deep Breathing Exercises',
        'description':
            'Practice 4-7-8 breathing: Inhale for 4 counts, hold for 7, exhale for 8. This technique can help reduce anxiety during hormonal shifts.',
        'icon': Icons.air
      },
      {
        'title': '3. Gentle Yoga Poses',
        'description':
            'Child\'s pose, legs-up-the-wall, and seated forward bend can help relieve tension and anxiety. Try gentle yoga particularly during PMS or your period.',
        'icon': Icons.self_improvement
      },
      {
        'title': '4. Limit Caffeine',
        'description':
            'Caffeine can worsen anxiety and PMS symptoms. Consider reducing intake, especially in the luteal phase (days before your period).',
        'icon': Icons.local_cafe
      },
      {
        'title': '5. Prioritize Sleep',
        'description':
            'Hormonal fluctuations can disrupt sleep. Aim for 7-9 hours and maintain a consistent sleep schedule, especially during your period.',
        'icon': Icons.bedtime
      },
      {
        'title': '6. Balance Blood Sugar',
        'description':
            'Eat regular meals with protein, healthy fats, and complex carbs. Blood sugar dips can trigger or worsen anxiety, especially pre-menstrually.',
        'icon': Icons.restaurant
      },
      {
        'title': '7. Mindfulness Meditation',
        'description':
            'Practice observing thoughts without judgment. Even 5 minutes daily can help manage hormonal-related mood changes.',
        'icon': Icons.spa
      },
      {
        'title': '8. Gentle Movement',
        'description':
            'Walking, swimming, or cycling can boost endorphins and reduce anxiety. During your period, low-impact exercise may be most beneficial.',
        'icon': Icons.directions_walk
      },
      {
        'title': '9. Herbal Support',
        'description':
            'Some women find relief with chamomile tea, valerian root, or lemon balm. Consult your healthcare provider before trying supplements.',
        'icon': Icons.local_florist
      },
      {
        'title': '10. Warm Baths',
        'description':
            'Adding Epsom salts or lavender oil can help relax muscles and reduce anxiety. Especially soothing for cramps and premenstrual tension.',
        'icon': Icons.bathtub
      },
      {
        'title': '11. Journal Your Thoughts',
        'description':
            'Writing down worries may help process emotions that intensify during hormonal shifts throughout your cycle.',
        'icon': Icons.edit_note
      },
      {
        'title': '12. Connect With Others',
        'description':
            'Share how you\'re feeling with supportive friends or join a women\'s health community. You\'re not alone in experiencing cycle-related anxiety.',
        'icon': Icons.people
      },
      {
        'title': '13. Reduce Environmental Stress',
        'description':
            'Create a calming space at home. Consider lighting, noise levels, and clutter, which may feel more overwhelming during sensitive cycle phases.',
        'icon': Icons.home
      },
      {
        'title': '14. Omega-3 Fatty Acids',
        'description':
            'Found in fatty fish, flaxseeds, and walnuts, omega-3s may help reduce inflammation and anxiety symptoms associated with PMS.',
        'icon': Icons.set_meal
      },
      {
        'title': '15. Professional Support',
        'description':
            'If anxiety significantly impacts your life, especially in a pattern related to your cycle, consider speaking with a healthcare provider about PMDD and treatment options.',
        'icon': Icons.medical_services
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: anxietyTips.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ExpansionTile(
            leading: Icon(
              anxietyTips[index]['icon'],
              color: const Color(0xFFD81B60), // Pink
            ),
            title: Text(
              anxietyTips[index]['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(anxietyTips[index]['description']),
              ),
            ],
          ),
        );
      },
    );
  }
}