import 'package:flutter/material.dart';

import 'destinations.dart';

/// Layout breakpoints (logical pixels), following Material 3 window size classes.
class Breakpoints {
  static const double medium = 600;
  static const double expanded = 1200;
}

enum ShellLayout { compact, medium, expanded }

ShellLayout layoutForWidth(double width) {
  if (width < Breakpoints.medium) return ShellLayout.compact;
  if (width < Breakpoints.expanded) return ShellLayout.medium;
  return ShellLayout.expanded;
}

/// Responsive navigation shell:
/// - compact (phones): bottom [NavigationBar]
/// - medium (tablets, small windows): [NavigationRail]
/// - expanded (desktop): extended [NavigationRail] with labels
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final layout = layoutForWidth(MediaQuery.sizeOf(context).width);
    final current = appDestinations[_index];
    // Keep each section's state (scroll position etc.) when switching.
    final body = IndexedStack(
      index: _index,
      children: [for (final d in appDestinations) Builder(builder: d.builder)],
    );

    if (layout == ShellLayout.compact) {
      return Scaffold(
        appBar: AppBar(title: Text(current.label)),
        body: body,
        bottomNavigationBar: NavigationBar(
          key: const Key('shell.navigationBar'),
          selectedIndex: _index,
          onDestinationSelected: _select,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            for (final d in appDestinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final extended = layout == ShellLayout.expanded;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              key: const Key('shell.navigationRail'),
              extended: extended,
              selectedIndex: _index,
              onDestinationSelected: _select,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: extended
                    ? Text('Paperless AI',
                        style: Theme.of(context).textTheme.titleLarge)
                    : const Icon(Icons.description_outlined, size: 32),
              ),
              destinations: [
                for (final d in appDestinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
