import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class NotesTab extends StatefulWidget {
  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          // 清除按钮
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 绘画区域
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                points.add(
                  DrawingPoint(
                    offset: details.localPosition,
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {
                points.add(
                  DrawingPoint(
                    offset: details.localPosition,
                    paint: Paint()
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(null);
              });
            },
            child: CustomPaint(
              painter: DrawingPainter(points: points),
              size: Size.infinite,
            ),
          ),
          // 底部工具栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 颜色选择器
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildColorChoice(Colors.black),
                      _buildColorChoice(Colors.red),
                      _buildColorChoice(Colors.blue),
                      _buildColorChoice(Colors.green),
                    ],
                  ),
                  // 笔触大小滑块
                  Expanded(
                    child: Slider(
                      value: strokeWidth,
                      min: 1,
                      max: 10,
                      onChanged: (value) {
                        setState(() {
                          strokeWidth = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChoice(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            width: 2,
            color: selectedColor == color ? Colors.grey : Colors.transparent,
          ),
        ),
        width: 30,
        height: 30,
      ),
    );
  }
}

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({
    required this.offset,
    required this.paint,
  });
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          points[i]!.paint,
        );
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.offset],
          points[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 