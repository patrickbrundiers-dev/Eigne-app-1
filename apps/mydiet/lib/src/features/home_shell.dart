import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../app.dart';
import '../branding.dart';
import '../core/meal_time.dart';
import '../data/targets.dart' show todayDayKey;
import 'diary/food_picker_page.dart';

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

  int get index => _index;

  void go(int i) => setState(() => _index = i);

  final _navs = <DateNav>[];

  /// Pages with a date (diary, weekly plan) register here for Alt+←/→ and Alt+Pos1.
  void addDateNav(DateNav n) => _navs.add(n);
  void removeDateNav(DateNav n) => _navs.remove(n);

  void _nav(void Function(DateNav n) f) {
    for (final n in _navs) {
      if (n.isActive()) return f(n);
    }
  }

  /// Strg+E: food search for the meal that is due now, today.
  Future<void> addNow() async {
    final db = context.db;
    final slots = await db.watchMealSlots().first;
    if (slots.isEmpty || !mounted) return;
    final now = DateTime.now();
    final i = currentMealIndex([for (final s in slots) s.minuteOfDay], now.hour * 60 + now.minute);
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => FoodPickerPage(day: todayDayKey(), mealSlotId: slots[i].id, slots: slots),
      ),
    );
  }

  void showShortcuts() => showDialog<void>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Tastenkürzel'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (k, what) in shortcutHelp)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 110,
                  child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                title: Text(what),
              ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Schließen'))],
    ),
  );

  Map<ShortcutActivator, VoidCallback> get _shortcuts => {
    for (var i = 0; i < _dest.length; i++)
      SingleActivator(LogicalKeyboardKey(LogicalKeyboardKey.digit1.keyId + i), control: true): () => go(i),
    const SingleActivator(LogicalKeyboardKey.keyE, control: true): addNow,
    const SingleActivator(LogicalKeyboardKey.keyN, control: true): addNow,
    const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true): () => _nav((n) => n.shift(-1)),
    const SingleActivator(LogicalKeyboardKey.arrowRight, alt: true): () => _nav((n) => n.shift(1)),
    const SingleActivator(LogicalKeyboardKey.home, alt: true): () => _nav((n) => n.today()),
    const SingleActivator(LogicalKeyboardKey.f1): showShortcuts,
    const SingleActivator(LogicalKeyboardKey.slash, control: true): showShortcuts,
  };

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
    final body = IndexedStack(index: _index, children: pages);
    return CallbackShortcuts(
      bindings: _shortcuts,
      child: Focus(autofocus: true, child: _layout(context, body)),
    );
  }

  Widget _layout(BuildContext context, Widget body) {
    final wide = MediaQuery.sizeOf(context).width >= 840;
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
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: IconButton(
                      tooltip: 'Tastenkürzel (F1)',
                      icon: const Icon(Icons.keyboard_outlined),
                      onPressed: showShortcuts,
                    ),
                  ),
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

/// Shown with F1 or Strg+/ (and from the keyboard button in the side navigation).
const shortcutHelp = [
  ('Strg+E', 'Eintragen: Lebensmittel für die aktuelle Mahlzeit suchen'),
  ('Strg+1 … 5', 'Heute, Tagebuch, Gewicht, Essen, Profil'),
  ('Alt+← / →', 'Tagebuch: Tag zurück/vor · Wochenplan: Woche zurück/vor'),
  ('Alt+Pos1', 'Zurück zu heute'),
  ('Wochenplan', 'Einträge auf einen anderen Tag ziehen (mit Strg: kopieren)'),
  ('Esc', 'Dialog oder Auswahl schließen'),
  ('F1', 'Diese Übersicht'),
];

/// A page that shows a date and can step through it with the keyboard.
class DateNav {
  DateNav({required this.isActive, required this.shift, required this.today});
  final bool Function() isActive;
  final void Function(int step) shift;
  final VoidCallback today;
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
