import 'package:material_ui/material_ui.dart';

import 'dart:async';

import '../app.dart';
import '../branding.dart';

import 'dashboard/dashboard_page.dart';
import 'diary/diary_page.dart';
import 'foods/food_hub_page.dart';
import 'profile/profile_page.dart';
import 'settings/reminders_page.dart';
import 'weight/weight_page.dart';

/// Navigation: bottom bar on phones, navigation rail from 840 px width.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  int _index = 0;

  static HomeShellState? of(BuildContext context) => context.findAncestorStateOfType<HomeShellState>();

  void go(int i) => setState(() => _index = i);

  StreamSubscription<void>? _reminders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reminders ??= startReminderSync(context.db);
  }

  @override
  void dispose() {
    _reminders?.cancel();
    super.dispose();
  }

  static const _dest = [
    (Icons.space_dashboard_outlined, Icons.space_dashboard, 'Heute'),
    (Icons.restaurant_menu_outlined, Icons.restaurant_menu, 'Tagebuch'),
    (Icons.monitor_weight_outlined, Icons.monitor_weight, 'Gewicht'),
    (Icons.egg_alt_outlined, Icons.egg_alt, 'Essen'),
    (Icons.person_outline, Icons.person, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = const [DashboardPage(), DiaryPage(), WeightPage(), FoodHubPage(), ProfilePage()];
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final body = IndexedStack(index: _index, children: pages);
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: go,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Tooltip(
                  message: appName,
                  child: Image.asset(appLogoAsset, width: 40, height: 40, semanticLabel: appName),
                ),
              ),
              destinations: [
                for (final d in _dest)
                  NavigationRailDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: Text(d.$3)),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: go,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final d in _dest) NavigationDestination(icon: Icon(d.$1), selectedIcon: Icon(d.$2), label: d.$3),
        ],
      ),
    );
  }
}

/// Max content width for pages on large screens.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.child, this.maxWidth = 1280});
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
