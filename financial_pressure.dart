import 'package:flutter/material.dart';

class FinancialWellnessPage extends StatelessWidget {
  const FinancialWellnessPage({Key? key}) : super(key: key);

  // Define a different color palette - using purple tones
  static const Color primaryColor = Color(0xFF7B1FA2); // Deep purple
  static const Color secondaryColor = Color(0xFFF3E5F5); // Light purple background
  static const Color accentColor = Color(0xFFAB47BC); // Medium purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Replace Image.asset with Icon to avoid the asset loading issue
            Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'Financial Wellness',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: secondaryColor,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header Image - Using NetworkImage like in the original code
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.pexels.com/photos/164474/pexels-photo-164474.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withOpacity(0.1),
                      primaryColor.withOpacity(0.6),
                    ],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Financial Self-Care',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            const Center(
              child: Text(
                'Financial Wellness Tips During Your Cycle',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            
            // Subtitle
            Center(
              child: Text(
                'Managing your finances can be particularly challenging during hormonal fluctuations',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // Financial tips
            ...financialTips.map((tip) => _buildTipCard(tip)).toList(),
            
            const SizedBox(height: 20),
            
            // Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.download, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Save Financial Tips',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    // Alternate between even and odd indices for card style
    final bool isEvenTip = financialTips.indexOf(tip) % 2 == 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isEvenTip ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: isEvenTip ? null : Border.all(color: accentColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  tip['icon'],
                  color: isEvenTip ? Colors.white : accentColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isEvenTip ? Colors.white : primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tip['description'],
              style: TextStyle(
                fontSize: 16,
                color: isEvenTip ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Financial tips data with icons, modified for women's health context
final List<Map<String, dynamic>> financialTips = [
  {
    'title': 'Budget for Self-Care',
    'description': 'Set aside funds specifically for period-related comfort items like heating pads, pain relievers, and healthy snacks.',
    'icon': Icons.spa,
  },
  {
    'title': 'Plan for Cravings',
    'description': 'Budget for occasional treats during your period while maintaining financial discipline.',
    'icon': Icons.cake,
  },
  {
    'title': 'Schedule Financial Tasks',
    'description': 'Handle complex financial decisions during your follicular phase when cognitive function is at its peak.',
    'icon': Icons.event_note,
  },
  {
    'title': 'Track Emotional Spending',
    'description': 'Note any correlation between your cycle phases and impulse purchases to identify patterns.',
    'icon': Icons.timeline,
  },
  {
    'title': 'Automate Bill Payments',
    'description': 'Set up automatic payments to reduce stress and avoid late fees, especially during high-symptom days.',
    'icon': Icons.sync,
  },
  {
    'title': 'Create a "Period Fund"',
    'description': 'Save a small amount each month for period products, medications, and comfort items.',
    'icon': Icons.account_balance_wallet,
  },
  {
    'title': 'Switch to Reusable Products',
    'description': 'Consider menstrual cups, period underwear, or cloth pads for long-term savings.',
    'icon': Icons.repeat,
  },
  {
    'title': 'Use the 24-Hour Rule',
    'description': 'Wait a day before making non-essential purchases, especially during PMS when impulse control may be lower.',
    'icon': Icons.timer,
  },
  {
    'title': 'Meal Prep During High Energy Days',
    'description': 'Prepare meals when you have more energy to avoid expensive takeout during low-energy phases.',
    'icon': Icons.restaurant,
  },
  {
    'title': 'Review Health Insurance Coverage',
    'description': 'Ensure your plan covers women\'s health needs, including gynecological visits and contraceptives.',
    'icon': Icons.security,
  },
  {
    'title': 'Set Cycle-Aware Financial Goals',
    'description': 'Plan financial goals that account for your energy fluctuations throughout your cycle.',
    'icon': Icons.flag,
  },
  {
    'title': 'Invest in Your Health',
    'description': 'View spending on nutritious food and exercise as investments in reducing period symptoms long-term.',
    'icon': Icons.trending_up,
  },
  {
    'title': 'Practice Mindful Spending',
    'description': 'Take deep breaths before purchasing and ask if this item will truly improve your wellbeing.',
    'icon': Icons.favorite_border,
  },
  {
    'title': 'Build a Support Network',
    'description': 'Connect with others who understand the financial impact of women\'s health issues.',
    'icon': Icons.people,
  },
  {
    'title': 'Focus on Financial Self-Compassion',
    'description': 'Be kind to yourself about financial decisions, especially during hormonal fluctuations.',
    'icon': Icons.favorite,
  },
];