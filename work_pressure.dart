import 'package:flutter/material.dart';

class WorkPressurePage extends StatelessWidget {
  const WorkPressurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Work Pressure',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBBDEFB),
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
                color: Color(0xFFBBDEFB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/work_pressure.png', // Make sure to add this image to your assets
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
                            Icons.work_outline,
                            size: 80,
                            color: Colors.blue[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Work Pressure',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[300],
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
                    'Managing Work Pressure',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Work-related stress can affect your mental health, productivity, and overall well-being. Here are 15 effective strategies to help you manage workplace pressure and maintain balance.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Weekly Pressure Tracker
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[50]!,
                          Colors.blue[100]!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weekly Pressure',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // View detailed tracking
                              },
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDayPressure('M', 0.3),
                            _buildDayPressure('T', 0.5),
                            _buildDayPressure('W', 0.8),
                            _buildDayPressure('T', 0.7),
                            _buildDayPressure('F', 0.4),
                            _buildDayPressure('S', 0.2),
                            _buildDayPressure('S', 0.1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Tips Section
                  const Text(
                    '15 Tips to Manage Work Pressure',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Tips List
                  ...workPressureTips.map((tip) => TipCard(
                    tipNumber: tip['number'],
                    title: tip['title'],
                    description: tip['description'],
                    color: Colors.blue,
                  )),
                  
                  const SizedBox(height: 25),
                  
                  // Quick Tools Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFE1F5FE),
                          const Color(0xFFB3E5FC),
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
                          'Work-Life Balance Tools',
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
                              'Task Planner',
                              () {
                                // Navigate to task planner
                              },
                            ),
                            _buildQuickTool(
                              context,
                              Icons.access_time_outlined,
                              'Time Blocks',
                              () {
                                // Navigate to time blocking feature
                              },
                            ),
                            _buildQuickTool(
                              context,
                              Icons.auto_awesome_outlined,
                              'Micro-Breaks',
                              () {
                                // Navigate to micro-break timer
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

  Widget _buildDayPressure(String day, double level) {
    final height = 70.0 * level;
    final color = level < 0.3
        ? Colors.green[300]
        : level < 0.6
            ? Colors.amber[300]
            : Colors.red[300];

    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 8,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 8,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
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
              color: Colors.blue[300],
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
  final MaterialColor color;
  
  const TipCard({
    super.key,
    required this.tipNumber,
    required this.title,
    required this.description,
    required this.color,
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
              color: color[50],
              shape: BoxShape.circle,
            ),
            child: Text(
              tipNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color[400],
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

// List of work pressure tips
final List<Map<String, dynamic>> workPressureTips = [
  {
    'number': 1,
    'title': 'Set Clear Boundaries',
    'description': "Define working hours and stick to them. Let colleagues know when you're available and when you're not. Don't check emails during off hours.",
  },
  {
    'number': 2,
    'title': 'Prioritize Tasks Effectively',
    'description': 'Use methods like the Eisenhower Matrix to categorize tasks by urgency and importance. Focus on high-impact activities first.',
  },
  {
    'number': 3,
    'title': 'Learn to Delegate',
    'description': "Identify tasks that others can handle and trust them to do so. Delegation isn't offloading—it's strategic resource allocation.",
  },
  {
    'number': 4,
    'title': 'Practice Strategic Time Blocking',
    'description': 'Dedicate specific time blocks for different types of work. Include buffer time between blocks for unexpected issues.',
  },
  {
    'number': 5,
    'title': 'Take Regular Micro-Breaks',
    'description': 'Follow the 20-20-20 rule: every 20 minutes, look at something 20 feet away for 20 seconds. Stand up and stretch every hour.',
  },
  {
    'number': 6,
    'title': 'Master the Art of Saying No',
    'description': "Politely decline tasks that don't align with your priorities or when your plate is full. Suggest alternatives when possible.",
  },
  {
    'number': 7,
    'title': 'Implement the Two-Minute Rule',
    'description': 'If a task takes less than two minutes to complete, do it immediately rather than scheduling it for later.',
  },
  {
    'number': 8,
    'title': 'Create a Distraction-Free Zone',
    'description': 'Use noise-canceling headphones, silence notifications, and communicate your need for focus time to colleagues.',
  },
  {
    'number': 9,
    'title': 'Practice Mindful Communication',
    'description': 'Be clear and concise in emails and meetings. Ask clarifying questions to avoid misunderstandings that create additional work.',
  },
  {
    'number': 10,
    'title': 'Use the 4D Method for Emails',
    'description': 'For each email: Do it, Delegate it, Defer it, or Delete it. Aim to touch each email only once.',
  },
  {
    'number': 11,
    'title': 'Build Strategic Breaks into Your Day',
    'description': 'Schedule lunch away from your desk and take short walks. These reset your mind and improve afternoon productivity.',
  },
  {
    'number': 12,
    'title': 'Create Templates for Repetitive Tasks',
    'description': 'Develop templates for common emails, reports, and processes to save time and mental energy.',
  },
  {
    'number': 13,
    'title': 'Practice Progressive Muscle Relaxation',
    'description': 'Tense and then release each muscle group, starting from your toes and working up to your head, to release physical tension.',
  },
  {
    'number': 14,
    'title': 'Have Difficult Conversations Early',
    'description': 'Address issues with colleagues or unrealistic deadlines promptly before they escalate and create more pressure.',
  },
  {
    'number': 15,
    'title': 'Create End-of-Day Rituals',
    'description': "Review accomplishments, prepare tomorrow's to-do list, and perform a symbolic action that signals the end of work time.",
  },
];

// Don't forget to add this to your routes or navigation system
// Example:
// routes: {
//   '/work-pressure': (context) => const WorkPressurePage(),
// },