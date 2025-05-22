import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CycleHistoryPage extends StatefulWidget {
  const CycleHistoryPage({Key? key}) : super(key: key);

  @override
  _CycleHistoryPageState createState() => _CycleHistoryPageState();
}

class _CycleHistoryPageState extends State<CycleHistoryPage> {
  // Sample cycle data - in a real app, this would come from a database
  final List<Map<String, dynamic>> _cycleHistory = [
    {
      'startDate': DateTime(2025, 3, 10),
      'endDate': DateTime(2025, 3, 15),
      'duration': 6,
      'symptoms': ['Cramps', 'Fatigue', 'Headache'],
      'flow': 'Medium',
      'notes': 'Took ibuprofen for cramps on day 2'
    },
    {
      'startDate': DateTime(2025, 2, 12),
      'endDate': DateTime(2025, 2, 17),
      'duration': 6,
      'symptoms': ['Cramps', 'Bloating'],
      'flow': 'Heavy',
      'notes': 'Cycle started 2 days earlier than expected'
    },
    {
      'startDate': DateTime(2025, 1, 15),
      'endDate': DateTime(2025, 1, 20),
      'duration': 6,
      'symptoms': ['Mild cramps'],
      'flow': 'Light',
      'notes': ''
    },
    {
      'startDate': DateTime(2024, 12, 18),
      'endDate': DateTime(2024, 12, 23),
      'duration': 6,
      'symptoms': ['Cramps', 'Mood swings'],
      'flow': 'Medium',
      'notes': 'Tried new menstrual cup'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle History'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCycleSummary(),
          Expanded(
            child: _buildCycleHistoryList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9C27B0),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showAddCycleDialog();
        },
      ),
    );
  }

  Widget _buildCycleSummary() {
    // Calculate average cycle length
    int totalDays = 0;
    for (int i = 0; i < _cycleHistory.length - 1; i++) {
      final currentStart = _cycleHistory[i]['startDate'] as DateTime;
      final nextStart = _cycleHistory[i + 1]['startDate'] as DateTime;
      totalDays += currentStart.difference(nextStart).abs().inDays;
    }
    final avgCycleLength = _cycleHistory.length > 1 
        ? (totalDays / (_cycleHistory.length - 1)).round() 
        : 0;

    // Calculate average period length
    final avgPeriodLength = _cycleHistory.isNotEmpty 
        ? _cycleHistory.map((c) => c['duration'] as int).reduce((a, b) => a + b) / _cycleHistory.length 
        : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F0FC),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Your Cycle Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C27B0),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryCard(
                'Average Cycle',
                '$avgCycleLength days',
                Icons.calendar_today,
              ),
              _buildSummaryCard(
                'Average Period',
                '${avgPeriodLength.toStringAsFixed(1)} days',
                Icons.water_drop,
              ),
              _buildSummaryCard(
                'Cycles Tracked',
                '${_cycleHistory.length}',
                Icons.history,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF9C27B0)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCycleHistoryList() {
    if (_cycleHistory.isEmpty) {
      return const Center(
        child: Text(
          'No cycle history yet. Tap + to add your first cycle.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cycleHistory.length,
      itemBuilder: (context, index) {
        final cycle = _cycleHistory[index];
        final startDate = cycle['startDate'] as DateTime;
        final endDate = cycle['endDate'] as DateTime;
        final formatter = DateFormat('MMM d, yyyy');
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showCycleDetails(cycle),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month, 
                        color: Color(0xFF9C27B0),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${formatter.format(startDate)} - ${formatter.format(endDate)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8BBD0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${cycle['duration']} days',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFAD1457),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoPill('Flow: ${cycle['flow']}'),
                      const SizedBox(width: 8),
                      if ((cycle['symptoms'] as List).isNotEmpty)
                        _buildInfoPill('${(cycle['symptoms'] as List).length} symptoms'),
                    ],
                  ),
                  if (cycle['notes'].toString().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Notes: ${cycle['notes']}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showCycleDetails(Map<String, dynamic> cycle) {
    final startDate = cycle['startDate'] as DateTime;
    final endDate = cycle['endDate'] as DateTime;
    final formatter = DateFormat('MMMM d, yyyy');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Cycle Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF9C27B0),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailItem(
                  'Start Date',
                  formatter.format(startDate),
                  Icons.calendar_today,
                ),
                _buildDetailItem(
                  'End Date',
                  formatter.format(endDate),
                  Icons.event,
                ),
                _buildDetailItem(
                  'Duration',
                  '${cycle['duration']} days',
                  Icons.timelapse,
                ),
                _buildDetailItem(
                  'Flow',
                  cycle['flow'],
                  Icons.water_drop,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Symptoms',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final symptom in (cycle['symptoms'] as List))
                      Chip(
                        label: Text(symptom),
                        backgroundColor: const Color(0xFFF8BBD0),
                        labelStyle: const TextStyle(color: Color(0xFFAD1457)),
                      ),
                  ],
                ),
                if (cycle['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(cycle['notes']),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditCycleDialog(cycle);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Edit Cycle'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    _deleteCycle(cycle);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Delete Cycle'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9C27B0)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCycleDialog() {
    // In a real app, this would be a form with date pickers, etc.
    // For simplicity, just showing a placeholder
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Cycle'),
        content: const Text('This would be a form to add a new cycle.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            onPressed: () {
              // In a real app, we'd add the new cycle to the database
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditCycleDialog(Map<String, dynamic> cycle) {
    // In a real app, this would be a form pre-filled with cycle data
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Cycle'),
        content: const Text('This would be a form to edit the cycle.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            onPressed: () {
              // In a real app, we'd update the cycle in the database
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCycle(Map<String, dynamic> cycle) {
    setState(() {
      _cycleHistory.removeWhere((c) => 
        c['startDate'] == cycle['startDate'] && 
        c['endDate'] == cycle['endDate']
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cycle deleted'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }
}