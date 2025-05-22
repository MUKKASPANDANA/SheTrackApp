import 'package:flutter/material.dart';
import 'package:shetrackv1/chatbothelper.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:ui';
import 'dart:math' as math; // Added proper math import

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  final WitAiService witAiService = WitAiService();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isLoading = false;
  
  // Controllers for animations
  late AnimationController _typingController;
  late AnimationController _micAnimationController;

  // For typing indicator
  final List<double> _typingBubbleHeights = [8.0, 12.0, 8.0];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestMicPermission();
    
    // Initialize animation controllers
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Add welcome message
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        messages.add({
          "role": "bot", 
          "text": "Hi there! I'm your period care assistant. How can I help you today?",
          "timestamp": DateTime.now()
        });
      });
    });
  }

  @override
  void dispose() {
    _typingController.dispose();
    _micAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> handleSend() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({
        "role": "user", 
        "text": userMessage,
        "timestamp": DateTime.now()
      });
      _controller.clear();
      _isLoading = true;
    });
    
    _scrollToBottom();

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final response = await witAiService.detectIntent(userMessage);
    String reply;

    if (response.containsKey('error')) {
      reply = "Sorry, I couldn't understand that. Could you please rephrase?";
    } else {
      final intent = response['intents']?.isNotEmpty == true
          ? response['intents'][0]['name']
          : 'unknown';

      switch (intent) {
        case 'greets':
          reply = 'Hello! How can I assist you with your period tracking today?';
          break;
        case 'period_cramps_advice':
          reply = 'For period cramps, I recommend:\n\n• Using a warm compress on your lower abdomen\n• Staying hydrated\n• Getting plenty of rest\n• Trying gentle yoga poses like child\'s pose\n• Taking over-the-counter pain relievers if needed\n\nWould you like me to set a reminder for your pain medication?';
          break;
        case 'late_period_question':
          reply = 'A late period can be caused by several factors including stress, significant weight changes, intense exercise, or health conditions. If you\'re sexually active, a pregnancy test might be worth considering. Would you like me to help track this delay in your cycle data?';
          break;
        case 'track_period':
          reply = 'You can easily log your period in the calendar tab! Would you like me to take you there now, or would you prefer to log it here?';
          break;
        case 'get_next_period_date':
          reply = 'Based on your previous cycle data, your next period should start around May 3rd! Would you like me to set a reminder for you?';
          break;
        case 'log_period_start':
          reply = 'Got it! I\'ve logged today as Day 1 of your period. Take care and remember to stay hydrated today! ❤ Would you like some self-care tips for the first day?';
          break;
        case 'log_symptom':
          reply = 'Thanks, I\'ve recorded your symptom in your health log. Is there anything else you\'d like to track today, or would you like some relief tips?';
          break;
        case 'get_symptom_advice':
          reply = 'Here\'s what might help:\n\n• A heating pad for cramps\n• Stay hydrated with warm drinks\n• Gentle stretching can ease tension\n• Rest when you need to\n• Light walks to improve circulation\n\nDo any of these sound particularly helpful for you right now?';
          break;
        case 'get_cycle_summary':
          reply = 'Based on your data, your cycle typically lasts 28 days with a 5-day period. Your last 3 cycles were quite regular. Would you like to see a detailed analysis of your cycle patterns?';
          break;
        case 'set_reminder':
          reply = 'Reminder set! I\'ll notify you 2 days before your expected period date. Is there anything specific you\'d like to be reminded about?';
          break;
        case 'log_mood':
          reply = 'I\'ve logged your mood. Thank you for sharing how you\'re feeling today. Remember that mood fluctuations are completely normal during your cycle. Would you like to see how your mood patterns correlate with your cycle phases?';
          break;
        case 'period_product_advice':
          reply = 'There are many period products to choose from:\n\n• Pads: Easy to use and come in various absorbencies\n• Tampons: Ideal for swimming and more active days\n• Menstrual cups: Reusable and eco-friendly\n• Period underwear: Great backup or for lighter days\n\nThe best choice is whichever feels most comfortable for you! Would you like more specific information about any of these?';
          break;
        case 'period_delay_query':
          reply = 'Period delays can happen due to stress, diet changes, exercise intensity, illness, or hormonal fluctuations. Let\'s continue monitoring this - if your period is more than 10 days late, you might want to consider consulting with a healthcare provider. Would you like me to note this delay in your records?';
          break;
        case 'end_period':
          reply = 'I\'ve marked your period as complete. Your cycle this month lasted 5 days, which is consistent with your average. Is there anything else you\'d like to log before we close this cycle?';
          break;
        case 'food_recommendation':
          reply = 'During your period, these foods may help:\n\n• Iron-rich foods like spinach and lentils to replace lost iron\n• Dark chocolate (70%+ cacao) for magnesium and mood boost\n• Fatty fish rich in omega-3s to reduce inflammation\n• Bananas for potassium to reduce bloating\n• Ginger tea to ease nausea and inflammation\n\nWould you like me to create a simple meal plan for your period week?';
          break;
        case 'ask_about_pms':
          reply = 'PMS symptoms often include mood swings, irritability, fatigue, bloating, breast tenderness, food cravings, and headaches. They typically start 1-2 weeks before your period begins. Would you like me to track your PMS symptoms and offer personalized management tips next cycle?';
          break;
        case 'ask_about_flow':
          reply = 'Flow variations are completely normal! Your flow can be:\n\n• Heavy (changing protection every 2-3 hours)\n• Medium (changing every 3-4 hours)\n• Light (changing every 4-6 hours)\n• Spotting (only when wiping or slight staining)\n\nWhat matters most is if YOUR flow suddenly changes. Would you like to start tracking your flow intensity?';
          break;
        case 'emergency_help':
          reply = '⚠️ IMPORTANT: If you\'re experiencing extremely heavy bleeding (soaking through a pad/tampon every hour), severe pain that medications don\'t help, dizziness, fainting, or fever with your period, please contact a healthcare provider immediately or go to the nearest emergency room. Would you like me to provide local emergency contacts?';
          break;
        case 'natural_remedies':
          reply = 'Here are some natural remedies that might help:\n\n• Chamomile or ginger tea for cramps\n• Warm baths with epsom salts\n• Gentle yoga or stretching\n• Rest and adequate sleep\n• Heat therapy with a warm compress\n• Acupressure on specific points\n\nWould you like detailed instructions for any of these remedies?';
          break;
        case 'mental_health_support':
          reply = 'I\'m here for you. Hormonal fluctuations can affect your mental wellbeing. Try practicing mindfulness or deep breathing exercises when you feel overwhelmed. Remember that your feelings are valid, and it\'s okay to prioritize self-care. Would you like to try a quick guided breathing exercise together?';
          break;
        case 'get_fertile_window':
          reply = 'Based on your average 28-day cycle, your fertile window is typically days 12-17, with ovulation likely around day 14. Remember that this is an estimate - would you like me to help you track more specific fertility indicators?';
          break;
        case 'period_symptoms_advice':
          reply = 'For common period symptoms:\n\n• Bloating: Reduce salt intake and try dandelion tea\n• Cramps: Heat therapy and gentle stretching\n• Fatigue: Prioritize rest and iron-rich foods\n• Headaches: Stay hydrated and consider magnesium supplements\n\nIs there a particular symptom you\'d like more specific advice for?';
          break;
        case 'suggest_exercise':
          reply = 'During your period, gentle exercises like these can help:\n\n• Walking at a comfortable pace\n• Yoga flows designed for menstruation\n• Light swimming if you\'re comfortable\n• Gentle stretching to ease tension\n• Tai chi for stress reduction\n\nRemember to listen to your body and rest when needed! Would you like me to suggest a specific gentle yoga sequence?';
          break;
        default:
          reply = 'I\'m still learning about period health. Could you rephrase that, or would you like to know about tracking periods, managing symptoms, or cycle predictions?';
      }
    }

    // Simulate typing delay for more natural conversation
    await Future.delayed(Duration(milliseconds: 1200 + (reply.length * 5).clamp(0, 2000)));

    setState(() {
      messages.add({
        "role": "bot", 
        "text": reply,
        "timestamp": DateTime.now()
      });
      _isLoading = false;
    });
    
    _scrollToBottom();
  }

  void _listen() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();
    
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('onStatus: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
            _micAnimationController.reverse();
          }
        },
        onError: (error) {
          print('onError: $error');
          setState(() => _isListening = false);
          _micAnimationController.reverse();
          
          // Show error snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sorry, I had trouble hearing you. Please try again.'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )
            );
          }
        },
      );
      
      if (available) {
        setState(() => _isListening = true);
        _micAnimationController.forward();
        
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
              
              // Auto-send message if confidence is high and sentence seems complete
              if (result.finalResult && 
                  result.recognizedWords.isNotEmpty && 
                  result.recognizedWords.endsWith('.') || 
                  result.recognizedWords.endsWith('?')) {
                Future.delayed(const Duration(milliseconds: 500), handleSend);
              }
            });
          },
          listenFor: const Duration(seconds: 10),
          pauseFor: const Duration(seconds: 3),
          listenMode: stt.ListenMode.confirmation,
        );
      }
    } else {
      setState(() => _isListening = false);
      _micAnimationController.reverse();
      _speech.stop();
    }
  }

  String _getTimeString(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  // Format messages to group by the same sender
  List<Map<String, dynamic>> _getGroupedMessages() {
    List<Map<String, dynamic>> groupedMessages = [];
    
    for (int i = 0; i < messages.length; i++) {
      final currentMsg = Map<String, dynamic>.from(messages[i]);
      
      // Add a property to indicate if this is the first message in a group
      if (i == 0 || messages[i]['role'] != messages[i-1]['role']) {
        currentMsg['isFirstInGroup'] = true;
      } else {
        currentMsg['isFirstInGroup'] = false;
      }
      
      // Add a property to indicate if this is the last message in a group
      if (i == messages.length-1 || messages[i]['role'] != messages[i+1]['role']) {
        currentMsg['isLastInGroup'] = true;
      } else {
        currentMsg['isLastInGroup'] = false;
      }
      
      groupedMessages.add(currentMsg);
    }
    
    return groupedMessages;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedMessages = _getGroupedMessages();
    
    // Colors for the UI
    final primaryColor = theme.colorScheme.primary;
    final botBubbleColor = Color(0xFFF0F4F8);
    final userBubbleColor = primaryColor;
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.health_and_safety_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PeriodCare Assistant",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Online now",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      // Show options menu
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text('View Cycle Calendar'),
                                onTap: () => Navigator.pop(context),
                              ),
                              ListTile(
                                leading: Icon(Icons.bar_chart),
                                title: Text('Symptom Analytics'),
                                onTap: () => Navigator.pop(context),
                              ),
                              ListTile(
                                leading: Icon(Icons.delete_outline),
                                title: Text('Clear Chat History'),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    messages.clear();
                                    messages.add({
                                      "role": "bot", 
                                      "text": "Chat history cleared. How can I help you today?",
                                      "timestamp": DateTime.now()
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Chat messages area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black12 : Color(0xFFF7F7F9),
                  image: DecorationImage(
                    image: AssetImage('assets/images/chat_bg.png'),
                    opacity: 0.05,
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: groupedMessages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show typing indicator
                    if (_isLoading && index == groupedMessages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(right: 50, top: 8, bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: botBubbleColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              return AnimatedBuilder(
                                animation: _typingController,
                                builder: (context, child) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    height: _typingBubbleHeights[i] * 
                                          (1 + 0.5 * math.sin((_typingController.value * math.pi) + (i * 1.0))),
                                    width: _typingBubbleHeights[i] * 
                                          (1 + 0.5 * math.sin((_typingController.value * math.pi) + (i * 1.0))),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      );
                    }
                    
                    final msg = groupedMessages[index];
                    final isUser = msg['role'] == 'user';
                    final isFirstInGroup = msg['isFirstInGroup'];
                    final isLastInGroup = msg['isLastInGroup'];
                    
                    // Different radius depending on grouping
                    BorderRadius borderRadius;
                    if (isUser) {
                      if (isFirstInGroup && isLastInGroup) {
                        borderRadius = BorderRadius.circular(18);
                      } else if (isFirstInGroup) {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(5),
                        );
                      } else if (isLastInGroup) {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        );
                      } else {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(5),
                        );
                      }
                    } else {
                      if (isFirstInGroup && isLastInGroup) {
                        borderRadius = BorderRadius.circular(18);
                      } else if (isFirstInGroup) {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(18),
                        );
                      } else if (isLastInGroup) {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        );
                      } else {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(18),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(18),
                        );
                      }
                    }
                    
                    return Padding(
                      padding: EdgeInsets.only(
                        top: isFirstInGroup ? 16.0 : 2.0,
                        bottom: 2.0,
                      ),
                      child: Column(
                        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (isFirstInGroup && !isUser)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
                              child: Text(
                                "Assistant",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isUser && isFirstInGroup)
                                Container(
                                  width: 28,
                                  height: 28,
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.health_and_safety_rounded,
                                    color: primaryColor,
                                    size: 16,
                                  ),
                                ),
                              if (!isUser && !isFirstInGroup)
                                const SizedBox(width: 36),
                              Flexible(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isUser ? userBubbleColor : botBubbleColor,
                                    borderRadius: borderRadius,
                                  ),
                                  child: Text(
                                    msg['text'] ?? '',
                                    style: TextStyle(
                                      color: isUser ? Colors.white : (isDarkMode ? Colors.white : Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLastInGroup)
                            Padding(
                              padding: EdgeInsets.only(
                                top: 4.0,
                                left: isUser ? 0 : 36.0,
                                right: isUser ? 4.0 : 0,
                              ),
                              child: Text(
                                _getTimeString(msg['timestamp']),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Suggestion chips (shown when chat is empty or after certain replies)
            if (messages.isNotEmpty && messages.last['role'] == 'bot')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildSuggestionChip('Track period'),
                    _buildSuggestionChip('Help with cramps'),
                    _buildSuggestionChip('Period products'),
                  ],
                ),
              ),
              
            // Input area with nice styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Type your message...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                                ),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              onSubmitted: (_) => handleSend(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                            onPressed: () {
                              // Show emoji picker
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Voice button with glow animation
                  _isListening
                      ? AvatarGlow(
                          animate: true,
                          glowColor: primaryColor,
                          glowRadiusFactor: 28.0,
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: primaryColor,
                            elevation: 4,
                            child: Icon(Icons.mic, color: Colors.white),
                            onPressed: _listen,
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _micAnimationController,
                          builder: (context, child) {
                            return GestureDetector(
                              onLongPress: () {
                                HapticFeedback.heavyImpact();
                                _listen();
                              },
                              child: FloatingActionButton(
                                mini: true,
                                backgroundColor: _controller.text.trim().isEmpty
                                    ? primaryColor
                                    : primaryColor.withOpacity(0.3),
                                elevation: 4,
                                child: Icon(
                                  _controller.text.trim().isEmpty ? Icons.mic : Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: _controller.text.trim().isEmpty
                                    ? _listen
                                    : handleSend,
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      shape: StadiumBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      onPressed: () {
        _controller.text = text;
        handleSend();
      },
    );
  }
}