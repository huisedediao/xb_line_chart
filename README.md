# xb_line_chart
折线图

![image.png](https://upload-images.jianshu.io/upload_images/3597041-9d0fadcce85c1363.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


```
import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/line_chart/line_chart_vm.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_model.dart';
import 'package:xb_scaffold/xb_scaffold.dart';

class LineChart extends XBPage<LineChartVM> {
  const LineChart({super.key});

  @override
  generateVM(BuildContext context) {
    return LineChartVM(context: context);
  }

  @override
  String setTitle(LineChartVM vm) {
    return "折线图demo";
  }

  @override
  Widget buildPage(vm, BuildContext context) {
    final beginDate = DateTime.now();
    final models = [
      XBLineChartModel(
          name: '张益达',
          color: Colors.orange,
          values: [10, 20, 1, 95, 38, 109, 127, 18, 98]),
      XBLineChartModel(
          name: '吕小布',
          color: Colors.green,
          values: [11, 26, 21, 35, 78, 19, 172, 22, 31]),
      XBLineChartModel(
          name: '曾小贤',
          color: Colors.blue,
          values: [57, 46, 100, 139, 88, 49, 72, 112, 21]),
      XBLineChartModel(
          name: '吴彦祖',
          color: Colors.greenAccent,
          values: [75, 64, 103, 39, 198, 219, 28, 122, 88]),
      XBLineChartModel(
          name: '张震',
          color: Colors.deepPurple,
          values: [35, 74, 93, 31, 34, 19, 18, 133, 188]),
      XBLineChartModel(
          name: '金城武',
          color: Color.fromARGB(255, 156, 154, 157),
          values: [78, 49, 27, 67, 36, 87, 103, 135, 75]),
      XBLineChartModel(
          name: '程冠希',
          color: Color.fromARGB(255, 26, 121, 76),
          values: [82, 120, 101, 56, 109, 187, 113, 235, 175])
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: XBLineChart(
                leftTitleCount: 8,
                beginDate: beginDate,
                models: models,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

```