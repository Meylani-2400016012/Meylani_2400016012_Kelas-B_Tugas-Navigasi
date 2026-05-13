import 'dart:ui';
import 'package:flutter/material.dart';

class AuroraBackground extends StatefulWidget {
  final Widget child;

  const AuroraBackground({
    super.key,
    required this.child,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _blurCircle({
    required Color color,
    required double size,
    required double top,
    required double left,
    required double move,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: top + (animation.value * move),
          left: left + (animation.value * move),
          child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.35),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFEFF6FF),
                Color(0xFFF5F3FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        _blurCircle(
          color: Color(0xFF2563EB),
          size: 220,
          top: -70,
          left: -70,
          move: 35,
        ),
        _blurCircle(
          color: Color(0xFF7C3AED),
          size: 230,
          top: 160,
          left: 230,
          move: -45,
        ),
        _blurCircle(
          color: Color(0xFF06B6D4),
          size: 190,
          top: 520,
          left: -70,
          move: 35,
        ),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
          child: Container(
            color: Colors.white.withOpacity(0.05),
          ),
        ),

        widget.child,
      ],
    );
  }
}