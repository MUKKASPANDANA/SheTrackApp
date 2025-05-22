import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ExamStressPage extends StatelessWidget {
  const ExamStressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Stress',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8BBD0),
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8BBD0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/exam_stress.png', // Make sure to add this image to your assets
                  height: 180,
                  fit: BoxFit.contain,
                  // If you don't have this specific image, replace with a placeholder
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 80,
                            color: Colors.pink[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Exam Stress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[300],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Introduction
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Managing Exam Stress',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Feeling anxious about exams is normal, but too much stress can impact your performance. Here are 15 research-backed tips to help you manage exam stress effectively.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Tips Section
                  const Text(
                    '15 Tips to Reduce Exam Stress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Tips List
                  ...examStressTips.map((tip) => TipCard(
                    tipNumber: tip['number'],
                    title: tip['title'],
                    description: tip['description'],
                  )),
                  
                  const SizedBox(height: 25),
                  
                  // Quick Tools Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink[50]!,
                          Colors.pink[100]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Tools',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickTool(
                              context,
                              Icons.calendar_today_outlined,
                              'Study Plan',
                              () {
                                // Navigate to study plan creator
                              },
                            ),
                            _buildQuickTool(
                              context,
                              Icons.timer_outlined,
                              'Pomodoro',
                              () {
                                // Navigate to pomodoro timer
                              },
                            ),
                            _buildQuickTool(
                              context,
                              Icons.self_improvement_outlined,
                              'Quick Relief',
                              () {
                                // Navigate to quick relief exercises
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickTool(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.pink[300],
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

// Tip Card Widget
class TipCard extends StatelessWidget {
  final int tipNumber;
  final String title;
  final String description;
  
  const TipCard({
    super.key,
    required this.tipNumber,
    required this.title,
    required this.description,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              shape: BoxShape.circle,
            ),
            child: Text(
              tipNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.pink[400],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// List of exam stress tips
final List<Map<String, dynamic>> examStressTips = [
  {
    'number': 1,
    'title': 'Create a Realistic Study Schedule',
    'description': 'Break your study time into manageable chunks with specific goals for each session. Include regular breaks and stick to your schedule.',
  },
  {
    'number': 2,
    'title': 'Practice Deep Breathing',
    'description': 'When anxiety hits, take 5 deep breaths, inhaling for 4 counts and exhaling for 6. This activates your parasympathetic nervous system and reduces stress.',
  },
  {
    'number': 3,
    'title': 'Use Active Study Methods',
    'description': 'Don\'t just read or highlight. Actively engage with material by teaching concepts out loud, creating mind maps, or taking practice tests.',
  },
  {
    'number': 4,
    'title': 'Prioritize Sleep',
    'description': 'Aim for 7-9 hours of sleep, especially the night before exams. Sleep helps consolidate memory and improves cognitive function.',
  },
  {
    'number': 5,
    'title': 'Stay Hydrated and Eat Well',
    'description': 'Your brain needs proper nutrition. Avoid excessive caffeine, eat foods rich in omega-3 fatty acids, and keep water nearby while studying.',
  },
  {
    'number': 6,
    'title': 'Use the Pomodoro Technique',
    'description': 'Study intensely for 25 minutes, then take a 5-minute break. After four cycles, take a longer 15-30 minute break to recharge.',
  },
  {
    'number': 7,
    'title': 'Exercise Regularly',
    'description': 'Even a 10-minute walk can reduce anxiety. Exercise releases endorphins that combat stress and improve cognitive function.',
  },
  {
    'number': 8,
    'title': 'Practice Positive Self-Talk',
    'description': 'Replace "I\'m going to fail" with "I\'ve prepared well and will do my best." How you talk to yourself affects your stress levels.',
  },
  {
    'number': 9,
    'title': 'Visualize Success',
    'description': 'Spend 5 minutes before studying imagining yourself successfully completing the exam with confidence and calm.',
  },
  {
    'number': 10,
    'title': 'Limit Social Media',
    'description': 'Reduce digital distractions during study periods. Put your phone in another room or use apps that block social media temporarily.',
  },
  {
    'number': 11,
    'title': 'Study with Friends Strategically',
    'description': 'Group study can be helpful for reviewing concepts, but ensure these sessions stay productive and don\'t increase anxiety.',
  },
  {
    'number': 12,
    'title': 'Create a Dedicated Study Space',
    'description': 'Your brain associates locations with activities. Having a clean, organized study space signals to your brain it\'s time to focus.',
  },
  {
    'number': 13,
    'title': 'Practice Mindfulness',
    'description': 'Take 5-minute mindfulness breaks to focus on the present moment rather than worrying about exam results.',
  },
  {
    'number': 14,
    'title': 'Prepare the Night Before',
    'description': 'Gather all materials you\'ll need for the exam, plan your route to the exam location, and set multiple alarms to reduce morning stress.',
  },
  {
    'number': 15,
    'title': 'Remember the Bigger Picture',
    'description': 'While exams are important, they don\'t define your worth or entire future. Maintaining perspective helps reduce unnecessary pressure.',
  },
];