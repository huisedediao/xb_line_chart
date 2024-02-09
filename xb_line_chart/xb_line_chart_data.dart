import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_config.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_model.dart';

class XBLineChartData extends StatefulWidget {
  final int leftTitleCount;
  final DateTime beginDate;
  final List<XBLineChartModel> models;
  final int valueRangeMax;
  final int valueRangeMin;
  final int valueLineCount;
  final double painterWidth;
  final double painterHeight;
  final XBLineChartOnHover onHover;
  const XBLineChartData(
      {required this.leftTitleCount,
      required this.beginDate,
      required this.models,
      required this.valueRangeMax,
      required this.valueRangeMin,
      required this.painterWidth,
      required this.painterHeight,
      required this.valueLineCount,
      required this.onHover,
      super.key});

  @override
  State<XBLineChartData> createState() => _XBLineChartDataState();
}

class _XBLineChartDataState extends State<XBLineChartData> {
  bool _isOnLongPress = false;
  double? _touchX;

  int? _findModelIndex() {
    if (_touchX == null) return null;
    double range = 5;
    double rangeLeft = _touchX! - range;
    double rangeRight = _touchX! + range;
    for (int i = 0; i < xbLineChartMaxValueCount(widget.models); i++) {
      double x = i * xbLineChartDayGap + xbLineChartDatasExtensionSpace;
      if (x > rangeLeft && x < rangeRight) {
        return i;
      }
    }
    return null;
  }

  updateHover(double localDx) {
    setState(() {
      _touchX = localDx;
      widget.onHover(_findModelIndex(), localDx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        if (_isOnLongPress == false) return;
        updateHover(event.localPosition.dx);
      },
      child: GestureDetector(
        onLongPressStart: (details) {
          // print(details.localPosition.dx);
          _isOnLongPress = true;
          updateHover(details.localPosition.dx);
        },
        onLongPressCancel: () {
          _isOnLongPress = false;
          setState(() {
            _touchX = null;
            widget.onHover(_findModelIndex(), 0);
          });
        },
        onLongPressUp: () {
          _isOnLongPress = false;
          setState(() {
            _touchX = null;
            widget.onHover(_findModelIndex(), 0);
          });
        },
        child: Container(
          // color: colors.randColor,
          alignment: Alignment.center,
          child: Container(
            // color: Colors.orange,
            child: CustomPaint(
              size: Size(widget.painterWidth, widget.painterHeight),
              painter: XBDataPainter(
                  models: widget.models,
                  max: widget.valueRangeMax,
                  min: widget.valueRangeMin,
                  lineCount: widget.valueLineCount,
                  beginDate: widget.beginDate,
                  touchX: _touchX),
            ),
          ),
        ),
      ),
    );
  }
}

class XBDataPainter extends CustomPainter {
  final List<XBLineChartModel> models;
  final int max;
  final int min;

  final int lineCount;
  final DateTime beginDate;
  final double? touchX;
  XBDataPainter(
      {required this.models,
      required this.max,
      required this.min,
      required this.lineCount,
      required this.beginDate,
      required this.touchX});

  @override
  void paint(Canvas canvas, Size size) {
    final double maxY =
        xbLineChartLeftTitleExtensionSpace + xbLineChartLeftTitleHeight * 0.5;
    final double minY = size.height - maxY - xbLineChartBottomTitleFix;
    final double rangeY = maxY - minY;
    final double stepY = rangeY / (lineCount - 1);
    final double stepX = xbLineChartDayGap;

    var paint = Paint()
      ..color = Colors.grey.withAlpha(40)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // canvas.drawLine(Offset(0, maxY), Offset(size.width, maxY), paint);
    // canvas.drawLine(Offset(0, minY), Offset(size.width, minY), paint);

    for (int i = 0; i < lineCount; i++) {
      final double y = maxY - i * stepY;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      // Draw vertical lines on the last horizontal line
      if (i == lineCount - 1) {
        const double verticalLineHeight = 7;
        paint.color = Colors.grey.withAlpha(40); // Or any color you prefer

        for (double x = xbLineChartDatasExtensionSpace;
            x <= size.width;
            x += stepX) {
          final double topY = y - verticalLineHeight;
          canvas.drawLine(Offset(x, y), Offset(x, topY), paint);
        }

        paint.color = Colors.grey.withAlpha(40); // Restore original color
      }
    }

    // Draw values
    for (final model in models) {
      paint.color = model.color;
      double fontSize = 10;
      double valuePointW = 2;
      double valueTextYOffset = 5;
      for (int i = 0; i < model.values.length - 1; i++) {
        final value = model.values[i];
        final double x = i * stepX + xbLineChartDatasExtensionSpace;
        final double ratio = value / max;
        final double y = minY + ratio * rangeY;

        final nextValue = model.values[i + 1];
        final double nextX = (i + 1) * stepX + xbLineChartDatasExtensionSpace;
        final double nextRatio = nextValue / max;
        final double nextY = minY + nextRatio * rangeY;

        canvas.drawCircle(Offset(x, y), valuePointW, paint);
        canvas.drawLine(Offset(x, y), Offset(nextX, nextY), paint);

        // Draw vertical line
        // paint.color =
        //     Color.fromARGB(255, 236, 235, 235); // Or any color you prefer
        // canvas.drawLine(Offset(x, minY - 5), Offset(x, minY), paint);
        // // canvas.drawLine(
        // //     Offset(x, y), Offset(x, minY), paint); // Draw vertical line
        // paint.color = model.color; // Change the color back to the original

        // Draw value text
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: value.toString(),
            style: TextStyle(color: model.color, fontSize: fontSize),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(
                x - fontSize,
                y -
                    fontSize -
                    valueTextYOffset)); // Adjust the offset according to your needs
      }
      final lastValue = model.values.last;
      final double lastX =
          (model.values.length - 1) * stepX + xbLineChartDatasExtensionSpace;
      final double lastRatio = lastValue / max;
      final double lastY = minY + lastRatio * rangeY;
      canvas.drawCircle(Offset(lastX, lastY), valuePointW, paint);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: lastValue.toString(),
          style: TextStyle(color: model.color, fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas,
          Offset(lastX - fontSize, lastY - fontSize - valueTextYOffset));
    }

    // Draw dates
    final double dateY = size.height - xbLineChartDateFontSize - 15;
    for (int i = 0; i < models[0].values.length; i += 3) {
      final dateStr = xbLineChartDateStr(beginDate, i);
      final double x = i * stepX + xbLineChartDatasExtensionSpace;

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: dateStr,
          style:
              xbLineChartDateStrStyle, // Change the color and font size to your preference
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width * 0.5, dateY));
    }
    // 在手指触摸的位置画线
    if (touchX != null) {
      paint = Paint()
        ..color = Colors.red
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(touchX!, 0), Offset(touchX!, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(XBDataPainter oldDelegate) {
    return oldDelegate.touchX != touchX;
  }
}
