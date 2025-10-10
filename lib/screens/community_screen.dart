import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../config/theme.dart';
import '../models/channel.dart';
import '../models/message.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  List<Channel> _channels = [];
  Map<String, List<Message>> _channelMessages = {}; // Store messages per channel
  Channel? _selectedChannel;
  bool _isLoading = true;
  bool _isLoadingMessages = false;
  String _errorMessage = '';
  bool _isAdmin = false;
  
  late AnimationController _dropdownController;
  late Animation<double> _dropdownAnimation;
  
  // Services
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _dropdownController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dropdownAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dropdownController, curve: Curves.easeInOut),
    );
    
    _initializeData();
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _checkAdminStatus();
    await _loadChannels();
    if (_channels.isNotEmpty) {
      _selectedChannel = _channels.first;
      await _loadMessages(_selectedChannel!.id);
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AuthService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  Future<void> _loadChannels() async {
    try {
      // Mock channels for now - replace with API call
      setState(() {
        _channels = [
          Channel(
            id: '1',
            name: 'General',
            description: 'General discussion about trading',
            accessLevel: 'open',
            isLocked: false,
            memberCount: 150,
          ),
          Channel(
            id: '2',
            name: 'Trading Strategies',
            description: 'Share and discuss trading strategies',
            accessLevel: 'open',
            isLocked: false,
            memberCount: 89,
          ),
          Channel(
            id: '3',
            name: 'Market Analysis',
            description: 'Daily market analysis and insights',
            accessLevel: 'open',
            isLocked: false,
            memberCount: 67,
          ),
          Channel(
            id: '4',
            name: 'Beginners',
            description: 'New to trading? Start here!',
            accessLevel: 'open',
            isLocked: false,
            memberCount: 234,
          ),
          Channel(
            id: '5',
            name: 'Premium Members',
            description: 'Exclusive content for premium members',
            accessLevel: 'premium',
            isLocked: true,
            memberCount: 45,
          ),
        ];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load channels';
      });
    }
  }

  Future<void> _loadMessages(String channelId) async {
    setState(() {
      _isLoadingMessages = true;
    });

    try {
      final messages = await _apiService.getMessages(channelId);
      setState(() {
        _channelMessages[channelId] = messages; // Store messages per channel
        _isLoadingMessages = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load messages';
        _isLoadingMessages = false;
      });
    }
  }

  void _selectChannel(Channel channel) {
    setState(() {
      _selectedChannel = channel;
    });
    
    // Only load messages if they haven't been loaded yet
    if (!_channelMessages.containsKey(channel.id)) {
      _loadMessages(channel.id);
    } else {
      _scrollToBottom();
    }
  }
  
  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _selectedChannel == null) return;
    
    final user = await AuthService.getCurrentUser();
    if (user == null) return;
    
    // Clear input immediately
    _messageController.clear();
    
    // Create message object
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      senderId: user['id'].toString(),
      senderUsername: user['username'] ?? 'User',
      timestamp: DateTime.now(),
      senderLevel: 1,
      userId: user['id'].toString(),
      username: user['username'] ?? 'User',
      isSystem: false,
    );
    
    // Add message to local list immediately for instant UI update
    setState(() {
      if (_channelMessages[_selectedChannel!.id] == null) {
        _channelMessages[_selectedChannel!.id] = [];
      }
      _channelMessages[_selectedChannel!.id]!.add(newMessage);
    });
    
    // Send via HTTP API
    try {
      final success = await _apiService.sendMessage(
        _selectedChannel!.id,
        content,
        user['id'].toString(),
        user['username'] ?? 'User',
      );
      
      if (!success) {
        // Remove message if sending failed
        setState(() {
          _channelMessages[_selectedChannel!.id]!.removeWhere((msg) => msg.id == newMessage.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Remove message if sending failed
      setState(() {
        _channelMessages[_selectedChannel!.id]!.removeWhere((msg) => msg.id == newMessage.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
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

  void _toggleDropdown() {
    if (_dropdownController.isCompleted) {
      _dropdownController.reverse();
    } else {
      _dropdownController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: _isLoading
          ? _buildLoadingState()
          : _buildCommunityInterface(),
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
            'Loading community...',
            style: GoogleFonts.roboto(
              color: textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityInterface() {
    return Column(
      children: [
        _buildHeader(),
        _buildChannelSelector(),
        Expanded(
          child: _selectedChannel == null
              ? _buildNoChannelSelected()
              : _buildMessagesArea(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
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
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.people,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE GLITCH Community',
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                Text(
                  'Connect with traders worldwide',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_isAdmin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'ADMIN',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChannelSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgMedium,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildChannelDropdown(),
          AnimatedBuilder(
            animation: _dropdownAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _dropdownAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildChannelList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelDropdown() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleDropdown,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.tag,
                color: primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedChannel?.name ?? 'Select a channel',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _selectedChannel != null ? textPrimary : textSecondary,
                      ),
                    ),
                    if (_selectedChannel != null)
                      Text(
                        _selectedChannel!.description,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                _dropdownController.isCompleted
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelList() {
    return Container(
      decoration: BoxDecoration(
        color: bgDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: _channels.map((channel) {
          final isSelected = _selectedChannel?.id == channel.id;
          return _buildChannelItem(channel, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildChannelItem(Channel channel, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _selectChannel(channel);
          _dropdownController.reverse();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? primary.withOpacity(0.1) : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                channel.isLocked ? Icons.lock : Icons.tag,
                color: channel.isLocked ? Colors.orange : primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          channel.name,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? primary : textPrimary,
                          ),
                        ),
                        if (channel.isLocked) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.lock,
                            color: Colors.orange,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      channel.description,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${channel.memberCount}',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoChannelSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a channel to start chatting',
            style: GoogleFonts.roboto(
              fontSize: 18,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea() {
    return Column(
      children: [
        _buildChannelHeader(),
        Expanded(
          child: _isLoadingMessages
              ? _buildMessagesLoading()
              : _buildMessagesList(),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildChannelHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgMedium,
        border: Border(
          bottom: BorderSide(color: primary.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _selectedChannel!.isLocked ? Icons.lock : Icons.tag,
            color: _selectedChannel!.isLocked ? Colors.orange : primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _selectedChannel!.name,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_selectedChannel!.memberCount} members',
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: primary,
              ),
            ),
          ),
          const Spacer(),
          if (_isAdmin)
            IconButton(
              onPressed: () {
                // TODO: Implement admin actions
                _showAdminOptions();
              },
              icon: const Icon(Icons.more_vert, color: textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildMessagesLoading() {
    return const Center(
      child: CircularProgressIndicator(color: primary),
    );
  }

  Widget _buildMessagesList() {
    final currentMessages = _selectedChannel != null 
        ? _channelMessages[_selectedChannel!.id] ?? []
        : [];
    
    if (currentMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to start the conversation!',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentMessages.length,
      itemBuilder: (context, index) {
        return _buildMessageItem(currentMessages[index]);
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: message.isSystem ? primary : accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              message.isSystem ? Icons.smart_toy : Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.username,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: message.isSystem ? primary : textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                    ),
                    if (_isAdmin && !message.isSystem) ...[
                      const Spacer(),
                      IconButton(
                        onPressed: () => _deleteMessage(message),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                _buildMessageContent(message.content),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(String content) {
    // Check if content contains an image URL
    final imageUrlRegex = RegExp(
      r'(https?:\/\/.*\.(?:png|jpg|jpeg|gif|webp))',
      caseSensitive: false,
    );
    final urlRegex = RegExp(
      r'(https?:\/\/[^\s]+)',
      caseSensitive: false,
    );
    
    final imageMatch = imageUrlRegex.firstMatch(content);
    
    // If content is just an image URL, display the image
    if (imageMatch != null && content.trim() == imageMatch.group(0)) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
        child: CachedNetworkImage(
          imageUrl: content.trim(),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Text(
            content,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: textPrimary,
            ),
          ),
          fit: BoxFit.cover,
        ),
      );
    }
    
    // If content contains URLs, make them clickable
    if (urlRegex.hasMatch(content)) {
      final spans = <InlineSpan>[];
      int lastMatchEnd = 0;
      
      for (final match in urlRegex.allMatches(content)) {
        // Add text before the URL
        if (match.start > lastMatchEnd) {
          spans.add(TextSpan(
            text: content.substring(lastMatchEnd, match.start),
          ));
        }
        
        // Add clickable URL
        final url = match.group(0)!;
        spans.add(
          TextSpan(
            text: url,
            style: const TextStyle(
              color: primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
          ),
        );
        
        lastMatchEnd = match.end;
      }
      
      // Add remaining text
      if (lastMatchEnd < content.length) {
        spans.add(TextSpan(
          text: content.substring(lastMatchEnd),
        ));
      }
      
      return RichText(
        text: TextSpan(
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: textPrimary,
          ),
          children: spans,
        ),
      );
    }
    
    // Default text display (supports emojis automatically)
    return Text(
      content,
      style: GoogleFonts.roboto(
        fontSize: 14,
        color: textPrimary,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              controller: _messageController,
              style: GoogleFonts.roboto(color: textPrimary),
              decoration: InputDecoration(
                hintText: _selectedChannel!.isLocked
                    ? 'This channel is locked'
                    : 'Type a message...',
                hintStyle: GoogleFonts.roboto(color: textSecondary),
                filled: true,
                fillColor: bgDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              enabled: !_selectedChannel!.isLocked,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _selectedChannel!.isLocked ? Colors.grey : primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _selectedChannel!.isLocked ? null : _sendMessage,
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

  Future<void> _deleteMessage(Message message) async {
    final confirmed = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.roboto(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Remove message from UI immediately
      setState(() {
        _channelMessages[_selectedChannel!.id]!.removeWhere((msg) => msg.id == message.id);
      });

      // Delete from backend (implement in API service)
      try {
        final success = await _apiService.deleteMessage(
          _selectedChannel!.id,
          message.id,
        );
        
        if (!success) {
          // Re-add message if deletion failed
          setState(() {
            _channelMessages[_selectedChannel!.id]!.add(message);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Re-add message if deletion failed
        setState(() {
          _channelMessages[_selectedChannel!.id]!.add(message);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAdminOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Admin Options',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                'Delete Channel',
                style: GoogleFonts.roboto(color: textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement delete channel
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: Text(
                'Toggle Lock',
                style: GoogleFonts.roboto(color: textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement toggle lock
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: primary),
              title: Text(
                'Manage Members',
                style: GoogleFonts.roboto(color: textPrimary),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement manage members
              },
            ),
          ],
        ),
      ),
    );
  }
}