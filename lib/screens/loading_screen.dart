import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.forward();
    
    // Navigate to main screen after loading
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // Binary background animation
          _buildBinaryBackground(),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // THE GLITCH title with glitch effect
                _buildGlitchText(),
                
                const SizedBox(height: 16),
                
                Text(
                  'WEALTH REVOLUTION',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: accent,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Loading progress
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Column(
                      children: [
                        Text(
                          'SYSTEM INITIALIZING... ${(_progressAnimation.value * 100).toInt()}%',
                          style: GoogleFonts.courierPrime(
                            fontSize: 14,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 300,
                          height: 4,
                          decoration: BoxDecoration(
                            color: bgLight,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primary, accent],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Pulsing rings
          _buildPulsingRings(),
        ],
      ),
    );
  }
  
  Widget _buildGlitchText() {
    return Stack(
      children: [
        // Shadow layers for glitch effect
        Text(
          'THE GLITCH',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = primary.withOpacity(0.5),
          ),
        ),
        Text(
          'THE GLITCH',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBinaryBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: BinaryBackgroundPainter(),
      ),
    );
  }
  
  Widget _buildPulsingRings() {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(3, (index) {
              final size = 100.0 + (index * 80.0) * _controller.value;
              final opacity = 0.3 - (index * 0.1) - (_controller.value * 0.2);
              
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primary.withOpacity(opacity.clamp(0.0, 1.0)),
                    width: 2,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class BinaryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primary.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    final random = DateTime.now().millisecondsSinceEpoch;
    
    for (int i = 0; i < 50; i++) {
      final x = ((random * i) % size.width.toInt()).toDouble();
      final y = ((random * i * 2) % size.height.toInt()).toDouble();
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: i % 2 == 0 ? '1' : '0',
          style: TextStyle(
            color: primary.withOpacity(0.1),
            fontSize: 20,
            fontFamily: 'Courier',
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

