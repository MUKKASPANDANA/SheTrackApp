import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Symptom Model
class Symptom {
  final String id;
  final String name;
  final IconData icon;
  final List<String> severityLevels;
  final List<String> possibleCauses;
  final List<String> managementTips;

  Symptom({
    required this.id,
    required this.name,
    required this.icon,
    required this.severityLevels,
    required this.possibleCauses,
    required this.managementTips,
  });
}

// Symptom Entry Model (for logging)
class SymptomEntry {
  final String symptomId;
  final DateTime timestamp;
  final int severityLevel; // Index of the severity level
  final String? notes;

  SymptomEntry({
    required this.symptomId,
    required this.timestamp,
    required this.severityLevel,
    this.notes,
  });
}

// Symptom Database
class SymptomsDatabase {
  static List<Symptom> getAllSymptoms() {
    return [
      Symptom(
        id: 'cramps',
        name: 'Cramps',
        icon: Icons.coronavirus_outlined,
        severityLevels: ['Mild', 'Moderate', 'Severe', 'Debilitating'],
        possibleCauses: [
          'Normal menstrual cramps (primary dysmenorrhea)',
          'Endometriosis',
          'Uterine fibroids',
          'Pelvic inflammatory disease',
          'Adenomyosis',
        ],
        managementTips: [
          'Apply heat to your abdomen or lower back',
          'Take over-the-counter pain relievers as directed',
          'Gentle exercise such as walking or yoga',
          'Relaxation techniques and stress management',
          'Avoid alcohol and caffeine which can worsen symptoms',
        ],
      ),
      Symptom(
        id: 'bloating',
        name: 'Bloating',
        icon: Icons.opacity,
        severityLevels: ['Slight', 'Moderate', 'Severe'],
        possibleCauses: [
          'Hormonal fluctuations',
          'Water retention',
          'Digestive issues',
          'Food sensitivities',
        ],
        managementTips: [
          'Reduce salt intake to minimize water retention',
          'Stay hydrated',
          'Eat smaller, more frequent meals',
          'Avoid carbonated drinks and foods that cause gas',
          'Try gentle exercise to help reduce bloating',
        ],
      ),
      Symptom(
        id: 'headache',
        name: 'Headache',
        icon: Icons.sick,
        severityLevels: ['Mild', 'Moderate', 'Severe', 'Migraine'],
        possibleCauses: [
          'Hormonal changes',
          'Stress',
          'Dehydration',
          'Lack of sleep',
          'Eye strain',
        ],
        managementTips: [
          'Rest in a quiet, dark room',
          'Apply cold or warm compress to your head',
          'Stay hydrated',
          'Practice relaxation techniques',
          'Consider over-the-counter pain relievers as directed',
        ],
      ),
      Symptom(
        id: 'fatigue',
        name: 'Fatigue',
        icon: Icons.airline_seat_flat,
        severityLevels: ['Mild', 'Moderate', 'Severe'],
        possibleCauses: [
          'Hormonal changes',
          'Poor sleep quality',
          'Iron deficiency or anemia',
          'Stress',
          'Dehydration',
        ],
        managementTips: [
          'Prioritize quality sleep',
          'Consider iron-rich foods or supplements if approved by doctor',
          'Stay hydrated',
          'Take short power naps when needed',
          'Gentle exercise can actually boost energy levels',
        ],
      ),
      Symptom(
        id: 'mood_changes',
        name: 'Mood Changes',
        icon: Icons.mood_bad,
        severityLevels: ['Mild', 'Moderate', 'Severe'],
        possibleCauses: [
          'Hormonal fluctuations',
          'Stress',
          'Fatigue',
          'Nutritional factors',
          'Underlying mood disorders',
        ],
        managementTips: [
          'Regular exercise',
          'Mindfulness and meditation',
          'Ensure adequate sleep',
          'Consider reducing caffeine and sugar',
          'Connect with supportive friends or family',
        ],
      ),
      Symptom(
        id: 'breast_tenderness',
        name: 'Breast Tenderness',
        icon: Icons.favorite_border,
        severityLevels: ['Mild', 'Moderate', 'Severe'],
        possibleCauses: [
          'Hormonal changes during menstrual cycle',
          'Pregnancy',
          'Birth control pills or hormone therapy',
          'Fibrocystic breast changes',
        ],
        managementTips: [
          'Wear a supportive bra',
          'Apply cold or warm compresses',
          'Reduce salt and caffeine intake',
          'Over-the-counter pain relievers as directed',
          'Vitamin E supplements (consult with doctor first)',
        ],
      ),
      Symptom(
        id: 'acne',
        name: 'Acne Breakouts',
        icon: Icons.face,
        severityLevels: ['Few Spots', 'Several Spots', 'Severe Breakout'],
        possibleCauses: [
          'Hormonal fluctuations',
          'Increased oil production',
          'Bacteria',
          'Diet',
          'Stress',
        ],
        managementTips: [
          'Gentle cleansing twice daily',
          'Avoid touching your face',
          'Use non-comedogenic skin products',
          'Consider over-the-counter acne treatments',
          'Stay hydrated and maintain a balanced diet',
        ],
      ),
      Symptom(
        id: 'appetite_changes',
        name: 'Appetite Changes',
        icon: Icons.restaurant,
        severityLevels: ['Slight', 'Moderate', 'Significant'],
        possibleCauses: [
          'Hormonal changes',
          'Stress',
          'Emotional factors',
          'Medications',
        ],
        managementTips: [
          'Plan balanced meals and snacks',
          'Stay hydrated',
          'Choose nutrient-dense foods when cravings hit',
          'Eat mindfully and listen to your body',
          'Avoid highly processed foods when possible',
        ],
      ),
      Symptom(
        id: 'irregular_bleeding',
        name: 'Irregular Bleeding',
        icon: Icons.opacity_outlined,
        severityLevels: ['Spotting', 'Light', 'Moderate', 'Heavy'],
        possibleCauses: [
          'Hormonal imbalance',
          'Stress',
          'Birth control methods',
          'Uterine polyps or fibroids',
          'Pregnancy complications',
          'Thyroid issues',
        ],
        managementTips: [
          'Track bleeding patterns carefully',
          'Use appropriate menstrual products',
          'Consider iron-rich foods if bleeding is heavy',
          'Consult healthcare provider if bleeding is unusual',
        ],
      ),
    ];
  }

  static Symptom? getSymptomById(String id) {
    try {
      return getAllSymptoms().firstWhere((symptom) => symptom.id == id);
    } catch (e) {
      return null;
    }
  }
}

// Main Symptoms Tracker Page
class SymptomsTrackerPage extends StatefulWidget {
  @override
  _SymptomsTrackerPageState createState() => _SymptomsTrackerPageState();
}

class _SymptomsTrackerPageState extends State<SymptomsTrackerPage> {
  final List<Symptom> allSymptoms = SymptomsDatabase.getAllSymptoms();
  List<SymptomEntry> symptomEntries = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SymptomHistoryPage(entries: symptomEntries),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: allSymptoms.length,
        itemBuilder: (context, index) {
          return SymptomCard(
            symptom: allSymptoms[index],
            onLogSymptom: (severityLevel, notes) {
              _logSymptom(allSymptoms[index].id, severityLevel, notes);
            },
          );
        },
      ),
    );
  }

  void _logSymptom(String symptomId, int severityLevel, String? notes) {
    setState(() {
      symptomEntries.add(
        SymptomEntry(
          symptomId: symptomId,
          timestamp: DateTime.now(),
          severityLevel: severityLevel,
          notes: notes,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Symptom logged successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Individual Symptom Card Widget
class SymptomCard extends StatelessWidget {
  final Symptom symptom;
  final Function(int, String?) onLogSymptom;

  const SymptomCard({
    required this.symptom,
    required this.onLogSymptom,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(symptom.icon, color: Theme.of(context).primaryColor),
        title: Text(
          symptom.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log this symptom:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    symptom.severityLevels.length,
                    (index) => ElevatedButton(
                      onPressed: () {
                        _showNotesDialog(context, index);
                      },
                      child: Text(symptom.severityLevels[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getSeverityColor(index, symptom.severityLevels.length),
                      ),
                    ),
                  ),
                ),
                Divider(height: 24),
                _buildInfoSection('Possible Causes:', symptom.possibleCauses),
                SizedBox(height: 12),
                _buildInfoSection('Management Tips:', symptom.managementTips),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 6),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
      ],
    );
  }

  Color _getSeverityColor(int level, int maxLevels) {
    if (maxLevels <= 1) return Colors.blue;
    
    double factor = level / (maxLevels - 1);
    
    if (factor < 0.25) return Colors.green;
    if (factor < 0.5) return Colors.amber;
    if (factor < 0.75) return Colors.orange;
    return Colors.red;
  }

  void _showNotesDialog(BuildContext context, int severityLevel) {
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Notes'),
        content: TextField(
          controller: notesController,
          decoration: InputDecoration(
            hintText: 'Any additional details? (Optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onLogSymptom(severityLevel, notesController.text.isEmpty ? null : notesController.text);
            },
            child: Text('SAVE'),
          ),
        ],
      ),
    );
  }
}

// Symptom History Page
class SymptomHistoryPage extends StatelessWidget {
  final List<SymptomEntry> entries;

  const SymptomHistoryPage({required this.entries});

  @override
  Widget build(BuildContext context) {
    // Sort entries by timestamp, newest first
    final sortedEntries = List<SymptomEntry>.from(entries)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom History'),
      ),
      body: sortedEntries.isEmpty
          ? Center(
              child: Text(
                'No symptoms logged yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: sortedEntries.length,
              itemBuilder: (context, index) {
                final entry = sortedEntries[index];
                final symptom = SymptomsDatabase.getSymptomById(entry.symptomId);
                
                if (symptom == null) return SizedBox();
                
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(symptom.icon),
                      backgroundColor: _getSeverityColor(entry.severityLevel, symptom.severityLevels.length),
                    ),
                    title: Text(symptom.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Severity: ${symptom.severityLevels[entry.severityLevel]}'),
                        Text(
                          DateFormat('MMM dd, yyyy - h:mm a').format(entry.timestamp),
                          style: TextStyle(fontSize: 12),
                        ),
                        if (entry.notes != null && entry.notes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Notes: ${entry.notes}',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                    isThreeLine: entry.notes != null && entry.notes!.isNotEmpty,
                  ),
                );
              },
            ),
    );
  }

  Color _getSeverityColor(int level, int maxLevels) {
    if (maxLevels <= 1) return Colors.blue;
    
    double factor = level / (maxLevels - 1);
    
    if (factor < 0.25) return Colors.green;
    if (factor < 0.5) return Colors.amber;
    if (factor < 0.75) return Colors.orange;
    return Colors.red;
  }
}

// Main App
void main() {
  runApp(MaterialApp(
    title: 'She Track App',
    theme: ThemeData(
      primarySwatch: Colors.purple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: SymptomsTrackerPage(),
  ));
}