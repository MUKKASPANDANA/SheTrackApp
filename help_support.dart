import 'package:flutter/material.dart';
import 'package:shetrackv1/screens/contactsupport.dart';
import 'package:shetrackv1/screens/knowledge.dart';
import 'package:shetrackv1/screens/livechat.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  // Section expansion states
  final Map<String, bool> _expandedSections = {
    'account': false,
    'tracking': false,
    'predictions': false,
    'symptoms': false,
    'technical': false,
  };

  // FAQ items
  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to the login screen and tap "Forgot Password". Enter your email address and follow the instructions sent to your inbox.'
    },
    {
      'question': 'How accurate are period predictions?',
      'answer': 'Predictions become more accurate the more data you provide. After tracking for 3-4 cycles, predictions typically achieve 80-90% accuracy for regular cycles.'
    },
    {
      'question': 'Can I export my health data?',
      'answer': 'Yes, go to Profile > Settings > Data & Privacy > Export My Data. You can choose to export your data as CSV or PDF format.'
    },
    {
      'question': 'How can I track custom symptoms?',
      'answer': 'In the symptom tracking screen, scroll to the bottom and tap "Add Custom Symptom". You can then create a personalized symptom to track.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Help banner
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFF8F0FC),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Color(0xFF9C27B0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Find answers to common questions or contact our support team for assistance.',
                      style: TextStyle(
                        color: Color(0xFF4A4A4A),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'QUICK ACTIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickActionButton(
                    icon: Icons.email_outlined,
                    title: 'Contact Support',
                    subtitle: 'Send an email to our support team',
                    onTap: () {
                      Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ContactSupportPage()),
              );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActionButton(
                    icon: Icons.chat_bubble_outline,
                    title: 'Live Chat',
                    subtitle: 'Chat with our support team (9AM-5PM ET)',
                    onTap: () {
                     Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => LiveChatPage()),
              );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildQuickActionButton(
                    icon: Icons.open_in_new,
                    title: 'Visit Knowledge Base',
                    subtitle: 'Browse our detailed articles and guides',
                    onTap: () {
                         Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => KnowledgeBasePage()),
              );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Frequently Asked Questions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FREQUENTLY ASKED QUESTIONS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._faqItems.map((item) => _buildFaqItem(
                      question: item['question']!, answer: item['answer']!)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Help Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HELP CATEGORIES',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExpandableSection(
                    title: 'Account & Login',
                    iconData: Icons.person_outline,
                    sectionKey: 'account',
                    content: const [
                      'Create and manage your account',
                      'Reset your password',
                      'Update your personal information',
                      'Subscription management',
                      'Delete your account',
                    ],
                  ),
                  _buildExpandableSection(
                    title: 'Cycle Tracking',
                    iconData: Icons.calendar_today,
                    sectionKey: 'tracking',
                    content: const [
                      'How to log your period',
                      'Understanding your cycle phases',
                      'Tracking irregularities',
                      'Menstrual flow tracking',
                      'Calendar interface guide',
                    ],
                  ),
                  _buildExpandableSection(
                    title: 'Predictions & Insights',
                    iconData: Icons.insights,
                    sectionKey: 'predictions',
                    content: const [
                      'How predictions work',
                      'Improving prediction accuracy',
                      'Understanding fertility windows',
                      'Interpreting cycle insights',
                      'Prediction limitations',
                    ],
                  ),
                  _buildExpandableSection(
                    title: 'Symptom Tracking',
                    iconData: Icons.track_changes,
                    sectionKey: 'symptoms',
                    content: const [
                      'Adding and tracking symptoms',
                      'Creating custom symptoms',
                      'Understanding symptom patterns',
                      'Symptom intensity tracking',
                      'Symptom history and trends',
                    ],
                  ),
                  _buildExpandableSection(
                    title: 'Technical Support',
                    iconData: Icons.settings,
                    sectionKey: 'technical',
                    content: const [
                      'App performance issues',
                      'Data synchronization',
                      'Notification troubleshooting',
                      'App permissions',
                      'Updating the app',
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Community support
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F0FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF9C27B0).withAlpha(51)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Join Our Community',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C27B0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect with others, share experiences, and get support from our community forums.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _joinCommunity,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people),
                        SizedBox(width: 8),
                        Text('Join Community'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F0FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF9C27B0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required IconData iconData,
    required String sectionKey,
    required List<String> content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        initiallyExpanded: _expandedSections[sectionKey] ?? false,
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedSections[sectionKey] = expanded;
          });
        },
        leading: Icon(
          iconData,
          color: const Color(0xFF9C27B0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content
                  .map((item) => _buildHelpItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_right,
            color: Color(0xFF9C27B0),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    // In a real app, this would open email or a contact form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email to support@shetrack.com'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }

  void _openLiveChat() {
    // In a real app, this would open a chat interface
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening live chat with support'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }

  void _openKnowledgeBase() {
    // In a real app, this would open a webview or external link
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening knowledge base'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }

  void _joinCommunity() {
    // In a real app, this would open the community forum
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening community forum'),
        backgroundColor: Color(0xFF9C27B0),
      ),
    );
  }
}