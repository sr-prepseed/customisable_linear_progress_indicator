import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final bool enableHapticFeedback;
  final Duration progressAnimationDuration;
  final Curve progressAnimationCurve;
  final Function(double)? onProgressChanged;
  final Function()? onDragStart;
  final Function()? onDragEnd;

  // Tooltip Properties
  final bool showTooltip;
  final Color tooltipColor;
  final TextStyle tooltipTextStyle;

  // Handle Properties
  final BoxShape handleShape;
  final Border? handleBorder;
  final EdgeInsetsGeometry handlePadding;

  // Scale Markers Properties
  final bool showMarkers;
  final int markerCount;
  final Color markerColor;
  final double markerHeight;

  // Tap Dialog Properties
  final bool showTapDialog;
  final Widget? customDialog;

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
    this.enableHapticFeedback = false,
    this.progressAnimationDuration = const Duration(milliseconds: 300),
    this.progressAnimationCurve = Curves.easeInOut,
    this.onProgressChanged,
    this.onDragStart,
    this.onDragEnd,

    // Tooltip Defaults
    this.showTooltip = true,
    this.tooltipColor = Colors.redAccent,
    this.tooltipTextStyle = const TextStyle(color: Colors.white, fontSize: 12),

    // Handle Defaults
    this.handleShape = BoxShape.circle,
    this.handleBorder,
    this.handlePadding = EdgeInsets.zero,

    // Scale Markers Defaults
    this.showMarkers = true,
    this.markerCount = 5,
    this.markerColor = Colors.black54,
    this.markerHeight = 20,

    // Tap Dialog Defaults
    this.showTapDialog = true,
    this.customDialog,
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
      onHorizontalDragStart: (details) {
        if (widget.enableHapticFeedback) HapticFeedback.lightImpact();
        if (widget.onDragStart != null) widget.onDragStart!();
      },
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
      onHorizontalDragEnd: (details) {
        if (widget.onDragEnd != null) widget.onDragEnd!();
      },
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
            duration: widget.progressAnimationDuration,
            curve: widget.progressAnimationCurve,
            width: widget.width * progress,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.progressColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),

          // Tooltip (Optional)
          if (widget.showTooltip)
            Positioned(
              left: widget.width * progress - (widget.handleSize),
              bottom: 30,
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.tooltipColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${(progress * (widget.markerCount - 1) * 3.3).toInt()} sessions", // This should now correctly display the session count based on progress
                      style: widget.tooltipTextStyle,
                    ),
                  ),
                  CustomPaint(
                    size: const Size(10, 5),
                    painter: TrianglePainter(widget.tooltipColor),
                  ),
                ],
              ),
            ),

          // Handle (Draggable Image or Widget)
          Positioned(
            left: widget.width * progress - (widget.handleSize / 2),
            child: GestureDetector(
              onTap: () {
                if (widget.showTapDialog) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        widget.customDialog ??
                        AlertDialog(
                          title: const Text("Session Details"),
                          content: Text(
                              "You have completed ${(progress * (widget.markerCount - 1) * 3).toInt()} sessions."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: widget.handleWidget ??
                  Container(
                    width: widget.handleSize,
                    height: widget.handleSize,
                    decoration: BoxDecoration(
                      shape: widget.handleShape,
                      color: Colors.red,
                      border: widget.handleBorder,
                    ),
                    padding: widget.handlePadding,
                  ),
            ),
          ),

          // Number Scale with Vertical Dividers (Optional)
          if (widget.showMarkers)
            Positioned(
              top: widget.height + 5, // Spacing below the progress bar
              left: 0,
              width: widget.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(widget.markerCount, (index) {
                  return Column(
                    children: [
                      Container(
                        width: 1.5, // Thin vertical divider
                        height: widget.markerHeight, // Custom height
                        color: widget.markerColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${index * 3}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// Triangle for Tooltip Arrow
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
