import 'package:flutter/material.dart';

class FamilyPressurePage extends StatelessWidget {
  const FamilyPressurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Family Issues',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD1C4E9),
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
                color: Color(0xFFD1C4E9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/family_pressure.png', // Make sure to add this image to your assets
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
                            Icons.family_restroom,
                            size: 80,
                            color: Colors.deepPurple[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Family Issues',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[300],
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
                    'Managing Family Pressure',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Family relationships can be both a source of support and stress. Learning to navigate expectations, conflicts, and boundaries is essential for maintaining your well-being and healthy relationships.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Quick Breathing Exercise
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple[50]!,
                          Colors.deepPurple[100]!,
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
                          'Before Family Gatherings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Take a moment to center yourself with this quick breathing exercise:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Start breathing exercise
                              },
                              icon: const Icon(Icons.air),
                              label: const Text('Start 1-Minute Breathing'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple[300],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Tips Section
                  const Text(
                    '15 Tips to Manage Family Pressure',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Tips List
                  ...familyPressureTips.map((tip) => TipCard(
                    tipNumber: tip['number'],
                    title: tip['title'],
                    description: tip['description'],
                    color: Colors.deepPurple,
                  )),
                  
                  const SizedBox(height: 25),
                  
                  // Affirmation Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.deepPurple[200]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '❝',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.deepPurple[300],
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'I have the right to set boundaries that protect my well-being, even with family members I love.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Daily Affirmation',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepPurple[300],
                          ),
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

// List of family pressure tips
final List<Map<String, dynamic>> familyPressureTips = [
  {
    'number': 1,
    'title': 'Set Clear Boundaries',
    'description': 'Define what behaviors you will and won\'t accept. Communicate these boundaries calmly but firmly, and be consistent in enforcing them.',
  },
  {
    'number': 2,
    'title': 'Practice Active Listening',
    'description': 'When family conflicts arise, focus on truly understanding others\' perspectives before responding. Repeat back what you\'ve heard to confirm understanding.',
  },
  {
    'number': 3,
    'title': 'Use "I" Statements',
    'description': 'Frame concerns as "I feel..." rather than "You always..." to reduce defensiveness and open genuine communication channels.',
  },
  {
    'number': 4,
    'title': 'Schedule Regular Alone Time',
    'description': 'Even when living with family, designate specific time for yourself to recharge. Make this non-negotiable personal time.',
  },
  {
    'number': 5,
    'title': 'Recognize Cultural Factors',
    'description': 'Acknowledge how cultural expectations influence family dynamics. Consider which traditions you want to honor and which you may want to adapt.',
  },
  {
    'number': 6,
    'title': 'Prepare for Triggering Situations',
    'description': 'Before family gatherings, identify potential triggers and plan calm responses. Consider having an exit strategy for overwhelming situations.',
  },
  {
    'number': 7,
    'title': 'Manage Expectations',
    'description': 'Adjust expectations about family members\' behavior to avoid disappointment. Accept that you cannot change others, only your response to them.',
  },
  {
    'number': 8,
    'title': 'Build a Support Network',
    'description': 'Develop relationships outside your family who can provide perspective and emotional support during difficult family situations.',
  },
  {
    'number': 9,
    'title': 'Practice Selective Engagement',
    'description': 'Choose which topics to engage with and which to redirect. Not every family disagreement requires your participation.',
  },
  {
    'number': 10,
    'title': 'Use Time-Limited Visits',
    'description': 'For stressful family situations, consider setting a specific duration for visits or calls rather than open-ended engagements.',
  },
  {
    'number': 11,
    'title': 'Identify Your Stress Responses',
    'description': 'Notice how your body signals family stress (tension, headaches, etc.) and use these as cues to implement self-care strategies.',
  },
  {
    'number': 12,
    'title': 'Develop Clear Communication',
    'description': 'Practice expressing needs directly rather than expecting family members to intuit them. Be specific about what would be helpful.',
  },
  {
    'number': 13,
    'title': 'Create New Traditions',
    'description': 'Establish new family rituals that promote positive interaction and minimize tension around old patterns or expectations.',
  },
  {
    'number': 14,
    'title': 'Practice Self-Compassion',
    'description': 'Be kind to yourself when family interactions don\'t go as hoped. Acknowledge that family relationships are complex for everyone.',
  },
  {
    'number': 15,
    'title': 'Seek Professional Help When Needed',
    'description': 'Consider family therapy or individual counseling for persistent family issues that significantly impact your well-being.',
  },
];

// Don't forget to add this to your routes or navigation system
// Example:
// routes: {
//   '/family-pressure': (context) => const FamilyPressurePage(),
// },