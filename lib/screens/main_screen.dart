import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';
import 'loading_screen.dart';
import 'login_screen.dart';
import 'community_screen.dart';
import 'courses_screen.dart';
import 'contact_us_screen.dart';
import 'admin_panel_screen.dart';
import '../widgets/help_chatbot_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _isAdmin = false;
  Map<String, dynamic>? _user;

  final List<Widget> _screens = const [
    CommunityScreen(),
    CoursesScreen(),
    ContactUsScreen(),
    HelpChatbotScreen(),
  ];

  final List<String> _titles = const [
    'Community',
    'Courses',
    'Contact Us',
    'Help',
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isAuthenticated = await AuthService.isAuthenticated();
    final isAdmin = await AuthService.isAdmin();
    final user = await AuthService.getCurrentUser();

    setState(() {
      _isAuthenticated = isAuthenticated;
      _isAdmin = isAdmin;
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    await AuthService.logout();
    setState(() {
      _isAuthenticated = false;
      _isAdmin = false;
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen();
    }

    if (!_isAuthenticated) {
      return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: bgDark,
      appBar: _buildAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      drawer: _isAdmin ? _buildAdminDrawer() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: bgMedium,
      elevation: 0,
      title: Text(
        'THE GLITCH',
        style: GoogleFonts.orbitron(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
      actions: [
        if (_user != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: primary,
                  child: Text(
                    _user!['username']?.substring(0, 1).toUpperCase() ?? 'U',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _user!['username'] ?? 'User',
                  style: GoogleFonts.roboto(
                    color: textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: textPrimary),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                _showProfileDialog();
                break;
              case 'logout':
                _logout();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Text('Profile'),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminDrawer() {
    return Drawer(
      backgroundColor: bgMedium,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Admin Panel',
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                Text(
                  'Manage users and content',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people, color: primary),
            title: Text(
              'User Management',
              style: GoogleFonts.roboto(color: textPrimary),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminPanelScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.message, color: primary),
            title: Text(
              'Contact Messages',
              style: GoogleFonts.roboto(color: textPrimary),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminPanelScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics, color: primary),
            title: Text(
              'Analytics',
              style: GoogleFonts.roboto(color: textPrimary),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminPanelScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: bgMedium,
        border: Border(
          top: BorderSide(
            color: primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            activeIcon: Icon(Icons.forum, size: 28),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.school, size: 28),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            activeIcon: Icon(Icons.contact_mail, size: 28),
            label: 'Contact Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            activeIcon: Icon(Icons.help, size: 28),
            label: 'Help',
          ),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgMedium,
        title: Text(
          'Profile',
          style: GoogleFonts.roboto(color: textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${_user?['username'] ?? 'N/A'}',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
            Text(
              'Email: ${_user?['email'] ?? 'N/A'}',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
            Text(
              'Name: ${_user?['name'] ?? 'N/A'}',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
            Text(
              'Role: ${_user?['role'] ?? 'USER'}',
              style: GoogleFonts.roboto(color: textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.roboto(color: primary),
            ),
          ),
        ],
      ),
    );
  }
}