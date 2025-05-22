import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this package to pubspec.yaml
import 'download_data.dart'; // Import the download_data.dart file

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HealthInsightScreen extends StatefulWidget {
  const HealthInsightScreen({super.key});

  @override
  State<HealthInsightScreen> createState() => _HealthInsightScreenState();
}

class _HealthInsightScreenState extends State<HealthInsightScreen> with SingleTickerProviderStateMixin {
  List<DateTime> periodDates = [];
  List<int> painLevels = [];
  List<int> cycleLengths = [];
  bool isLoading = true;

  double? averageCycleLength;
  double? averagePainLevel;
  DateTime? lastPeriodDate;
  String painTrend = "";
  DateTime? estimatedNextPeriod;
  double? bmi;
  
  late TabController _tabController;

  final List<String> healthTips = [
    "Drink enough water throughout your cycle.",
    "Track emotional changes along with physical symptoms.",
    "Gentle yoga or walking helps relieve cramps.",
    "Eat iron-rich foods like spinach during periods.",
    "Avoid high caffeine intake close to your period.",
    "Using a heating pad can help relieve menstrual cramps.",
    "Regular exercise may help reduce PMS symptoms.",
    "Consider tracking your mood alongside your cycle.",
    "Stay hydrated, especially during your period.",
    "Prioritize good sleep hygiene throughout your cycle.",
  ];

  late String todayTip;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    todayTip = (healthTips..shuffle()).first;
    fetchInsights();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchInsights() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('period_logs')
          .orderBy('date')
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

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

      painLevels = snapshot.docs
          .map((doc) => (doc['painLevel'] ?? 0) as int)
          .toList();

      if (periodDates.length > 1) {
        cycleLengths = [];
        for (int i = 1; i < periodDates.length; i++) {
          cycleLengths.add(periodDates[i].difference(periodDates[i - 1]).inDays);
        }
        averageCycleLength = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
        if (averageCycleLength != null) {
          estimatedNextPeriod =
              periodDates.last.add(Duration(days: averageCycleLength!.round()));
        }
      }

      if (painLevels.isNotEmpty) {
        averagePainLevel =
            painLevels.reduce((a, b) => a + b) / painLevels.length;

        if (painLevels.length >= 3) {
          final recent = painLevels.sublist(painLevels.length - 3);
          if (recent[2] > recent[0]) {
            painTrend = "Increasing";
          } else if (recent[2] < recent[0]) {
            painTrend = "Decreasing";
          } else {
            painTrend = "Stable";
          }
        }
      }

      lastPeriodDate = periodDates.last;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
      final data = userDoc.data();
      if (data != null) {
        final rawWeight = data['weight'];
        final rawHeight = data['height'];
        print("rawWeight: $rawWeight, rawHeight: $rawHeight");

        if (rawWeight != null && rawHeight != null) {
  double weight;
  double heightInCm;

  if (rawWeight is num) {
    weight = rawWeight.toDouble();
  } else if (rawWeight is String) {
    weight = double.tryParse(rawWeight) ?? 0.0;
  } else {
    weight = 0.0;
  }

  if (rawHeight is num) {
    heightInCm = rawHeight.toDouble();
  } else if (rawHeight is String) {
    heightInCm = double.tryParse(rawHeight) ?? 0.0;
  } else {
    heightInCm = 0.0;
  }

  if (heightInCm > 0) {
    double heightInMeters = heightInCm / 100;
    
    bmi = weight / (heightInMeters * heightInMeters);
    bmi = double.parse(bmi!.toStringAsFixed(1)); // Round to 1 decimal place
  }
}

    }



    }
    } catch (e) {
      print("Error fetching insights: $e");
    }

    setState(() => isLoading = false);
  }

  Widget buildStatCard(String title, String value, IconData icon,
      {Color color = Colors.purple}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildWarningCard(String message) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: const Text("Health Alert", style: TextStyle(color: Colors.red)),
        subtitle: Text(message),
      ),
    );
  }

  Widget buildTipCard(String tip) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.lightbulb, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Today's Health Tip",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tip,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("New Tip"),
                onPressed: () {
                  setState(() {
                    todayTip = (healthTips..shuffle()).first;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPainLevelGraph() {
    if (painLevels.isEmpty) return const Center(child: Text("No pain data available"));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pain Level Trend",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 2,
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= periodDates.length) {
                          return const Text('');
                        }
                        // Just show month and day for x-axis labels
                        return Text(
                          DateFormat('d-M').format(periodDates[index]),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: (painLevels.length - 1).toDouble(),
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(painLevels.length, (index) {
                      return FlSpot(index.toDouble(), painLevels[index].toDouble());
                    }),
                    isCurved: true,
                    color: Colors.pinkAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.pinkAccent.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCycleLengthGraph() {
    if (cycleLengths.isEmpty) return const Center(child: Text("Not enough data to calculate cycle lengths"));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cycle Length History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (cycleLengths.reduce((a, b) => max(a, b)) + 5).toDouble(),
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                     // This is the corrected parameter
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${cycleLengths[groupIndex]} days',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= cycleLengths.length) {
                          return const Text('');
                        }
                        // Find the end date of the cycle
                        DateTime cycleEndDate = periodDates[index + 1];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MMM').format(cycleEndDate),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true, horizontalInterval: 5),
                barGroups: List.generate(cycleLengths.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: cycleLengths[index].toDouble(),
                        color: cycleLengths[index] >= 21 && cycleLengths[index] <= 35
                            ? Colors.purple 
                            : Colors.redAccent, // Highlight abnormal cycles
                        width: 16,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (averageCycleLength != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timeline, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                    "Average: ${averageCycleLength!.toStringAsFixed(1)} days",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildInsightsOverview() {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 251, 64, 198), Color.fromARGB(255, 176, 39, 69)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Cycle Summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Last Period",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastPeriodDate != null 
                            ? DateFormat('MMM d').format(lastPeriodDate!)
                            : "N/A",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Next Period",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        estimatedNextPeriod != null 
                            ? DateFormat('MMM d').format(estimatedNextPeriod!)
                            : "N/A",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Cycle Length",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        averageCycleLength != null 
                            ? "${averageCycleLength!.toStringAsFixed(1)} days"
                            : "N/A",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (estimatedNextPeriod != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "${DateTime.now().difference(estimatedNextPeriod!).inDays.abs()} days ${DateTime.now().isAfter(estimatedNextPeriod!) ? 'overdue' : 'until next period'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        buildTipCard(todayTip),
        if (averagePainLevel != null)
          buildStatCard(
            "Average Pain Level",
            "${averagePainLevel!.toStringAsFixed(1)} / 10",
            Icons.monitor_heart,
            color: Colors.redAccent,
          ),
          buildStatCard(
            "BMI",
            "${bmi}",
            Icons.scale,
            color: const Color.fromARGB(255, 79, 151, 40),
          ),
          
        if (painTrend.isNotEmpty)
          buildStatCard(
            "Pain Trend",
            painTrend,
            Icons.trending_up,
            color: Colors.orange,
          ),
        if (averageCycleLength != null &&
            (averageCycleLength! < 21 || averageCycleLength! > 35))
          buildWarningCard(
              "Your cycle length is outside the normal range (21–35 days). It is recommended to consult a healthcare provider."),
        Expanded(
  child: ElevatedButton.icon(
    icon: const Icon(Icons.download),
    label: const Text("Download Insights"),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 124, 27, 98),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
    onPressed: () async {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Generating PDF...")
              ],
            ),
          );
        },
      );
      
      try {
        await downloadInsightsPdf(
          context,
          periodDates: periodDates,
          painLevels: painLevels,
          cycleLengths: cycleLengths,
          averageCycleLength: averageCycleLength,
          averagePainLevel: averagePainLevel,
          lastPeriodDate: lastPeriodDate,
          estimatedNextPeriod: estimatedNextPeriod,
          painTrend: painTrend,
          bmi: bmi,
        );
        
        // Close the loading dialog
        Navigator.of(context).pop();
      } catch (e) {
        // Close the loading dialog
        Navigator.of(context).pop();
        
        // Show error toast
        Fluttertoast.showToast(
          msg: "Error generating PDF: ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    },
  ),
),
        // Quick stats in cards
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Statistics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatisticBox(
                      "Tracked Cycles",
                      periodDates.length.toString(),
                      Icons.repeat,
                      Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatisticBox(
                      "Data Points",
                      (periodDates.length + painLevels.length).toString(),
                      Icons.data_usage,
                      Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatisticBox(
                      "Longest Cycle",
                      cycleLengths.isNotEmpty ? "${cycleLengths.reduce(max)} days" : "N/A",
                      Icons.arrow_circle_up,
                      Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatisticBox(
                      "Shortest Cycle",
                      cycleLengths.isNotEmpty ? "${cycleLengths.reduce(min)} days" : "N/A",
                      Icons.arrow_circle_down,
                      Colors.amber,
                    ),
                  ),
                  
                ],
                
              ),
              
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Insights"),
        backgroundColor: const Color.fromARGB(255, 176, 39, 96),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: "Overview"),
            Tab(icon: Icon(Icons.bar_chart), text: "Graphs"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : periodDates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hourglass_empty,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "No Data Available",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Start tracking your periods to see insights",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Log Your Period"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          // Navigate to period logging screen
                        },
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    buildInsightsOverview(),
                    ListView(
                      children: [
                        buildPainLevelGraph(),
                        const Divider(),
                        buildCycleLengthGraph(),
                      ],
                    ),
                  ],
                ),
    );
  }
}