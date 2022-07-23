import 'package:flutter/material.dart';

class TabControllerHandler extends InheritedWidget {
  final TabController tabController;

  TabControllerHandler({
    required this.tabController,
    required Widget child,
  }) : super(child: child);

  static TabControllerHandler? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabControllerHandler>();
  }

  @override
  bool updateShouldNotify(TabControllerHandler oldWidget) {
    return oldWidget.tabController != tabController;
  }
}
