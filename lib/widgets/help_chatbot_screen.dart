import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/theme.dart';

class HelpChatbotScreen extends StatefulWidget {
  const HelpChatbotScreen({super.key});

  @override
  State<HelpChatbotScreen> createState() => _HelpChatbotScreenState();
}

class _HelpChatbotScreenState extends State<HelpChatbotScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _connectError = false;
  bool _showOptions = true;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
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
        return 'Yes! We have free courses available. The \'Introduction to Trading\' course is completely free and perfect for beginners.';
      }
      if (msg.contains('premium')) {
        return 'Premium features include advanced courses, priority support, and exclusive community access. Premium membership starts at \$19.99/month.';
      }
      return 'We have a freemium model. Basic access is free, premium features start at \$19.99/month. Check our Courses page for detailed pricing.';
    }
    
    // Community related queries
    if (msg.contains('community') || msg.contains('chat') || msg.contains('discord')) {
      return 'Our community is a great place to connect with other traders! You can join discussions, share strategies, and get help from experienced traders. Access it through the Community tab.';
    }
    
    // Support related queries
    if (msg.contains('help') || msg.contains('support') || msg.contains('problem')) {
      return 'I\'m here to help! For technical issues, you can contact our support team through the Contact Us page. For general questions, feel free to ask me anything!';
    }
    
    // Trading related queries
    if (msg.contains('trading') || msg.contains('market') || msg.contains('stock')) {
      return 'Trading involves risk and requires proper education. I recommend starting with our free \'Introduction to Trading\' course to learn the basics before making any trades.';
    }
    
    // Default response
    return 'I\'m THE GLITCH, your trading education assistant! I can help you with questions about our courses, community, pricing, or general trading education. What would you like to know?';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgMedium,
        elevation: 0,
        title: Text(
          'AI Help Assistant',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: _messages.isEmpty
                ? _buildWelcomeScreen()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is thinking...',
                    style: GoogleFonts.roboto(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.smart_toy,
                size: 40,
                color: primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'THE GLITCH AI Assistant',
              style: GoogleFonts.orbitron(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'I\'m here to help you with questions about our platform, courses, and trading education.',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_showOptions) _buildQuickOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOptions() {
    final options = [
      'What courses do you offer?',
      'How much does it cost?',
      'How do I join the community?',
      'I need help with trading basics',
    ];

    return Column(
      children: options.map((option) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        child: ElevatedButton(
          onPressed: () => _sendMessage(option),
          style: ElevatedButton.styleFrom(
            backgroundColor: bgMedium,
            foregroundColor: textPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: primary.withOpacity(0.3)),
            ),
          ),
          child: Text(
            option,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['from'] == 'user';
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? primary : bgMedium,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 16.0 : 0.0),
            topRight: Radius.circular(isUser ? 0.0 : 16.0),
            bottomLeft: const Radius.circular(16.0),
            bottomRight: const Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message['text'],
          style: GoogleFonts.roboto(
            color: isUser ? Colors.white : textPrimary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: bgMedium,
        border: Border(
          top: BorderSide(color: primary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              style: GoogleFonts.roboto(color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: GoogleFonts.roboto(color: textSecondary),
                filled: true,
                fillColor: bgDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) {
                if (_inputController.text.trim().isNotEmpty) {
                  _sendMessage(_inputController.text.trim());
                  _inputController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () {
              if (_inputController.text.trim().isNotEmpty) {
                _sendMessage(_inputController.text.trim());
                _inputController.clear();
              }
            },
            backgroundColor: primary,
            mini: true,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
