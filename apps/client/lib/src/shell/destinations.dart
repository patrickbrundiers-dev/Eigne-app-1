import 'package:flutter/material.dart';

import '../pages/dashboard_page.dart';
import '../pages/placeholder_page.dart';

/// One top-level section of the app.
class AppDestination {
  const AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final WidgetBuilder builder;
}

final List<AppDestination> appDestinations = [
  AppDestination(
    label: 'Übersicht',
    icon: Icons.space_dashboard_outlined,
    selectedIcon: Icons.space_dashboard,
    builder: (_) => const DashboardPage(),
  ),
  AppDestination(
    label: 'Posteingang',
    icon: Icons.inbox_outlined,
    selectedIcon: Icons.inbox,
    builder: (_) => const PlaceholderPage(
      icon: Icons.inbox_outlined,
      title: 'Posteingang ist leer',
      message: 'Neu importierte Dokumente landen hier, bis du sie einordnest.',
    ),
  ),
  AppDestination(
    label: 'Dokumente',
    icon: Icons.folder_outlined,
    selectedIcon: Icons.folder,
    builder: (_) => const PlaceholderPage(
      icon: Icons.folder_outlined,
      title: 'Noch keine Dokumente',
      message: 'Dein Archiv, nach Bereichen und Kategorien sortiert.',
    ),
  ),
  AppDestination(
    label: 'Fristen',
    icon: Icons.event_note_outlined,
    selectedIcon: Icons.event_note,
    builder: (_) => const PlaceholderPage(
      icon: Icons.event_note_outlined,
      title: 'Keine Fristen',
      message: 'Kündigungsfristen und Erinnerungen erscheinen hier.',
    ),
  ),
  AppDestination(
    label: 'Einstellungen',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    builder: (_) => const PlaceholderPage(
      icon: Icons.settings_outlined,
      title: 'Einstellungen',
      message: 'Familie, Bereiche, Sicherung und Synchronisierung.',
    ),
  ),
];
