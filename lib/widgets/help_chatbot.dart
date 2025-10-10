import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/theme.dart';

class HelpChatbot extends StatefulWidget {
  const HelpChatbot({super.key});

  @override
  State<HelpChatbot> createState() => _HelpChatbotState();
}

class _HelpChatbotState extends State<HelpChatbot>
    with TickerProviderStateMixin {
  bool _isOpen = false;
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _connectError = false;
  bool _showOptions = true;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _bounceController.forward();
        _connectError = false;
        if (_messages.isEmpty) {
          _addWelcomeMessage();
        }
      } else {
        _bounceController.reverse();
      }
    });
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'from': 'bot',
        'text': '👋 Welcome to THE GLITCH! How can I help you today?\nChoose a question or type your own.',
      });
      _showOptions = true;
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'from': 'user', 'text': message});
      _showOptions = false;
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _getBotResponse(message);
      setState(() {
        _messages.add({'from': 'bot', 'text': response});
        _connectError = false;
      });
    } catch (e) {
      setState(() {
        _connectError = true;
        _messages.add({'from': 'bot', 'text': _getSimulatedResponse(message)});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  Future<String> _getBotResponse(String message) async {
    try {
      const apiUrl = 'http://localhost:8080/api/chatbot';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? data['message'] ?? data['response'] ?? 
               'I received your message but couldn\'t generate a proper response.';
      } else {
        throw Exception('API request failed');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }

  String _getSimulatedResponse(String message) {
    final msg = message.toLowerCase();
    
    // Greetings
    if (msg.contains('hello') || msg.contains('hi') || msg.contains('hey')) {
      return 'Hello! I\'m THE GLITCH, your trading assistant. How can I help you today?';
    }
    
    // Course related queries
    if (msg.contains('course') || msg.contains('learn') || msg.contains('study')) {
      if (msg.contains('beginner') || msg.contains('start')) {
        return 'We offer several beginner-friendly courses including \'Introduction to Trading\' which is completely free! Visit our Courses page to get started.';
      }
      if (msg.contains('video')) {
        return 'Yes, our courses include video tutorials, interactive lessons, quizzes, and downloadable resources.';
      }
      if (msg.contains('track') || msg.contains('progress')) {
        return 'You can track your course progress in the \'My Courses\' section after logging in. It shows completion percentage and which modules you\'ve finished.';
      }
      return 'We offer various trading courses from beginner to advanced levels. Popular options include Introduction to Trading (free), Technical Analysis (\$49.99), and Advanced Options Trading (\$79.99).';
    }
    
    // Pricing related queries
    if (msg.contains('price') || msg.contains('cost') || msg.contains('subscription')) {
      if (msg.contains('free')) {
        return 'Yes, we offer free courses including \'Introduction to Trading\' and limited access to the community.';
      }
      if (msg.contains('premium')) {
        return 'Premium membership costs \$19.99/month and includes access to all courses, advanced features, and priority support.';
      }
      return 'We have a freemium model. Basic access is free, premium features start at \$19.99/month, and individual courses range from free to \$79.99.';
    }
    
    // Platform features
    if (msg.contains('feature') || msg.contains('tool') || msg.contains('function')) {
      return 'THE GLITCH provides educational resources on various trading topics including stocks, forex, and cryptocurrencies. Our platform is focused on helping you learn trading strategies, not on providing direct trading capabilities.';
    }
    
    // Community related
    if (msg.contains('community') || msg.contains('forum') || msg.contains('chat')) {
      return 'Our community is a great place to connect with other traders, share strategies, and get help. You can access it after logging in, and it\'s free for all users!';
    }
    
    // Technical support
    if (msg.contains('help') || msg.contains('support') || msg.contains('problem')) {
      return 'I\'m here to help! For technical issues, you can contact our support team through the Contact Us page. For general questions about trading or our platform, feel free to ask me!';
    }
    
    // About the platform
    if (msg.contains('about') || msg.contains('what') || msg.contains('how')) {
      return 'THE GLITCH is an educational trading platform designed to help you learn and master trading strategies. We offer courses, community support, and educational resources to help you become a better trader.';
    }
    
    // Default response
    return 'That\'s an interesting question! While I\'m here to help with general information about THE GLITCH, I\'d recommend checking our courses or community for more specific trading advice. Is there something else I can help you with?';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleOption(String message) {
    _sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Stack(
        children: [
          // Chat window
          if (_isOpen)
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: _buildChatWindow(),
                );
              },
            ),
          
          // Help button
          _buildHelpButton(),
        ],
      ),
    );
  }

  Widget _buildHelpButton() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _toggleChat,
          child: const Icon(
            Icons.help_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildChatWindow() {
    return Container(
      width: 320,
      height: 500,
      decoration: BoxDecoration(
        color: bgMedium,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChatHeader(),
          _buildMessagesArea(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE GLITCH Help',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                if (_connectError)
                  Text(
                    'Offline Mode',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: _toggleChat,
            icon: const Icon(Icons.close, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length + (_showOptions ? 1 : 0) + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _messages.length) {
              return _buildMessage(_messages[index]);
            } else if (index == _messages.length && _showOptions) {
              return _buildOptions();
            } else if (_isLoading) {
              return _buildLoadingMessage();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['from'] == 'user';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? primary : bgDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message['text'],
                style: GoogleFonts.roboto(
                  color: isUser ? Colors.white : textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptions() {
    final groupedOptions = {
      "📚 Courses": [
        "What trading courses do you offer for beginners?",
        "Are there any video tutorials or just text?",
        "How do I track my course progress?",
        "Do the courses include quizzes or checkpoints?",
      ],
      "💸 Pricing & Subscriptions": [
        "What's the difference between the Free and Premium plans?",
        "How much does the Premium plan cost?",
        "Can I cancel my subscription anytime?",
        "What payment methods are accepted?",
      ],
      "💬 Community": [
        "What's the THE GLITCH community?",
        "How do I unlock new chat channels?",
        "Is the community moderated?",
        "Can free users access the chatroom?",
      ],
      "🛠️ Tech Help": [
        "Where can I use the chatbot?",
        "What can the chatbot help me with?",
        "Why can't I send messages in some channels?",
        "I purchased a course — why can't I access the community?",
      ],
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedOptions.entries.map((group) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.key,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ...group.value.map((question) {
                return GestureDetector(
                  onTap: () => _handleOption(question),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      question,
                      style: GoogleFonts.roboto(
                        color: textPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLoadingMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Thinking...',
                  style: GoogleFonts.roboto(
                    color: textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgDark.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              style: GoogleFonts.roboto(color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: GoogleFonts.roboto(color: textSecondary),
                filled: true,
                fillColor: bgMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendMessage(value);
                  _inputController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (_inputController.text.trim().isNotEmpty) {
                    _sendMessage(_inputController.text);
                    _inputController.clear();
                  }
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
