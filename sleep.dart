import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepTrackerWidget extends StatefulWidget {
  const SleepTrackerWidget({super.key});

  @override
  State<SleepTrackerWidget> createState() => _SleepTrackerWidgetState();
}

class _SleepTrackerWidgetState extends State<SleepTrackerWidget> {
  bool _isLoading = true;
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 0); // Default 10:00 PM
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0); // Default 7:00 AM
  String _sleepQuality = 'Good';
  List<Map<String, dynamic>> _recentSleepEntries = [];
  final List<String> _qualityOptions = ['Poor', 'Fair', 'Good', 'Excellent'];

  @override
  void initState() {
    super.initState();
    _loadRecentSleepData();
  }

  Future<void> _loadRecentSleepData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('sleep_logs') ?? [];

    final entries = data.map((e) => json.decode(e) as Map<String, dynamic>).toList();

    // Filter to last 7 days
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    _recentSleepEntries = entries
        .map((entry) => {
              'bedTime': entry['bedTime'],
              'wakeTime': entry['wakeTime'],
              'quality': entry['quality'],
              'date': DateTime.parse(entry['date']),
              'duration': entry['duration']
            })
        .where((entry) => entry['date'].isAfter(sevenDaysAgo))
        .toList()
      ..sort((a, b) => b['date'].compareTo(a['date']));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveSleepData() async {
    final prefs = await SharedPreferences.getInstance();

    int bedTimeMinutes = _bedTime.hour * 60 + _bedTime.minute;
    int wakeTimeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;

    int durationMinutes;
    if (wakeTimeMinutes < bedTimeMinutes) {
      durationMinutes = (24 * 60 - bedTimeMinutes) + wakeTimeMinutes;
    } else {
      durationMinutes = wakeTimeMinutes - bedTimeMinutes;
    }

    final newEntry = {
      'bedTime': _formatTimeOfDay(_bedTime),
      'wakeTime': _formatTimeOfDay(_wakeTime),
      'quality': _sleepQuality,
      'date': DateTime.now().toIso8601String(),
      'duration': durationMinutes
    };

    final List<String> currentLogs = prefs.getStringList('sleep_logs') ?? [];
    currentLogs.add(json.encode(newEntry));
    await prefs.setStringList('sleep_logs', currentLogs);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sleep data saved locally')),
    );
    _loadRecentSleepData();
  }

  Future<void> _selectBedTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _bedTime,
    );
    if (picked != null && picked != _bedTime && mounted) {
      setState(() {
        _bedTime = picked;
      });
    }
  }

  Future<void> _selectWakeTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null && picked != _wakeTime && mounted) {
      setState(() {
        _wakeTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '$hours hr ${mins.toString().padLeft(2, '0')} min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Log Your Sleep',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.bedtime, color: Colors.indigo),
                            title: const Text('Bed Time'),
                            trailing: Text(
                              _formatTimeOfDay(_bedTime),
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: _selectBedTime,
                          ),
                          ListTile(
                            leading: const Icon(Icons.wb_sunny, color: Colors.orange),
                            title: const Text('Wake Time'),
                            trailing: Text(
                              _formatTimeOfDay(_wakeTime),
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: _selectWakeTime,
                          ),
                          ListTile(
                            leading: const Icon(Icons.star, color: Colors.amber),
                            title: const Text('Sleep Quality'),
                            trailing: DropdownButton<String>(
                              value: _sleepQuality,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _sleepQuality = newValue;
                                  });
                                }
                              },
                              items: _qualityOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveSleepData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Save Sleep Data'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_recentSleepEntries.isNotEmpty) ...[
                    const Text(
                      'Recent Sleep History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._recentSleepEntries.map(_buildSleepHistoryCard),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSleepHistoryCard(Map<String, dynamic> entry) {
    final dateStr = DateFormat('MMM dd, yyyy').format(entry['date']);
    final quality = entry['quality'];

    Color qualityColor;
    switch (quality) {
      case 'Excellent':
        qualityColor = Colors.green;
        break;
      case 'Good':
        qualityColor = Colors.teal;
        break;
      case 'Fair':
        qualityColor = Colors.orange;
        break;
      case 'Poor':
        qualityColor = Colors.red;
        break;
      default:
        qualityColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: qualityColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: qualityColor),
                  ),
                  child: Text(
                    quality,
                    style: TextStyle(
                      color: qualityColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.bedtime, size: 16, color: Colors.indigo),
                const SizedBox(width: 4),
                Text('Bed: ${entry['bedTime']}'),
                const SizedBox(width: 16),
                const Icon(Icons.wb_sunny, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text('Wake: ${entry['wakeTime']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(entry['duration']),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
