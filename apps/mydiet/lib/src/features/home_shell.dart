import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../app.dart';
import '../branding.dart';
import '../core/meal_time.dart';
import '../data/targets.dart' show todayDayKey;
import 'diary/food_picker_page.dart';

import 'dashboard/dashboard_page.dart';
import 'dashboard/quick_log_sheet.dart';
import '../ui/design/tokens.dart';
import 'diary/diary_page.dart';
import 'foods/food_hub_page.dart';
import 'profile/profile_page.dart';
import '../data/health_sync.dart';
import '../data/home_widget_sync.dart';
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
    if (_reminders == null) unawaited(autoImportHealth(context.db));
    _reminders ??= startReminderSync(context.db);
    _widget ??= startHomeWidgetSync(context.db, onAddFood: () => mounted ? addNow() : null);
  }

  StreamSubscription<void>? _widget;

  @override
  void dispose() {
    _reminders?.cancel();
    _widget?.cancel();
    super.dispose();
  }

  /// Bereiche in fester Reihenfolge (Index = Seite, Strg+1 … 5).
  static const _dest = [
    (Icons.space_dashboard_outlined, Icons.space_dashboard, 'Heute'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Tagebuch'),
    (Icons.insights_outlined, Icons.insights, 'Fortschritt'),
    (Icons.restaurant_outlined, Icons.restaurant, 'Essen'),
    (Icons.person_outline, Icons.person, 'Profil'),
  ];

  /// Handy-Leiste (Design 2): Heute · Tagebuch · Plus · Fortschritt · Essen. Profil über den Avatar oben auf „Heute“.
  static const _phoneTabs = [0, 1, -1, 2, 3];

  /// Zentrales „Eintragen“: Mahlzeit und Weg wählen (Suchen, Barcode, Text, Nur kcal, Gewicht).
  void openLog() => showQuickLogSheet(context);

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
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Column(
                  children: [
                    Tooltip(
                      message: appName,
                      child: Image.asset(appLogoAsset, width: 40, height: 40, semanticLabel: appName),
                    ),
                    const SizedBox(height: 16),
                    FloatingActionButton(
                      heroTag: 'shell-log',
                      tooltip: 'Eintragen (Strg+E)',
                      onPressed: openLog,
                      child: const Icon(Icons.add, size: 28),
                    ),
                  ],
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
            VerticalDivider(width: 1, color: Theme.of(context).dividerColor),
            Expanded(child: body),
          ],
        ),
      );
    }
    return Scaffold(
      body: body,
      bottomNavigationBar: _BottomBar(index: _index, onSelect: go, onLog: openLog),
    );
  }
}

/// Untere Leiste auf dem Handy mit erhöhter Plus-Taste in der Mitte.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onSelect, required this.onLog});
  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final tk = context.tokens;
    return Material(
      color: tk.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: tk.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 68,
            child: Row(
              children: [
                for (final i in HomeShellState._phoneTabs)
                  Expanded(
                    child: i < 0
                        ? Center(
                            child: Semantics(
                              button: true,
                              label: 'Eintragen',
                              excludeSemantics: true,
                              child: Tooltip(
                                message: 'Eintragen',
                                child: Material(
                                  color: tk.primary,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(SattlyRadius.fab)),
                                  ),
                                  child: InkWell(
                                    key: const Key('nav-log'),
                                    customBorder: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(SattlyRadius.fab)),
                                    ),
                                    onTap: onLog,
                                    child: SizedBox(
                                      width: 56,
                                      height: 48,
                                      child: Icon(Icons.add, size: 30, color: tk.onPrimary),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : _NavItem(
                            icon: index == i ? HomeShellState._dest[i].$2 : HomeShellState._dest[i].$1,
                            label: HomeShellState._dest[i].$3,
                            selected: index == i,
                            onTap: () => onSelect(i),
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tk = context.tokens;
    final color = selected ? tk.ink : tk.muted;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 52,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? tk.primarySoft : Colors.transparent,
                borderRadius: BorderRadius.circular(SattlyRadius.control),
              ),
              child: Icon(icon, size: 24, color: selected ? tk.primaryInk : tk.muted),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                fontFamily: SattlyFonts.body,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown with F1 or Strg+/ (and from the keyboard button in the side navigation).
const shortcutHelp = [
  ('Strg+E', 'Eintragen: Lebensmittel für die aktuelle Mahlzeit suchen'),
  ('Strg+1 … 5', 'Heute, Tagebuch, Fortschritt, Essen, Profil'),
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
