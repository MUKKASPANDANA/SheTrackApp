import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';

class PeriodCalendarScreen extends StatefulWidget {
  @override
  _PeriodCalendarScreenState createState() => _PeriodCalendarScreenState();
}

class _PeriodCalendarScreenState extends State<PeriodCalendarScreen> {
  // Theme colors
  final Color primaryColor = Color(0xFFE91E63); // Pink 500
  final Color lightPink = Color(0xFFF8BBD0); // Pink 100
  final Color darkPink = Color(0xFFC2185B); // Pink 700
  final Color accentColor = Color(0xFF9C27B0); // Purple 500
  final Color backgroundColor = Color(0xFFFCE4EC); // Pink 50
  final Color surfaceColor = Colors.white;
  final Color textColor = Color(0xFF212121); // Grey 900

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<DateTime, int> _markedDatesWithPain = {};
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedPainLevel = 5;

  @override
  void initState() {
    super.initState();
    _loadUserPainLogs();
    _selectedDay = _normalizeDate(DateTime.now());
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Gets a unique string identifier for a date (for Firestore document ID)
  String _getDateId(DateTime date) {
    final normalized = _normalizeDate(date);
    return normalized.toIso8601String().split('T')[0]; // YYYY-MM-DD format
  }

  Future<void> _loadUserPainLogs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('period_logs')
          .get();

      final Map<DateTime, int> newMarkedDates = {};
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        DateTime date;
        
        // Handle different date formats
        if (data['date'] is Timestamp) {
          date = _normalizeDate((data['date'] as Timestamp).toDate());
        } else if (data['date'] is String) {
          try {
            date = _normalizeDate(DateTime.parse(data['date'] as String));
          } catch (e) {
            print("Invalid date string: ${data['date']}");
            continue;
          }
        } else {
          print("Unknown date format: ${data['date']}");
          continue; // Skip invalid dates
        }
        
        final painLevel = (data['painLevel'] is int) 
            ? data['painLevel'] as int 
            : int.tryParse(data['painLevel']?.toString() ?? '') ?? 5;
            
        newMarkedDates[date] = painLevel;
      }

      setState(() {
        _markedDatesWithPain = newMarkedDates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load data: ${e.toString()}";
        _isLoading = false;
      });
      print("Error loading data: $e");
    }
  }

  Future<void> _savePeriodLog(DateTime date) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      final normalizedDate = _normalizeDate(date);
      final docId = _getDateId(normalizedDate);
      
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('period_logs')
          .doc(docId);

      await docRef.set({
        'date': Timestamp.fromDate(normalizedDate), // Store as Timestamp
        'painLevel': _selectedPainLevel,
        'dateString': normalizedDate.toIso8601String(), // Also store as string for backup
        'lastUpdated': FieldValue.serverTimestamp(), // Track when it was last updated
      });

      // Update local state immediately for a more responsive UI
      setState(() {
        _markedDatesWithPain[normalizedDate] = _selectedPainLevel;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Period data saved successfully'),
          backgroundColor: darkPink,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // Reload from server to ensure synchronization
      _loadUserPainLogs();
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to save data: ${e.toString()}";
        _isLoading = false;
      });
      print("Error saving data: $e");
    }
  }

  Future<void> _unsavePeriodLog(DateTime date) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _auth.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = "User not logged in";
          _isLoading = false;
        });
        return;
      }

      final normalizedDate = _normalizeDate(date);
      final docId = _getDateId(normalizedDate);
      
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('period_logs')
          .doc(docId);

      // Get document first to verify it exists
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
        print("Document deleted successfully: $docId");
        
        // Update local state immediately for responsive UI
        setState(() {
          // Find and remove the exact date
          final keysToRemove = <DateTime>[];
          for (final key in _markedDatesWithPain.keys) {
            if (isSameDay(key, normalizedDate)) {
              keysToRemove.add(key);
            }
          }
          for (final key in keysToRemove) {
            _markedDatesWithPain.remove(key);
          }
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Period data deleted'),
            backgroundColor: Colors.grey[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print("Document not found for deletion: $docId");
        setState(() {
          _isLoading = false;
        });
      }
      
      // Reload from server to ensure synchronization
      _loadUserPainLogs();
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to delete data: ${e.toString()}";
        _isLoading = false;
      });
      print("Error deleting data: $e");
    }
  }

  bool _isMarked(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    return _markedDatesWithPain.keys.any((d) => isSameDay(d, normalizedDate));
  }

  int _getPainLevel(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    for (var entry in _markedDatesWithPain.entries) {
      if (isSameDay(entry.key, normalizedDate)) {
        return entry.value;
      }
    }
    return 0;
  }

  Color _getPainColor(int painLevel) {
    // Color gradient based on pain level
    if (painLevel <= 2) {
      return lightPink.withOpacity(0.7);
    } else if (painLevel <= 5) {
      return primaryColor.withOpacity(0.8);
    } else if (painLevel <= 8) {
      return darkPink.withOpacity(0.9);
    } else {
      return darkPink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: surfaceColor,
          onSurface: textColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: primaryColor,
          thumbColor: primaryColor,
          overlayColor: primaryColor.withOpacity(0.3),
          inactiveTrackColor: lightPink,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Period Tracker',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadUserPainLogs,
              tooltip: 'Refresh data',
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundColor,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = _normalizeDate(selectedDay);
                        _focusedDay = focusedDay;
                        // Set pain level to current or default
                        _selectedPainLevel = _isMarked(_selectedDay!)
                            ? _getPainLevel(_selectedDay!)
                            : 5;
                      });
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonDecoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      formatButtonTextStyle: TextStyle(color: primaryColor),
                      formatButtonShowsNext: false,
                      titleTextStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: darkPink,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.red[300]),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final normalizedDay = _normalizeDate(day);
                        if (_isMarked(normalizedDay)) {
                          final painLevel = _getPainLevel(normalizedDay);
                          return Container(
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _getPainColor(painLevel),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getPainColor(painLevel).withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              if (_selectedDay != null)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_isLoading)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            ),
                          ),
                        if (_errorMessage != null)
                          Card(
                            color: Colors.red[50],
                            margin: EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(color: Colors.red[700]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Selected Date:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 28, top: 4, bottom: 16),
                                  child: Text(
                                    '${_selectedDay!.toLocal().toString().split(' ')[0]}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: darkPink,
                                    ),
                                  ),
                                ),
                                Divider(color: lightPink),
                                SizedBox(height: 16),
                                if (_isMarked(_selectedDay!)) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.healing,
                                        color: _getPainColor(_getPainLevel(_selectedDay!)),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Current Pain Level: ${_getPainLevel(_selectedDay!)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: _getPainColor(_getPainLevel(_selectedDay!)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                ],
                                Text(
                                  'Adjust Pain Level:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: lightPink),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: _selectedPainLevel.toDouble(),
                                          min: 0,
                                          max: 10,
                                          divisions: 10,
                                          label: _selectedPainLevel.toString(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedPainLevel = value.toInt();
                                            });
                                          },
                                          activeColor: _getPainColor(_selectedPainLevel),
                                        ),
                                      ),
                                      Text(
                                        '10',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _isLoading
                                            ? null
                                            : () async {
                                                await _savePeriodLog(_selectedDay!);
                                              },
                                        icon: Icon(_isMarked(_selectedDay!)
                                            ? Icons.update
                                            : Icons.add),
                                        label: Text(_isMarked(_selectedDay!)
                                            ? 'Update'
                                            : 'Save'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _isMarked(_selectedDay!)
                                              ? Colors.pink
                                              : primaryColor,
                                          disabledBackgroundColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    if (_isMarked(_selectedDay!)) ...[
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: _isLoading
                                              ? null
                                              : () async {
                                                  // Show confirmation dialog
                                                  bool confirm = await showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text('Delete Entry?'),
                                                      content: Text(
                                                          'Are you sure you want to delete this period data?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, false),
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, true),
                                                          child: Text('Delete'),
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ) ?? false;

                                                  if (confirm) {
                                                    await _unsavePeriodLog(_selectedDay!);
                                                  }
                                                },
                                          icon: Icon(Icons.delete_outline),
                                          label: Text('Delete'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _isMarked(_selectedDay!)
                                        ? Colors.green[50]
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _isMarked(_selectedDay!)
                                          ? Colors.green[200]!
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _isMarked(_selectedDay!)
                                            ? Icons.check_circle_outline
                                            : Icons.info_outline,
                                        color: _isMarked(_selectedDay!)
                                            ? Colors.green[700]
                                            : Colors.grey[600],
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        _isMarked(_selectedDay!)
                                            ? 'Marked as period day'
                                            : 'Not marked as period day',
                                        style: TextStyle(
                                          color: _isMarked(_selectedDay!)
                                              ? Colors.green[700]
                                              : Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        if (_isMarked(_selectedDay!))
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pain Level Guide',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: darkPink,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  _buildPainLevelIndicator('0-2', 'Mild', lightPink),
                                  _buildPainLevelIndicator('3-5', 'Moderate', primaryColor),
                                  _buildPainLevelIndicator('6-8', 'Severe', darkPink.withOpacity(0.8)),
                                  _buildPainLevelIndicator('9-10', 'Very Severe', darkPink),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPainLevelIndicator(String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Text(
            '$range: $label',
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}