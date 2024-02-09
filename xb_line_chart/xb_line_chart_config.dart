import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_model.dart';

typedef XBLineChartOnHover = void Function(int? hoverIndex, double hoverDx);
typedef XBLineChartHoverBuilder = Widget Function(
    int? hoverIndex, double hoverDx, double maxHeight);
typedef XBLineChartHoverWidth = double Function(
    int? hoverIndex, double hoverDx);

enum XBLineChartNameLayout { scroll, wrap }

double XBLineChartBottomTitleFix = 10;
double XBLineChartBottomTitleWidth = 60;
double XBLineChartLeftTitleHeight = 30;
double XBLineChartDayGap = 30;
double XBLineChartNameMarkWidth = 5;

/// 数据点的横向扩展空间
double XBLineChartDatasExtensionSpace = 30;

/// 左边标题纵向的扩展空间
double XBLineChartLeftTitleExtensionSpace = 15;

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
