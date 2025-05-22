import 'package:flutter/material.dart';

class PasswordSecurityPage extends StatefulWidget {
  const PasswordSecurityPage({Key? key}) : super(key: key);

  @override
  _PasswordSecurityPageState createState() => _PasswordSecurityPageState();
}

class _PasswordSecurityPageState extends State<PasswordSecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _biometricEnabled = true;
  bool _twoFactorEnabled = false;
  
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password & Security'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Summary Card
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shield, color: Color(0xFF9C27B0)),
                          SizedBox(width: 8),
                          Text(
                            'Security Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: Color(0xFFE1BEE7),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Security Level'),
                          Text(
                            'Good',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Enable two-factor authentication to improve your account security.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Quick Settings Section
              const Text(
                'QUICK SETTINGS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Biometric Login'),
                      subtitle: const Text('Use fingerprint or face ID to log in'),
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          color: Color(0xFF9C27B0),
                        ),
                      ),
                      value: _biometricEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _biometricEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF9C27B0),
                    ),
                    const Divider(height: 0),
                    SwitchListTile(
                      title: const Text('Two-Factor Authentication'),
                      subtitle: const Text('Add an extra layer of security'),
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C27B0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.security,
                          color: Color(0xFF9C27B0),
                        ),
                      ),
                      value: _twoFactorEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _twoFactorEnabled = value;
                        });
                        if (value) {
                          // Show setup 2FA dialog or navigate to setup page
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Set Up Two-Factor Authentication'),
                              content: const Text(
                                'To enable two-factor authentication, you\'ll need to verify your phone number and set up an authenticator app.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      _twoFactorEnabled = false;
                                    });
                                  },
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Navigate to 2FA setup page
                                  },
                                  child: const Text('CONTINUE'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      activeColor: const Color(0xFF9C27B0),
                    ),
                  ],
                ),
              ),
              
              // Change Password Section
              const SizedBox(height: 8),
              
              
              // Recent Logins Section
              const SizedBox(height: 24),
              const Text(
                'RECENT LOGINS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildLoginListTile(
                      'iPhone 13 Pro',
                      'San Francisco, CA',
                      'Today, 2:45 PM',
                      Icons.phone_iphone,
                      Colors.blue,
                      true,
                    ),
                    const Divider(height: 0),
                    _buildLoginListTile(
                      'Chrome on Windows',
                      'San Francisco, CA',
                      'Yesterday, 10:30 AM',
                      Icons.laptop_windows,
                      Colors.orange,
                      false,
                    ),
                    const Divider(height: 0),
                    _buildLoginListTile(
                      'Safari on Mac',
                      'San Francisco, CA',
                      'Apr 15, 8:20 AM',
                      Icons.laptop_mac,
                      Colors.green,
                      false,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextButton(
                        onPressed: () {
                          // Show all login activity
                        },
                        child: const Text(
                          'VIEW ALL LOGIN ACTIVITY',
                          style: TextStyle(color: Color(0xFF9C27B0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginListTile(
    String device,
    String location,
    String time,
    IconData icon,
    Color iconColor,
    bool isCurrentDevice,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Row(
        children: [
          Text(device,
          
                  overflow: TextOverflow.fade,),
            
        ],
      ),
      subtitle: Text('$location • $time'),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          // Show more options
        },
      ),
    );
  }
}