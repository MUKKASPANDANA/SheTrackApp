import 'package:flutter/material.dart';

class KnowledgeBasePage extends StatefulWidget {
  @override
  _KnowledgeBasePageState createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  
  // Updated category descriptions map with shorter descriptions to prevent overflow
  final Map<String, String> _categoryDescriptions = {
    'Account': 'Manage your personal information and security settings.',
    'Basics': 'Essential guides to help you get started with our platform.',
    'Billing': 'Information about subscription plans and payment options.',
    'Mobile': 'Guides for using our mobile application effectively.',
    'Troubleshooting': 'Solutions for common issues you might encounter.',
    'Tutorials': 'In-depth guides to help you master advanced features.',
  };
  
  final List<KnowledgeArticle> _articles = [
    // Basics Category
    KnowledgeArticle(
      id: 1,
      title: 'Getting Started Guide',
      description: 'Learn the basics of our platform and how to set up your account',
      category: 'Basics',
      views: 1524,
    ),
    KnowledgeArticle(
      id: 7,
      title: 'Understanding the Dashboard',
      description: 'A comprehensive overview of the main dashboard interface',
      category: 'Basics',
      views: 983,
    ),
    KnowledgeArticle(
      id: 8,
      title: 'Navigation Tips and Tricks',
      description: 'Helpful shortcuts and navigation techniques for new users',
      category: 'Basics',
      views: 752,
    ),
    
    // Account Category
    KnowledgeArticle(
      id: 2,
      title: 'How to Reset Your Password',
      description: 'Follow these steps to reset your password if you forgot it',
      category: 'Account',
      views: 3218,
    ),
    KnowledgeArticle(
      id: 9,
      title: 'Managing Account Settings',
      description: 'Learn how to update your profile information and preferences',
      category: 'Account',
      views: 1425,
    ),
    KnowledgeArticle(
      id: 10,
      title: 'Account Security Best Practices',
      description: 'Tips to keep your account secure and prevent unauthorized access',
      category: 'Account',
      views: 2105,
    ),
    
    // Billing Category
    KnowledgeArticle(
      id: 3,
      title: 'Subscription and Billing FAQ',
      description: 'Frequently asked questions about subscription plans and billing',
      category: 'Billing',
      views: 942,
    ),
    KnowledgeArticle(
      id: 11,
      title: 'Payment Methods and Options',
      description: 'Information about supported payment methods and how to update them',
      category: 'Billing',
      views: 865,
    ),
    KnowledgeArticle(
      id: 12,
      title: 'Understanding Your Invoice',
      description: 'A guide to reading and understanding your monthly invoice',
      category: 'Billing',
      views: 723,
    ),
    
    // Troubleshooting Category
    KnowledgeArticle(
      id: 4,
      title: 'Troubleshooting Common Issues',
      description: 'Solutions for the most common problems users encounter',
      category: 'Troubleshooting',
      views: 2195,
    ),
    KnowledgeArticle(
      id: 13,
      title: 'Error Messages Explained',
      description: 'A comprehensive list of error messages and how to resolve them',
      category: 'Troubleshooting',
      views: 1876,
    ),
    KnowledgeArticle(
      id: 14,
      title: 'Connectivity Problems',
      description: 'How to diagnose and fix connection issues with our platform',
      category: 'Troubleshooting',
      views: 1543,
    ),
    
    // Tutorials Category
    KnowledgeArticle(
      id: 5,
      title: 'Advanced Features Tutorial',
      description: 'Detailed guide on how to use advanced features of our platform',
      category: 'Tutorials',
      views: 876,
    ),
    KnowledgeArticle(
      id: 15,
      title: 'Data Import and Export Guide',
      description: 'Step-by-step instructions for importing and exporting your data',
      category: 'Tutorials',
      views: 793,
    ),
    KnowledgeArticle(
      id: 16,
      title: 'Custom Reporting Tutorial',
      description: 'Learn how to create and customize reports for your specific needs',
      category: 'Tutorials',
      views: 682,
    ),
    
    // Mobile Category
    KnowledgeArticle(
      id: 6,
      title: 'Mobile App User Guide',
      description: 'Complete guide to using our mobile application',
      category: 'Mobile',
      views: 1347,
    ),
    KnowledgeArticle(
      id: 17,
      title: 'Mobile App vs Desktop Differences',
      description: 'Understanding the key differences between mobile and desktop versions',
      category: 'Mobile',
      views: 895,
    ),
    KnowledgeArticle(
      id: 18,
      title: 'Offline Mode on Mobile',
      description: 'How to use the mobile app features when you have no internet connection',
      category: 'Mobile',
      views: 1023,
    ),
  ];

  List<KnowledgeArticle> get _filteredArticles {
    if (_searchQuery.isEmpty && _selectedCategory == null) {
      return _articles;
    } else if (_selectedCategory != null) {
      return _articles.where((article) => 
        article.category == _selectedCategory
      ).toList();
    }
    return _articles.where((article) {
      return article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<String> get _categories {
    final categories = _articles.map((article) => article.category).toSet().toList();
    categories.sort();
    return categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Knowledge Base',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.purple.shade50,
              child: Row(
                children: [
                  Icon(Icons.article_outlined, color: Colors.purple.shade700),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Browse our detailed articles and guides',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search knowledge base',
                  prefixIcon: const Icon(Icons.search, size: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _selectedCategory = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 4),
            // Fixed category selection cards - adjusted height and improved layout
            SizedBox(
              height: 120, // Increased height to accommodate content
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final description = _categoryDescriptions[category] ?? '';
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedCategory == category) {
                            _selectedCategory = null;
                            _searchQuery = '';
                            _searchController.text = '';
                          } else {
                            _selectedCategory = category;
                            _searchQuery = '';
                            _searchController.text = '';
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedCategory == category 
                              ? Colors.purple.withOpacity(0.1) 
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedCategory == category
                                ? Colors.purple
                                : Colors.grey[300]!,
                            width: 1,
                          ),
                          boxShadow: _selectedCategory == category
                              ? [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _selectedCategory == category
                                    ? Colors.purple
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(  // Using Expanded to handle text overflow
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.3,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Category description display when selected - with improved styling
            if (_selectedCategory != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.purple.withOpacity(0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedCategory!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _categoryDescriptions[_selectedCategory!] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            // Improved article list with better spacing and styling
            Expanded(
              child: _filteredArticles.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = _filteredArticles[index];
                        return ArticleCard(article: article);
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No articles found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try using different keywords',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class KnowledgeArticle {
  final int id;
  final String title;
  final String description;
  final String category;
  final int views;

  KnowledgeArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.views,
  });
}

class ArticleCard extends StatelessWidget {
  final KnowledgeArticle article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(article: article),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.visibility, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${article.views}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Read more',
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.purple.shade700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final KnowledgeArticle article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(article.title),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    article.category,
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.visibility, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${article.views}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: April 10, 2025',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              getArticleContent(article),
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.grey[700]),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Was this article helpful?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Thank you for your feedback')),
                                );
                              },
                              icon: const Icon(Icons.thumb_up, size: 18),
                              label: const Text('Yes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('We\'ll try to improve this article')),
                                );
                              },
                              icon: const Icon(Icons.thumb_down, size: 18),
                              label: const Text('No'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to provide custom content for each article
String getArticleContent(KnowledgeArticle article) {
  // Map of article IDs to custom content
  final Map<int, String> articleContents = {
    // Basics Category
    1: '''# Getting Started Guide

Welcome to our platform! This guide will help you get up and running quickly.

## Creating Your Account
1. Visit our sign-up page and enter your email address
2. Choose a secure password (at least 8 characters with numbers and symbols)
3. Verify your email address by clicking the link we send you
4. Complete your profile information

If you encounter any issues during signup, contact support@example.com.''',

    7: '''# Understanding the Dashboard

The dashboard is your central hub for accessing all platform features.

## Main Sections
- **Overview**: Shows key metrics and recent activity
- **Quick Access**: Frequently used tools and shortcuts
- **Notifications**: System alerts and updates
- **Recent Items**: Recently viewed or edited content

Click on any card to expand and see more details.''',

    8: '''# Navigation Tips and Tricks

Master these navigation techniques to move efficiently through the platform.

## Keyboard Shortcuts
- **Ctrl+H**: Return to dashboard
- **Ctrl+F**: Open search
- **Ctrl+S**: Save current item
- **Esc**: Close current modal or panel

## Menu Navigation
The side menu can be collapsed by clicking the arrow icon to maximize your workspace.''',

    // Account Category
    2: '''# How to Reset Your Password

If you've forgotten your password, follow these steps:

1. Click "Forgot Password" on the login screen
2. Enter the email address associated with your account
3. Check your email for a password reset link
4. Click the link and enter your new password
5. Log in with your new password

For security reasons, password reset links expire after 24 hours.''',

    9: '''# Managing Account Settings

Keep your account information up to date for the best experience.

## Personal Information
You can update your name, email, and phone number under "Profile Settings."

## Notification Preferences
Control which notifications you receive:
- Email alerts
- In-app notifications
- Weekly digest emails''',

    10: '''# Account Security Best Practices

Protect your account with these essential security practices:

## Password Guidelines
- Use unique, complex passwords with at least 12 characters
- Include a mix of uppercase, lowercase, numbers, and symbols
- Change passwords every 90 days

## Two-Factor Authentication
Enable two-factor authentication for an extra layer of security.''',

    // Billing Category
    3: '''# Subscription and Billing FAQ

## Frequently Asked Questions

**Q: When will I be charged?**
A: Your subscription renews automatically on the same day each month.

**Q: How do I change my subscription plan?**
A: Go to Account > Billing > Subscription to upgrade or downgrade your plan.

**Q: Can I get a refund?**
A: We offer refunds within 14 days of payment. Contact billing@example.com.''',

    11: '''# Payment Methods and Options

We accept multiple payment methods for your convenience.

## Supported Payment Methods
- Credit/Debit Cards (Visa, Mastercard, Amex)
- PayPal
- Bank Transfer (for annual plans only)

## Adding a New Payment Method
1. Go to Account > Billing > Payment Methods
2. Click "Add Payment Method"
3. Enter the required information''',

    12: '''# Understanding Your Invoice

Learn how to read and interpret your monthly invoice.

## Invoice Sections
- **Summary**: Total amount and payment status
- **Subscription Details**: Your current plan and billing period
- **Payment Breakdown**: Itemized charges and applicable taxes
- **Payment Method**: Which payment method was charged

To download past invoices, visit Account > Billing > Invoice History.''',

    // Troubleshooting Category
    4: '''# Troubleshooting Common Issues

Solutions for the most frequently reported problems.

## Login Problems
- Clear your browser cache and cookies
- Check if your email address is entered correctly
- Reset your password if you've forgotten it

## Performance Issues
If the application is running slowly:
- Check your internet connection
- Close unused browser tabs
- Try refreshing the page''',

    13: '''# Error Messages Explained

Common error codes and what they mean.

## Error 404
This means the page you're looking for doesn't exist. Check the URL or navigate from the dashboard.

## Error 403
You don't have permission to access this resource. Contact your administrator if you need access.

## Error 500
This is a server error. Please try again later or contact support if the issue persists.''',

    14: '''# Connectivity Problems

Troubleshoot connection issues with our platform.

## Internet Connection
- Test your connection by visiting other websites
- Restart your router if necessary
- Try connecting via a different network

## API Connection Issues
If you're a developer using our API:
- Check if your API key is valid
- Verify your request format
- Check our status page for any outages''',

    // Tutorials Category
    5: '''# Advanced Features Tutorial

Get the most out of our platform with these advanced features.

## Custom Workflows
Create automated workflows to save time:
1. Go to Settings > Workflows
2. Click "Create New Workflow"
3. Define triggers and actions
4. Save and activate your workflow

## Data Analysis Tools
Our powerful analytics dashboard helps you gain insights from your data.''',

    15: '''# Data Import and Export Guide

Efficiently move your data in and out of our platform.

## Importing Data
1. Prepare your data in CSV, Excel, or JSON format
2. Go to Tools > Import
3. Select your file and mapping options
4. Review and confirm the import

## Exporting Data
1. Navigate to the data you want to export
2. Click "Export" in the top right
3. Choose your preferred format
4. Download the file''',

    16: '''# Custom Reporting Tutorial

Create reports tailored to your specific needs.

## Building a Basic Report
1. Go to Reports > Create New
2. Select data sources to include
3. Choose metrics and dimensions
4. Apply filters as needed
5. Save and schedule regular updates

## Sharing Reports
You can share reports with team members or export them as PDFs.''',

    // Mobile Category
    6: '''# Mobile App User Guide

Everything you need to know about our mobile application.

## Installation
1. Download from the App Store or Google Play
2. Open the app and log in with your account
3. Follow the onboarding tutorial

## Key Features
- Real-time data synchronization
- Offline mode for working without internet
- Push notifications for important updates
- Touch ID/Face ID login support''',

    17: '''# Mobile App vs Desktop Differences

Understanding the key differences between platforms.

## Mobile-Only Features
- Camera integration for document scanning
- Location-based services
- Push notifications

## Desktop-Only Features
- Advanced reporting tools
- Bulk editing capabilities
- Keyboard shortcuts

Most core functionality is available on both platforms, but optimized for each experience.''',

    18: '''# Offline Mode on Mobile

How to use the app when you don't have an internet connection.

## Enabling Offline Mode
1. Go to Settings > Offline Access
2. Select which data to make available offline
3. Tap "Sync Now" to download the latest data

## Working Offline
- Changes made offline will sync when you reconnect
- Some features are limited in offline mode
- Look for the offline indicator in the status bar'''
  };

  // Return the content for the requested article, or a default message if not found
  return articleContents[article.id] ?? 
    '''This article is currently being updated. 
    
Please check back soon for the complete information about "${article.title}".

If you need immediate assistance, please contact our support team.''';
}