import 'package:flutter/material.dart';

class PeriodNutritionPlanPage extends StatelessWidget {
  const PeriodNutritionPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '7-Day Period Nutrition Plan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFFE57373),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image and Introduction
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://placehold.co/600x400/ffcdd2/e57373?text=Nutrition+During+Periods'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'Nourish Your Body During Your Cycle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Introduction Text
            Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'This 7-day nutrition plan is designed specifically to help balance hormones, reduce inflammation, and ease common period symptoms. Each day focuses on specific nutrients that your body needs most during different phases of your cycle.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            // Key Benefits Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xFFF9A825),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Key Benefits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildBenefitItem('Reduce inflammation and cramps'),
                  _buildBenefitItem('Balance hormones naturally'),
                  _buildBenefitItem('Improve energy levels'),
                  _buildBenefitItem('Support healthy blood flow'),
                  _buildBenefitItem('Minimize mood swings'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 7-Day Plan Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFFE57373),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '7-Day Nutrition Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 7-Day Plan Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              itemBuilder: (context, index) {
                return _buildDayCard(context, index + 1);
              },
            ),

            const SizedBox(height: 30),

            // Additional Tips
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFE57373).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFFE57373),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Remember',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Stay hydrated by drinking at least 8-10 glasses of water daily. Listen to your body and adjust portions based on your hunger levels. This plan is a guide - feel free to substitute with similar foods based on your preferences and availability.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFD32F2F),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, int day) {
    String title;
    String focus;
    Color color;
    IconData icon;

    switch (day) {
      case 1:
        title = 'Day 1: Iron Boost';
        focus = 'Focus: Replenish iron stores';
        color = const Color(0xFFEF9A9A);
        icon = Icons.fitness_center;
        break;
      case 2:
        title = 'Day 2: Anti-Inflammatory';
        focus = 'Focus: Reduce inflammation & cramps';
        color = const Color(0xFFF48FB1);
        icon = Icons.healing;
        break;
      case 3:
        title = 'Day 3: Magnesium Rich';
        focus = 'Focus: Ease muscle tension';
        color = const Color(0xFFCE93D8);
        icon = Icons.spa;
        break;
      case 4:
        title = 'Day 4: Hormone Balance';
        focus = 'Focus: Support hormone regulation';
        color = const Color(0xFF9FA8DA);
        icon = Icons.balance;
        break;
      case 5:
        title = 'Day 5: Energy Boost';
        focus = 'Focus: Combat fatigue';
        color = const Color(0xFF90CAF9);
        icon = Icons.bolt;
        break;
      case 6:
        title = 'Day 6: Mood Support';
        focus = 'Focus: Improve mood & mental clarity';
        color = const Color(0xFF80DEEA);
        icon = Icons.sentiment_satisfied_alt;
        break;
      case 7:
        title = 'Day 7: Recovery & Renewal';
        focus = 'Focus: Overall wellness & recovery';
        color = const Color(0xFFA5D6A7);
        icon = Icons.restart_alt;
        break;
      default:
        title = 'Day $day';
        focus = 'Focus: Balanced nutrition';
        color = Colors.grey;
        icon = Icons.restaurant;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyNutritionDetailPage(
                day: day,
                title: title,
                focus: focus,
                color: color,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
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
                    const SizedBox(height: 5),
                    Text(
                      focus,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Detailed page for each day's nutrition plan
class DailyNutritionDetailPage extends StatelessWidget {
  final int day;
  final String title;
  final String focus;
  final Color color;

  const DailyNutritionDetailPage({
    super.key,
    required this.day,
    required this.title,
    required this.focus,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Get meal plan and benefits based on the day
    final mealPlan = _getMealPlanForDay(day);
    final benefits = _getBenefitsForDay(day);
    final keyNutrients = _getKeyNutrientsForDay(day);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with day focus
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: color.withOpacity(0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    focus,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            // Key Nutrients Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Key Nutrients Today',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      children: keyNutrients.map((nutrient) {
                        return _buildNutrientItem(nutrient['name']!, nutrient['benefit']!);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Meal Plan Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Meal Plan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...mealPlan.map((meal) => _buildMealCard(meal)).toList(),
                ],
              ),
            ),

            // Benefits Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: benefits.map((benefit) {
                        return _buildBenefitItem(benefit);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Self-Care Tip
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: color,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Self-Care Tip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getSelfCareTipForDay(day),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientItem(String name, String benefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  benefit,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, String> meal) {
    IconData icon;
    switch (meal['time']) {
      case 'Breakfast':
        icon = Icons.wb_sunny;
        break;
      case 'Lunch':
        icon = Icons.light_mode;
        break;
      case 'Dinner':
        icon = Icons.nightlight_round;
        break;
      case 'Snack':
        icon = Icons.coffee;
        break;
      default:
        icon = Icons.restaurant;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                meal['time']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            meal['food']!,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          if (meal['tip'] != null && meal['tip']!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: color,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      meal['tip']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getMealPlanForDay(int day) {
    switch (day) {
      case 1:
        return [
          {
            'time': 'Breakfast',
            'food': 'Spinach omelet with whole grain toast and vitamin C-rich orange slices',
            'tip': 'The vitamin C helps with iron absorption from the spinach!'
          },
          {
            'time': 'Snack',
            'food': 'Trail mix with dried apricots, pumpkin seeds, and dark chocolate chips',
            'tip': ''
          },
          {
            'time': 'Lunch',
            'food': 'Quinoa bowl with lentils, roasted beets, and leafy greens topped with tahini dressing',
            'tip': 'This iron-rich combination helps replenish what lost during menstruatio'
          },
          {
            'time': 'Snack',
            'food': 'Smoothie with banana, strawberries and blackstrap molasses',
            'tip': 'Molasses is incredibly rich in iron'
          },
          {
            'time': 'Dinner',
            'food': 'Grass-fed beef stir fry with broccoli, bell peppers and brown rice',
            'tip': 'Red meat is one of the most bioavailable sources of iron'
          },
        ];
      case 2:
        return [
          {
            'time': 'Breakfast',
            'food': 'Anti-inflammatory turmeric oatmeal with cinnamon, ginger, berries and walnuts',
            'tip': 'Turmeric contains curcumin which has powerful anti-inflammatory effects'
          },
          {
            'time': 'Snack',
            'food': 'Pineapple chunks with a handful of almonds',
            'tip': 'Pineapple contains bromelain which helps reduce inflammation'
          },
          {
            'time': 'Lunch',
            'food': 'Ginger-turmeric salmon with leafy greens and sweet potatoes',
            'tip': 'Omega-3s in salmon are powerful anti-inflammatory compounds'
          },
          {
            'time': 'Snack',
            'food': 'Green tea with lemon and a small piece of dark chocolate',
            'tip': 'Green tea contains catechins that reduce inflammation'
          },
          {
            'time': 'Dinner',
            'food': 'Mediterranean bowl with chickpeas, olive oil, cucumbers, tomatoes and herbs',
            'tip': 'The Mediterranean diet pattern is associated with lower inflammation'
          },
        ];
      case 3:
        return [
          {
            'time': 'Breakfast',
            'food': 'Chia seed pudding with banana, almond butter and cacao nibs',
            'tip': 'Chia seeds are an excellent source of magnesium'
          },
          {
            'time': 'Snack',
            'food': 'A handful of Brazil nuts and dried figs',
            'tip': 'Just 2-3 Brazil nuts provide significant magnesium'
          },
          {
            'time': 'Lunch',
            'food': 'Avocado and black bean wrap with spinach and pumpkin seeds',
            'tip': 'Beans and dark leafy greens are magnesium powerhouses'
          },
          {
            'time': 'Snack',
            'food': 'Edamame with sea salt',
            'tip': ''
          },
          {
            'time': 'Dinner',
            'food': 'Brown rice bowl with grilled tofu, steamed kale, and sesame seeds',
            'tip': 'This meal is loaded with magnesium to ease muscle tension'
          },
        ];
      case 4:
        return [
          {
            'time': 'Breakfast',
            'food': 'Flaxseed porridge with berries, hemp seeds, and a drizzle of honey',
            'tip': 'Flax contains lignans that help balance estrogen levels'
          },
          {
            'time': 'Snack',
            'food': 'Apple slices with almond butter',
            'tip': ''
          },
          {
            'time': 'Lunch',
            'food': 'Lentil soup with cruciferous vegetables (broccoli, cauliflower) and herbs',
            'tip': 'Cruciferous vegetables help metabolize excess estrogen'
          },
          {
            'time': 'Snack',
            'food': 'Kombucha tea and seaweed snacks',
            'tip': 'Fermented foods support gut health which is crucial for hormone balance'
          },
          {
            'time': 'Dinner',
            'food': 'Wild-caught salmon with roasted Brussels sprouts and quinoa',
            'tip': 'This combination supports detoxification pathways for hormone balance'
          },
        ];
      case 5:
        return [
          {
            'time': 'Breakfast',
            'food': 'Energy-boosting smoothie with banana, spinach, almond milk, and nut butter',
            'tip': 'The combination of complex carbs and healthy fats provides sustained energy'
          },
          {
            'time': 'Snack',
            'food': 'Dates stuffed with almond butter',
            'tip': 'Natural sugars in dates provide a quick energy boost'
          },
          {
            'time': 'Lunch',
            'food': 'Grain bowl with farro, roasted sweet potatoes, black beans, and avocado',
            'tip': 'Iron, B vitamins and complex carbs combat fatigue'
          },
          {
            'time': 'Snack',
            'food': 'Greek yogurt with honey and berries',
            'tip': 'Protein-rich snacks help maintain stable blood sugar'
          },
          {
            'time': 'Dinner',
            'food': 'Baked chicken breast with herb-roasted vegetables and wild rice',
            'tip': 'Lean protein with complex carbs supports sustained energy'
          },
        ];
      case 6:
        return [
          {
            'time': 'Breakfast',
            'food': 'Whole grain toast with smashed avocado, eggs, and sprouts',
            'tip': 'Eggs contain choline which supports brain function and mood'
          },
          {
            'time': 'Snack',
            'food': 'Blueberries and walnuts',
            'tip': 'Both are brain-boosting foods that support cognitive function'
          },
          {
            'time': 'Lunch',
            'food': 'Tuna salad with leafy greens, olives, and whole grain crackers',
            'tip': 'Omega-3s in tuna support brain health and mood regulation'
          },
          {
            'time': 'Snack',
            'food': 'Dark chocolate square and green tea',
            'tip': 'The combination of theanine in tea and flavanols in chocolate supports mood'
          },
          {
            'time': 'Dinner',
            'food': 'Turkey and vegetable stir-fry with brown rice and ginger',
            'tip': 'Turkey contains tryptophan which helps produce serotonin for mood support'
          },
        ];
      case 7:
        return [
          {
            'time': 'Breakfast',
            'food': 'Green smoothie bowl with kale, banana, mango, and hemp seeds',
            'tip': 'Green vegetables help detoxify excess hormones'
          },
          {
            'time': 'Snack',
            'food': 'Pomegranate seeds and pistachios',
            'tip': 'Pomegranates are rich in antioxidants that support recovery'
          },
          {
            'time': 'Lunch',
            'food': 'Rainbow Buddha bowl with various vegetables, chickpeas, and turmeric dressing',
            'tip': 'A variety of colorful vegetables provides diverse nutrients for healing'
          },
          {
            'time': 'Snack',
            'food': 'Coconut yogurt with berries and a sprinkle of cinnamon',
            'tip': ''
          },
          {
            'time': 'Dinner',
            'food': 'Herb-baked fish with lemon, asparagus, and sweet potato',
            'tip': 'This balanced meal supports overall recovery and renewal'
          },
        ];
      default:
        return [];
    }
  }

  List<String> _getBenefitsForDay(int day) {
    switch (day) {
      case 1:
        return [
          'Replenishes iron lost during menstruation',
          'Prevents fatigue and weakness',
          'Supports healthy oxygen transport in the body',
          'Improves cognitive function and concentration',
          'Reduces the risk of anemia'
        ];
      case 2:
        return [
          'Reduces period pain and cramping',
          'Decreases bloating and water retention',
          'Lowers overall body inflammation',
          'Eases back pain and headaches',
          'Supports better sleep during your period'
        ];
      case 3:
        return [
          'Relaxes cramping muscles in the uterus',
          'Reduces tension and stress',
          'Helps prevent menstrual migraines',
          'Supports healthy nerve function',
          'May reduce PMS symptoms'
        ];
      case 4:
        return [
          'Helps balance estrogen and progesterone levels',
          'Regulates menstrual cycle length',
          'Reduces PMS symptoms',
          'Supports liver detoxification of hormones',
          'May help with hormonal acne'
        ];
      case 5:
        return [
          'Combats period-related fatigue',
          'Provides sustained energy throughout the day',
          'Supports healthy iron levels',
          'Improves focus and concentration',
          'Stabilizes blood sugar levels'
        ];
      case 6:
        return [
          'Reduces mood swings and irritability',
          'Supports production of feel-good neurotransmitters',
          'Improves mental clarity and focus',
          'May help reduce anxiety and depression symptoms',
          'Supports overall emotional wellbeing'
        ];
      case 7:
        return [
          'Supports overall hormonal balance',
          'Aids in detoxification after your period',
          'Replenishes nutrients lost during menstruation',
          'Boosts immune function',
          'Prepares body for the next cycle'
        ];
      default:
        return [];
    }
  }

  List<Map<String, String>> _getKeyNutrientsForDay(int day) {
    switch (day) {
      case 1:
        return [
          {
            'name': 'Iron',
            'benefit': 'Essential for red blood cell production, prevents anemia and fatigue'
          },
          {
            'name': 'Vitamin C',
            'benefit': 'Enhances iron absorption from plant foods'
          },
          {
            'name': 'B Vitamins',
            'benefit': 'Supports energy production and reduces fatigue'
          },
          {
            'name': 'Copper',
            'benefit': 'Works with iron for red blood cell formation'
          },
        ];
      case 2:
        return [
          {
            'name': 'Omega-3 Fatty Acids',
            'benefit': 'Reduces inflammation and period pain'
          },
          {
            'name': 'Curcumin (Turmeric)',
            'benefit': 'Powerful anti-inflammatory compound'
          },
          {
            'name': 'Ginger',
            'benefit': 'Helps reduce menstrual cramps and nausea'
          },
          {
            'name': 'Bromelain',
            'benefit': 'Enzyme in pineapple that fights inflammation'
          },
        ];
      case 3:
        return [
          {
            'name': 'Magnesium',
            'benefit': 'Natural muscle relaxant that eases cramps'
          },
          {
            'name': 'Calcium',
            'benefit': 'Works with magnesium for muscle function'
          },
          {
            'name': 'Vitamin B6',
            'benefit': 'Helps with magnesium absorption and use'
          },
          {
            'name': 'Potassium',
            'benefit': 'Reduces muscle cramps and supports fluid balance'
          },
        ];
      case 4:
        return [
          {
            'name': 'Fiber',
            'benefit': 'Helps remove excess estrogen from the body'
          },
          {
            'name': 'Phytoestrogens',
            'benefit': 'Plant compounds that help balance hormones'
          },
          {
            'name': 'DIM (Diindolylmethane)',
            'benefit': 'Found in cruciferous vegetables, helps metabolize estrogen'
          },
          {
            'name': 'Probiotics',
            'benefit': 'Support gut health which is crucial for hormone balance'
          },
        ];
      case 5:
        return [
          {
            'name': 'B Complex Vitamins',
            'benefit': 'Essential for energy production and reducing fatigue'
          },
          {
            'name': 'Complex Carbohydrates',
            'benefit': 'Provide sustained energy throughout the day'
          },
          {
            'name': 'Iron',
            'benefit': 'Crucial for energy and combating period fatigue'
          },
          {
            'name': 'CoQ10',
            'benefit': 'Supports cellular energy production'
          },
        ];
      case 6:
        return [
          {
            'name': 'Tryptophan',
            'benefit': 'Amino acid that helps produce serotonin for mood support'
          },
          {
            'name': 'Vitamin D',
            'benefit': 'Linked to mood regulation and reducing depression'
          },
          {
            'name': 'Omega-3s',
            'benefit': 'Support brain health and reduce inflammation'
          },
          {
            'name': 'Zinc',
            'benefit': 'Helps regulate brain function and neurotransmitters'
          },
        ];
      case 7:
        return [
          {
            'name': 'Antioxidants',
            'benefit': 'Fight oxidative stress and support recovery'
          },
          {
            'name': 'Vitamin E',
            'benefit': 'Supports skin health and tissue repair'
          },
          {
            'name': 'Selenium',
            'benefit': 'Supports detoxification and immune function'
          },
          {
            'name': 'Polyphenols',
            'benefit': 'Plant compounds that support overall health'
          },
        ];
      default:
        return [];
    }
  }

  String _getSelfCareTipForDay(int day) {
    switch (day) {
      case 1:
        return 'Take it easy today and prioritize rest. Consider using a heating pad on your abdomen to ease cramps. Stay hydrated with warm water with lemon to support iron absorption.';
      case 2:
        return 'Try gentle stretching or yoga poses that open the hips and lower back to further reduce inflammation. Avoid alcohol and caffeine which can worsen inflammation.';
      case 3:
        return 'Consider taking a warm Epsom salt bath tonight, as the magnesium sulfate can be absorbed through the skin and help relax muscles even further.';
      case 4:
        return 'Practice stress management today, as stress affects hormone balance. Try 10 minutes of deep breathing or meditation, focusing on your abdomen.';
      case 5:
        return 'Balance activity with rest today. A short 15-minute walk can boost energy, but don\'t push yourself too hard. Listen to your body\'s cues.';
      case 6:
        return 'Make time for activities that bring you joy today. Connecting with loved ones, journaling, or enjoying nature can all boost mood naturally.';
      case 7:
        return 'Focus on quality sleep tonight to support your body\'s recovery process. Try to get to bed early and create a peaceful bedtime routine.';
      default:
        return 'Practice self-compassion and listen to your body\'s needs today.';
    }
  }
}

// This would be your main file that runs the app
/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Nutrition App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFFE57373),
        fontFamily: 'Roboto',
      ),
      home: const PeriodNutritionPlanPage(),
    );
  }
}
*/