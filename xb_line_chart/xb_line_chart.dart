import 'dart:math';

import 'package:flutter/material.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_config.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_data.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_model.dart';
import 'package:xb_custom_widget_cabin/line_chart/xb_line_chart/xb_line_chart_name_widget.dart';

// ignore: must_be_immutable
class XBLineChart extends StatefulWidget {
  /// 左侧标题的数量，默认为8个
  final int leftTitleCount;

  /// 左侧标题的宽度，默认为50
  final double leftTitleWidth;

  /// 开始日期，后面每一个点在此基础上增加1天
  final DateTime beginDate;

  /// 每页，横向要显示几个点，默认7个
  final int pointCountPerPage;

  /// 数据源
  List<XBLineChartModel> models;

  /// 悬浮窗的宽度，用于控制悬浮窗显示的位置
  final XBLineChartHoverWidth hoverWidth;

  /// 悬浮窗的样式构建函数
  final XBLineChartHoverBuilder hoverBuilder;

  /// 是否需要底部的名字部分
  final bool needNames;

  /// 最底部，名字的左边距
  final double? namesPaddingLeft;

  /// 最底部，名字的布局方式，默认为wrap
  final XBLineChartNameLayout namesLayout;

  XBLineChart(
      {this.leftTitleCount = 8,
      this.leftTitleWidth = 50,
      required this.beginDate,
      required this.models,
      this.pointCountPerPage = 7,
      required this.hoverBuilder,
      required this.hoverWidth,
      this.namesPaddingLeft,
      this.needNames = true,
      this.namesLayout = XBLineChartNameLayout.wrap,
      super.key})
      : assert(leftTitleCount > 1, "XBLineChart error：左侧标题数至少为2个") {
    if (models.isEmpty) {
      models = [
        XBLineChartModel(name: "暂无数据", color: Colors.transparent, values: [1])
      ];
    }
  }

  @override
  State<XBLineChart> createState() => _XBLineChartState();
}

class _XBLineChartState extends State<XBLineChart> {
  final ScrollController _controller = ScrollController();
  late double _maxDataWidth;
  double _hoverDx = 0;
  int? _hoverIndex;
  int get _maxCount => xbLineChartMaxValueCount(widget.models);

  double get _maxValue => xbLineChartMaxValue(widget.models);

  List<int> get leftTitleContents {
    if (_maxValue == 0 || widget.leftTitleCount < 1) return [];
    int unit = (_maxValue / (widget.leftTitleCount - 1)).ceil();
    if (unit == 0) {
      unit = 1;
    }
    return List.generate(widget.leftTitleCount, (index) {
      return unit * (widget.leftTitleCount - 1 - index);
    });
  }

  double get _painterHeight {
    return widget.leftTitleCount * XBLineChartLeftTitleHeight +
        XBLineChartLeftTitleExtensionSpace * 2 +
        XBLineChartBottomTitleFix;
  }

  double get _painterWidth {
    return (_maxCount - 1) * XBLineChartDayGap +
        XBLineChartDatasExtensionSpace * 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: _painterHeight,
            // color: Colors.purple,
            child: Row(
              children: [_leftTitles(), Expanded(child: _datas())],
            ),
          ),
          _names()
        ],
      ),
    );
  }

  Widget _leftTitles() {
    return Container(
      // color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.only(top: XBLineChartLeftTitleExtensionSpace),
        child: Container(
          width: widget.leftTitleWidth,
          // color: Colors.red,
          child: Column(
            children: List.generate(leftTitleContents.length, (index) {
              return Container(
                  alignment: Alignment.center,
                  height: XBLineChartLeftTitleHeight,
                  // color: colors.randColor,
                  child: Text(
                    '${leftTitleContents[index]}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ));
            }),
          ),
        ),
      ),
    );
  }

  Widget _datas() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        ///必须在最前面
        XBLineChartDayGap =
            (constraints.maxWidth - XBLineChartDatasExtensionSpace * 2) /
                (widget.pointCountPerPage - 1);
        _maxDataWidth = constraints.maxWidth;
        // print("maxWidth:${constraints.maxWidth}");

        final double h = max(_painterHeight, constraints.maxHeight);
        final double w = max(_painterWidth, constraints.maxWidth);

        return Stack(
          children: [
            Container(
              // color: Colors.blue.withAlpha(10),
              child: SingleChildScrollView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: Container(
                  // color: Colors.blue.withAlpha(10),
                  width: w,
                  height: h,
                  child: XBLineChartData(
                    leftTitleCount: widget.leftTitleCount,
                    beginDate: widget.beginDate,
                    models: widget.models,
                    valueRangeMax: leftTitleContents.first,
                    valueRangeMin: leftTitleContents.last,
                    valueLineCount: leftTitleContents.length,
                    painterWidth: w,
                    painterHeight: h,
                    onHover: (int? hoverIndex, double dx) {
                      // print("globalDx:$dx,hoverIndex:$hoverIndex");
                      _hoverIndex = hoverIndex;
                      setState(() {
                        _hoverDx = dx - _controller.offset;
                      });
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _hoverIndex != null,
              child: Positioned(
                top: 0,
                left: _hoverLeft,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // print("constraints.maxWidth:${constraints.maxWidth}");
                    return widget.hoverBuilder(
                        _hoverIndex, _hoverDx, constraints.maxHeight);
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  double get _hoverLeft {
    double padding = 0;
    final hoverWidth = widget.hoverWidth(_hoverIndex, _hoverDx);
    double ret = _hoverDx - hoverWidth * 0.5;
    if (ret < padding) {
      ret = padding;
    }
    if (ret + hoverWidth + padding > _maxDataWidth) {
      ret = _maxDataWidth - hoverWidth - padding;
    }
    return ret;
  }

  Widget _names() {
    if (widget.needNames == false) return Container();
    if (widget.namesLayout == XBLineChartNameLayout.wrap) {
      /// 换行显示
      return Padding(
        padding: EdgeInsets.only(left: widget.namesPaddingLeft ?? 0),
        child: Container(
          // alignment: Alignment.centerLeft,
          // color: Colors.blue,
          child: Container(
            // color: Colors.amber,
            // height: 30,
            alignment: Alignment.centerLeft,
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(widget.models.length, (index) {
                final model = widget.models[index];
                return Padding(
                  padding: EdgeInsets.only(
                      right: index == widget.models.length - 1 ? 0 : 10,
                      left: 5,
                      bottom: 5),
                  child: XBLineChartNameWidget(
                    color: model.color,
                    name: model.name,
                  ),
                );
              }),
            ),
          ),
        ),
      );
    } else {
      /// 横向滑动
      return Container(
        alignment: Alignment.centerLeft,
        // color: Colors.blue,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            // color: Colors.amber,
            height: 30,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(widget.models.length, (index) {
                final model = widget.models[index];
                return Padding(
                  padding: EdgeInsets.only(
                      right: index == widget.models.length - 1 ? 0 : 10,
                      left: 5),
                  child: XBLineChartNameWidget(
                    color: model.color,
                    name: model.name,
                  ),
                );
              }),
            ),
          ),
        ),
      );
    }
  }
}
