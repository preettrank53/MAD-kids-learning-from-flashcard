import 'package:flutter/material.dart';

/// A Flat Card with "Button Depth" (Solid Bottom Border)
/// Replaces the old Clay/Neumorphic style.
class ClayCard extends StatefulWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color color;
  final double borderRadius;
  final double depth; // Maps to bottom border height
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color = Colors.white,
    this.borderRadius = 16.0,
    this.depth = 4.0, // Standard depth
    this.padding,
    this.margin,
    this.onTap,
    // Deprecated/Ignored params from Clay
    dynamic surfaceColor,
    dynamic parentColor,
    dynamic spread,
    dynamic emboss,
    dynamic customBorder,
  });

  @override
  State<ClayCard> createState() => _ClayCardState();
}

class _ClayCardState extends State<ClayCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Calculate "Darker" shade for the bottom border/side
    final HSLColor hsl = HSLColor.fromColor(widget.color);
    final Color borderColor = hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

    // When pressed, we reduce the bottom margin (translate down) and reduce border width
    final double currentDepth = _isPressed ? 0.0 : widget.depth;
    final double topOffset = _isPressed ? widget.depth : 0.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        // We use a Transform or Margin trick to simulate the press down
        // But simplest way for "3D Button":
        // Container with "border-bottom" of height X.
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          transform: Matrix4.translationValues(0, topOffset, 0),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(0),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
