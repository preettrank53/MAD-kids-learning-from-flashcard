import 'package:flutter/material.dart';

class ClayCard extends StatefulWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color color;
  final Color? surfaceColor;
  final Color? parentColor;
  final double borderRadius;
  final double depth;
  final double spread;
  final Widget? customBorder;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const ClayCard({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color = const Color(0xFFF0F2F5),
    this.surfaceColor,
    this.parentColor,
    this.borderRadius = 30.0,
    this.depth = 10.0,
    this.spread = 4.0,
    this.customBorder,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  State<ClayCard> createState() => _ClayCardState();
}

class _ClayCardState extends State<ClayCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Colors for shadows
    // Top-Left (Highlight) - usually white/lighter
    final Color shadowLight = Colors.white;
    // Bottom-Right (Shadow) - usually darker
    final Color shadowDark = const Color(0xFFA6ABBD);

    return GestureDetector(
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? [
                  // INSET EFFECT SIMULATION (Pressed)
                  // We can't do true inner shadows with standard BoxShadow, 
                  // but we can simulate the "pressed" look by:
                  // 1. Removing outer highlighting
                  // 2. Adding a slight dark border or subtle gradient
                  // 3. Or simply flattening it.
                  //
                  // Improved Trick: 
                  // Use no shadow, but maybe a slight border to show "inset".
                  // The prompt asks to "invert shadows". 
                  // True inversion (Inner Shadow) needs a custom painter or Stack.
                  // For high fidelity without packages, we'll try a Stack approach internally?
                  // No, let's keep it simple: Pressed = Flat + slightly darker color
                  // actually, let's simulate rudimentary inner shadow with gradients if needed,
                  // but for now, "Pressed" usually means losing the drop shadow and maybe
                  // having a small shadow *inside*.
                  // Since we only have BoxShadow (outer), we will return NO/Tiny shadows
                  // and maybe shift colors.
                  
                  // Alternative: "Neumorphic Press" in vanilla Flutter often just removes shadows.
                  // Let's do a very small shadow to keep it visible but "lowered".
                  BoxShadow(
                    color: shadowDark.withOpacity(0.2),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                   BoxShadow(
                    color: shadowLight.withOpacity(0.5),
                    offset: const Offset(-1, -1),
                    blurRadius: 1,
                  ),
                ]
              : [
                  // OUTSET EFFECT (Unpressed - Puffy)
                  // Highlight (Top Left)
                  BoxShadow(
                    color: shadowLight,
                    offset: const Offset(-4, -4),
                    blurRadius: widget.depth,
                    spreadRadius: 1,
                  ),
                  // Shadow (Bottom Right)
                  BoxShadow(
                    color: shadowDark.withOpacity(0.4), // softer
                    offset: const Offset(4, 4),
                    blurRadius: widget.depth,
                    spreadRadius: 1,
                  ),
                ],
          gradient: _isPressed 
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _darken(widget.color, 0.05),
                    _lighten(widget.color, 0.05),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _lighten(widget.color, 0.05),
                    widget.color,
                    _darken(widget.color, 0.05),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
        ),
        child: widget.child,
      ),
    );
  }

  Color _darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color _lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
