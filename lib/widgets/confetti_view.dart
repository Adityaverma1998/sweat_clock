import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiView extends StatefulWidget {
  const ConfettiView({super.key});

  @override
  State<ConfettiView> createState() => _ConfettiViewState();
}

class _ConfettiViewState extends State<ConfettiView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Generate random particles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 50; i++) {
        _particles.add(ConfettiParticle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * -size.height, // start above screen
          color: _getRandomColor(),
          size: _random.nextDouble() * 8 + 6,
          speed: _random.nextDouble() * 3 + 2,
          sway: _random.nextDouble() * 2 * math.pi,
          swaySpeed: _random.nextDouble() * 0.05 + 0.02,
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: _random.nextDouble() * 0.1 - 0.05,
          isCircle: _random.nextBool(),
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFc084fc), // Purple L
      const Color(0xFFa855f7), // Purple
      const Color(0xFFfcd34d), // Prep L
      const Color(0xFFf87171), // Workout L
      const Color(0xFF60a5fa), // Rest L
      const Color(0xFF4ade80), // Green L
      const Color(0xFFec4899), // Pink
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        for (var p in _particles) {
          p.y += p.speed;
          p.rotation += p.rotationSpeed;
          p.sway += p.swaySpeed;
          // Reset when it goes below screen
          if (p.y > size.height) {
            p.y = -20;
            p.x = _random.nextDouble() * size.width;
          }
        }

        return CustomPaint(
          size: Size.infinite,
          painter: ConfettiPainter(particles: _particles),
        );
      },
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double speed;
  double sway;
  final double swaySpeed;
  double rotation;
  final double rotationSpeed;
  final bool isCircle;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.sway,
    required this.swaySpeed,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      paint.color = p.color;
      canvas.save();
      
      // Apply sway and translation
      final double currentX = p.x + math.sin(p.sway) * 15;
      canvas.translate(currentX, p.y);
      canvas.rotate(p.rotation);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      }
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
