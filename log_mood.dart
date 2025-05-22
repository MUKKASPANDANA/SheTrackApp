import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class MoodLoggingPage extends StatefulWidget {
  @override
  _MoodLoggingPageState createState() => _MoodLoggingPageState();
}

class _MoodLoggingPageState extends State<MoodLoggingPage> with TickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  String _selectedMood = '😊 Happy';
  late TabController _tabController;
  Map<String, dynamic> _moodAnalysis = {};
  List<String> _moodTips = [];
  bool _isLoading = true;

  // Simplified color themes
  final Map<String, ThemeData> _moodThemes = {
    '😊 Happy': ThemeData(
      primaryColor: Colors.amber,
      scaffoldBackgroundColor: Colors.amber.shade50,
    ),
    '😢 Sad': ThemeData(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.blue.shade50,
    ),
    '😡 Angry': ThemeData(
      primaryColor: Colors.red,
      scaffoldBackgroundColor: Colors.red.shade50,
    ),
    '😴 Tired': ThemeData(
      primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.purple.shade50,
    ),
    '😐 Neutral': ThemeData(
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.teal.shade50,
    ),
  };

  final moodOptions = ['😊 Happy', '😢 Sad', '😡 Angry', '😴 Tired', '😐 Neutral'];
  
  // Numerical values for moods
  final Map<String, int> _moodValues = {
    '😊 Happy': 5,
    '😐 Neutral': 3,
    '😴 Tired': 2,
    '😢 Sad': 1,
    '😡 Angry': 0,
  };

  // Simplified tips
  final Map<String, List<String>> _moodTipsMap = {
    '😊 Happy': ['Celebrate your positive mood by doing something you enjoy!'],
    '😢 Sad': ['Take some time for self-care activities that comfort you.'],
    '😡 Angry': ['Practice deep breathing exercises to help calm your nervous system.'],
    '😴 Tired': ['Consider adjusting your sleep schedule if possible.'],
    '😐 Neutral': ['This can be a good time for mindfulness practices.'],
    'mixed': ['Your mood has been varying - this is completely normal!'],
    'stable': ['Your mood has been consistent lately.'],
    'improving': ['Your mood seems to be improving - great job taking care of yourself!'],
    'declining': ['Your mood appears to be declining recently.'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _analyzeMoods();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _saveMood() async {
    if (_noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a note about how you\'re feeling')),
      );
      return;
    }

    final box = Hive.box('moods');
    final id = Uuid().v4();

    final moodData = {
      'id': id,
      'mood': _selectedMood,
      'note': _noteController.text,
      'timestamp': DateTime.now().toString(),
      'value': _moodValues[_selectedMood],
    };

    await box.put(id, moodData);
    _noteController.clear();
    
    _analyzeMoods();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood logged successfully!')),
    );
  }

  // FIXED: Analyze moods function with proper error handling
  void _analyzeMoods() async {
    setState(() => _isLoading = true);
    
    try {
      final box = Hive.box('moods');
      final moods = box.values.toList();
      
      if (moods.isEmpty) {
        setState(() {
          _moodAnalysis = {
            'dominantMood': '😐 Neutral',
            'moodCounts': {},
            'totalEntries': 0,
            'trendType': 'stable',
            'trendValue': 0.0,
          };
          _moodTips = ['Start logging your moods to see analysis and tips!'];
          _isLoading = false;
        });
        return;
      }

      // Sort moods by timestamp
      moods.sort((a, b) => 
        DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp']))
      );

      // Count each mood type
      Map<String, int> moodCounts = {};
      for (var mood in moodOptions) {
        moodCounts[mood] = 0;
      }
      
      for (var entry in moods) {
        final mood = entry['mood'] as String;
        moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      }
      
      // Determine dominant mood
      String dominantMood = moodOptions[0];
      int maxCount = 0;
      moodCounts.forEach((mood, count) {
        if (count > maxCount) {
          maxCount = count;
          dominantMood = mood;
        }
      });
      
      // Calculate mood trend
      String trendType = 'stable';
      double trendValue = 0;
      
      if (moods.length >= 3) {
        // Get recent moods
        final recentMoods = moods.length <= 7 ? moods : moods.sublist(moods.length - 7);
        
        // Calculate slope of mood values
        List<int> values = [];
        for (var mood in recentMoods) {
          int moodValue = mood['value'] != null ? 
            (mood['value'] as int) : 
            (_moodValues[mood['mood']] ?? 3);
          values.add(moodValue);
        }
        
        if (values.length >= 3) {
          double sum = 0;
          for (int i = 1; i < values.length; i++) {
            sum += values[i] - values[i-1];
          }
          
          trendValue = sum / (values.length - 1);
          
          if (trendValue > 0.5) {
            trendType = 'improving';
          } else if (trendValue < -0.5) {
            trendType = 'declining';
          } else {
            // Check for high variance
            double mean = values.reduce((a, b) => a + b) / values.length;
            double variance = values.map((v) => math.pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
            
            if (variance > 2) {
              trendType = 'mixed';
            } else {
              trendType = 'stable';
            }
          }
        }
      }
      
      // Generate insights
      Map<String, dynamic> analysis = {
        'dominantMood': dominantMood,
        'moodCounts': moodCounts,
        'totalEntries': moods.length,
        'trendType': trendType,
        'trendValue': trendValue,
      };
      
      // Generate personalized tips
      List<String> tips = [];
      
      // Add tip based on dominant mood
      if (_moodTipsMap.containsKey(dominantMood)) {
        tips.add(_moodTipsMap[dominantMood]!.first);
      }
      
      // Add tip based on trend
      if (_moodTipsMap.containsKey(trendType)) {
        tips.add(_moodTipsMap[trendType]!.first);
      }
      
      // Ensure we have at least one tip
      if (tips.isEmpty) {
        tips.add('Regular mood tracking can help you identify patterns.');
      }
      
      setState(() {
        _moodAnalysis = analysis;
        _moodTips = tips;
        _isLoading = false;
      });
    } catch (e) {
      print('Error analyzing moods: $e');
      setState(() {
        _moodAnalysis = {
          'dominantMood': '😐 Neutral',
          'moodCounts': {},
          'totalEntries': 0,
          'trendType': 'stable',
          'trendValue': 0.0,
        };
        _moodTips = ['Start logging your moods to see analysis and tips!'];
        _isLoading = false;
      });
    }
  }

  // FIXED: Get trend icon function
  String _getTrendIcon(String trendType) {
    switch (trendType.toLowerCase() ?? 'unknown') {
      case 'improving':
        return '📈';
      case 'declining':
        return '📉';
      case 'stable':
        return '➖';
      case 'mixed':
        return '↕️';
      default:
        return '❓';
    }
  }

  // Helper function to safely get mood color
  Color _getMoodColor(String mood) {
    if (_moodThemes.containsKey(mood)) {
      return _moodThemes[mood]!.primaryColor;
    }
    return _moodThemes['😐 Neutral']!.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    // Determine theme based on dominant mood or default to neutral
    String dominantMood = _moodAnalysis['dominantMood'] ?? '😐 Neutral';
    ThemeData theme = _moodThemes[dominantMood] ?? _moodThemes['😐 Neutral']!;
    
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mood Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.add), text: 'Log Mood'),
              Tab(icon: Icon(Icons.history), text: 'History'),
              Tab(icon: Icon(Icons.analytics), text: 'Insights'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildLogMoodTab(),
            _buildHistoryTab(),
            _buildInsightsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogMoodTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('How are you feeling?', 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 24),
          
          // Mood Selection
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMood,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down_circle),
                onChanged: (val) => setState(() => _selectedMood = val!),
                items: moodOptions.map((m) => 
                  DropdownMenuItem(value: m, child: Text(m, style: TextStyle(fontSize: 18)))
                ).toList(),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Note Field
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add a note about how you\'re feeling...',
                border: InputBorder.none,
              ),
            ),
          ),
          
          SizedBox(height: 32),
          
          // Save Button
          ElevatedButton(
            onPressed: _saveMood,
            child: Text('Save Mood', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          
          SizedBox(height: 24),
          
          // Tips Card
          if (_moodTips.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber),
                      SizedBox(width: 8),
                      Text('Mood Tip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(_moodTips.first, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final box = Hive.box('moods');
    final moods = box.values.toList().reversed.toList();
    
    if (moods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No mood entries yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final Map entry = moods[index] as Map;
        final timestamp = DateTime.parse(entry['timestamp'] as String);
        final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(timestamp);
        
        final moodEmoji = entry['mood'].toString().split(' ')[0];
        final moodText = entry['mood'].toString().split(' ')[1];
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getMoodColor(entry['mood']).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(moodEmoji, style: TextStyle(fontSize: 24))),
              ),
              title: Row(
                children: [
                  Text(moodText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Spacer(),
                  Text(formattedDate, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(entry['note'] as String, style: TextStyle(fontSize: 14)),
              ),
              isThreeLine: true,
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete this entry?'),
                    content: Text('This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () async {
                          await box.delete(entry['id']);
                          Navigator.of(context).pop();
                          _analyzeMoods();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // FIXED: Build insights tab with better error handling
  Widget _buildInsightsTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_moodAnalysis.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No data for analysis yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    final box = Hive.box('moods');
    final moods = box.values.toList();
    
    // Sort moods by timestamp
    moods.sort((a, b) => 
      DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp']))
    );
    
    // Prepare chart data
    final chartData = moods.length > 7 ? moods.sublist(moods.length - 7) : moods;
    
    List<FlSpot> spots = [];
    for (int i = 0; i < chartData.length; i++) {
      final value = double.tryParse(chartData[i]['value'].toString()) ?? 0.0;
      spots.add(FlSpot(i.toDouble(), value));
    }
    
    // Get dominant mood safely
    String dominantMood = _moodAnalysis['dominantMood'] ?? '😐 Neutral';
    if (!moodOptions.contains(dominantMood)) {
      dominantMood = '😐 Neutral';
    }
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Your Mood Summary', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Entries', style: TextStyle(color: Colors.grey)),
                        Text(_moodAnalysis['totalEntries'].toString(), 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Dominant', style: TextStyle(color: Colors.grey)),
                        Text(dominantMood.split(' ')[0], 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Trend', style: TextStyle(color: Colors.grey)),
                        Text(_getTrendIcon(_moodAnalysis['trendType']), 
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Chart Card
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mood Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Expanded(
                  child: spots.length < 2 ?
                    Center(child: Text('Need more entries for trend visualization')) :
                    LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minY: 0,
                        maxY: 5,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: _getMoodColor(dominantMood),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: _getMoodColor(dominantMood).withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Tips Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Mood Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                ...(_moodTips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: _getMoodColor(dominantMood)),
                      SizedBox(width: 8),
                      Expanded(child: Text(tip)),
                    ],
                  ),
                ))).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}