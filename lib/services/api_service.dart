import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/channel.dart';
import '../models/message.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // Your Spring Boot backend
  
  // Chatbot
  Future<String> sendChatMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? data['message'] ?? data['response'] ?? 'No response';
      } else {
        return _getSimulatedResponse(message);
      }
    } catch (e) {
      return _getSimulatedResponse(message);
    }
  }
  
  String _getSimulatedResponse(String message) {
    final msg = message.toLowerCase();
    
    if (msg.contains('course')) {
      return 'We offer various trading courses from beginner to advanced levels. Check out our Courses page!';
    } else if (msg.contains('price') || msg.contains('cost')) {
      return 'We have a freemium model. Basic access is free, premium features start at \$19.99/month.';
    } else if (msg.contains('community')) {
      return 'Our community is a great place to connect with other traders. You can access it after logging in!';
    } else if (msg.contains('help') || msg.contains('support')) {
      return 'I\'m here to help! For technical issues, contact our support team through the Contact Us page.';
    }
    
    return 'THE GLITCH is an educational trading platform. How can I help you today?';
  }
  
  // Contact Us
  Future<bool> sendContactMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/contact'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'message': message,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      // Fallback: In production, this would show an error
      return false;
    }
  }
  
  // Courses
  Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/courses'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Course.fromJson(json)).toList();
      } else {
        return _getMockCourses();
      }
    } catch (e) {
      return _getMockCourses();
    }
  }
  
  List<Course> _getMockCourses() {
    return [
      Course(
        id: '1',
        title: 'Health & Fitness',
        description: 'Master the science of peak physical performance, biohacking techniques, and longevity protocols that enhance cognitive function, energy levels, and decision-making capabilities for sustained wealth creation',
        price: 79.99,
      ),
      Course(
        id: '2',
        title: 'E-Commerce',
        description: 'Build and scale profitable online businesses using advanced dropshipping strategies, Amazon FBA mastery, Shopify optimization, and multi-channel selling techniques that generate 6-7 figure revenues',
        price: 99.99,
      ),
      Course(
        id: '3',
        title: 'Forex Trading',
        description: 'Master professional-grade currency trading strategies, risk management systems, and market analysis techniques used by institutional traders to consistently profit from global currency fluctuations',
        price: 89.99,
      ),
      Course(
        id: '4',
        title: 'Crypto & Blockchain',
        description: 'Navigate the digital asset revolution with advanced DeFi strategies, yield farming protocols, NFT arbitrage, and blockchain technology investments that capitalize on the future of finance',
        price: 79.99,
      ),
      Course(
        id: '5',
        title: 'Algorithmic FX',
        description: 'Develop sophisticated automated trading systems using machine learning, quantitative analysis, and algorithmic strategies that execute high-frequency trades with precision and minimal risk',
        price: 149.99,
      ),
      Course(
        id: '6',
        title: 'Intelligent Systems Development',
        description: 'Create cutting-edge AI applications, automated trading bots, and intelligent software solutions that generate passive income through technology innovation and system automation',
        price: 199.99,
      ),
      Course(
        id: '7',
        title: 'Social Media',
        description: 'Build massive personal brands and monetize digital influence across TikTok, Instagram, YouTube, and LinkedIn using advanced content strategies, affiliate marketing, and brand partnerships',
        price: 59.99,
      ),
      Course(
        id: '8',
        title: 'Real Estate',
        description: 'Master strategic property investment, REIT analysis, real estate crowdfunding, and PropTech opportunities that create multiple passive income streams and long-term wealth appreciation',
        price: 119.99,
      ),
    ];
  }
  
  // Community - Channels
  Future<List<Channel>> getChannels() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/community/channels'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Channel.fromJson(json)).toList();
      } else {
        print('Failed to load channels: ${response.statusCode}');
        return _getMockChannels();
      }
    } catch (e) {
      print('Error loading channels: $e');
      return _getMockChannels();
    }
  }
  
  // Send message
  Future<bool> sendMessage(String channelId, String content, String userId, String username) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/api/community/channels/$channelId/messages'),
        headers: headers,
        body: jsonEncode({
          'content': content,
          'userId': userId,
          'username': username,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Message sent successfully');
        return true;
      } else {
        print('Failed to send message: ${response.statusCode}');
        // For now, simulate success for demo purposes
        await Future.delayed(const Duration(milliseconds: 500));
        return true;
      }
    } catch (e) {
      print('Error sending message: $e');
      // For now, simulate success for demo purposes
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }
  }
  
  // Delete message (admin only)
  Future<bool> deleteMessage(String channelId, String messageId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/community/channels/$channelId/messages/$messageId'),
        headers: headers,
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Message deleted successfully');
        return true;
      } else {
        print('Failed to delete message: ${response.statusCode}');
        // For now, simulate success for demo purposes
        await Future.delayed(const Duration(milliseconds: 500));
        return true;
      }
    } catch (e) {
      print('Error deleting message: $e');
      // For now, simulate success for demo purposes
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }
  }

  // Get auth headers with token
  Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
    } catch (e) {
      return {'Content-Type': 'application/json'};
    }
  }
  
  List<Channel> _getMockChannels() {
    return [
      // System Channels
      Channel(id: '1', name: 'welcome', description: 'Welcome to THE GLITCH - Create generational wealth', accessLevel: 'readonly'),
      Channel(id: '2', name: 'announcements', description: 'Important platform announcements', accessLevel: 'readonly'),
      Channel(id: '3', name: 'rules', description: 'Community rules and guidelines', accessLevel: 'readonly'),
      
      // General Channels
      Channel(id: '4', name: 'general-chat', description: 'General discussion for all members', accessLevel: 'open'),
      Channel(id: '5', name: 'strategy-sharing', description: 'Share wealth-building strategies', accessLevel: 'open'),
      Channel(id: '6', name: 'trade-ideas', description: 'Share your investment ideas', accessLevel: 'open'),
      Channel(id: '7', name: 'ai-insights', description: 'Discuss AI and algorithmic wealth building', accessLevel: 'open'),
      Channel(id: '8', name: 'feedback-bugs', description: 'Report bugs and provide feedback', accessLevel: 'open'),
      Channel(id: '9', name: 'course-help', description: 'Get help with courses', accessLevel: 'open'),
      
      // Level-based Channels
      Channel(id: '10', name: 'rookie-hub', description: 'For new wealth builders (level 1+)', accessLevel: 'level', minLevel: 1),
      Channel(id: '11', name: 'member-lounge', description: 'For regular members (level 10+)', accessLevel: 'level', minLevel: 10),
      Channel(id: '12', name: 'pro-discussion', description: 'For experienced investors (level 25+)', accessLevel: 'level', minLevel: 25),
      Channel(id: '13', name: 'elite-insights', description: 'For advanced wealth builders (level 50+)', accessLevel: 'level', minLevel: 50),
      Channel(id: '14', name: 'legend-chat', description: 'For legendary investors (level 99+)', accessLevel: 'level', minLevel: 99),
      
      // Course Channels - Updated to match website
      Channel(id: '15', name: 'health-fitness', description: 'Health & Fitness course channel - Master peak physical performance and biohacking', accessLevel: 'course', courseId: '1'),
      Channel(id: '16', name: 'e-commerce', description: 'E-Commerce course channel - Build and scale profitable online businesses', accessLevel: 'course', courseId: '2'),
      Channel(id: '17', name: 'forex-trading', description: 'Forex Trading course channel - Master professional currency trading strategies', accessLevel: 'course', courseId: '3'),
      Channel(id: '18', name: 'crypto-blockchain', description: 'Crypto & Blockchain course channel - Navigate the digital asset revolution', accessLevel: 'course', courseId: '4'),
      Channel(id: '19', name: 'algorithmic-fx', description: 'Algorithmic FX course channel - Develop automated trading systems', accessLevel: 'course', courseId: '5'),
      Channel(id: '20', name: 'intelligent-systems', description: 'Intelligent Systems Development course channel - Create AI applications and bots', accessLevel: 'course', courseId: '6'),
      Channel(id: '21', name: 'social-media', description: 'Social Media course channel - Build personal brands and monetize influence', accessLevel: 'course', courseId: '7'),
      Channel(id: '22', name: 'real-estate', description: 'Real Estate course channel - Master strategic property investment', accessLevel: 'course', courseId: '8'),
      
      // Admin Channel
      Channel(id: '23', name: 'staff-lounge', description: 'Admin only channel', accessLevel: 'admin-only'),
    ];
  }
  
  // Community - Messages
  Future<List<Message>> getMessages(String channelId) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/community/channels/$channelId/messages'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        print('Failed to load messages: ${response.statusCode}');
        return _getMockMessages(channelId);
      }
    } catch (e) {
      print('Error loading messages: $e');
      return _getMockMessages(channelId);
    }
  }
  
  List<Message> _getMockMessages(String channelId) {
    if (channelId == '1') {
      return [
        Message(
          id: '1',
          content: 'Welcome to THE GLITCH! 🚀 Create generational wealth and make money work for you through our multiple streams of knowledge!',
          senderId: 'admin',
          senderUsername: 'Admin',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          senderLevel: 10,
          userId: 'admin',
          username: 'Admin',
          isSystem: true,
        ),
      ];
    } else if (channelId == '2') {
      return [
        Message(
          id: '1',
          content: '📢 New course on Investment Psychology now available! Learn to build wealth without falling into bad habits.',
          senderId: 'admin',
          senderUsername: 'Admin',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          senderLevel: 10,
          userId: 'admin',
          username: 'Admin',
          isSystem: true,
        ),
      ];
    } else if (channelId == '3') {
      return [
        Message(
          id: '1',
          content: 'Please read our community guidelines to maintain a positive wealth-building environment.',
          senderId: 'admin',
          senderUsername: 'Admin',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          senderLevel: 10,
          userId: 'admin',
          username: 'Admin',
          isSystem: true,
        ),
      ];
    } else if (channelId == '4') {
      return [
        Message(
          id: '1',
          content: 'What wealth-building strategies is everyone working on today? 💰',
          senderId: 'user1',
          senderUsername: 'WealthBuilder',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          senderLevel: 5,
          userId: 'user1',
          username: 'WealthBuilder',
        ),
        Message(
          id: '2',
          content: 'Looking at some crypto investment opportunities for long-term wealth',
          senderId: 'user2',
          senderUsername: 'CryptoInvestor',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          senderLevel: 8,
          userId: 'user2',
          username: 'CryptoInvestor',
        ),
        Message(
          id: '3',
          content: 'Remember: "Make money work for you, not the other way around!" 💪',
          senderId: 'user3',
          senderUsername: 'MoneyMentor',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          senderLevel: 12,
          userId: 'user3',
          username: 'MoneyMentor',
        ),
      ];
    } else if (channelId == '5') {
      return [
        Message(
          id: '1',
          content: 'Diversification is key! Don\'t put all your eggs in one basket. Spread across stocks, crypto, real estate, and other assets.',
          senderId: 'user4',
          senderUsername: 'DiversificationPro',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          senderLevel: 15,
          userId: 'user4',
          username: 'DiversificationPro',
        ),
      ];
    } else if (channelId == '6') {
      return [
        Message(
          id: '1',
          content: 'Found a great dividend stock with 5% yield - perfect for passive income! 📈',
          senderId: 'user5',
          senderUsername: 'DividendHunter',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          senderLevel: 7,
          userId: 'user5',
          username: 'DividendHunter',
        ),
      ];
    } else if (channelId == '7') {
      return [
        Message(
          id: '1',
          content: 'AI-powered portfolio management is the future of wealth building! 🤖💰',
          senderId: 'user6',
          senderUsername: 'AITrader',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          senderLevel: 20,
          userId: 'user6',
          username: 'AITrader',
        ),
      ];
    } else if (channelId == '10') {
      return [
        Message(
          id: '1',
          content: 'Welcome new wealth builders! Start with small investments and learn as you grow. Every expert was once a beginner! 🌱',
          senderId: 'user7',
          senderUsername: 'WealthMentor',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          senderLevel: 25,
          userId: 'user7',
          username: 'WealthMentor',
        ),
      ];
    }
    return [];
  }
}


