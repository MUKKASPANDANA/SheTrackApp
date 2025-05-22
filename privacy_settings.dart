import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Privacy setting states
  bool _dataEncryption = true;
  bool _localStorageOnly = true;
  bool _anonymizeData = true;
  bool _biometricLock = false;
  bool _hideAppContent = false;
  bool _sharePeriodData = false;
  bool _shareHealthProviders = false;
  bool _allowBackup = true;
  bool _dataRetentionLimit = false;
  
  // App passcode
  String _passcode = "";
  bool _passcodeEnabled = false;
  final TextEditingController _passcodeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  // Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dataEncryption = prefs.getBool('dataEncryption') ?? true;
      _localStorageOnly = prefs.getBool('localStorageOnly') ?? true;
      _anonymizeData = prefs.getBool('anonymizeData') ?? true;
      _biometricLock = prefs.getBool('biometricLock') ?? false;
      _hideAppContent = prefs.getBool('hideAppContent') ?? false;
      _sharePeriodData = prefs.getBool('sharePeriodData') ?? false;
      _shareHealthProviders = prefs.getBool('shareHealthProviders') ?? false;
      _allowBackup = prefs.getBool('allowBackup') ?? true;
      _dataRetentionLimit = prefs.getBool('dataRetentionLimit') ?? false;
      _passcodeEnabled = prefs.getBool('passcodeEnabled') ?? false;
      _passcode = prefs.getString('passcode') ?? "";
    });
  }
  
  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dataEncryption', _dataEncryption);
    await prefs.setBool('localStorageOnly', _localStorageOnly);
    await prefs.setBool('anonymizeData', _anonymizeData);
    await prefs.setBool('biometricLock', _biometricLock);
    await prefs.setBool('hideAppContent', _hideAppContent);
    await prefs.setBool('sharePeriodData', _sharePeriodData);
    await prefs.setBool('shareHealthProviders', _shareHealthProviders);
    await prefs.setBool('allowBackup', _allowBackup);
    await prefs.setBool('dataRetentionLimit', _dataRetentionLimit);
    await prefs.setBool('passcodeEnabled', _passcodeEnabled);
    if (_passcodeEnabled && _passcodeController.text.isNotEmpty) {
      await prefs.setString('passcode', _passcodeController.text);
    }
    
    // Fix for "Don't use BuildContext across async gaps"
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings saved')),
    );
  }
  
  void _showPasscodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set App Passcode'),
          content: TextField(
            controller: _passcodeController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Enter 6-digit passcode',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                if (_passcode.isEmpty) {
                  setState(() {
                    _passcodeEnabled = false;
                  });
                }
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  _passcode = _passcodeController.text;
                });
                Navigator.of(context).pop();
                _saveSettings();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _showDataRetentionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Data Retention Period'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('3 months'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement data retention logic
                },
              ),
              ListTile(
                title: const Text('6 months'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement data retention logic
                },
              ),
              ListTile(
                title: const Text('1 year'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement data retention logic
                },
              ),
              ListTile(
                title: const Text('Forever'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _dataRetentionLimit = false;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.purple.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.purple.shade100,
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.purple),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'SheTrack respects your privacy. All your health data is protected and you control how it is used.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Data Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text('Encrypt Data'),
              subtitle: const Text('Securely encrypt all your health data'),
              value: _dataEncryption,
              onChanged: (value) {
                setState(() {
                  _dataEncryption = value;
                });
              },
              secondary: const Icon(Icons.enhanced_encryption),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Store Data Locally Only'),
              subtitle: const Text('Keep data on device only, not on servers'),
              value: _localStorageOnly,
              onChanged: (value) {
                setState(() {
                  _localStorageOnly = value;
                  // If local only, disable data sharing
                  if (value) {
                    _sharePeriodData = false;
                    _shareHealthProviders = false;
                  }
                });
              },
              secondary: const Icon(Icons.smartphone),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Anonymize Data'),
              subtitle: const Text('Remove personal identifiers from your data'),
              value: _anonymizeData,
              onChanged: (value) {
                setState(() {
                  _anonymizeData = value;
                });
              },
              secondary: const Icon(Icons.visibility_off),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'App Access Protection',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text('App Passcode'),
              subtitle: const Text('Require a passcode to open the app'),
              value: _passcodeEnabled,
              onChanged: (value) {
                setState(() {
                  _passcodeEnabled = value;
                });
                if (value) {
                  _showPasscodeDialog();
                }
              },
              secondary: const Icon(Icons.pin),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Biometric Lock'),
              subtitle: const Text('Use fingerprint or Face ID to unlock'),
              value: _biometricLock,
              onChanged: (value) {
                setState(() {
                  _biometricLock = value;
                });
              },
              secondary: const Icon(Icons.fingerprint),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Hide App Content in Switcher'),
              subtitle: const Text('Prevent screenshots and blur app in multitasking view'),
              value: _hideAppContent,
              onChanged: (value) {
                setState(() {
                  _hideAppContent = value;
                });
              },
              secondary: const Icon(Icons.remove_red_eye),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Data Sharing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text('Share Period Data for Research'),
              subtitle: const Text('Contribute anonymized data to women\'s health research'),
              value: _sharePeriodData,
              onChanged: _localStorageOnly ? null : (value) {
                setState(() {
                  _sharePeriodData = value;
                });
              },
              secondary: const Icon(Icons.science),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Share with Healthcare Providers'),
              subtitle: const Text('Allow sharing reports with your doctors'),
              value: _shareHealthProviders,
              onChanged: _localStorageOnly ? null : (value) {
                setState(() {
                  _shareHealthProviders = value;
                });
              },
              secondary: const Icon(Icons.local_hospital),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Data Management',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text('Allow Cloud Backup'),
              subtitle: const Text('Back up your data to restore if you change devices'),
              value: _allowBackup,
              onChanged: (value) {
                setState(() {
                  _allowBackup = value;
                });
              },
              secondary: const Icon(Icons.backup),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Limit Data Retention Period'),
              subtitle: const Text('Automatically delete older data'),
              value: _dataRetentionLimit,
              onChanged: (value) {
                setState(() {
                  _dataRetentionLimit = value;
                });
                if (value) {
                  _showDataRetentionDialog();
                }
              },
              secondary: const Icon(Icons.auto_delete),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                title: const Text('Delete All My Data'),
                subtitle: const Text('Permanently erase all your data from SheTrack'),
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete All Data?'),
                        content: const Text(
                          'This action cannot be undone. All your period tracking history, notes, and settings will be permanently erased.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              // Implement data deletion logic
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('All data has been deleted')),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _saveSettings,
                child: const Text('Save Settings', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                },
                child: const Text('View Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Additional screen for Privacy Policy
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.purple.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'SheTrack Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: April 19, 2025',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 24),
            Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'SheTrack is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our period tracking application.',
            ),
            SizedBox(height: 16),
            Text(
              'Information We Collect',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Health data: Menstrual cycle information, symptoms, moods, and other health metrics you choose to track\n'
              '• Personal information: Age, height, weight (if provided)\n'
              '• Device information: Operating system, app version, and usage statistics',
            ),
            SizedBox(height: 16),
            Text(
              'How We Use Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• To provide period predictions and health insights\n'
              '• To improve our app features and functionality\n'
              '• For research purposes (only with your explicit consent and in anonymized form)',
            ),
            // Add more sections as needed for a complete privacy policy
          ],
        ),
      ),
    );
  }
}