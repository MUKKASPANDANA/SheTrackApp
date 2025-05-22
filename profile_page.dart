import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'connected_apps.dart';
import 'edit_profile.dart';
import 'notifications_page.dart';
import 'password_security.dart';
import 'subscription_page.dart';
import 'help_support.dart';
import 'privacy_settings.dart';
import 'login_screen.dart';
import 'chatscreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = 'Loading...';
  String _userEmail = 'Loading...';
  String? _profileImageUrl;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 150 && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= 150 && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        setState(() {
          _userName = userData['name'] ?? 'User';
          _userEmail = user.email ?? 'No email';
          _profileImageUrl = userData['profileImageUrl'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load profile: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      try {
        final uploadUrl = Uri.parse("https://api.cloudinary.com/v1_1/ddcxt655c/image/upload");

        var request = http.MultipartRequest('POST', uploadUrl)
          ..fields['upload_preset'] = 'flutter_preset'
          ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

        var response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final imageUrl = json.decode(responseData)['secure_url'];

          final user = _auth.currentUser;
          if (user != null) {
            await _firestore.collection('users').doc(user.uid).update({
              'profileImageUrl': imageUrl,
            });
            setState(() {
              _profileImageUrl = imageUrl;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile image updated")));
          }
        } else {
          throw Exception("Upload failed");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload error: $e")));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 300,
                      pinned: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      flexibleSpace: FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          opacity: _isCollapsed ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 200),
                          child: Text(_userName, style: TextStyle(color: Colors.white)),
                        ),
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.pinkAccent,Colors.deepPurple],
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
  alignment: Alignment.bottomRight,
  children: [
    // Profile Image
    CircleAvatar(
      radius: 60,
      backgroundImage: (_profileImageUrl != null)
          ? NetworkImage(_profileImageUrl!)
          : null, // Only load if available
      child: (_profileImageUrl == null )
          ? Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : '',
              style: GoogleFonts.poppins(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
                                  ),
                                )
                              : null,
    ),

    // Camera Icon Button
    GestureDetector(
      onTap: () {
        showMenu(
          context: context,
          position: RelativeRect.fill, // Adjust position as needed
          items: [
            PopupMenuItem(
              value: 'upload',
              child: Text('Upload Image'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete Image'),
            ),
          ],
        ).then((value) async {
          if (value == 'upload') {
            await _pickAndUploadImage(); // Your existing function
          } else if (value == 'delete') {
            setState(() {
              _profileImageUrl = null;
            });
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'profileImageUrl': null});
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile image removed")),
            );
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.6),
        ),
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
      ),
    ),
  ],
                                ),

                                SizedBox(height: 15),
                                Text(_userName, style: TextStyle(fontSize: 24, color: Colors.white)),
                                Text(_userEmail, style: TextStyle(fontSize: 14, color: Colors.white70)),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 5),
                        _buildMenuSection('Account Settings'),
                        _buildMenuTile(context, 'Edit Profile', Icons.edit, Colors.blue, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfilePage())).then((_) => _loadUserData());
                        }),
                        _buildMenuTile(context, 'Password & Security', Icons.lock, Colors.green, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordSecurityPage()));
                        }),
                        _buildMenuTile(context, 'Connected Apps', Icons.phonelink, Colors.orange, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ConnectedAppsPage()));
                        }),
                        const SizedBox(height: 5),
                        _buildMenuSection('App Settings'),
                        _buildMenuTile(context, 'Notifications', Icons.notifications, Colors.pink, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
                        }),
                        _buildMenuTile(context, 'Subscription', Icons.card_membership, Colors.indigo, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SubscriptionPage()));
                        }),
                        _buildMenuTile(context, 'Help & Support', Icons.help, Colors.cyan, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => HelpSupportPage()));
                        }),
                        _buildMenuTile(context, 'Privacy Settings', Icons.privacy_tip, Colors.deepPurple, () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacySettingsScreen()));
                        }),
                      
                        _buildMenuTile(context, 'Logout', Icons.exit_to_app, Colors.red, () async {
                          bool confirm = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Confirm Logout'),
                                  content: Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context, false)),
                                    TextButton(child: Text('Logout'), onPressed: () => Navigator.pop(context, true)),
                                  ],
                                ),
                              ) ??
                              false;

                          if (confirm) {
                            await _auth.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                            );
                          }
                        }),
                        const SizedBox(height: 80),
                      ]),
                    ),
                  ],
                ),
    );
  }

  Widget _buildMenuSection(String title) => Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
        child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
      );

  Widget _buildMenuTile(BuildContext context, String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildErrorView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            SizedBox(height: 16),
            Text(_errorMessage ?? 'An error occurred', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _loadUserData, child: Text('Retry')),
          ],
        ),
      );
}
