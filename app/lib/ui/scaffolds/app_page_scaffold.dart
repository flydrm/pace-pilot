import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.actions = const [],
    this.showSettingsAction = true,
  });

  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget> actions;
  final bool showSettingsAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...actions,
          if (showSettingsAction)
            IconButton(
              tooltip: '设置',
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined),
            ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
