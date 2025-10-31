import 'dart:math' as math;

import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  static const _animationDuration = Duration(milliseconds: 120);
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (widget.isLoading) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey.shade400;
    final disabled = widget.isLoading;
    return Center(
      child: AnimatedScale(
        duration: _animationDuration,
        scale: disabled ? 1 : (_isPressed ? 0.97 : 1),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: SizedBox(
            width: 280,
            height: 56,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              elevation: 0,
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: InkWell(
                  onTap: disabled ? null : widget.onPressed,
                  onTapDown: disabled ? null : (_) => _setPressed(true),
                  onTapCancel: disabled ? null : () => _setPressed(false),
                  onTapUp: disabled ? null : (_) => _setPressed(false),
                  borderRadius: BorderRadius.circular(28),
                  splashColor: Colors.black.withValues(alpha: 0.05),
                  highlightColor: Colors.transparent,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: widget.isLoading
                          ? const _LoadingContent(key: ValueKey('loading'))
                          : const _GoogleButtonContent(
                              key: ValueKey('content'),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleButtonContent extends StatelessWidget {
  const _GoogleButtonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _GoogleLogo(),
        const SizedBox(width: 12),
        Text(
          'Continue with Google',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF2C2C2C),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
        SizedBox(width: 12),
        Text(
          'Signing in...',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.18;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -40 * (math.pi / 180),
      200 * (math.pi / 180),
      false,
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      170 * (math.pi / 180),
      110 * (math.pi / 180),
      false,
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      80 * (math.pi / 180),
      90 * (math.pi / 180),
      false,
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -50 * (math.pi / 180),
      90 * (math.pi / 180),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
