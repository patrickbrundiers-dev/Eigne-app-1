import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:home_widget/home_widget.dart';

import '../core/dates.dart';
import '../core/day_budget.dart';
import '../core/nutrition.dart';
import '../core/week_budget.dart';
import '../core/widget_summary.dart';
import '../ui/widgets.dart' show combineLatest;
import 'database.dart';
import 'display_prefs.dart';
import 'targets.dart';

/// Hands the summary to the home screen widget. Replaceable in tests ([homeWidgetBridgeFactory]).
abstract class HomeWidgetBridge {
  Future<void> push(WidgetSummary s);
}

class NoHomeWidget implements HomeWidgetBridge {
  @override
  Future<void> push(WidgetSummary s) async {}
}

/// Android widget `SattlyWidgetProvider` (android/app/src/main/kotlin/…).
class AndroidHomeWidget implements HomeWidgetBridge {
  @override
  Future<void> push(WidgetSummary s) async {
    await HomeWidget.saveWidgetData<String>('day', s.day);
    await HomeWidget.saveWidgetData<String>('headline', s.headline);
    await HomeWidget.saveWidgetData<String>('detail', s.detail);
    await HomeWidget.saveWidgetData<int>('percent', s.percent);
    await HomeWidget.updateWidget(androidName: 'SattlyWidgetProvider');
  }
}

HomeWidgetBridge Function() homeWidgetBridgeFactory = () => Platform.isAndroid ? AndroidHomeWidget() : NoHomeWidget();

/// The widget text for today, recomputed whenever diary, activity, profile or settings change.
Stream<WidgetSummary> watchWidgetSummary(AppDatabase db, {DateTime? now}) {
  final t = now ?? DateTime.now();
  final day = dayKey(t);
  final monday = mondayOf(t);
  final yesterday = DateTime(t.year, t.month, t.day - 1);
  return combineLatest([
    db.watchProfile(),
    db.watchWeights(),
    db.watchDailyTotals(day, day),
    db.watchActivities(day),
    db.watchSetting(budgetModeKey),
    db.watchSetting(hideNumbersKey),
    db.watchDailyTotals(dayKey(monday), dayKey(yesterday)),
  ]).where((v) => v[0] != null).map((v) {
    final profile = v[0] as Profile;
    final targets = targetsFor(profile, v[1] as List<WeightEntry>, today: t);
    final eaten = (v[2] as Map<String, Nutrients>)[day] ?? Nutrients.zero;
    final weekTotals = v[6] as Map<String, Nutrients>;
    var target = targets.targetKcal;
    if (v[4] == 'week') {
      target = weekBudget(
        today: t,
        dailyTargetKcal: targets.targetKcal,
        consumedByDay: {for (final e in weekTotals.entries) parseDayKey(e.key): e.value.kcal},
        floorKcal: profile.sex == 'female' ? 1200 : 1500,
      ).todayTargetKcal;
    }
    final budget = dayBudget(
      targetKcal: target,
      consumed: eaten,
      activities: [
        for (final a in v[3] as List<ActivityEntry>)
          ActivityItem(kcal: a.kcal, source: a.source, externalId: a.externalId, id: a.id),
      ],
      creditPercent: profile.activityCreditPercent,
    );
    return widgetSummary(
      day: day,
      budgetKcal: budget.budgetKcal,
      eatenKcal: eaten.kcal,
      proteinG: eaten.protein,
      proteinTargetG: targets.proteinG,
      hideNumbers: v[5] == 'true',
    );
  });
}

/// Keeps the widget current while the app runs; restarts after midnight. Errors are only logged.
StreamSubscription<void> startHomeWidgetSync(AppDatabase db, {HomeWidgetBridge? bridge}) {
  final b = bridge ?? homeWidgetBridgeFactory();
  final out = StreamController<void>();
  StreamSubscription<WidgetSummary>? sub;
  WidgetSummary? last;
  String? subscribedDay;
  void subscribe() {
    subscribedDay = todayDayKey();
    sub?.cancel();
    sub = watchWidgetSummary(db).listen((s) async {
      if (s == last) return;
      last = s;
      try {
        await b.push(s);
      } catch (e) {
        debugPrint('Widget konnte nicht aktualisiert werden: $e');
      }
    });
  }

  if (b is NoHomeWidget) return out.stream.listen((_) {});
  subscribe();
  final timer = Timer.periodic(const Duration(minutes: 5), (_) {
    if (todayDayKey() != subscribedDay) subscribe();
  });
  out.onCancel = () async {
    timer.cancel();
    await sub?.cancel();
  };
  return out.stream.listen((_) {});
}
