/// Keys of user preferences in the settings table.
library;

import '../core/widget_summary.dart' show gentle;

/// "day" (default) or "week": daily target or weekly budget.
const budgetModeKey = 'budgetMode';

/// "true": show progress without calorie numbers (diary and dashboard).
const hideNumbersKey = 'hideNumbers';

/// Text used instead of numbers when [hideNumbersKey] is on.
String gentleStatus(double progress) => gentle(progress);

/// "false": do not ask Open Food Facts while typing in the food search (default: on).
const offLiveSearchKey = 'offLiveSearch';

/// Live search is on unless the user switched it off.
bool offLiveSearchEnabled(String? value) => value != 'false';
