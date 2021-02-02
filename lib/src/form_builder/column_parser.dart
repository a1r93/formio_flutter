import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:formio_flutter/formio_flutter.dart';
import 'package:formio_flutter/src/abstraction/abstraction.dart';
import 'package:formio_flutter/src/models/models.dart';
import 'package:formio_flutter/src/providers/providers.dart';

/// Extends the abstract class [WidgetParser]
class ColumnParser extends WidgetParser {
  /// Returns a [Widget] of type [Column]
  @override
  Widget parse(Component map, BuildContext context, ClickListener listener,
      WidgetProvider widgetProvider) {
    return ColumnParserWidget(
      map: map,
      listener: listener,
      widgetProvider: widgetProvider,
    );
  }

  /// [widgetName] => "columns"
  @override
  String get widgetName => "columns";
}

// ignore: must_be_immutable
class ColumnParserWidget extends StatefulWidget {
  final Component map;
  final WidgetProvider widgetProvider;
  List<Widget> widgets = [];
  ClickListener listener;

  ColumnParserWidget({
    this.map,
    this.listener,
    this.widgetProvider,
  });

  @override
  _ColumnParserWidgetState createState() => _ColumnParserWidgetState();
}

class _ColumnParserWidgetState extends State<ColumnParserWidget> {
  Future<List<Widget>> _widgets;

  @override
  Widget build(BuildContext context) {
    bool isVisible = true;
    _widgets ??= _buildWidget(context);
    return StreamBuilder(
      stream: widget.widgetProvider.widgetBloc.widgetsStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        isVisible = (widget.map.conditional != null && snapshot.data != null)
            ? (snapshot.data.containsKey(widget.map.conditional.when) &&
                    snapshot.data[widget.map.conditional.when].toString() ==
                        widget.map.conditional.eq)
                ? widget.map.conditional.show
                : !widget.map.conditional.show
            : true;
        return (!isVisible)
            ? SizedBox.shrink()
            : Neumorphic(
                child: Container(
                  //height: 200,
                  decoration: BoxDecoration(
                    color: widget.map.background,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: FutureBuilder<List<Widget>>(
                      future: _widgets,
                      builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return (snapshot.hasData)
                                ? Flex(
                                    mainAxisSize: MainAxisSize.min,
                                    direction: Axis.vertical,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: snapshot.data,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                            break;
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                            break;
                          case ConnectionState.none:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                        }
                      },
                    ),
                  ),
                ),
              );
      },
    );
  }

  /// Returns a [List<Widget>] contained in [Component.map.columns] and [Component.map.component]
  Future<List<Widget>> _buildWidget(BuildContext context) async {
    widget.map.columns.asMap().forEach(
      (key, value) {
        value.component.asMap().forEach(
          (key, ss) {
            ss.total = widget.map.columns.length;
            widget.widgets.add(
              Flexible(
                fit: FlexFit.loose,
                child: WidgetParserBuilder.build(
                  ss,
                  context,
                  widget.listener,
                  widget.widgetProvider,
                ),
              ),
            );
          },
        );
      },
    );
    return widget.widgets;
  }
}
