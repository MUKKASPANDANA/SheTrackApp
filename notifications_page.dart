import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<bool> init() async {
    if (_initialized) return true;
    
    try {
      // Initialize timezones
      tz.initializeTimeZones();
      
      // Initialize Android settings
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // Initialize iOS settings
      final DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          // Handle iOS foreground notification
        }
      );
      
      // Complete initialization
      final InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      );
      
      final bool? success = await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          // Handle notification tapped
          print('Notification tapped: ${notificationResponse.payload}');
        },
      );
      
      _initialized = success ?? false;
      print('Notification service initialized: $_initialized');
      return _initialized;
    } catch (e) {
      print('Error initializing notifications: $e');
      return false;
    }
  }

  static Future<bool> requestPermissions() async {
    // Request notification permissions
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> showDebugNotification() async {
    await init();
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'debug_channel',
      'Debug Notifications',
      channelDescription: 'Used for testing notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    
    await _notifications.show(
      0,
      'Test Notification',
      'This is a test notification. If you see this, notifications are working!',
      platformDetails,
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeating = false,
    RepeatInterval? repeatInterval,
  }) async {
    try {
      print('Scheduling notification for: $scheduledDate');
      await init();
      
      // Convert to TZDateTime
      final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(scheduledDate, tz.local);
      
      // Check if the scheduled time is in the past
      if (scheduledDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
        print('Warning: Attempted to schedule notification in the past. Adjusted to future time.');
        // Reschedule for tomorrow at the same time if it's in the past
        final scheduledTomorrow = tz.TZDateTime(
          tz.local,
          scheduledDateTime.year,
          scheduledDateTime.month,
          scheduledDateTime.day + 1,
          scheduledDateTime.hour,
          scheduledDateTime.minute,
        );
        
        return scheduleNotification(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledTomorrow.toLocal(),
          payload: payload,
          repeating: repeating,
          repeatInterval: repeatInterval,
        );
      }
      
      // Create platform-specific notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'wellness_reminders',
        'Wellness Reminders',
        channelDescription: 'Reminders for period tracking and hydration',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        styleInformation: BigTextStyleInformation(''),
      );
      
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      
      if (repeating && repeatInterval != null) {
        // Schedule repeating notification
        await _notifications.periodicallyShow(
          id,
          title,
          body,
          repeatInterval,
          platformDetails,
          androidAllowWhileIdle: true,
          payload: payload,
        );
        print('Scheduled repeating notification with ID: $id');
      } else {
        // Schedule one-time notification
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledDateTime,
          platformDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
        print('Scheduled one-time notification with ID: $id');
      }
      
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }
}

class NotificationManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Initialize the manager
  static Future<void> initialize() async {
    await NotificationService.init();
    await NotificationService.requestPermissions();
  }
  
  // Schedule all notifications based on user data
  static Future<void> scheduleAllNotifications() async {
    try {
      String? userId = _auth.currentUser?.uid;
      
      // Cancel existing notifications first
      await NotificationService.cancelAllNotifications();
      
      // Schedule period notifications
      await schedulePeriodNotifications(userId);
      
      // Schedule hydration notifications
      await scheduleHydrationNotifications();
      
    } catch (e) {
      print('Error scheduling notifications: $e');
    }
  }
  
  // Calculate and schedule period notifications based on historical data
  static Future<void> schedulePeriodNotifications(String userId) async {
    try {
      // Get user settings
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return;
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      bool periodNotificationsEnabled = userData['periodNotificationsEnabled'] ?? true;
      int periodReminderDays = userData['periodReminderDays'] ?? 3;
      
      if (!periodNotificationsEnabled) return;
      
      // Get period history in chronological order
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('period_logs')
          .orderBy('date')
          .get();
          
      if (snapshot.docs.isEmpty) return;
      
      // Calculate average cycle length based on history
      int totalCycles = 0;
      int totalDays = 0;
      DateTime? previousDate;
      
      for (var doc in snapshot.docs) {
        DateTime currentDate = (doc['date'] as Timestamp).toDate();
        
        if (previousDate != null) {
          int daysBetween = currentDate.difference(previousDate).inDays;
          if (daysBetween > 14 && daysBetween < 45) { // Valid cycle range
            totalDays += daysBetween;
            totalCycles++;
          }
        }
        
        previousDate = currentDate;
      }
      
      // Default to 28 days if not enough data
      int averageCycleLength = totalCycles > 0 ? (totalDays / totalCycles).round() : 28;
      
      // Get the most recent period start date
      DateTime lastPeriodDate = (snapshot.docs.last['date'] as Timestamp).toDate();
      
      // Predict next period
      DateTime predictedNextPeriod = lastPeriodDate.add(Duration(days: averageCycleLength));
      
      // Schedule notification for X days before predicted period
      DateTime notificationDate = predictedNextPeriod.subtract(Duration(days: periodReminderDays));
      
      // Only schedule if the date is in the future
      if (notificationDate.isAfter(DateTime.now())) {
        await NotificationService.scheduleNotification(
          id: 1,
          title: 'Upcoming Period',
          body: 'Your period is expected in $periodReminderDays days. Remember to stay prepared 💕',
          scheduledDate: notificationDate,
          payload: 'period_reminder',
        );
        
        print('Scheduled period notification for: ${notificationDate.toString()}');
      }
      
    } catch (e) {
      print('Error scheduling period notifications: $e');
    }
  }
  
  // Schedule hydration notifications based on user settings and current intake
  static Future<void> scheduleHydrationNotifications() async {
    try {
      // Get hydration settings from Hive
      Box hydrationBox = Hive.box('hydrationBox');
      bool waterReminderEnabled = hydrationBox.get('waterReminderEnabled', defaultValue: true);
      int waterReminderHours = hydrationBox.get('waterReminderHours', defaultValue: 2);
      
      if (!waterReminderEnabled) return;
      
      // Get today's water intake data
      final stored = hydrationBox.get('entries', defaultValue: []) as List<dynamic>;
      final today = DateTime.now();
      
      List<Map<String, dynamic>> todayEntries = stored
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
          
      int totalCups = todayEntries.fold(0, (sum, entry) => sum + (entry['cups'] as int));
      
      // Calculate target cups based on recommended daily intake (8 cups)
      int targetCups = 8;
      int remainingCups = targetCups - totalCups;
      
      // Define the notification message based on current intake
      String notificationBody;
      if (remainingCups <= 0) {
        notificationBody = 'Great job staying hydrated today! Keep it up 💧';
      } else if (remainingCups <= 2) {
        notificationBody = 'You\'re almost there! Drink $remainingCups more cup${remainingCups == 1 ? '' : 's'} to reach your goal 💧';
      } else {
        notificationBody = 'Time to hydrate! You still need $remainingCups more cups to reach your daily goal 💧';
      }
      
      // Schedule hourly reminders
      await NotificationService.scheduleNotification(
        id: 2,
        title: 'Hydration Reminder',
        body: notificationBody,
        scheduledDate: DateTime.now().add(Duration(hours: waterReminderHours)),
        repeating: true,
        repeatInterval: RepeatInterval.hourly,
        payload: 'hydration_reminder',
      );
      
      print('Scheduled hydration notifications every $waterReminderHours hour(s)');
      
    } catch (e) {
      print('Error scheduling hydration notifications: $e');
    }
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late Box _hiveBox;
  
  bool _isPeriodNotificationsEnabled = true;
  bool _isWaterReminderEnabled = true;
  bool _isLoading = true;
  bool _notificationsPermissionGranted = false;
  
  // Default values
  int _waterReminderHours = 2;
  int _periodReminderDays = 3;
  
  // Stats for display
  DateTime? _predictedNextPeriod;
  int _todayWaterIntake = 0;
  int _targetWaterIntake = 8;
  
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }
  
  Future<void> _initializeNotifications() async {
    setState(() => _isLoading = true);
    
    try {
      // Open Hive box
      _hiveBox = Hive.box('hydrationBox');
      
      // Initialize notification service
      await NotificationService.init();
      
      // Check notification permissions
      _notificationsPermissionGranted = await NotificationService.requestPermissions();
      
      // Load notification settings
      await _loadSettings();
      
      // Load stats for display
      await _loadStats();
      
    } catch (e) {
      print('Error initializing notifications: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _loadSettings() async {
    try {
      // Load water reminder settings
      _waterReminderHours = _hiveBox.get('waterReminderHours', defaultValue: 2);
      _isWaterReminderEnabled = _hiveBox.get('waterReminderEnabled', defaultValue: true);
      
      // Load period reminder settings
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          _isPeriodNotificationsEnabled = userData['periodNotificationsEnabled'] ?? true;
          _periodReminderDays = userData['periodReminderDays'] ?? 3;
        }
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
  }
  
  Future<void> _loadStats() async {
    try {
      // Load water intake for today
      final stored = _hiveBox.get('entries', defaultValue: []) as List<dynamic>;
      final today = DateTime.now();
      
      List<Map<String, dynamic>> todayEntries = stored
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
          
      _todayWaterIntake = todayEntries.fold(0, (sum, entry) => sum + (entry['cups'] as int));
      
      // Calculate next period date
      await _calculateNextPeriod();
      
    } catch (e) {
      print('Error loading stats: $e');
    }
  }
  
  Future<void> _calculateNextPeriod() async {
    try {
      // Get period history
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('period_logs')
          .orderBy('date')
          .get();
          
      if (snapshot.docs.isEmpty) return;
      
      // Calculate average cycle length
      int totalCycles = 0;
      int totalDays = 0;
      DateTime? previousDate;
      
      for (var doc in snapshot.docs) {
        DateTime currentDate = (doc['date'] as Timestamp).toDate();
        
        if (previousDate != null) {
          int daysBetween = currentDate.difference(previousDate).inDays;
          if (daysBetween > 14 && daysBetween < 45) { // Valid cycle range
            totalDays += daysBetween;
            totalCycles++;
          }
        }
        
        previousDate = currentDate;
      }
      
      // Default to 28 days if not enough data
      int averageCycleLength = totalCycles > 0 ? (totalDays / totalCycles).round() : 28;
      
      // Get the most recent period start date
      DateTime lastPeriodDate = (snapshot.docs.last['date'] as Timestamp).toDate();
      
      // Predict next period
      _predictedNextPeriod = lastPeriodDate.add(Duration(days: averageCycleLength));
      
    } catch (e) {
      print('Error calculating next period: $e');
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      // Save water reminder settings
      await _hiveBox.put('waterReminderHours', _waterReminderHours);
      await _hiveBox.put('waterReminderEnabled', _isWaterReminderEnabled);
      
      // Save period reminder settings
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'periodNotificationsEnabled': _isPeriodNotificationsEnabled,
          'periodReminderDays': _periodReminderDays,
        });
      }
    } catch (e) {
      print('Error saving settings: $e');
    }
  }
  
  Future<void> _scheduleAllNotifications() async {
    if (!_notificationsPermissionGranted) {
      _notificationsPermissionGranted = await NotificationService.requestPermissions();
      if (!_notificationsPermissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enable notifications in settings'))
        );
        return;
      }
    }
    
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scheduling notifications...'))
      );
      
      // Save settings first
      await _saveSettings();
      
      // Schedule all notifications
      await NotificationManager.scheduleAllNotifications();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notifications scheduled successfully!'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scheduling notifications: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6F9),
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFFE75A7C),
        elevation: 0,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: Color(0xFFE75A7C)))
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Permissions card
                  if (!_notificationsPermissionGranted)
                    _buildPermissionsCard(),
                    
                  // Header
                  Text(
                    'Your Health Stats',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF442C2E),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Quick stats overview
                  _buildStatsOverview(),
                  SizedBox(height: 24),
                    
                  // Header
                  Text(
                    'Customize Your Reminders',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF442C2E),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Personalize how and when you want to be notified',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Period notifications section
                  _buildPeriodNotificationCard(),
                  SizedBox(height: 16),
                  
                  // Water reminder section
                  _buildWaterReminderCard(),
                  SizedBox(height: 24),
                  
                  // Test notification button
                  _buildTestNotificationButton(),
                  SizedBox(height: 16),
                  
                  // Schedule notifications button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _scheduleAllNotifications,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE75A7C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Save & Schedule Notifications',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
  
  Widget _buildStatsOverview() {
    return Row(
      children: [
        // Period prediction card
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Color(0xFFE75A7C), size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Next Period',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    _predictedNextPeriod != null 
                      ? DateFormat('MMM d').format(_predictedNextPeriod!)
                      : 'Not enough data',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_predictedNextPeriod != null)
                    Text(
                      _calculateDaysUntil(_predictedNextPeriod!),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Hydration progress card
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.water_drop, color: Color(0xFF5A9CE7), size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Hydration',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$_todayWaterIntake/$_targetWaterIntake cups',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  LinearProgressIndicator(
                    value: (_todayWaterIntake / _targetWaterIntake).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A9CE7)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  String _calculateDaysUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference < 0) {
      return 'Overdue by ${-difference} days';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return 'In $difference days';
    }
  }
  
  Widget _buildPermissionsCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFE69C)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFF856404)),
              SizedBox(width: 8),
              Text(
                'Notification Permission Required',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF856404),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Please enable notifications to receive reminders for your period and hydration.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFF856404),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              bool granted = await NotificationService.requestPermissions();
              setState(() => _notificationsPermissionGranted = granted);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF856404),
              foregroundColor: Colors.white,
            ),
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPeriodNotificationCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Color(0xFFE75A7C),
                ),
                SizedBox(width: 8),
                Text(
                  'Period Reminder',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF442C2E),
                  ),
                ),
                Spacer(),
                Switch(
                  value: _isPeriodNotificationsEnabled,
                  onChanged: (value) {
                    setState(() => _isPeriodNotificationsEnabled = value);
                    _saveSettings();
                  },
                  activeColor: Color(0xFFE75A7C),
                ),
              ],
            ),
            Divider(),
            if (_isPeriodNotificationsEnabled) ...[
              Text(
                'Notify me before my period starts:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_periodReminderDays days before',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        color: Color(0xFFE75A7C),
                        onPressed: _periodReminderDays > 1
                            ? () {
                                setState(() => _periodReminderDays--);
                                _saveSettings();
                              }
                            : null,
                      ),
                      Text(
                        '$_periodReminderDays',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Color(0xFFE75A7C),
                        onPressed: _periodReminderDays < 7
                            ? () {
                                setState(() => _periodReminderDays++);
                                _saveSettings();
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Add period prediction info
              if (_predictedNextPeriod != null) ...[
                Divider(),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Based on your history, your next period is predicted to start on ${DateFormat('MMMM d').format(_predictedNextPeriod!)}. You\'ll be notified $_periodReminderDays days before.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Period notifications are currently disabled',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildWaterReminderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  color: Color(0xFF5A9CE7),
                ),
                SizedBox(width: 8),
                Text(
                  'Hydration Reminder',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF442C2E),
                  ),
                ),
                Spacer(),
                Switch(
                  value: _isWaterReminderEnabled,
                  onChanged: (value) {
                    setState(() => _isWaterReminderEnabled = value);
                    _saveSettings();
                  },
                  activeColor: Color(0xFF5A9CE7),
                ),
              ],
            ),
            Divider(),
            if (_isWaterReminderEnabled) ...[
              Text(
                'Remind me to drink water every:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_waterReminderHours ${_waterReminderHours == 1 ? 'hour' : 'hours'}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        color: Color(0xFF5A9CE7),
                        onPressed: _waterReminderHours > 1
                            ? () {
                                setState(() => _waterReminderHours--);
                                _saveSettings();
                              }
                            : null,
                      ),
                      Text(
                        '$_waterReminderHours',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        color: Color(0xFF5A9CE7),
                        onPressed: _waterReminderHours < 8
                            ? () {
                                setState(() => _waterReminderHours++);
                                _saveSettings();
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Add hydration progress info
              Divider(),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You\'ve had $_todayWaterIntake of $_targetWaterIntake cups today. Notifications will adjust based on your daily progress.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Hydration reminders are currently disabled',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildTestNotificationButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(Icons.notifications_active_outlined),
        label: Text('Send Test Notification'),
        onPressed: () async {
          if (!_notificationsPermissionGranted) {
            _notificationsPermissionGranted = await NotificationService.requestPermissions();
          }
          
          if (_notificationsPermissionGranted) {
            await NotificationService.showDebugNotification();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Test notification sent!'))
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please enable notifications in settings'))
            );
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF442C2E),
          side: BorderSide(color: Color(0xFFE75A7C)),
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// New component: NotificationHelper to be used across the app
class NotificationHelper {
  static Future<void> updatePeriodNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) return;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      bool notificationsEnabled = userData['periodNotificationsEnabled'] ?? true;
      if (!notificationsEnabled) return;
      
      // Cancel existing period notifications
      await NotificationService.cancelNotification(1);
      
      // Schedule new one
      await NotificationManager.schedulePeriodNotifications(user.uid);
      
      print('Period notifications updated after log entry');
    } catch (e) {
      print('Error updating period notifications: $e');
    }
  }
  
  static Future<void> updateHydrationNotifications() async {
    try {
      // Cancel existing hydration notifications
      await NotificationService.cancelNotification(2);
      
      // Schedule new ones
      await NotificationManager.scheduleHydrationNotifications();
      
      print('Hydration notifications updated after water intake');
    } catch (e) {
      print('Error updating hydration notifications: $e');
    }
  }
}

// New screen: NotificationHistoryPage to show past and upcoming notifications
class NotificationHistoryPage extends StatefulWidget {
  @override
  _NotificationHistoryPageState createState() => _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  
  DateTime? _nextPeriodDate;
  DateTime? _nextPeriodNotificationDate;
  DateTime _nextHydrationReminder = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _loadNotificationData();
  }
  
  Future<void> _loadNotificationData() async {
    setState(() => _isLoading = true);
    
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }
      
      // Get notification settings
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      bool periodNotificationsEnabled = userData['periodNotificationsEnabled'] ?? true;
      int periodReminderDays = userData['periodReminderDays'] ?? 3;
      
      // Get period history
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('period_logs')
          .orderBy('date', descending: true)
          .get();
          
      if (snapshot.docs.isNotEmpty && periodNotificationsEnabled) {
        // Calculate average cycle
        List<int> cycleLengths = [];
        for (int i = 0; i < snapshot.docs.length - 1; i++) {
          DateTime current = (snapshot.docs[i]['date'] as Timestamp).toDate();
          DateTime previous = (snapshot.docs[i + 1]['date'] as Timestamp).toDate();
          
          int daysBetween = current.difference(previous).inDays;
          if (daysBetween > 14 && daysBetween < 45) {
            cycleLengths.add(daysBetween);
          }
        }
        
        // Calculate average or use default
        int averageCycle = cycleLengths.isNotEmpty 
            ? cycleLengths.reduce((a, b) => a + b) ~/ cycleLengths.length
            : 28;
            
        // Get most recent period
        DateTime mostRecentPeriod = (snapshot.docs.first['date'] as Timestamp).toDate();
        
        // Predict next period
        _nextPeriodDate = mostRecentPeriod.add(Duration(days: averageCycle));
        
        // Calculate notification date
        _nextPeriodNotificationDate = _nextPeriodDate!.subtract(Duration(days: periodReminderDays));
      }
      
      // Get hydration settings
      Box hydrationBox = Hive.box('hydrationBox');
      bool waterReminderEnabled = hydrationBox.get('waterReminderEnabled', defaultValue: true);
      int waterReminderHours = hydrationBox.get('waterReminderHours', defaultValue: 2);
      
      if (waterReminderEnabled) {
        _nextHydrationReminder = DateTime.now().add(Duration(hours: waterReminderHours));
      }
      
    } catch (e) {
      print('Error loading notification data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6F9),
      appBar: AppBar(
        title: Text(
          'Notification Timeline',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFFE75A7C),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFE75A7C)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Notifications',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF442C2E),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Timeline of upcoming notifications
                    _buildNotificationTimeline(),
                    
                    SizedBox(height: 24),
                    
                    // Refresh button
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text('Refresh Timeline'),
                        onPressed: _loadNotificationData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE75A7C),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  
  Widget _buildNotificationTimeline() {
    List<Map<String, dynamic>> timelineEntries = [];
    
    // Add hydration reminders
    final now = DateTime.now();
    for (int i = 0; i < 5; i++) {
      timelineEntries.add({
        'date': _nextHydrationReminder.add(Duration(hours: i * 2)),
        'title': 'Hydration Reminder',
        'description': 'Remember to drink water',
        'icon': Icons.water_drop,
        'color': Color(0xFF5A9CE7),
      });
    }
    
    // Add period notification if applicable
    if (_nextPeriodNotificationDate != null && _nextPeriodDate != null) {
      if (_nextPeriodNotificationDate!.isAfter(now)) {
        timelineEntries.add({
          'date': _nextPeriodNotificationDate!,
          'title': 'Period Reminder',
          'description': 'Your period is expected to start soon',
          'icon': Icons.calendar_month,
          'color': Color(0xFFE75A7C),
        });
      }
      
      timelineEntries.add({
        'date': _nextPeriodDate!,
        'title': 'Expected Period',
        'description': 'Your period is expected to start',
        'icon': Icons.event,
        'color': Color(0xFFE75A7C),
      });
    }
    
    // Sort by date
    timelineEntries.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    
    // Limit to upcoming notifications only
    timelineEntries = timelineEntries
        .where((entry) => (entry['date'] as DateTime).isAfter(now))
        .take(10)
        .toList();
    
    if (timelineEntries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(Icons.notifications_off, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No upcoming notifications',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: timelineEntries.length,
      itemBuilder: (context, index) {
        final entry = timelineEntries[index];
        final date = entry['date'] as DateTime;
        
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left timeline with date
              Container(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMM d').format(date),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      DateFormat('h:mm a').format(date),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Timeline line and dot
              Container(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: entry['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (index < timelineEntries.length - 1)
                      Container(
                        width: 2,
                        height: 50,
                        color: Colors.grey[300],
                      ),
                  ],
                ),
              ),
              
              // Right notification card
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  margin: EdgeInsets.only(bottom: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          entry['icon'] as IconData,
                          color: entry['color'] as Color,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry['title'] as String,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                entry['description'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Add this method to integrate with period tracking screen
void updateNotificationsAfterPeriodLog(DateTime logDate) async {
  // Call this after adding a new period log
  await NotificationHelper.updatePeriodNotifications();
}

// Add this method to integrate with water tracking screen
void updateNotificationsAfterWaterIntake(int cups) async {
  // Call this after updating water intake
  await NotificationHelper.updateHydrationNotifications();
}