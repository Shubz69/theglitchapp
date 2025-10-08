import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import '../models/channel.dart';
import '../models/message.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // Change this to your backend URL
  
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
        title: 'Introduction to Trading',
        description: 'Learn the basics of trading and financial markets',
        price: 0,
      ),
      Course(
        id: '2',
        title: 'Technical Analysis',
        description: 'Master chart patterns and technical indicators',
        price: 49.99,
      ),
      Course(
        id: '3',
        title: 'Fundamental Analysis',
        description: 'Understand financial statements and company valuation',
        price: 49.99,
      ),
      Course(
        id: '4',
        title: 'Cryptocurrency Trading',
        description: 'Learn to trade Bitcoin, Ethereum, and altcoins',
        price: 59.99,
      ),
      Course(
        id: '5',
        title: 'Advanced Options Trading',
        description: 'Strategies for options trading and risk management',
        price: 79.99,
      ),
    ];
  }
  
  // Community - Channels
  Future<List<Channel>> getChannels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/community/channels'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Channel.fromJson(json)).toList();
      } else {
        return _getMockChannels();
      }
    } catch (e) {
      return _getMockChannels();
    }
  }
  
  List<Channel> _getMockChannels() {
    return [
      Channel(id: '1', name: 'welcome', description: 'Welcome to the platform', accessLevel: 'readonly'),
      Channel(id: '2', name: 'announcements', description: 'Important announcements', accessLevel: 'readonly'),
      Channel(id: '3', name: 'general-chat', description: 'General discussion', accessLevel: 'open'),
      Channel(id: '4', name: 'rookie-hub', description: 'For new traders (level 1+)', accessLevel: 'level', minLevel: 1),
      Channel(id: '5', name: 'strategy-sharing', description: 'Share trading strategies', accessLevel: 'open'),
      Channel(id: '6', name: 'trade-ideas', description: 'Share your trade ideas', accessLevel: 'open'),
    ];
  }
  
  // Community - Messages
  Future<List<Message>> getMessages(String channelId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/community/channels/$channelId/messages'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        return _getMockMessages(channelId);
      }
    } catch (e) {
      return _getMockMessages(channelId);
    }
  }
  
  List<Message> _getMockMessages(String channelId) {
    if (channelId == '1') {
      return [
        Message(
          id: '1',
          content: 'Welcome to THE GLITCH trading platform!',
          senderId: 'admin',
          senderUsername: 'Admin',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          senderLevel: 10,
        ),
      ];
    } else if (channelId == '3') {
      return [
        Message(
          id: '1',
          content: 'What\'s everyone trading today?',
          senderId: 'user1',
          senderUsername: 'TraderPro',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          senderLevel: 5,
        ),
        Message(
          id: '2',
          content: 'Looking at some crypto setups',
          senderId: 'user2',
          senderUsername: 'CryptoKing',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          senderLevel: 8,
        ),
      ];
    }
    return [];
  }
}

