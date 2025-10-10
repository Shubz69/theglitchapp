import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/theme.dart';
import '../services/auth_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _isAdmin = false;
  String _errorMessage = '';
  int _selectedTab = 0;
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAdminStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AuthService.isAdmin();
    if (!isAdmin) {
      Navigator.of(context).pushReplacementNamed('/main');
      return;
    }
    
    setState(() {
      _isAdmin = true;
    });
    
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadUsers(),
        _loadMessages(),
      ]);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUsers() async {
    try {
      // Mock users for now - replace with API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _users = [
          {
            'id': '1',
            'username': 'TraderPro',
            'email': 'trader@example.com',
            'name': 'John Smith',
            'role': 'USER',
            'joinedAt': DateTime.now().subtract(const Duration(days: 30)),
            'isOnline': true,
            'lastActive': DateTime.now().subtract(const Duration(minutes: 5)),
          },
          {
            'id': '2',
            'username': 'CryptoNewbie',
            'email': 'crypto@example.com',
            'name': 'Sarah Johnson',
            'role': 'USER',
            'joinedAt': DateTime.now().subtract(const Duration(days: 15)),
            'isOnline': false,
            'lastActive': DateTime.now().subtract(const Duration(hours: 2)),
          },
          {
            'id': '3',
            'username': 'StockMaster',
            'email': 'stock@example.com',
            'name': 'Mike Wilson',
            'role': 'USER',
            'joinedAt': DateTime.now().subtract(const Duration(days: 45)),
            'isOnline': true,
            'lastActive': DateTime.now().subtract(const Duration(minutes: 1)),
          },
          {
            'id': '4',
            'username': 'AdminUser',
            'email': 'admin@example.com',
            'name': 'Admin User',
            'role': 'ADMIN',
            'joinedAt': DateTime.now().subtract(const Duration(days: 60)),
            'isOnline': true,
            'lastActive': DateTime.now(),
          },
        ];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users';
      });
    }
  }

  Future<void> _loadMessages() async {
    try {
      // Mock messages for now - replace with API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _messages = [
          {
            'id': '1',
            'name': 'John Doe',
            'email': 'john@example.com',
            'message': 'I need help with my account setup. Can someone assist me?',
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
            'isRead': false,
          },
          {
            'id': '2',
            'name': 'Jane Smith',
            'email': 'jane@example.com',
            'message': 'I\'m having trouble accessing the premium courses. Please help!',
            'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
            'isRead': true,
          },
          {
            'id': '3',
            'name': 'Bob Johnson',
            'email': 'bob@example.com',
            'message': 'Great platform! Just wanted to say thanks for the excellent content.',
            'timestamp': DateTime.now().subtract(const Duration(days: 1)),
            'isRead': true,
          },
        ];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load messages';
      });
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      // Mock delete - replace with API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _users.removeWhere((user) => user['id'] == userId);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      // Mock delete - replace with API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _messages.removeWhere((message) => message['id'] == messageId);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdmin) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgMedium,
        elevation: 0,
        title: Text(
          'Admin Panel',
          style: GoogleFonts.orbitron(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: textPrimary),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: textSecondary,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Messages'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildAdminContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: primary),
          const SizedBox(height: 16),
          Text(
            'Loading admin data...',
            style: GoogleFonts.roboto(
              color: textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildUsersTab(),
        _buildMessagesTab(),
        _buildAnalyticsTab(),
      ],
    );
  }

  Widget _buildUsersTab() {
    return Column(
      children: [
        _buildUsersHeader(),
        Expanded(
          child: _users.isEmpty
              ? _buildEmptyState('No users found')
              : _buildUsersList(),
        ),
      ],
    );
  }

  Widget _buildUsersHeader() {
    final onlineCount = _users.where((user) => user['isOnline']).length;
    final totalCount = _users.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgMedium,
        border: Border(
          bottom: BorderSide(color: primary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Management',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: $totalCount | Online: $onlineCount | Offline: ${totalCount - onlineCount}',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadUsers,
            icon: const Icon(Icons.refresh, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: user['isOnline'] ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user['username'],
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (user['role'] == 'ADMIN')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'ADMIN',
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  user['email'],
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
                Text(
                  user['name'],
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      user['isOnline'] ? Icons.circle : Icons.circle_outlined,
                      color: user['isOnline'] ? Colors.green : Colors.grey,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user['isOnline'] ? 'Online' : 'Offline',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: user['isOnline'] ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Joined: ${_formatDate(user['joinedAt'])}',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (user['role'] != 'ADMIN')
            IconButton(
              onPressed: () => _showDeleteUserDialog(user),
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return Column(
      children: [
        _buildMessagesHeader(),
        Expanded(
          child: _messages.isEmpty
              ? _buildEmptyState('No messages found')
              : _buildMessagesList(),
        ),
      ],
    );
  }

  Widget _buildMessagesHeader() {
    final unreadCount = _messages.where((msg) => !msg['isRead']).length;
    final totalCount = _messages.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgMedium,
        border: Border(
          bottom: BorderSide(color: primary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Messages',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: $totalCount | Unread: $unreadCount',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadMessages,
            icon: const Icon(Icons.refresh, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageCard(message);
      },
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: message['isRead'] ? primary.withOpacity(0.2) : primary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.person,
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
                      message['name'],
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      message['email'],
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTimestamp(message['timestamp']),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                  if (!message['isRead'])
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message['message'],
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement reply
                },
                icon: const Icon(Icons.reply, size: 16),
                label: const Text('Reply'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    message['isRead'] = true;
                  });
                },
                icon: const Icon(Icons.mark_email_read, size: 16),
                label: const Text('Mark Read'),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showDeleteMessageDialog(message),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAnalyticsCard(
            'Total Users',
            _users.length.toString(),
            Icons.people,
            primary,
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard(
            'Online Users',
            _users.where((user) => user['isOnline']).length.toString(),
            Icons.circle,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard(
            'Total Messages',
            _messages.length.toString(),
            Icons.message,
            accent,
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard(
            'Unread Messages',
            _messages.where((msg) => !msg['isRead']).length.toString(),
            Icons.mark_email_unread,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgMedium,
        title: Text(
          'Delete User',
          style: GoogleFonts.roboto(color: textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete ${user['username']}? This action cannot be undone.',
          style: GoogleFonts.roboto(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user['id']);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.roboto(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteMessageDialog(Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgMedium,
        title: Text(
          'Delete Message',
          style: GoogleFonts.roboto(color: textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this message?',
          style: GoogleFonts.roboto(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMessage(message['id']);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.roboto(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
