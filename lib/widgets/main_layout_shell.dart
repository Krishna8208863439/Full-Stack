import 'package:flutter/material.dart';
import 'responsive/responsive_scaffold.dart';

class MainLayoutShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const MainLayoutShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: title,
      body: body,
      actions: actions,
    );
  }
}
