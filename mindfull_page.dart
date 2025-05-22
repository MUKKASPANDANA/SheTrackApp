import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class EmpowermentCard {
  final String title;
  final String quote;
  final String activity;
  final Color backgroundColor;
  final IconData iconData;

  const EmpowermentCard({
    required this.title,
    required this.quote,
    required this.activity,
    required this.backgroundColor,
    required this.iconData,
  });
}

class BreathingExercise {
  final String name;
  final String description;
  final int inhaleCount;
  final int holdCount;
  final int exhaleCount;
  final int pauseCount;
  final Color color;

  const BreathingExercise({
    required this.name,
    required this.description,
    required this.inhaleCount,
    required this.holdCount,
    required this.exhaleCount,
    required this.pauseCount,
    required this.color,
  });
}

class MindfulnessPage extends StatefulWidget {
  const MindfulnessPage({Key? key}) : super(key: key);

  @override
  State<MindfulnessPage> createState() => _MindfulnessPageState();
}

class _MindfulnessPageState extends State<MindfulnessPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPage = 0;
  
  // Journal
  late TextEditingController _journalController;
  String _journalPrompt = "What are you grateful for today?";
  List<Map<String, String>> _journalEntries = [];
  
  // Breathing exercise
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  int _breathingPhase = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
  int _breathCount = 0;
  bool _isBreathingActive = false;
  String _breathingText = "Tap to start";
  
  // Card animation
  late AnimationController _cardAnimationController;
  late Animation<double> _cardScaleAnimation;
  
  final List<EmpowermentCard> _cards = [
    EmpowermentCard(
      title: "Embrace Your Cycle",
      quote: "Your menstrual cycle is a powerful rhythm that connects you to nature's own cycles. Embrace this time as sacred.",
      activity: "Practice gratitude for your body's natural wisdom",
      backgroundColor: Color(0xFFF8BBD0),
      iconData: Icons.favorite,
    ),
    EmpowermentCard(
      title: "Inner Strength",
      quote: "The strength of a woman is not measured by the impact that all her hardships have had on her; it's measured by the extent of her refusal to allow those hardships to dictate who she becomes.",
      activity: "Practice positive affirmations for 2 minutes",
      backgroundColor: Color(0xFFBBDEFB),
      iconData: Icons.psychology,
    ),
    EmpowermentCard(
      title: "Honor Your Feelings",
      quote: "Your emotions during your cycle are valid messengers. Neither suppress nor be consumed by them - simply observe and honor their presence.",
      activity: "Try a guided emotional awareness meditation",
      backgroundColor: Color(0xFFFFCCBC),
      iconData: Icons.spa,
    ),
    EmpowermentCard(
      title: "Mindful Movement",
      quote: "Movement is medicine. Listen to what your body needs today.",
      activity: "Try these 3 gentle yoga poses for menstrual comfort",
      backgroundColor: Color(0xFFD1C4E9),
      iconData: Icons.self_improvement,
    ),
    EmpowermentCard(
      title: "Emotional Balance",
      quote: "Your hormones may fluctuate, but your worth never does. Honor all your emotions today.",
      activity: "Take 5 deep breaths when feeling overwhelmed",
      backgroundColor: Color(0xFFFFE0B2),
      iconData: Icons.balance,
    ),
    EmpowermentCard(
      title: "Rest Without Guilt",
      quote: "Rest is not lazy. Rest is essential. Your body is working hard, even when you're still.",
      activity: "Schedule a 20-minute power nap or meditation today",
      backgroundColor: Color(0xFFB2DFDB),
      iconData: Icons.nightlight_round,
    ),
    EmpowermentCard(
      title: "Nurture Your Body",
      quote: "The way you speak to your body matters. Choose words of kindness and appreciation.",
      activity: "Take a warm bath with essential oils",
      backgroundColor: Color(0xFFC8E6C9),
      iconData: Icons.water_drop,
    ),
    EmpowermentCard(
      title: "Cyclical Wisdom",
      quote: "Each phase of your cycle brings different gifts. Learn to harness the unique energy of today.",
      activity: "Reflect on what your body is telling you now",
      backgroundColor: Color(0xFFE1BEE7),
      iconData: Icons.loop,
    ),
  ];

  final List<BreathingExercise> _breathingExercises = [
    BreathingExercise(
      name: "4-7-8 Breathing",
      description: "Calms the nervous system and helps with anxiety and sleep",
      inhaleCount: 4,
      holdCount: 7,
      exhaleCount: 8,
      pauseCount: 0,
      color: Colors.blue[100]!,
    ),
    BreathingExercise(
      name: "Box Breathing",
      description: "Reduces stress and improves concentration",
      inhaleCount: 4,
      holdCount: 4,
      exhaleCount: 4,
      pauseCount: 4,
      color: Colors.green[100]!,
    ),
    BreathingExercise(
      name: "Calming Breath",
      description: "Helps with cramps and tension during your period",
      inhaleCount: 5,
      holdCount: 2,
      exhaleCount: 7,
      pauseCount: 0,
      color: Colors.purple[100]!,
    ),
    BreathingExercise(
      name: "Energizing Breath",
      description: "Helps with fatigue and low energy",
      inhaleCount: 6,
      holdCount: 0,
      exhaleCount: 4,
      pauseCount: 0,
      color: Colors.orange[100]!,
    ),
  ];

  final List<String> _journalPrompts = [
    "What emotions have you experienced today? How are they connected to your cycle?",
    "What are three ways you can honor your body today?",
    "How has your menstrual cycle taught you about your own strength?",
    "What self-care activities make you feel most nourished during your period?",
    "How can you better listen to what your body needs right now?",
    "Write a love letter to your body, acknowledging all it does for you.",
    "What are you grateful for in this moment?",
    "What wisdom has your cycle brought you that you'd like to remember?",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
    _journalController = TextEditingController();
    
    // Setup breathing animation
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut)
    );
    
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextBreathingPhase();
      } else if (status == AnimationStatus.dismissed) {
        _nextBreathingPhase();
      }
    });
    
    // Card animation controller
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _cardScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeOutBack)
    );
    
    _cardAnimationController.forward();
  }

  void _nextBreathingPhase() {
    if (!_isBreathingActive) return;
    
    setState(() {
      BreathingExercise exercise = _breathingExercises[_breathCount % _breathingExercises.length];
      
      switch (_breathingPhase) {
        case 0: // Inhale completed -> Hold
          _breathingPhase = 1;
          _breathingText = "Hold";
          if (exercise.holdCount > 0) {
            _breathingController.duration = Duration(seconds: exercise.holdCount);
            _breathingController.forward(from: 0);
          } else {
            _nextBreathingPhase(); // Skip hold if holdCount is 0
          }
          break;
        case 1: // Hold completed -> Exhale
          _breathingPhase = 2;
          _breathingText = "Exhale";
          _breathingController.duration = Duration(seconds: exercise.exhaleCount);
          _breathingController.reverse(from: 1);
          break;
        case 2: // Exhale completed -> Pause or next breath
          if (exercise.pauseCount > 0) {
            _breathingPhase = 3;
            _breathingText = "Rest";
            _breathingController.duration = Duration(seconds: exercise.pauseCount);
            _breathingController.forward(from: 0);
          } else {
            _breathCount++;
            _breathingPhase = 0;
            _breathingText = "Inhale";
            _breathingController.duration = Duration(seconds: exercise.inhaleCount);
            _breathingController.forward(from: 0);
          }
          break;
        case 3: // Pause completed -> Next breath
          _breathCount++;
          _breathingPhase = 0;
          _breathingText = "Inhale";
          _breathingController.duration = Duration(seconds: exercise.inhaleCount);
          _breathingController.forward(from: 0);
          break;
      }
    });
  }

  void _startBreathingExercise(BreathingExercise exercise) {
    setState(() {
      _isBreathingActive = true;
      _breathingPhase = 0;
      _breathCount = 0;
      _breathingText = "Inhale";
      _breathingController.duration = Duration(seconds: exercise.inhaleCount);
      _breathingController.forward(from: 0);
    });
  }

  void _stopBreathingExercise() {
    setState(() {
      _isBreathingActive = false;
      _breathingController.stop();
      _breathingText = "Tap to start";
    });
  }

  void _saveJournalEntry() {
    if (_journalController.text.trim().isEmpty) return;
    
    setState(() {
      _journalEntries.add({
        'date': DateFormat('MMM d, yyyy').format(DateTime.now()),
        'prompt': _journalPrompt,
        'entry': _journalController.text,
      });
      _journalController.clear();
      _journalPrompt = _journalPrompts[math.Random().nextInt(_journalPrompts.length)];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Journal entry saved'),
        backgroundColor: Colors.purple[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDetailedActivity(BuildContext context, EmpowermentCard card) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'cardIcon${card.title}',
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: card.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        card.iconData,
                        size: 30,
                        color: Colors.deepPurple[700],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      card.title,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: card.backgroundColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  card.quote,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: Colors.deepPurple[900],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "Activity",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
              SizedBox(height: 16),
              _buildActivityContent(card),
              SizedBox(height: 32),
              Text(
                "Benefits",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
              SizedBox(height: 16),
              _buildBenefitsList(card),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Activity completed! Well done.'),
                      backgroundColor: Colors.purple[700],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Text("Mark as Complete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityContent(EmpowermentCard card) {
    // Expanded activity content based on the card title
    String activityDescription;
    List<Widget> activitySteps = [];
    
    switch (card.title) {
      case "Embrace Your Cycle":
        activityDescription = "Take 5 minutes to journal about the strengths and wisdom your cycle brings. Consider how each phase offers different types of energy and gifts.";
        activitySteps = [
          _buildActivityStep(1, "Find a quiet space where you won't be disturbed"),
          _buildActivityStep(2, "Place your hand on your lower abdomen and take 3 deep breaths"),
          _buildActivityStep(3, "Mentally thank your body for its wisdom and cycles"),
          _buildActivityStep(4, "Journal about how your cycle connects you to natural rhythms"),
        ];
        break;
      case "Inner Strength":
        activityDescription = "Affirmations help rewire negative thought patterns. Choose one that resonates with you and repeat it while focusing on your breath.";
        activitySteps = [
          _buildActivityStep(1, "Sit comfortably with your back straight"),
          _buildActivityStep(2, "Close your eyes and take 3 deep breaths"),
          _buildActivityStep(3, "Repeat: \"I am strong. I am resilient. I honor my body's wisdom.\""),
          _buildActivityStep(4, "Continue for 2 minutes, focusing on truly believing these words"),
        ];
        break;
      case "Honor Your Feelings":
        activityDescription = "This short meditation helps you acknowledge emotions without judgment, especially helpful during hormonal shifts.";
        activitySteps = [
          _buildActivityStep(1, "Find a comfortable seated position"),
          _buildActivityStep(2, "Close your eyes and scan your body for sensations"),
          _buildActivityStep(3, "Notice any emotions present without judging them"),
          _buildActivityStep(4, "Breathe into any areas of tension for 5-10 minutes"),
        ];
        break;
      case "Mindful Movement":
        activityDescription = "These gentle poses help relieve menstrual discomfort while honoring your body's needs.";
        activitySteps = [
          _buildActivityStep(1, "Child's pose: Kneel and fold forward with arms stretched out"),
          _buildActivityStep(2, "Supine twist: Lie on your back and gently twist to each side"),
          _buildActivityStep(3, "Legs up the wall: Lie with legs extended up against a wall"),
          _buildActivityStep(4, "Hold each pose for 1-3 minutes, breathing deeply"),
        ];
        break;
      case "Emotional Balance":
        activityDescription = "When emotions feel overwhelming, this breathing technique helps restore balance and calm.";
        activitySteps = [
          _buildActivityStep(1, "Stop what you're doing when you feel overwhelmed"),
          _buildActivityStep(2, "Place one hand on your heart, one on your belly"),
          _buildActivityStep(3, "Inhale for 4 counts, exhale for 6"),
          _buildActivityStep(4, "Repeat 5 times, feeling your emotions settle"),
        ];
        break;
      case "Rest Without Guilt":
        activityDescription = "Intentional rest is productive and healing, especially during menstruation when your body needs extra care.";
        activitySteps = [
          _buildActivityStep(1, "Find a quiet, comfortable place to lie down"),
          _buildActivityStep(2, "Set a timer for 20 minutes"),
          _buildActivityStep(3, "Allow yourself to rest fully, without checking your phone"),
          _buildActivityStep(4, "If thoughts of productivity arise, remind yourself this rest is necessary"),
        ];
        break;
      case "Nurture Your Body":
        activityDescription = "A warm bath with essential oils can ease cramping, boost mood, and provide a moment of self-care.";
        activitySteps = [
          _buildActivityStep(1, "Fill a bath with warm (not hot) water"),
          _buildActivityStep(2, "Add 5-7 drops of lavender or clary sage essential oil"),
          _buildActivityStep(3, "Soak for 15-20 minutes, breathing deeply"),
          _buildActivityStep(4, "As you soak, mentally thank your body for all it does"),
        ];
        break;
      case "Cyclical Wisdom":
        activityDescription = "Each phase of your cycle brings different energies and wisdom. This practice helps you tune into your current phase.";
        activitySteps = [
          _buildActivityStep(1, "Sit quietly and place your hands on your lower abdomen"),
          _buildActivityStep(2, "Take 5 deep breaths, focusing on this area"),
          _buildActivityStep(3, "Ask yourself: What does my body need today?"),
          _buildActivityStep(4, "Listen for the answer and commit to honoring it"),
        ];
        break;
      default:
        activityDescription = "Take a few moments to practice this activity mindfully.";
        activitySteps = [
          _buildActivityStep(1, "Find a quiet space"),
          _buildActivityStep(2, "Take a few deep breaths"),
          _buildActivityStep(3, "Focus on the present moment"),
          _buildActivityStep(4, "Reflect on how you feel afterward"),
        ];
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activityDescription,
          style: GoogleFonts.poppins(
            fontSize: 16,
            height: 1.5,
            color: Colors.purple[900],
          ),
        ),
        SizedBox(height: 20),
        ...activitySteps,
      ],
    );
  }

  Widget _buildActivityStep(int number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple[700],
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.4,
                color: Colors.purple[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsList(EmpowermentCard card) {
    // Benefits based on card title
    List<String> benefits;
    
    switch (card.title) {
      case "Embrace Your Cycle":
        benefits = [
          "Decreased period shame and improved body image",
          "Better understanding of your unique cycle patterns",
          "Increased connection to your body's wisdom",
          "Reduced stress around menstruation"
        ];
        break;
      case "Inner Strength":
        benefits = [
          "Improved emotional resilience during hormonal shifts",
          "Reduced negative self-talk during your period",
          "Increased self-compassion and body acceptance",
          "Better stress management throughout your cycle"
        ];
        break;
      case "Honor Your Feelings":
        benefits = [
          "Decreased emotional overwhelm during PMS",
          "Better emotional regulation throughout your cycle",
          "Increased self-awareness of emotional patterns",
          "Improved relationship with cyclical emotions"
        ];
        break;
      case "Mindful Movement":
        benefits = [
          "Reduced menstrual cramping and discomfort",
          "Improved blood flow and decreased bloating",
          "Better sleep quality during your period",
          "Gentle endorphin release for natural pain relief"
        ];
        break;
      case "Emotional Balance":
        benefits = [
          "Reduced anxiety and emotional volatility",
          "Increased emotional awareness and regulation",
          "Better stress response during hormonal shifts",
          "Improved ability to communicate needs during your period"
        ];
        break;
      case "Rest Without Guilt":
        benefits = [
          "Reduced fatigue and increased energy conservation",
          "Better recovery during menstruation",
          "Decreased stress hormones that can worsen period symptoms",
          "Improved mood and mental clarity"
        ];
        break;
      case "Nurture Your Body":
        benefits = [
          "Reduced menstrual cramping through warm water therapy",
          "Decreased muscle tension often associated with periods",
          "Improved sleep quality following the bath",
          "Increased mind-body connection and body appreciation"
        ];
        break;
      case "Cyclical Wisdom":
        benefits = [
          "Better alignment of activities with your cycle's phases",
          "Increased productivity by working with, not against, your hormones",
          "Improved body literacy and cycle awareness",
          "Enhanced intuition and connection to your body's signals"
        ];
        break;
      default:
        benefits = [
          "Reduced stress and anxiety",
          "Improved well-being and self-awareness",
          "Better connection to your body",
          "Enhanced mindfulness in daily life"
        ];
    }
    
    return Column(
      children: benefits.map((benefit) => _buildBenefitItem(benefit)).toList(),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.purple[700],
            size: 22,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.4,
                color: Colors.purple[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showJournalHistory(BuildContext context) {
    if (_journalEntries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No journal entries yet. Start writing today!'),
          backgroundColor: Colors.purple[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Journal History",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Your mindfulness journey",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: _journalEntries.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = _journalEntries.length - 1 - index;
                    final entry = _journalEntries[reversedIndex];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          childrenPadding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          title: Text(
                            entry['date']!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                          subtitle: Text(
                            entry['prompt']!,
                            style: GoogleFonts.poppins(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.purple[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          children: [
                            Text(
                              entry['entry']!,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.purple[900],
                              ),
                            ),
                          ],
                          iconColor: Colors.purple[700],
                          collapsedIconColor: Colors.purple[300],
                        ),
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

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _journalController.dispose();
    _breathingController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Mindfulness",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.purple[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.purple[800],
          unselectedLabelColor: Colors.grey[500],
          indicatorColor: Colors.purple[700],
          tabs: [
            Tab(icon: Icon(Icons.favorite), text: "Empower"),
            Tab(icon: Icon(Icons.self_improvement), text: "Breathe"),
            Tab(icon: Icon(Icons.edit_note), text: "Journal"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmpower(),
          _buildBreathe(),
          _buildJournal(),
        ],
      ),
    );
  }

  Widget _buildEmpower() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "Your Daily Empowerment",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple[800],
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Swipe to explore mindful practices",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _cards.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                _cardAnimationController.reset();
                _cardAnimationController.forward();
              });
            },
            itemBuilder: (context, index) {
              final card = _cards[index];
              return AnimatedBuilder(
                animation: _cardAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _cardScaleAnimation.value,
                    child: _buildCard(context, card),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _cards.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.purple[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildCard(BuildContext context, EmpowermentCard card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => _showDetailedActivity(context, card),
        child: Container(
          decoration: BoxDecoration(
            color: card.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'cardIcon${card.title}',
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        card.iconData,
                        size: 28,
                        color: Colors.purple[700],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      card.title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          card.quote,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                            color: Colors.purple[900],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.purple[700],
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              card.activity,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.purple[900],
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildBreathe() {
    final BreathingExercise currentExercise = _breathingExercises[_breathCount % _breathingExercises.length];
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Breathe & Release",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Breathwork helps regulate hormones & reduce period discomfort",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _breathingExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _breathingExercises[index];
                  final isSelected = !_isBreathingActive && index == (_breathCount % _breathingExercises.length);
                  return GestureDetector(
                    onTap: () {
                      if (!_isBreathingActive) {
                        setState(() {
                          _breathCount = index;
                        });
                      }
                    },
                    child: Container(
                      width: 160,
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? exercise.color : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey[300]!,
                          width: 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: exercise.color.withOpacity(0.7),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ] : [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            exercise.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.deepPurple[800] : Colors.deepPurple[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '${exercise.inhaleCount}-${exercise.holdCount}-${exercise.exhaleCount}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.deepPurple[700] : Colors.grey[600],
                                ),
                              ),
                              if (exercise.pauseCount > 0) 
                                Text(
                                  '-${exercise.pauseCount}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected ? Colors.deepPurple[700] : Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: currentExercise.color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentExercise.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    currentExercise.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_isBreathingActive) {
                    _stopBreathingExercise();
                  } else {
                    _startBreathingExercise(currentExercise);
                  }
                },
                child: AnimatedBuilder(
                  animation: _breathingController,
                  builder: (context, child) {
                    double scale = _isBreathingActive ? _breathingAnimation.value : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentExercise.color,
                          boxShadow: [
                            BoxShadow(
                              color: currentExercise.color.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _breathingText,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40),
            if (_isBreathingActive)
              Center(
                child: ElevatedButton(
                  onPressed: _stopBreathingExercise,
                  child: Text("End Session"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournal() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cycle Journal",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Track your emotions & growth",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () => _showJournalHistory(context),
                      icon: Icon(Icons.history, color: Colors.purple[700]),
                      label: Text(
                        "History",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.purple[700],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Prompt:",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _journalPrompt,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.purple[900],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  constraints: BoxConstraints(minHeight: 200),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _journalController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Start writing here...",
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[400],
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.purple[900],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveJournalEntry,
                    icon: Icon(Icons.save_alt),
                    label: Text("Save Entry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

}