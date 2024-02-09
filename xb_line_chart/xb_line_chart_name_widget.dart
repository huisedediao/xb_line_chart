import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_config.dart';

class XBLineChartNameWidget extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String name;
  const XBLineChartNameWidget(
      {required this.color,
      required this.name,
      this.textColor = Colors.black,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: xbLineChartNameMarkWidth,
          height: xbLineChartNameMarkWidth,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 12, color: textColor),
        )
      ],
    );
  }
}
