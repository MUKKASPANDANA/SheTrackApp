import 'package:flutter/material.dart';

class SocialPressurePage extends StatelessWidget {
  const SocialPressurePage({Key? key}) : super(key: key);

  // Defining color scheme constants to maintain the original design
  static const Color primaryColor = Color(0xFF6A7B76);    // Muted sage green
  static const Color secondaryColor = Color(0xFFD49A6A);  // Warm terracotta
  static const Color tertiaryColor = Color(0xFF9E7B9B);   // Soft lavender
  static const Color backgroundColor = Color(0xFFF6F4F1); // Soft cream

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Managing Social Pressure'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              color: primaryColor.withOpacity(0.8),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.balance,  // Balance icon representing equilibrium in social situations
                        size: 200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield,  // Shield icon representing protection from pressure
                          size: 70,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Managing Social Pressure",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Stand your ground",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '15 Tips to Handle Social Pressure',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SocialPressureTipsList(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SelfAffirmationDialog();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.spa),  // Spa icon representing self-care
                label: const Text(
                  'Self-Affirmation Exercise',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class SelfAffirmationDialog extends StatefulWidget {
  const SelfAffirmationDialog({Key? key}) : super(key: key);

  @override
  State<SelfAffirmationDialog> createState() => _SelfAffirmationDialogState();
}

class _SelfAffirmationDialogState extends State<SelfAffirmationDialog> {
  final List<String> _affirmations = [
    "I am worthy of respect and acceptance.",
    "I have the right to set my own boundaries.",
    "My worth is not determined by others' opinions.",
    "I trust my own judgment and decisions.",
    "It's okay to say no without feeling guilty.",
    "I deserve to be treated with kindness and respect.",
    "I am enough just as I am.",
    "I choose who I want to be.",
  ];
  
  int _currentIndex = 0;

  void _nextAffirmation() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _affirmations.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Self-Affirmation',
        textAlign: TextAlign.center,
        style: TextStyle(color: SocialPressurePage.primaryColor),
      ),
      content: SizedBox(
        height: 200,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SocialPressurePage.tertiaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _affirmations[_currentIndex],
                style: const TextStyle(
                  fontSize: 18,
                  color: SocialPressurePage.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: _nextAffirmation,
              style: OutlinedButton.styleFrom(
                foregroundColor: SocialPressurePage.secondaryColor,
                side: const BorderSide(color: SocialPressurePage.secondaryColor),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Next Affirmation'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: SocialPressurePage.primaryColor,
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class SocialPressureTipsList extends StatelessWidget {
  const SocialPressureTipsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> socialPressureTips = [
      {
        'title': '1. Know Your Values',
        'icon': Icons.star,
        'description': 
            'Clearly define what matters to you. When you know your personal values, it\'s easier to make decisions that align with them despite external pressure.'
      },
      {
        'title': '2. Practice Saying No',
        'icon': Icons.do_not_disturb_alt,
        'description': 
            'Rehearse polite but firm ways to decline invitations or requests that don\'t align with your values or boundaries.'
      },
      {
        'title': '3. Develop a Support System',
        'icon': Icons.handshake,
        'description': 
            'Surround yourself with friends who respect your choices and encourage your authenticity.'
      },
      {
        'title': '4. Prepare Responses in Advance',
        'icon': Icons.assignment,
        'description': 
            'Have ready answers for common pressure situations so you don\'t feel caught off guard.'
      },
      {
        'title': '5. Use the "Broken Record" Technique',
        'icon': Icons.repeat,
        'description': 
            'Calmly repeat your position without feeling the need to over-explain or justify yourself.'
      },
      {
        'title': '6. Practice Self-Awareness',
        'icon': Icons.visibility,
        'description': 
            'Recognize when you\'re feeling pressured and identify the physical and emotional signs so you can address them.'
      },
      {
        'title': '7. Remove Yourself from Situations',
        'icon': Icons.exit_to_app,
        'description': 
            'It\'s okay to leave environments where you feel uncomfortable or excessively pressured.'
      },
      {
        'title': '8. Focus on Long-Term Goals',
        'icon': Icons.trending_up,
        'description': 
            'Remember your long-term objectives and how giving in to short-term social pressure might affect them.'
      },
      {
        'title': '9. Challenge Cognitive Distortions',
        'icon': Icons.psychology,
        'description': 
            'Notice when you\'re catastrophizing ("Everyone will hate me if I don\'t go") and reframe these thoughts realistically.'
      },
      {
        'title': '10. Practice Mindfulness',
        'icon': Icons.self_improvement,
        'description': 
            'Stay present and aware of your feelings without immediately reacting to pressure from others.'
      },
      {
        'title': '11. Strengthen Your Self-Esteem',
        'icon': Icons.fitness_center,
        'description': 
            'Engage in activities that build your confidence and sense of self-worth outside of social validation.'
      },
      {
        'title': '12. Use Humor',
        'icon': Icons.sentiment_very_satisfied,
        'description': 
            'Sometimes a light-hearted response can deflect pressure without creating conflict.'
      },
      {
        'title': '13. Seek Professional Help',
        'icon': Icons.medical_services,
        'description': 
            'If social pressure consistently causes you distress, consider talking to a therapist or counselor.'
      },
      {
        'title': '14. Practice Self-Compassion',
        'icon': Icons.favorite,
        'description': 
            'Be kind to yourself when you give in to pressure. Learn from the experience rather than engaging in self-criticism.'
      },
      {
        'title': '15. Remember It\'s Your Life',
        'icon': Icons.person,
        'description': 
            'Ultimately, you are the one who has to live with the consequences of your decisions, not those pressuring you.'
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: socialPressureTips.length,
      itemBuilder: (context, index) {
        final isEven = index % 2 == 0;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 1,
          color: isEven ? Colors.white : SocialPressurePage.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: SocialPressurePage.primaryColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ExpansionTile(
            leading: Icon(
              socialPressureTips[index]['icon'],
              color: SocialPressurePage.secondaryColor,
            ),
            title: Text(
              socialPressureTips[index]['title'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: SocialPressurePage.primaryColor,
              ),
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            iconColor: SocialPressurePage.tertiaryColor,
            children: [
              Text(
                socialPressureTips[index]['description'],
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}