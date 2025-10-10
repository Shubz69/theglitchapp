import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlitchPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  GlitchPainter({
    required this.animationValue,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create glitch lines
    for (int i = 0; i < 20; i++) {
      final random = math.Random(i);
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = random.nextDouble() * 2 + 1;
      final height = random.nextDouble() * 20 + 5;
      
      // Animate the glitch effect
      final opacity = (math.sin(animationValue * math.pi * 2 + i) + 1) / 2;
      
      paint.color = color.withOpacity(opacity * 0.3);
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }

    // Create glitch blocks
    for (int i = 0; i < 10; i++) {
      final random = math.Random(i + 100);
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final blockSize = random.nextDouble() * 30 + 10;
      
      final opacity = (math.cos(animationValue * math.pi * 3 + i) + 1) / 2;
      
      paint.color = color.withOpacity(opacity * 0.2);
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, blockSize, blockSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GlitchPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.color != color;
  }
}

class GlitchText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double animationValue;

  const GlitchText({
    super.key,
    required this.text,
    this.style,
    this.animationValue = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Red glitch
        Transform.translate(
          offset: Offset(
            math.sin(animationValue * math.pi * 4) * 2,
            math.cos(animationValue * math.pi * 3) * 1,
          ),
          child: Text(
            text,
            style: (style ?? const TextStyle()).copyWith(
              color: Colors.red.withOpacity(0.7),
            ),
          ),
        ),
        // Blue glitch
        Transform.translate(
          offset: Offset(
            math.sin(animationValue * math.pi * 3) * -2,
            math.cos(animationValue * math.pi * 4) * -1,
          ),
          child: Text(
            text,
            style: (style ?? const TextStyle()).copyWith(
              color: Colors.blue.withOpacity(0.7),
            ),
          ),
        ),
        // Main text
        Text(
          text,
          style: style,
        ),
      ],
    );
  }
}
