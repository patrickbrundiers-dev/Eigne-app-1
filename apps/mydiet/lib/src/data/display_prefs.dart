/// Keys of user preferences in the settings table.
library;

/// "day" (default) or "week": daily target or weekly budget.
const budgetModeKey = 'budgetMode';

/// "true": show progress without calorie numbers (diary and dashboard).
const hideNumbersKey = 'hideNumbers';

/// Text used instead of numbers when [hideNumbersKey] is on.
String gentleStatus(double progress) {
  if (progress <= 0) return 'Noch nichts eingetragen';
  if (progress < 0.85) return 'Gut im Rahmen';
  if (progress <= 1.05) return 'Ziel erreicht';
  return 'Etwas über dem Ziel, kein Problem';
}
