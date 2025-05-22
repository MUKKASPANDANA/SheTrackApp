import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shetrackv1/screens/edit_profile.dart';
import 'package:shetrackv1/screens/log_mood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'water_tracker.dart';
import 'package:shetrackv1/screens/symtoms.dart';
import 'package:shetrackv1/screens/sleep.dart';
import 'Exercise.dart';
import 'package:shetrackv1/screens/track_period.dart';
import 'Dite_menu.dart';
import 'mindfull_page.dart';
import 'health_insights.dart';
import 'package:shetrackv1/screens/water_tracker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'health_resources.dart';
import 'health_resources.dart';
import 'package:shetrackv1/screens/steps_count.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<DateTime> periodDates = [];
  double? averageCycleLength;
  // User data
  String _userName = "User";
  String _userEmail = "";
  String _userId = "";
  String imageUrl='';
  
  // Period data
  DateTime? _lastPeriodDate;
  int _cycleDay = 0;
  String _cyclePhase = "Unknown";
  DateTime? _nextPeriodDate;
  int _painLevel = 0;
  bool _isLoading = true;
  
  @override
void initState() {
  super.initState();
  _loadUserData();
}

Future<void> _loadUserData() async {
  setState(() => _isLoading = true);

  try {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    _userId = currentUser.uid;

    // Load user profile info
    final userDoc = await _firestore.collection('users').doc(_userId).get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      _userName = userData['name'] ?? 'User';
      _userEmail = userData['email'] ?? currentUser.email ?? '';
      imageUrl = userData['profileImageUrl'] ?? '';
    }
    

    // Load period logs
    final periodLogs = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('period_logs')
        .get();
    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('period_logs')
        .orderBy('date')
        .get();
    periodDates = snapshot.docs.map((doc) {
        final rawDate = doc['date'];
        if (rawDate is Timestamp) {
          return rawDate.toDate();
        } else if (rawDate is String) {
          return DateTime.parse(rawDate);
        } else {
          throw Exception("Unsupported date format: $rawDate");
        }
      }).toList();
    if (periodDates.length > 1) {
        List<int> gaps = [];
        for (int i = 1; i < periodDates.length; i++) {
          gaps.add(periodDates[i].difference(periodDates[i - 1]).inDays);
        }
        averageCycleLength = gaps.reduce((a, b) => a + b) / gaps.length;
        if (averageCycleLength != null) {
          _nextPeriodDate =
              periodDates.last.add(Duration(days: averageCycleLength!.round()));
        }
      }

    DateTime? latestDate;
    int latestPainLevel = 0;

    for (var doc in periodLogs.docs) {
      try {
        final data = doc.data() as Map<String, dynamic>?;

        if (data == null) continue;

        // Parse the date from document ID or from 'date' fields
        DateTime? logDate;
        try {
          logDate = DateTime.parse(doc.id); // ID is usually 'yyyy-MM-dd'
        } catch (_) {
          if (data.containsKey('dateString')) {
            logDate = DateTime.tryParse(data['dateString']);
          } else if (data.containsKey('date') && data['date'] is Timestamp) {
            logDate = (data['date'] as Timestamp).toDate();
          }
        }

        if (logDate == null) continue;

        final int pain = data['painLevel'] ?? 0;
        if (pain > 0 && (latestDate == null || logDate.isAfter(latestDate))) {
          latestDate = logDate;
          latestPainLevel = pain;
        }
      } catch (e) {
        print("Error reading period log ${doc.id}: $e");
      }
    }

    if (latestDate != null) {
      _lastPeriodDate = latestDate;
      _painLevel = latestPainLevel;
      _calculateCycleInfo(); // Only call when valid date found
    } else {
      _cyclePhase = "No valid period data found";
    }
  } catch (e, stack) {
    print("Error loading user data: $e\n$stack");
  } finally {
    setState(() => _isLoading = false);
  }
}





// Improved cycle calculation with setState
void _calculateCycleInfo() {
  if (_lastPeriodDate != null) {
    final now = DateTime.now();
    
    // Calculate days since last period started (include today)
    final difference = now.difference(_lastPeriodDate!).inDays;
    
    // Assuming a 28-day cycle for calculations
    int cycleDuration = (averageCycleLength ?? 28).toInt();


    
    // Calculate current cycle day (1-28)
    final cycleDay = (difference % cycleDuration) + 1;
    
    // Calculate next period date
    int daysToNextPeriod = cycleDuration - (cycleDay - 1);
    final nextPeriodDate = now.add(Duration(days: daysToNextPeriod));
    
    // Determine cycle phase
    String cyclePhase;
    if (cycleDay <= 5) {
      cyclePhase = "Period Phase";
    } else if (cycleDay <= 13) {
      cyclePhase = "Follicular Phase";
    } else if (cycleDay <= 16) {
      cyclePhase = "Ovulation Phase";
    } else {
      cyclePhase = "Luteal Phase";
    }
    
    // Update all state variables at once
    setState(() {
      _cycleDay = cycleDay;
      _nextPeriodDate = nextPeriodDate;
      _cyclePhase = cyclePhase;
    });
    
    print("DEBUG: Cycle day: $_cycleDay, Next period: ${_nextPeriodDate.toString()}, Phase: $_cyclePhase");
  }
}
  
  // Calculate cycle day, phase, and next period date
  

  @override
  Widget build(BuildContext context) {
    // Get current date in formatted string
    final today = DateFormat('MMMM d, yyyy').format(DateTime.now());
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F9),
      body: SafeArea(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE75A7C)))
          : CustomScrollView(
              slivers: [
                // App Bar with user welcome and profile
                SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible( // <-- Add this wrapper
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $_userName",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF442C2E),
                ),
                overflow: TextOverflow.visible, // <-- neat truncation
                maxLines: 1,
              ),
              const SizedBox(height: 6),
              Text(
                today,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
  onTap: () {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => const EditProfilePage() // Navigate to ProfilePage
    ));
  },
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.pink.shade100, width: 2),
      borderRadius: BorderRadius.circular(30),
    ),
    child: CircleAvatar(
      radius: 24,
      backgroundColor: Colors.pink.shade50,
      backgroundImage: (imageUrl.isNotEmpty)
          ? NetworkImage(imageUrl)
          : null, // Only load if available
      child: (imageUrl.isEmpty)
          ? Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : '',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
                                  ),
                                )
                              : null, // No fallback text if there's an image
                        ),
                      ),
                    ),

                          ],
                        ),
                      ),
                    ),


                
                // Cycle status card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: _buildCycleStatusCard(context),
                  ),
                ),
                
                // Health insights cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Your Health Today",
                              style: GoogleFonts.poppins(
                                fontSize: 18, 
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF442C2E),
                              ),
                            ),
                            
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildHealthInsightsCards(context),
                      ],
                    ),
                  ),
                ),
                
                // Quick actions section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Actions",
                          style: GoogleFonts.poppins(
                            fontSize: 18, 
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF442C2E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildQuickActions(context),
                      ],
                    ),
                  ),
                ),
                
// Replace the section where you're adding HealthResourcesScreen
// Replace the section where you're adding HealthResourcesScreen
SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  HealthResourcesScreen(embedded: false),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Health Resources",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF442C2E),
                  ),
                ),
                const SizedBox(height: 12),
                 Image.asset('lib/assets/images/articlesandvideos.png'),
              ],
            ),

        ),
        )
      ],
    ),
  ),
)

              ],
            ),
      ),
    );
  }

  Widget _buildCycleStatusCard(BuildContext context) {
    // Calculate percentage of cycle completed
    double cyclePercentage = _cycleDay / 28.0;
    String cyclePercentageText = "${(cyclePercentage * 100).round()}%";
    
    // Format next period date
    String nextPeriodText = _nextPeriodDate != null 
        ? DateFormat('MMMM d').format(_nextPeriodDate!)
        : "Unknown";
        
    // Determine remaining days in current phase
    int daysRemaining = 0;
    if (_cyclePhase == "Period Phase") {
      daysRemaining = 5 - _cycleDay;
    } else if (_cyclePhase == "Follicular Phase") {
      daysRemaining = 13 - _cycleDay;
    } else if (_cyclePhase == "Ovulation Phase") {
      daysRemaining = 16 - _cycleDay;
    } else if (_cyclePhase == "Luteal Phase") {
      daysRemaining = 28 - _cycleDay;
    }
    
    if (daysRemaining < 0) daysRemaining = 0;
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/cycle_details');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE75A7C),
              Color(0xFFD96AA7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE75A7C).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your Cycle",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Day $_cycleDay",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cyclePhase,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "$daysRemaining days remaining",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: cyclePercentage,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      Text(
                        cyclePercentageText,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Your next period is expected on $nextPeriodText",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
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
    );
  }

  Widget _buildHealthInsightsCards(BuildContext context) {
    // For now, we'll fetch real period data but use placeholder data for other health metrics
    // In a complete implementation, we'd fetch this data from Firebase collections as well
    final insights = [
      {
        "title": "Mood",
        "icon": Icons.sentiment_very_satisfied_rounded,
        "color": const Color.fromARGB(255, 244, 207, 0),
        "screen": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MoodLoggingPage()),
        ),
      },
      {
        "title": "Water",
        "icon": Icons.water_drop_rounded,
        "color": const Color(0xFF2D82B5),
        "screen": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HydrationTracker()),)
      },
      {
        "title": "Steps",
        "icon": Icons.directions_walk_rounded,
        "color": const Color.fromARGB(255, 24, 222, 216),
        "screen": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  StepTrackerScreen()),
        ),
      },
      {
        "title": "Sleep",
        "icon": Icons.nightlight_round,
        "color": const Color.fromARGB(255, 198, 79, 188),
        "screen": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SleepTrackerWidget()),)
      },
      {
        "title": "Excercise",
        "icon": Icons.fitness_center_rounded,
        "color": const Color(0xFFE98A15),
        "screen": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  ExercisePage()),)
      },
    ];

    return SizedBox(

      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final item = insights[index];
          return GestureDetector(
            onTap: item["screen"] as Function(),
            child: Column(
              children: [
                Container(
                  width: 85,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: 
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (item["color"] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          item["icon"] as IconData,
                          color: item["color"] as Color,
                          size: 50,
                        ),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  item["title"].toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF442C2E),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        "icon": Icons.restaurant_rounded, 
        "label": "Nutrition", 
        "color": const Color(0xFF8FC93A),
        "screen": '/PeriodNutritionPlanPage'
      },
      {
        "icon": Icons.spa_rounded, 
        "label": "Mindfulness", 
        "color": const Color(0xFFEA5C2B),
        "screen": '/mindfulness'
      },
      {
        "icon": Icons.insights_rounded, 
        "label": "Health Insights", 
        "color": const Color(0xFF9BA7C0),
        "screen": '/health_insights'
      },
      {
        "icon": Icons.edit_note_rounded, 
        "label": "Symptoms", 
        "color": const Color(0xFFD96AA7),
        "screen": '/symptoms'
      },
      {
        "icon": Icons.psychology_rounded, 
        "label": "Stress", 
        "color": const Color(0xaa01faf4),
        "screen": '/stress'
      },
      {
        "icon": Icons.emergency_rounded, 
        "label": "Emergency", 
        "color": const Color(0xFFFF0000),
        "screen": '/emergency'
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, item["screen"] as String);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade100, blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item["color"] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    size: 24,
                    color: item["color"] as Color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item["label"].toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF442C2E),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
}