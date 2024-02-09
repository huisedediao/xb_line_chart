import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_model.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_name_widget.dart';

typedef XBLineChartOnHover = void Function(int? hoverIndex, double hoverDx);
typedef XBLineChartHoverBuilder = Widget Function(
    int? hoverIndex, double hoverDx, double maxHeight);
typedef XBLineChartHoverWidthGetter = double Function(
    int? hoverIndex, double hoverDx);

enum XBLineChartNameLayout { scroll, wrap }

double XBLineChartBottomTitleFix = 10;
double XBLineChartBottomTitleWidth = 60;
double XBLineChartLeftTitleHeight = 30;
double XBLineChartDayGap = 30;
double XBLineChartNameMarkWidth = 5;

/// 数据点的横向扩展空间
double XBLineChartDatasExtensionSpace = 20;

/// 左边标题纵向的扩展空间
double XBLineChartLeftTitleExtensionSpace = 15;

double xbLineChartDefHoverWidth = 125;

String xbLineChartConvertDateToString(DateTime date) {
  String year = xbLineChartFixZeroStr(date.year);
  String month = xbLineChartFixZeroStr(date.month);
  String day = xbLineChartFixZeroStr(date.day);

  return "$year-$month-$day";
}

String xbLineChartFixZeroStr(int value) {
  if (value < 10) {
    return '0$value';
  } else {
    return '$value';
  }
}

int xbLineChartMaxValueCount(List<XBLineChartModel> models) {
  int ret = 0;
  for (var element in models) {
    if (element.values.length > ret) {
      ret = element.values.length;
    }
  }
  return ret;
}

double xbLineChartMaxValue(List<XBLineChartModel> models) {
  double ret = 0;
  for (var element in models) {
    for (var value in element.values) {
      if (value > ret) {
        ret = value;
      }
    }
  }
  return ret;
}

String xbLineChartDateStr(DateTime beginDate, int offset) {
  final date = beginDate.add(Duration(days: offset));
  final dateStr = xbLineChartConvertDateToString(date);
  return dateStr;
}

double xbLineChartDefHoverWidthGetter(int? hoverIndex, double hoverDx) {
  return xbLineChartDefHoverWidth;
}

Widget xbLineChartDefHoverBuilder(int? hoverIndex, double hoverDx,
    double maxHeight, DateTime beginDate, List<XBLineChartModel> models) {
  if (hoverIndex == null) {
    return Container();
  }
  double dateStrHeight = 20;
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: xbLineChartDefHoverWidth,
      // constraints: BoxConstraints(maxHeight: maxHeight - dateStrHeight),
      // constraints:
      //     BoxConstraints(maxHeight: 70 - dateStrHeight),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: dateStrHeight,
              child: Text(
                xbLineChartDateStr(beginDate, hoverIndex),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxHeight: maxHeight - dateStrHeight),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(models.length, (index) {
                    final model = models[index];
                    final value = model.values[hoverIndex];

                    return _hoverItem(
                        color: model.color, name: model.name, value: value);
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _hoverItem(
    {required Color color, required String name, required double value}) {
  return Row(
    children: [
      XBLineChartNameWidget(
        color: color,
        textColor: Colors.white,
        name: name,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        value.toStringAsFixed(0),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ],
  );
}
