import 'package:flutter/material.dart';

class LinearProgressWidget extends StatefulWidget {
  final double initialProgress;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;
  final Widget? handleWidget;
  final double handleSize;
  final bool isDraggable;
  final Duration animationDuration;
  final Curve animationCurve;
  final Function(double)? onProgressChanged;

  const LinearProgressWidget({
    super.key,
    this.initialProgress = 0.2,
    this.width = 300,
    this.height = 10,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.borderRadius = 5.0,
    this.handleWidget,
    this.handleSize = 30.0,
    this.isDraggable = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.onProgressChanged,
  }) : assert(initialProgress >= 0 && initialProgress <= 1,
            "Initial progress must be between 0 and 1");

  @override
  _LinearProgressWidgetState createState() => _LinearProgressWidgetState();
}

class _LinearProgressWidgetState extends State<LinearProgressWidget> {
  late double progress;

  @override
  void initState() {
    super.initState();
    progress = widget.initialProgress;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: widget.isDraggable
          ? (details) {
              setState(() {
                double newProgress =
                    progress + details.primaryDelta! / widget.width;
                progress = newProgress.clamp(0.0, 1.0);
                if (widget.onProgressChanged != null) {
                  widget.onProgressChanged!(progress);
                }
              });
            }
          : null,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          // Background Bar
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),

          // Progress Bar
          AnimatedContainer(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            width: widget.width * progress,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.progressColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),

          // Handle (Draggable Image or Widget)
          Positioned(
            left: widget.width * progress - (widget.handleSize / 2),
            child: widget.handleWidget ??
                Container(
                  width: widget.handleSize,
                  height: widget.handleSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
