import 'dart:io' show Platform;

import 'package:health/health.dart';

import '../core/dates.dart';
import '../core/health_export.dart';
import '../core/health_import.dart';

enum HealthAvailability {
  /// Health Connect is usable.
  available,

  /// The Health Connect app has to be installed or updated (Android 9–13).
  needsInstall,

  /// Not possible here (Windows, work profile, old Android).
  unavailable,
}

/// Access to the device's health data. Replaceable in tests ([healthSourceFactory]).
abstract class HealthSource {
  Future<HealthAvailability> availability();
  Future<void> install();
  Future<bool> hasPermissions();
  Future<bool> requestPermissions();
  Future<HealthRead> read(DateTime from, DateTime to);

  /// Writing meals needs its own permission, asked only when the user switches it on.
  Future<bool> hasWritePermission();
  Future<bool> requestWritePermission();

  /// Replaces what this app wrote for [day] (yyyy-MM-dd) with [meals].
  Future<void> writeDay(String day, List<HealthMeal> meals);
}

/// Types the app reads.
const healthReadTypes = [
  HealthDataType.STEPS,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.WORKOUT,
  HealthDataType.WEIGHT,
];

/// Health Connect on Android through the `health` plugin.
class HealthConnectSource implements HealthSource {
  final _health = Health();
  bool _configured = false;

  Future<void> _ready() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  @override
  Future<HealthAvailability> availability() async {
    if (!Platform.isAndroid) return HealthAvailability.unavailable;
    await _ready();
    return switch (await _health.getHealthConnectSdkStatus()) {
      HealthConnectSdkStatus.sdkAvailable => HealthAvailability.available,
      HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired => HealthAvailability.needsInstall,
      _ => HealthAvailability.unavailable,
    };
  }

  @override
  Future<void> install() => _health.installHealthConnect();

  @override
  Future<bool> hasPermissions() async {
    await _ready();
    return await _health.hasPermissions(healthReadTypes) ?? false;
  }

  @override
  Future<bool> requestPermissions() async {
    await _ready();
    return _health.requestAuthorization(healthReadTypes);
  }

  static const _write = [HealthDataType.NUTRITION];
  static const _writeAccess = [HealthDataAccess.WRITE];

  @override
  Future<bool> hasWritePermission() async {
    await _ready();
    return await _health.hasPermissions(_write, permissions: _writeAccess) ?? false;
  }

  @override
  Future<bool> requestWritePermission() async {
    await _ready();
    return _health.requestAuthorization(_write, permissions: _writeAccess);
  }

  @override
  Future<void> writeDay(String day, List<HealthMeal> meals) async {
    await _ready();
    final d = DateTime.parse(day);
    // Health Connect only lets an app delete its own records, so this never touches other apps' data.
    await _health.delete(
      type: HealthDataType.NUTRITION,
      startTime: d,
      endTime: DateTime(d.year, d.month, d.day + 1).subtract(const Duration(seconds: 1)),
    );
    for (final m in meals) {
      final n = m.nutrients;
      await _health.writeMeal(
        mealType: switch (m.kind) {
          MealKind.breakfast => MealType.BREAKFAST,
          MealKind.lunch => MealType.LUNCH,
          MealKind.dinner => MealType.DINNER,
          MealKind.snack => MealType.SNACK,
        },
        startTime: m.start,
        endTime: m.end,
        clientRecordId: m.clientId,
        name: m.name,
        caloriesConsumed: n.kcal,
        protein: n.protein,
        carbohydrates: n.carbs,
        sugar: n.sugar,
        fatTotal: n.fat,
        fatSaturated: n.saturatedFat,
        fiber: n.fiber,
        sodium: n.salt / 2.5, // salt → sodium (g)
        recordingMethod: RecordingMethod.manual,
      );
    }
  }

  @override
  Future<HealthRead> read(DateTime from, DateTime to) async {
    await _ready();
    final steps = <String, int>{};
    for (var d = DateTime(from.year, from.month, from.day); !d.isAfter(to); d = DateTime(d.year, d.month, d.day + 1)) {
      final end = DateTime(d.year, d.month, d.day + 1);
      steps[dayKey(d)] = await _health.getTotalStepsInInterval(d, end.isAfter(to) ? to : end);
    }
    final points = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.ACTIVE_ENERGY_BURNED, HealthDataType.WORKOUT, HealthDataType.WEIGHT],
      startTime: from,
      endTime: to,
    );
    final active = <HealthValueSample>[];
    final weights = <HealthValueSample>[];
    final workouts = <HealthWorkout>[];
    for (final p in points) {
      final v = p.value;
      switch (p.type) {
        case HealthDataType.ACTIVE_ENERGY_BURNED when v is NumericHealthValue:
          active.add(HealthValueSample(p.dateFrom, p.dateTo, v.numericValue.toDouble()));
        case HealthDataType.WEIGHT when v is NumericHealthValue:
          weights.add(HealthValueSample(p.dateFrom, p.dateTo, v.numericValue.toDouble()));
        case HealthDataType.WORKOUT when v is WorkoutHealthValue:
          workouts.add(
            HealthWorkout(
              id: p.uuid,
              type: v.workoutActivityType.name,
              start: p.dateFrom,
              end: p.dateTo,
              kcal: v.totalEnergyBurned?.toDouble(),
              sourceName: p.sourceName,
            ),
          );
        default:
          break;
      }
    }
    return HealthRead(stepsByDay: steps, activeKcal: active, workouts: workouts, weights: weights);
  }
}

HealthSource Function() healthSourceFactory = HealthConnectSource.new;
