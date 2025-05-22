import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class TrackScreen extends StatefulWidget {
  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _symptomController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TabController? _tabController;
  
  // Expanded tracking data
  Map<DateTime, List<String>> _dailyLogs = {};
  Map<DateTime, String> _dailyNotes = {};
  Map<DateTime, double> _moodRatings = {};
  Map<DateTime, double> _painLevels = {};
  Map<DateTime, bool> _periodDays = {};
  Map<DateTime, int> _flowLevels = {}; // 1-Light, 2-Medium, 3-Heavy
  
  // Mood and symptoms presets
  final List<String> _moodPresets = ['Happy', 'Calm', 'Tired', 'Irritable', 'Anxious', 'Sad'];
  final List<String> _symptomPresets = [
    'Cramps', 'Headache', 'Bloating', 'Fatigue', 
    'Breast tenderness', 'Acne', 'Back pain', 'Nausea',
    'Mood swings', 'Food cravings'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _tabController = TabController(length: 3, vsync: this);
    
    // Pre-populate with sample data for demonstration
    final now = DateTime.now();
    _periodDays[DateTime(now.year, now.month, now.day - 2)] = true;
    _periodDays[DateTime(now.year, now.month, now.day - 3)] = true;
    _periodDays[DateTime(now.year, now.month, now.day - 4)] = true;
    _flowLevels[DateTime(now.year, now.month, now.day - 2)] = 2;
    _flowLevels[DateTime(now.year, now.month, now.day - 3)] = 3;
    _flowLevels[DateTime(now.year, now.month, now.day - 4)] = 1;
  }

  @override
  void dispose() {
    _symptomController.dispose();
    _noteController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _addSymptom() {
    if (_symptomController.text.trim().isNotEmpty && _selectedDay != null) {
      final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
      setState(() {
        _dailyLogs.putIfAbsent(logDate, () => []).add(_symptomController.text.trim());
        _symptomController.clear();
      });
    }
  }

  void _addPresetSymptom(String symptom) {
    if (_selectedDay != null) {
      final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
      final currentSymptoms = _dailyLogs[logDate] ?? [];
      
      if (!currentSymptoms.contains(symptom)) {
        setState(() {
          _dailyLogs.putIfAbsent(logDate, () => []).add(symptom);
        });
      }
    }
  }
  
  void _togglePeriodDay() {
    if (_selectedDay == null) return;
    
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      bool current = _periodDays[logDate] ?? false;
      if (current) {
        _periodDays.remove(logDate);
        _flowLevels.remove(logDate);
      } else {
        _periodDays[logDate] = true;
        _flowLevels[logDate] = 2; // Default to medium flow
      }
    });
  }
  
  void _setFlowLevel(int level) {
    if (_selectedDay == null) return;
    
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    if (_periodDays[logDate] ?? false) {
      setState(() {
        _flowLevels[logDate] = level;
      });
    }
  }
  
  void _setMoodRating(double rating) {
    if (_selectedDay == null) return;
    
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      _moodRatings[logDate] = rating;
    });
  }
  
  void _setPainLevel(double level) {
    if (_selectedDay == null) return;
    
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    setState(() {
      _painLevels[logDate] = level;
    });
  }
  
  void _saveNote() {
    if (_selectedDay == null) return;
    
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _dailyNotes[logDate] = _noteController.text.trim();
      });
    }
  }

  List<String> _getLogsForSelectedDay() {
    if (_selectedDay == null) return [];
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _dailyLogs[logDate] ?? [];
  }
  
  String _getNoteForSelectedDay() {
    if (_selectedDay == null) return '';
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _dailyNotes[logDate] ?? '';
  }
  
  double _getMoodRatingForSelectedDay() {
    if (_selectedDay == null) return 3;
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _moodRatings[logDate] ?? 3;
  }
  
  double _getPainLevelForSelectedDay() {
    if (_selectedDay == null) return 0;
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _painLevels[logDate] ?? 0;
  }
  
  bool _isSelectedDayPeriod() {
    if (_selectedDay == null) return false;
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _periodDays[logDate] ?? false;
  }
  
  int _getFlowLevelForSelectedDay() {
    if (_selectedDay == null) return 0;
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    return _flowLevels[logDate] ?? 0;
  }

  String _generateInsight() {
    if (_selectedDay == null) return "Select a day to see insights";
    
    final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final symptoms = _dailyLogs[logDate] ?? [];
    final isPeriodDay = _periodDays[logDate] ?? false;
    final painLevel = _painLevels[logDate] ?? 0;
    final moodRating = _moodRatings[logDate] ?? 3;
    
    if (isPeriodDay) {
      final flowLevel = _flowLevels[logDate] ?? 2;
      if (flowLevel == 3 && painLevel > 7) {
        return "You're experiencing heavy flow with severe pain. Consider taking a pain reliever and using a heating pad. If this is unusual for you, consider consulting your healthcare provider.";
      } else if (flowLevel == 3) {
        return "Remember to stay hydrated during heavy flow days and consider iron-rich foods to prevent fatigue.";
      } else {
        return "You're on your period today. Take time for self-care and listen to your body's needs.";
      }
    } else if (symptoms.contains("Cramps") || painLevel > 5) {
      return "You reported cramps or significant pain. Try using a heating pad, gentle exercise, or herbal tea. Anti-inflammatory medications may help if appropriate for you.";
    } else if (symptoms.contains("Headache")) {
      return "Headaches can be hormone-related. Try to reduce screen time, stay hydrated, and rest in a dark room if needed.";
    } else if (symptoms.contains("Fatigue") || symptoms.contains("Tired")) {
      return "Feeling fatigued? Make sure to get enough sleep and iron-rich foods. Consider a B-vitamin supplement after consulting your healthcare provider.";
    } else if (moodRating < 2) {
      return "You logged a low mood today. Gentle exercise, spending time with loved ones, or mindfulness practices may help boost your mood.";
    } else if (symptoms.isNotEmpty) {
      return "Keep tracking your symptoms for better cycle prediction and patterns recognition.";
    } else {
      return "No symptoms logged for today. Regular tracking helps predict your cycle more accurately.";
    }
  }
  
  String _nextPeriodPrediction() {
    // Simple period prediction logic - normally this would be more sophisticated
    final now = DateTime.now();
    int periodCount = 0;
    DateTime? lastPeriodStart;
    
    // Find the most recent period start date
    for (int i = 30; i >= 0; i--) {
      final checkDate = DateTime(now.year, now.month, now.day - i);
      final normalizedDate = DateTime(checkDate.year, checkDate.month, checkDate.day);
      
      if (_periodDays[normalizedDate] ?? false) {
        periodCount++;
        if (periodCount == 1) {
          lastPeriodStart = normalizedDate;
        }
      } else {
        if (periodCount > 0 && periodCount < 8) {
          // Found the start of the most recent period
          break;
        }
        periodCount = 0;
      }
    }
    
    if (lastPeriodStart != null) {
      // Assuming 28-day cycle for simplicity
      final nextPeriod = lastPeriodStart.add(Duration(days: 28));
      return "Based on your cycle data, your next period may start around ${DateFormat('MMM d').format(nextPeriod)}";
    }
    
    return "Continue tracking to get period predictions";
  }

  @override
  Widget build(BuildContext context) {
    final logs = _getLogsForSelectedDay();
    final note = _getNoteForSelectedDay();
    final moodRating = _getMoodRatingForSelectedDay();
    final painLevel = _getPainLevelForSelectedDay();
    final isPeriodDay = _isSelectedDayPeriod();
    final flowLevel = _getFlowLevelForSelectedDay();
    final insight = _generateInsight();
    final prediction = _nextPeriodPrediction();

    if (_noteController.text.isEmpty && note.isNotEmpty) {
      _noteController.text = note;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Track Health', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFE75A7C),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              // Navigate to analytics screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Analytics feature coming soon'))
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // child: 
            ),
          ),
          
          SizedBox(height: 16),
          
          // Date indicator and period toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDay != null ? DateFormat('EEEE, MMMM d').format(_selectedDay!) : '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.water_drop,
                    color: isPeriodDay ? Colors.white : Color(0xFFE75A7C),
                  ),
                  label: Text(
                    isPeriodDay ? 'Period Day' : 'Add Period',
                    style: TextStyle(
                      color: isPeriodDay ? Colors.white : Color(0xFFE75A7C),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPeriodDay ? Color(0xFFE75A7C) : Colors.white,
                    side: BorderSide(color: Color(0xFFE75A7C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _togglePeriodDay,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 8),
          
          // Flow level selector (only visible when period day is selected)
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: isPeriodDay
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Flow: ', style: TextStyle(fontWeight: FontWeight.w500)),
                        SizedBox(width: 8),
                        _FlowButton(
                          label: 'Light',
                          isSelected: flowLevel == 1,
                          onTap: () => _setFlowLevel(1),
                          color: Color(0xFFFFB6C1),
                        ),
                        SizedBox(width: 8),
                        _FlowButton(
                          label: 'Medium',
                          isSelected: flowLevel == 2,
                          onTap: () => _setFlowLevel(2),
                          color: Color(0xFFE75A7C),
                        ),
                        SizedBox(width: 8),
                        _FlowButton(
                          label: 'Heavy',
                          isSelected: flowLevel == 3,
                          onTap: () => _setFlowLevel(3),
                          color: Color(0xFFC71F3D),
                        ),
                      ],
                    ),
                  )
                : Container(height: 0),
          ),
          
          SizedBox(height: 8),
          
          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Color(0xFFE75A7C),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFE75A7C),
            tabs: [
              Tab(text: 'Symptoms'),
              Tab(text: 'Mood & Pain'),
              Tab(text: 'Notes'),
            ],
          ),
          
          // Tab content
          Expanded(
            
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                // Symptoms Tab
                _buildSymptomsTab(logs),
                
                // Mood & Pain Tab
                _buildMoodPainTab(moodRating, painLevel),
                
                // Notes Tab
                _buildNotesTab(),
              ],
            ),
          ),
          
          // Health Insight & Predictions
          
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFE75A7C),
        child: Icon(Icons.add),
        onPressed: () {
          // Show modal bottom sheet with all tracking options
          _showTrackingOptions(context);
        },
      ),
    );
  }
  
  Widget _buildSymptomsTab(List<String> logs) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Common Symptoms',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          
          // Symptom chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _symptomPresets.map((symptom) {
              final isSelected = logs.contains(symptom);
              
              return FilterChip(
                label: Text(symptom),
                selected: isSelected,
                backgroundColor: Colors.grey.shade200,
                selectedColor: Color(0xFFE75A7C).withOpacity(0.2),
                checkmarkColor: Color(0xFFE75A7C),
                onSelected: (selected) {
                  if (selected) {
                    _addPresetSymptom(symptom);
                  } else {
                    setState(() {
                      if (_selectedDay != null) {
                        final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                        _dailyLogs[logDate]?.remove(symptom);
                      }
                    });
                  }
                },
              );
            }).toList(),
          ),
          
          SizedBox(height: 24),
          
          // Custom symptom input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _symptomController,
                  decoration: InputDecoration(
                    labelText: 'Add a custom symptom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFE75A7C)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.add_circle, color: Color(0xFFE75A7C)),
                onPressed: _addSymptom,
              )
            ],
          ),
          
          SizedBox(height: 16),
          
          // Current symptoms list
          if (logs.isNotEmpty) ...[
            Text(
              'Logged Symptoms',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ...logs.map((symptom) {
              if (!_symptomPresets.contains(symptom)) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(symptom),
                      trailing: IconButton(
                        icon: Icon(Icons.close, size: 20),
                        onPressed: () {
                          setState(() {
                            if (_selectedDay != null) {
                              final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                              _dailyLogs[logDate]?.remove(symptom);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            })
          ],
        ],
      ),
    );
  }
  
  Widget _buildMoodPainTab(double moodRating, double painLevel) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood section
          Text(
            'How are you feeling today?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          
          // Mood emojis
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MoodButton(
                emoji: '😞',
                label: 'Bad',
                isSelected: moodRating == 1,
                onTap: () => _setMoodRating(1),
              ),
              _MoodButton(
                emoji: '😐',
                label: 'Okay',
                isSelected: moodRating == 2,
                onTap: () => _setMoodRating(2),
              ),
              _MoodButton(
                emoji: '🙂',
                label: 'Good',
                isSelected: moodRating == 3,
                onTap: () => _setMoodRating(3),
              ),
              _MoodButton(
                emoji: '😊',
                label: 'Great',
                isSelected: moodRating == 4,
                onTap: () => _setMoodRating(4),
              ),
              _MoodButton(
                emoji: '🤩',
                label: 'Amazing',
                isSelected: moodRating == 5,
                onTap: () => _setMoodRating(5),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          
          // Mood presets chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _moodPresets.map((mood) {
              return ActionChip(
                label: Text(mood),
                backgroundColor: Colors.grey.shade200,
                onPressed: () {
                  _addPresetSymptom(mood);
                },
              );
            }).toList(),
          ),
          
          SizedBox(height: 32),
          
          // Pain level slider
          Text(
            'Pain Level',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.sentiment_very_satisfied, color: Colors.green),
              Expanded(
                child: Slider(
                  value: painLevel,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: Color(0xFFE75A7C),
                  onChanged: (value) {
                    _setPainLevel(value);
                  },
                ),
              ),
              Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
            ],
          ),
          Center(
            child: Text(
              painLevel == 0 
                  ? 'No pain' 
                  : painLevel < 4 
                      ? 'Mild pain (${painLevel.toInt()}/10)'
                      : painLevel < 7
                          ? 'Moderate pain (${painLevel.toInt()}/10)'
                          : 'Severe pain (${painLevel.toInt()}/10)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: painLevel == 0 
                    ? Colors.green 
                    : painLevel < 4 
                        ? Colors.amber
                        : painLevel < 7
                            ? Colors.orange
                            : Colors.red,
              ),
            ),
          ),
          
          SizedBox(height: 32),
          
          // Pain locations
          Text(
            'Pain Locations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Abdomen', 'Lower back', 'Head', 'Breasts', 'Joints'
            ].map((location) {
              return ActionChip(
                label: Text(location),
                backgroundColor: Colors.grey.shade200,
                onPressed: () {
                  _addPresetSymptom('Pain: $location');
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotesTab() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes for ${_selectedDay != null ? DateFormat('MMM d').format(_selectedDay!) : "today"}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 16),
          Expanded(
            child: TextField(
              controller: _noteController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Write your thoughts, feelings, or anything you want to remember about today...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFE75A7C)),
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: (value) {
                // Save the note when the user changes it
                if (_selectedDay != null) {
                  final logDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                  _dailyNotes[logDate] = value.trim();
                }
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.check),
            label: Text('Save Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE75A7C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _saveNote,
          ),
        ],
      ),
    );
  }
  
  void _showTrackingOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: EdgeInsets.only(top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Track Your Health',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _TrackingOptionCard(
                      title: 'Period',
                      description: 'Track your period days and flow level',
                      icon: Icons.water_drop,
                      color: Color(0xFFE75A7C),
                      onTap: () {
                        Navigator.pop(context);
                        _togglePeriodDay();
                        _tabController?.animateTo(0);
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Symptoms',
                      description: 'Log any symptoms you\'re experiencing',
                      icon: Icons.healing,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pop(context);
                        _tabController?.animateTo(0);
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Mood',
                      description: 'How are you feeling today?',
                      icon: Icons.mood,
                      color: Colors.amber,
                      onTap: () {
                        Navigator.pop(context);
                        _tabController?.animateTo(1);
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Pain',
                      description: 'Track pain levels and locations',
                      icon: Icons.favorite_border,
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        _tabController?.animateTo(1);
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Notes',
                      description: 'Write down your thoughts or reminders',
                      icon: Icons.note_alt_outlined,
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pop(context);
                        _tabController?.animateTo(2);
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Sleep',
                      description: 'Track your sleep duration and quality',
                      icon: Icons.nightlight_round,
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sleep tracking coming soon'))
                        );
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Exercise',
                      description: 'Log your physical activities',
                      icon: Icons.fitness_center,
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Exercise tracking coming soon'))
                        );
                      },
                    ),
                    _TrackingOptionCard(
                      title: 'Medication',
                      description: 'Keep track of your medications',
                      icon: Icons.medication_outlined,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Medication tracking coming soon'))
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFFE75A7C).withOpacity(0.2) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected ? Color(0xFFE75A7C) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Color(0xFFE75A7C) : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _FlowButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TrackingOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TrackingOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// Analytics widgets for future implementation

class _CycleAnalyticsWidget extends StatelessWidget {
  final Map<DateTime, bool> periodDays;
  
  const _CycleAnalyticsWidget({required this.periodDays});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle Analysis',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 16),
        Container(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 3),
                    FlSpot(2.6, 2),
                    FlSpot(4.9, 5),
                    FlSpot(6.8, 3.1),
                    FlSpot(8, 4),
                    FlSpot(9.5, 3),
                    FlSpot(11, 4),
                  ],
                  isCurved: true,
                  color: Color(0xFFE75A7C),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Color(0xFFE75A7C).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(
              label: 'Cycle Length',
              value: '28 days',
              icon: Icons.calendar_month,
              iconColor: Colors.blue,
            ),
            _StatCard(
              label: 'Period Length',
              value: '5 days',
              icon: Icons.water_drop,
              iconColor: Color(0xFFE75A7C),
            ),
            _StatCard(
              label: 'Next Period',
              value: 'In 14 days',
              icon: Icons.event,
              iconColor: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}