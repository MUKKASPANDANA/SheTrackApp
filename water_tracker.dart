import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('hydrationBox');
  runApp(const HydrationTrackerApp());
}

class HydrationTrackerApp extends StatelessWidget {
  const HydrationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydration Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      themeMode: ThemeMode.system,
      home: const HydrationTracker(),
    );
  }
}

class HydrationTracker extends StatefulWidget {
  const HydrationTracker({super.key});

  @override
  State<HydrationTracker> createState() => _HydrationTrackerState();
}

class _HydrationTrackerState extends State<HydrationTracker> with SingleTickerProviderStateMixin {
  late Box _hydrationBox;
  int _totalCups = 0;
  List<Map<String, dynamic>> _entries = [];
  final TextEditingController _waterController = TextEditingController();
  final int _dailyGoal = 8; // Default daily goal in cups
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _hydrationBox = Hive.box('hydrationBox');
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    final stored = _hydrationBox.get('entries', defaultValue: []) as List<dynamic>;
    final today = DateTime.now();
    
    _entries = stored
        .map((e) => e as Map)
        .map((e) => {
              'cups': e['cups'],
              'timestamp': DateTime.parse(e['timestamp']),
            })
        .where((entry) {
          final entryTime = entry['timestamp'] as DateTime;
          return entryTime.year == today.year &&
              entryTime.month == today.month &&
              entryTime.day == today.day;
        })
        .toList();

    _totalCups = _entries.fold(0, (sum, entry) => sum + (entry['cups'] as int));
    setState(() {});
  }

  void _addWater(int cups) {
    final now = DateTime.now();
    
    // Update the entries list for today
    final entry = {'cups': cups, 'timestamp': now};
    
    // Get all entries from storage
    final stored = _hydrationBox.get('entries', defaultValue: []) as List;
    List<Map<String, dynamic>> allEntries = List<Map<String, dynamic>>.from(
      stored.map((e) => {
        'cups': e['cups'],
        'timestamp': DateTime.parse(e['timestamp']),
      })
    );
    
    // Add the new entry
    allEntries.add(entry);
    
    // Convert DateTime to string for storage
    List<Map<String, dynamic>> toStore = allEntries.map((e) => {
      'cups': e['cups'],
      'timestamp': (e['timestamp'] as DateTime).toIso8601String(),
    }).toList();
    
    // Store all entries
    _hydrationBox.put('entries', toStore);
    
    // Update the state
    setState(() {
      _entries.add(entry);
      _totalCups += cups;
    });
    
    // Show success feedback
    _showSnackBar('Added $cups ${cups == 1 ? 'cup' : 'cups'} of water');
  }

  void _resetTodayData() {
    final today = DateTime.now();
    
    // Get all entries from storage
    final stored = _hydrationBox.get('entries', defaultValue: []) as List;
    List<Map<String, dynamic>> allEntries = List<Map<String, dynamic>>.from(
      stored.map((e) => {
        'cups': e['cups'],
        'timestamp': DateTime.parse(e['timestamp']),
      })
    );
    
    // Filter out entries from today
    allEntries = allEntries.where((entry) {
      final entryTime = entry['timestamp'] as DateTime;
      return !(entryTime.year == today.year &&
          entryTime.month == today.month &&
          entryTime.day == today.day);
    }).toList();
    
    // Convert DateTime to string for storage
    List<Map<String, dynamic>> toStore = allEntries.map((e) => {
      'cups': e['cups'],
      'timestamp': (e['timestamp'] as DateTime).toIso8601String(),
    }).toList();
    
    // Store filtered entries
    _hydrationBox.put('entries', toStore);
    
    // Update the state
    setState(() {
      _entries.clear();
      _totalCups = 0;
    });
    
    _showSnackBar('Today\'s data has been reset');
  }

  void _addCustomWater() {
    final input = int.tryParse(_waterController.text);
    if (input != null && input > 0) {
      _addWater(input);
      _waterController.clear();
      FocusScope.of(context).unfocus();
    } else {
      _showSnackBar('Please enter a valid number');
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmReset() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Today\'s Data?'),
        content: const Text('This will remove all water entries for today. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              _resetTodayData();
              Navigator.pop(context);
            },
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _waterController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _confirmReset,
            tooltip: 'Reset Today\'s Data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(colorScheme, textTheme, isMobile),
          _buildHistoryTab(colorScheme, textTheme),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWaterBottomSheet(context),
        tooltip: 'Add Water',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayTab(ColorScheme colorScheme, TextTheme textTheme, bool isMobile) {
    final progress = _dailyGoal > 0 ? _totalCups / _dailyGoal : 0.0;
    final clampedProgress = progress.clamp(0.0, 1.0);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Daily Progress',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  CircularPercentIndicator(
                    radius: 80,
                    lineWidth: 12,
                    percent: clampedProgress,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_totalCups',
                          style: textTheme.headlineLarge,
                        ),
                        Text(
                          'of $_dailyGoal cups',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    progressColor: _getProgressColor(clampedProgress, colorScheme),
                    backgroundColor: colorScheme.surfaceVariant,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1000,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _getProgressMessage(clampedProgress),
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Quick Add',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildQuickAddButtons(colorScheme),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Today\'s Entries',
                    style: textTheme.titleMedium,
                  ),
                ),
                if (_entries.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text('No entries yet today'),
                    ),
                  )
                else
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _entries.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = _entries[_entries.length - 1 - index]; // Show newest first
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            '${entry['cups']}',
                            style: TextStyle(color: colorScheme.onPrimaryContainer),
                          ),
                        ),
                        title: Text('${entry['cups']} ${entry['cups'] == 1 ? 'cup' : 'cups'} of water'),
                        subtitle: Text(_formatTime(entry['timestamp'])),
                        trailing: const Icon(Icons.water_drop),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(ColorScheme colorScheme, TextTheme textTheme) {
    // This would show history data grouped by date
    final stored = _hydrationBox.get('entries', defaultValue: []) as List<dynamic>;
    
    // Convert stored data to a list of entries
    final allEntries = stored
        .map((e) => e as Map)
        .map((e) => {
              'cups': e['cups'],
              'timestamp': DateTime.parse(e['timestamp']),
            })
        .toList();
    
    // Group entries by date
    final Map<String, List<Map<String, dynamic>>> entriesByDate = {};
    for (var entry in allEntries) {
      final date = DateFormat('yyyy-MM-dd').format(entry['timestamp'] as DateTime);
      if (!entriesByDate.containsKey(date)) {
        entriesByDate[date] = [];
      }
      entriesByDate[date]!.add(entry);
    }
    
    // Sort dates in descending order
    final sortedDates = entriesByDate.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return sortedDates.isEmpty
        ? const Center(child: Text('No history available'))
        : ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final entries = entriesByDate[date]!;
              final totalForDay = entries.fold(0, (sum, entry) => sum + (entry['cups'] as int));
              final progress = _dailyGoal > 0 ? totalForDay / _dailyGoal : 0.0;
              final clampedProgress = progress.clamp(0.0, 1.0);
              
              // Parse the date string back to DateTime for formatting
              final dateTime = DateTime.parse(date);
              final isToday = date == DateFormat('yyyy-MM-dd').format(DateTime.now());
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    isToday ? 'Today' : _formatDate(dateTime),
                    style: textTheme.titleMedium,
                  ),
                  subtitle: Text('$totalForDay of $_dailyGoal cups'),
                  leading: CircleAvatar(
                    backgroundColor: _getProgressColor(clampedProgress, colorScheme),
                    child: Text(
                      '$totalForDay',
                      style: TextStyle(color: colorScheme.onPrimary),
                    ),
                  ),
                  children: [
                    LinearProgressIndicator(
                      value: clampedProgress,
                      backgroundColor: colorScheme.surfaceVariant,
                      color: _getProgressColor(clampedProgress, colorScheme),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: entries.length,
                      itemBuilder: (context, idx) {
                        final entry = entries[entries.length - 1 - idx]; // Show newest first
                        return ListTile(
                          dense: true,
                          title: Text('${entry['cups']} ${entry['cups'] == 1 ? 'cup' : 'cups'}'),
                          trailing: Text(_formatTime(entry['timestamp'] as DateTime)),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildQuickAddButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildWaterButton(1, colorScheme),
        _buildWaterButton(2, colorScheme),
        _buildWaterButton(3, colorScheme),
      ],
    );
  }

  Widget _buildWaterButton(int cups, ColorScheme colorScheme) {
    return ElevatedButton(
      onPressed: () => _addWater(cups),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Column(
        children: [
          Icon(cups == 1 ? Icons.water_drop : Icons.water, size: 24),
          const SizedBox(height: 4),
          Text('$cups ${cups == 1 ? 'cup' : 'cups'}'),
        ],
      ),
    );
  }

  void _showAddWaterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Water',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _waterController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Enter number of cups',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.water_drop),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _addCustomWater();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('ADD'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Color _getProgressColor(double progress, ColorScheme colorScheme) {
    if (progress < 0.33) {
      return Colors.red;
    } else if (progress < 0.66) {
      return Colors.orange;
    } else if (progress < 1.0) {
      return Colors.lightBlue;
    } else {
      return Colors.green;
    }
  }

  String _getProgressMessage(double progress) {
    if (progress < 0.33) {
      return 'You need to drink more water!';
    } else if (progress < 0.66) {
      return 'Keep going, you\'re making progress!';
    } else if (progress < 1.0) {
      return 'Almost there! Just a bit more water needed.';
    } else {
      return 'Great job! You\'ve met your daily goal.';
    }
  }
}