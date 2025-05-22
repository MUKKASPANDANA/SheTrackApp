import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EmergencyContact {
  final String name;
  final String phoneNumber;

  EmergencyContact({required this.name, required this.phoneNumber});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
      };

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class EmergencyWhatsAppPage extends StatefulWidget {
  const EmergencyWhatsAppPage({Key? key}) : super(key: key);

  @override
  State<EmergencyWhatsAppPage> createState() => _EmergencyWhatsAppPageState();
}

class _EmergencyWhatsAppPageState extends State<EmergencyWhatsAppPage> with WidgetsBindingObserver {
  final List<EmergencyContact> _contacts = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  String _customMessage = '';
  Position? _lastPosition;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadContacts();
    _loadCustomMessage();
    _initializeNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsData = prefs.getStringList('emergencyContacts') ?? [];
      
      setState(() {
        _contacts.clear();
        for (final contactJson in contactsData) {
          final contactMap = Map<String, dynamic>.from(
              Map<String, dynamic>.from({"data": contactJson}));
          _contacts.add(EmergencyContact.fromJson(contactMap));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading contacts: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsData = _contacts.map((contact) => contact.toJson().toString()).toList();
      await prefs.setStringList('emergencyContacts', contactsData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving contacts: $e')),
      );
    }
  }

  Future<void> _loadCustomMessage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _customMessage = prefs.getString('customMessage') ?? 
            '🚨 Emergency! Please help. Here is my live location:';
      });
    } catch (e) {
      print('Error loading custom message: $e');
    }
  }

  Future<void> _saveCustomMessage(String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('customMessage', message);
      setState(() => _customMessage = message);
    } catch (e) {
      print('Error saving custom message: $e');
    }
  }

  // Get user's current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    _lastPosition = position;
    return position;
  }

  // Send location via WhatsApp
  Future<void> sendLocationViaWhatsApp(EmergencyContact contact) async {
    try {
      setState(() => _isLoading = true);
      final position = await getCurrentLocation();
      final message = '$_customMessage\n'
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      final whatsappUrl = Uri.parse(
          'https://wa.me/${contact.phoneNumber}?text=${Uri.encodeComponent(message)}');

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        
        // Show confirmation notification
        _showNotification(
          'Location Sent', 
          'Emergency location sent to ${contact.name}'
        );
      } else {
        throw 'Could not open WhatsApp';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'emergency_channel',
      'Emergency Channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    
    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  void _addContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (with country code)',
                prefixIcon: Icon(Icons.phone),
                hintText: 'Example: 12025550123',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                setState(() {
                  _contacts.add(EmergencyContact(
                    name: _nameController.text,
                    phoneNumber: _phoneController.text,
                  ));
                });
                _saveContacts();
                _nameController.clear();
                _phoneController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _editCustomMessage() {
    _messageController.text = _customMessage;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Emergency Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Custom Emergency Message',
                hintText: 'Enter your emergency message',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text(
              'Your location will automatically be added to the end of this message.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                _saveCustomMessage(_messageController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _sendToAllContacts() async {
    if (_contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No emergency contacts added yet.'),
        ),
      );
      return;
    }

    try {
      setState(() => _isLoading = true);
      final position = await getCurrentLocation();
      final message = '$_customMessage\n'
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      for (final contact in _contacts) {
        final whatsappUrl = Uri.parse(
            'https://wa.me/${contact.phoneNumber}?text=${Uri.encodeComponent(message)}');

        await Future.delayed(const Duration(seconds: 1));
        if (await canLaunchUrl(whatsappUrl)) {
          await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        }
      }

      // Show confirmation notification
      _showNotification(
        'Emergency Alert Sent', 
        'Location shared with all ${_contacts.length} contacts'
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _directCall(EmergencyContact contact) async {
    try {
      final callUrl = Uri.parse('tel:${contact.phoneNumber}');
      if (await canLaunchUrl(callUrl)) {
        await launchUrl(callUrl);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making call: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Location 🚨'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _editCustomMessage,
            tooltip: 'Edit Emergency Message',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Emergency Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '🚨 Emergency WhatsApp Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Send your current location via WhatsApp to your emergency contacts with a single tap.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ],
                  ),
                ),

                // Fast Actions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _sendToAllContacts,
                          icon: const Icon(Icons.emergency, color: Colors.white),
                          label: const Text(
                            'ALERT ALL CONTACTS',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.contacts),
                      SizedBox(width: 8),
                      Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(indent: 16, endIndent: 16),

                // Contact List
                Expanded(
                  child: _contacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_add_alt_1,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No emergency contacts yet',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Add some contacts to quickly send your location',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _contacts.length,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              elevation: 2,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.green.shade100,
                                  child: Icon(Icons.person,
                                      color: Colors.green.shade700),
                                ),
                                title: Text(contact.name),
                                subtitle: Text(contact.phoneNumber),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.call, color: Colors.blue),
                                      onPressed: () => _directCall(contact),
                                      tooltip: 'Call directly',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.share_location,
                                          color: Colors.green),
                                      onPressed: () =>
                                          sendLocationViaWhatsApp(contact),
                                      tooltip: 'Send location',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _contacts.removeAt(index);
                                        });
                                        _saveContacts();
                                      },
                                      tooltip: 'Remove contact',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Add emergency contact',
      ),
    );
  }
}