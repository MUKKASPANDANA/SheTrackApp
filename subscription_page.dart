import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _selectedPlanIndex = 1; // Default to annual plan
  bool _annualBillingEnabled = true;
  
  // Plan details
  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Basic',
      'monthlyPrice': 0,
      'annualPrice': 0,
      'features': [
        'Basic cycle tracking',
        'Period predictions',
        'Limited symptom tracking',
        'Basic insights',
      ],
      'isPopular': false,
    },
    {
      'name': 'Premium',
      'monthlyPrice': 7.99,
      'annualPrice': 59.99,
      'features': [
        'Advanced cycle tracking',
        'Unlimited symptom tracking',
        'Personalized insights',
        'Health reports',
        'Sync with health apps',
        'Custom reminders',
        'Ad-free experience',
      ],
      'isPopular': true,
    },
    {
      'name': 'Family',
      'monthlyPrice': 12.99,
      'annualPrice': 99.99,
      'features': [
        'Everything in Premium',
        'Up to 5 family members',
        'Family health dashboard',
        'Shared calendar',
        'Premium support',
      ],
      'isPopular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildBillingToggle(),
          Expanded(
            child: _buildPlans(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9C27B0),
            const Color(0xFF9C27B0).withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Upgrade to SheTrack Premium',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Get access to all features and take control of your health journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBillingToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Monthly',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: _annualBillingEnabled,
            onChanged: (value) {
              setState(() {
                _annualBillingEnabled = value;
              });
            },
            activeColor: const Color(0xFF9C27B0),
          ),
          const Text(
            'Annual',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8BBD0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Save 30%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAD1457),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlans() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _plans.length,
      itemBuilder: (context, index) {
        final plan = _plans[index];
        final isSelected = _selectedPlanIndex == index;
        final price = _annualBillingEnabled ? plan['annualPrice'] : plan['monthlyPrice'];
        final billingCycle = _annualBillingEnabled ? '/year' : '/month';
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPlanIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? const Color(0xFF9C27B0) : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected ? const Color(0xFFF8F0FC) : Colors.white,
            ),
            child: Stack(
              children: [
                // Popular badge
                if (plan['isPopular'])
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF9C27B0),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'POPULAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                // Plan content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Radio button
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFF9C27B0) 
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF9C27B0),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          
                          // Plan name and price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: price == 0 
                                          ? 'Free' 
                                          : '\$${price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF9C27B0),
                                      ),
                                    ),
                                    if (price > 0)
                                      TextSpan(
                                        text: billingCycle,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Features list
                      ...List.generate(
                        plan['features'].length,
                        (featureIndex) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF9C27B0),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(plan['features'][featureIndex]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildBottomBar() {
    final selectedPlan = _plans[_selectedPlanIndex];
    final price = _annualBillingEnabled 
        ? selectedPlan['annualPrice'] 
        : selectedPlan['monthlyPrice'];
    final billingCycle = _annualBillingEnabled ? 'year' : 'month';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (price > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total: \$${price.toStringAsFixed(2)}/${_annualBillingEnabled ? "year" : "month"}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _annualBillingEnabled 
                  ? 'Billed annually at \$${price.toStringAsFixed(2)}'
                  : 'Billed monthly at \$${price.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: () => _subscribeToPlan(selectedPlan),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              price > 0 
                  ? 'Subscribe for \$${price.toStringAsFixed(2)}/$billingCycle'
                  : 'Continue with Free Plan',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (price > 0) ...[
            const SizedBox(height: 12),
            const Text(
              '7-day free trial available. Cancel anytime.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  void _subscribeToPlan(Map<String, dynamic> plan) {
    // In a real app, this would handle payment processing
    final billingType = _annualBillingEnabled ? 'annual' : 'monthly';
    final price = _annualBillingEnabled ? plan['annualPrice'] : plan['monthlyPrice'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Subscribe to ${plan['name']}'),
        content: Text(
          price > 0
              ? 'You selected the ${plan['name']} plan with $billingType billing at \$${price.toStringAsFixed(2)}.'
              : 'You selected the free Basic plan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
            ),
            onPressed: () {
              Navigator.pop(context);
              
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully subscribed to ${plan['name']} plan!'),
                  backgroundColor: const Color(0xFF9C27B0),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}