// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startWeightKgMeta = const VerificationMeta('startWeightKg');
  @override
  late final GeneratedColumn<double> startWeightKg = GeneratedColumn<double>(
    'start_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta('targetWeightKg');
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta('bodyFatPercent');
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta('occupation');
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobActivityMeta = const VerificationMeta('jobActivity');
  @override
  late final GeneratedColumn<String> jobActivity = GeneratedColumn<String>(
    'job_activity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sportMinutesPerWeekMeta = const VerificationMeta('sportMinutesPerWeek');
  @override
  late final GeneratedColumn<int> sportMinutesPerWeek = GeneratedColumn<int>(
    'sport_minutes_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sportNoteMeta = const VerificationMeta('sportNote');
  @override
  late final GeneratedColumn<String> sportNote = GeneratedColumn<String>(
    'sport_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta('sleepHours');
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dietStyleMeta = const VerificationMeta('dietStyle');
  @override
  late final GeneratedColumn<String> dietStyle = GeneratedColumn<String>(
    'diet_style',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eatingHabitsMeta = const VerificationMeta('eatingHabits');
  @override
  late final GeneratedColumn<String> eatingHabits = GeneratedColumn<String>(
    'eating_habits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesJsonMeta = const VerificationMeta('allergiesJson');
  @override
  late final GeneratedColumn<String> allergiesJson = GeneratedColumn<String>(
    'allergies_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _preferredFoodsJsonMeta = const VerificationMeta('preferredFoodsJson');
  @override
  late final GeneratedColumn<String> preferredFoodsJson = GeneratedColumn<String>(
    'preferred_foods_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dislikedFoodsJsonMeta = const VerificationMeta('dislikedFoodsJson');
  @override
  late final GeneratedColumn<String> dislikedFoodsJson = GeneratedColumn<String>(
    'disliked_foods_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _calorieOverrideMeta = const VerificationMeta('calorieOverride');
  @override
  late final GeneratedColumn<int> calorieOverride = GeneratedColumn<int>(
    'calorie_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinOverrideGMeta = const VerificationMeta('proteinOverrideG');
  @override
  late final GeneratedColumn<int> proteinOverrideG = GeneratedColumn<int>(
    'protein_override_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinPerKgMeta = const VerificationMeta('proteinPerKg');
  @override
  late final GeneratedColumn<double> proteinPerKg = GeneratedColumn<double>(
    'protein_per_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.8),
  );
  static const VerificationMeta _fatPercentMeta = const VerificationMeta('fatPercent');
  @override
  late final GeneratedColumn<double> fatPercent = GeneratedColumn<double>(
    'fat_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _fiberTargetGMeta = const VerificationMeta('fiberTargetG');
  @override
  late final GeneratedColumn<double> fiberTargetG = GeneratedColumn<double>(
    'fiber_target_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _waterOverrideMlMeta = const VerificationMeta('waterOverrideMl');
  @override
  late final GeneratedColumn<int> waterOverrideMl = GeneratedColumn<int>(
    'water_override_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityCreditPercentMeta = const VerificationMeta('activityCreditPercent');
  @override
  late final GeneratedColumn<int> activityCreditPercent = GeneratedColumn<int>(
    'activity_credit_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    displayName,
    sex,
    birthDate,
    heightCm,
    startWeightKg,
    targetWeightKg,
    targetDate,
    bodyFatPercent,
    occupation,
    jobActivity,
    sportMinutesPerWeek,
    sportNote,
    sleepHours,
    dietStyle,
    eatingHabits,
    allergiesJson,
    preferredFoodsJson,
    dislikedFoodsJson,
    calorieOverride,
    proteinOverrideG,
    proteinPerKg,
    fatPercent,
    fiberTargetG,
    waterOverrideMl,
    activityCreditPercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('sex')) {
      context.handle(_sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(_birthDateMeta, birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta));
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta, heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('start_weight_kg')) {
      context.handle(
        _startWeightKgMeta,
        startWeightKg.isAcceptableOrUnknown(data['start_weight_kg']!, _startWeightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_startWeightKgMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(data['target_weight_kg']!, _targetWeightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_targetWeightKgMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(_targetDateMeta, targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(data['body_fat_percent']!, _bodyFatPercentMeta),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(_occupationMeta, occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta));
    }
    if (data.containsKey('job_activity')) {
      context.handle(_jobActivityMeta, jobActivity.isAcceptableOrUnknown(data['job_activity']!, _jobActivityMeta));
    } else if (isInserting) {
      context.missing(_jobActivityMeta);
    }
    if (data.containsKey('sport_minutes_per_week')) {
      context.handle(
        _sportMinutesPerWeekMeta,
        sportMinutesPerWeek.isAcceptableOrUnknown(data['sport_minutes_per_week']!, _sportMinutesPerWeekMeta),
      );
    }
    if (data.containsKey('sport_note')) {
      context.handle(_sportNoteMeta, sportNote.isAcceptableOrUnknown(data['sport_note']!, _sportNoteMeta));
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(_sleepHoursMeta, sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta));
    }
    if (data.containsKey('diet_style')) {
      context.handle(_dietStyleMeta, dietStyle.isAcceptableOrUnknown(data['diet_style']!, _dietStyleMeta));
    }
    if (data.containsKey('eating_habits')) {
      context.handle(_eatingHabitsMeta, eatingHabits.isAcceptableOrUnknown(data['eating_habits']!, _eatingHabitsMeta));
    }
    if (data.containsKey('allergies_json')) {
      context.handle(
        _allergiesJsonMeta,
        allergiesJson.isAcceptableOrUnknown(data['allergies_json']!, _allergiesJsonMeta),
      );
    }
    if (data.containsKey('preferred_foods_json')) {
      context.handle(
        _preferredFoodsJsonMeta,
        preferredFoodsJson.isAcceptableOrUnknown(data['preferred_foods_json']!, _preferredFoodsJsonMeta),
      );
    }
    if (data.containsKey('disliked_foods_json')) {
      context.handle(
        _dislikedFoodsJsonMeta,
        dislikedFoodsJson.isAcceptableOrUnknown(data['disliked_foods_json']!, _dislikedFoodsJsonMeta),
      );
    }
    if (data.containsKey('calorie_override')) {
      context.handle(
        _calorieOverrideMeta,
        calorieOverride.isAcceptableOrUnknown(data['calorie_override']!, _calorieOverrideMeta),
      );
    }
    if (data.containsKey('protein_override_g')) {
      context.handle(
        _proteinOverrideGMeta,
        proteinOverrideG.isAcceptableOrUnknown(data['protein_override_g']!, _proteinOverrideGMeta),
      );
    }
    if (data.containsKey('protein_per_kg')) {
      context.handle(_proteinPerKgMeta, proteinPerKg.isAcceptableOrUnknown(data['protein_per_kg']!, _proteinPerKgMeta));
    }
    if (data.containsKey('fat_percent')) {
      context.handle(_fatPercentMeta, fatPercent.isAcceptableOrUnknown(data['fat_percent']!, _fatPercentMeta));
    }
    if (data.containsKey('fiber_target_g')) {
      context.handle(_fiberTargetGMeta, fiberTargetG.isAcceptableOrUnknown(data['fiber_target_g']!, _fiberTargetGMeta));
    }
    if (data.containsKey('water_override_ml')) {
      context.handle(
        _waterOverrideMlMeta,
        waterOverrideMl.isAcceptableOrUnknown(data['water_override_ml']!, _waterOverrideMlMeta),
      );
    }
    if (data.containsKey('activity_credit_percent')) {
      context.handle(
        _activityCreditPercentMeta,
        activityCreditPercent.isAcceptableOrUnknown(data['activity_credit_percent']!, _activityCreditPercentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      sex: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sex'])!,
      birthDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}birth_date'])!,
      heightCm: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}height_cm'])!,
      startWeightKg: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}start_weight_kg'])!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}target_date']),
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      ),
      occupation: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}occupation']),
      jobActivity: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}job_activity'])!,
      sportMinutesPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sport_minutes_per_week'],
      )!,
      sportNote: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sport_note']),
      sleepHours: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}sleep_hours']),
      dietStyle: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}diet_style']),
      eatingHabits: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}eating_habits']),
      allergiesJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}allergies_json'])!,
      preferredFoodsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_foods_json'],
      )!,
      dislikedFoodsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disliked_foods_json'],
      )!,
      calorieOverride: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}calorie_override']),
      proteinOverrideG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_override_g'],
      ),
      proteinPerKg: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}protein_per_kg'])!,
      fatPercent: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}fat_percent'])!,
      fiberTargetG: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}fiber_target_g'])!,
      waterOverrideMl: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}water_override_ml']),
      activityCreditPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_credit_percent'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? displayName;
  final String sex;
  final DateTime birthDate;
  final double heightCm;
  final double startWeightKg;
  final double targetWeightKg;
  final DateTime? targetDate;
  final double? bodyFatPercent;
  final String? occupation;
  final String jobActivity;
  final int sportMinutesPerWeek;
  final String? sportNote;
  final double? sleepHours;
  final String? dietStyle;
  final String? eatingHabits;
  final String allergiesJson;
  final String preferredFoodsJson;
  final String dislikedFoodsJson;
  final int? calorieOverride;
  final int? proteinOverrideG;
  final double proteinPerKg;
  final double fatPercent;
  final double fiberTargetG;
  final int? waterOverrideMl;

  /// Share (0-100 %) of logged activity calories added to the day's budget.
  final int activityCreditPercent;
  const Profile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.displayName,
    required this.sex,
    required this.birthDate,
    required this.heightCm,
    required this.startWeightKg,
    required this.targetWeightKg,
    this.targetDate,
    this.bodyFatPercent,
    this.occupation,
    required this.jobActivity,
    required this.sportMinutesPerWeek,
    this.sportNote,
    this.sleepHours,
    this.dietStyle,
    this.eatingHabits,
    required this.allergiesJson,
    required this.preferredFoodsJson,
    required this.dislikedFoodsJson,
    this.calorieOverride,
    this.proteinOverrideG,
    required this.proteinPerKg,
    required this.fatPercent,
    required this.fiberTargetG,
    this.waterOverrideMl,
    required this.activityCreditPercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['sex'] = Variable<String>(sex);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['height_cm'] = Variable<double>(heightCm);
    map['start_weight_kg'] = Variable<double>(startWeightKg);
    map['target_weight_kg'] = Variable<double>(targetWeightKg);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || bodyFatPercent != null) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent);
    }
    if (!nullToAbsent || occupation != null) {
      map['occupation'] = Variable<String>(occupation);
    }
    map['job_activity'] = Variable<String>(jobActivity);
    map['sport_minutes_per_week'] = Variable<int>(sportMinutesPerWeek);
    if (!nullToAbsent || sportNote != null) {
      map['sport_note'] = Variable<String>(sportNote);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || dietStyle != null) {
      map['diet_style'] = Variable<String>(dietStyle);
    }
    if (!nullToAbsent || eatingHabits != null) {
      map['eating_habits'] = Variable<String>(eatingHabits);
    }
    map['allergies_json'] = Variable<String>(allergiesJson);
    map['preferred_foods_json'] = Variable<String>(preferredFoodsJson);
    map['disliked_foods_json'] = Variable<String>(dislikedFoodsJson);
    if (!nullToAbsent || calorieOverride != null) {
      map['calorie_override'] = Variable<int>(calorieOverride);
    }
    if (!nullToAbsent || proteinOverrideG != null) {
      map['protein_override_g'] = Variable<int>(proteinOverrideG);
    }
    map['protein_per_kg'] = Variable<double>(proteinPerKg);
    map['fat_percent'] = Variable<double>(fatPercent);
    map['fiber_target_g'] = Variable<double>(fiberTargetG);
    if (!nullToAbsent || waterOverrideMl != null) {
      map['water_override_ml'] = Variable<int>(waterOverrideMl);
    }
    map['activity_credit_percent'] = Variable<int>(activityCreditPercent);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      displayName: displayName == null && nullToAbsent ? const Value.absent() : Value(displayName),
      sex: Value(sex),
      birthDate: Value(birthDate),
      heightCm: Value(heightCm),
      startWeightKg: Value(startWeightKg),
      targetWeightKg: Value(targetWeightKg),
      targetDate: targetDate == null && nullToAbsent ? const Value.absent() : Value(targetDate),
      bodyFatPercent: bodyFatPercent == null && nullToAbsent ? const Value.absent() : Value(bodyFatPercent),
      occupation: occupation == null && nullToAbsent ? const Value.absent() : Value(occupation),
      jobActivity: Value(jobActivity),
      sportMinutesPerWeek: Value(sportMinutesPerWeek),
      sportNote: sportNote == null && nullToAbsent ? const Value.absent() : Value(sportNote),
      sleepHours: sleepHours == null && nullToAbsent ? const Value.absent() : Value(sleepHours),
      dietStyle: dietStyle == null && nullToAbsent ? const Value.absent() : Value(dietStyle),
      eatingHabits: eatingHabits == null && nullToAbsent ? const Value.absent() : Value(eatingHabits),
      allergiesJson: Value(allergiesJson),
      preferredFoodsJson: Value(preferredFoodsJson),
      dislikedFoodsJson: Value(dislikedFoodsJson),
      calorieOverride: calorieOverride == null && nullToAbsent ? const Value.absent() : Value(calorieOverride),
      proteinOverrideG: proteinOverrideG == null && nullToAbsent ? const Value.absent() : Value(proteinOverrideG),
      proteinPerKg: Value(proteinPerKg),
      fatPercent: Value(fatPercent),
      fiberTargetG: Value(fiberTargetG),
      waterOverrideMl: waterOverrideMl == null && nullToAbsent ? const Value.absent() : Value(waterOverrideMl),
      activityCreditPercent: Value(activityCreditPercent),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      sex: serializer.fromJson<String>(json['sex']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      startWeightKg: serializer.fromJson<double>(json['startWeightKg']),
      targetWeightKg: serializer.fromJson<double>(json['targetWeightKg']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      bodyFatPercent: serializer.fromJson<double?>(json['bodyFatPercent']),
      occupation: serializer.fromJson<String?>(json['occupation']),
      jobActivity: serializer.fromJson<String>(json['jobActivity']),
      sportMinutesPerWeek: serializer.fromJson<int>(json['sportMinutesPerWeek']),
      sportNote: serializer.fromJson<String?>(json['sportNote']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      dietStyle: serializer.fromJson<String?>(json['dietStyle']),
      eatingHabits: serializer.fromJson<String?>(json['eatingHabits']),
      allergiesJson: serializer.fromJson<String>(json['allergiesJson']),
      preferredFoodsJson: serializer.fromJson<String>(json['preferredFoodsJson']),
      dislikedFoodsJson: serializer.fromJson<String>(json['dislikedFoodsJson']),
      calorieOverride: serializer.fromJson<int?>(json['calorieOverride']),
      proteinOverrideG: serializer.fromJson<int?>(json['proteinOverrideG']),
      proteinPerKg: serializer.fromJson<double>(json['proteinPerKg']),
      fatPercent: serializer.fromJson<double>(json['fatPercent']),
      fiberTargetG: serializer.fromJson<double>(json['fiberTargetG']),
      waterOverrideMl: serializer.fromJson<int?>(json['waterOverrideMl']),
      activityCreditPercent: serializer.fromJson<int>(json['activityCreditPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'displayName': serializer.toJson<String?>(displayName),
      'sex': serializer.toJson<String>(sex),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'heightCm': serializer.toJson<double>(heightCm),
      'startWeightKg': serializer.toJson<double>(startWeightKg),
      'targetWeightKg': serializer.toJson<double>(targetWeightKg),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'bodyFatPercent': serializer.toJson<double?>(bodyFatPercent),
      'occupation': serializer.toJson<String?>(occupation),
      'jobActivity': serializer.toJson<String>(jobActivity),
      'sportMinutesPerWeek': serializer.toJson<int>(sportMinutesPerWeek),
      'sportNote': serializer.toJson<String?>(sportNote),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'dietStyle': serializer.toJson<String?>(dietStyle),
      'eatingHabits': serializer.toJson<String?>(eatingHabits),
      'allergiesJson': serializer.toJson<String>(allergiesJson),
      'preferredFoodsJson': serializer.toJson<String>(preferredFoodsJson),
      'dislikedFoodsJson': serializer.toJson<String>(dislikedFoodsJson),
      'calorieOverride': serializer.toJson<int?>(calorieOverride),
      'proteinOverrideG': serializer.toJson<int?>(proteinOverrideG),
      'proteinPerKg': serializer.toJson<double>(proteinPerKg),
      'fatPercent': serializer.toJson<double>(fatPercent),
      'fiberTargetG': serializer.toJson<double>(fiberTargetG),
      'waterOverrideMl': serializer.toJson<int?>(waterOverrideMl),
      'activityCreditPercent': serializer.toJson<int>(activityCreditPercent),
    };
  }

  Profile copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    String? sex,
    DateTime? birthDate,
    double? heightCm,
    double? startWeightKg,
    double? targetWeightKg,
    Value<DateTime?> targetDate = const Value.absent(),
    Value<double?> bodyFatPercent = const Value.absent(),
    Value<String?> occupation = const Value.absent(),
    String? jobActivity,
    int? sportMinutesPerWeek,
    Value<String?> sportNote = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<String?> dietStyle = const Value.absent(),
    Value<String?> eatingHabits = const Value.absent(),
    String? allergiesJson,
    String? preferredFoodsJson,
    String? dislikedFoodsJson,
    Value<int?> calorieOverride = const Value.absent(),
    Value<int?> proteinOverrideG = const Value.absent(),
    double? proteinPerKg,
    double? fatPercent,
    double? fiberTargetG,
    Value<int?> waterOverrideMl = const Value.absent(),
    int? activityCreditPercent,
  }) => Profile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    displayName: displayName.present ? displayName.value : this.displayName,
    sex: sex ?? this.sex,
    birthDate: birthDate ?? this.birthDate,
    heightCm: heightCm ?? this.heightCm,
    startWeightKg: startWeightKg ?? this.startWeightKg,
    targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    bodyFatPercent: bodyFatPercent.present ? bodyFatPercent.value : this.bodyFatPercent,
    occupation: occupation.present ? occupation.value : this.occupation,
    jobActivity: jobActivity ?? this.jobActivity,
    sportMinutesPerWeek: sportMinutesPerWeek ?? this.sportMinutesPerWeek,
    sportNote: sportNote.present ? sportNote.value : this.sportNote,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    dietStyle: dietStyle.present ? dietStyle.value : this.dietStyle,
    eatingHabits: eatingHabits.present ? eatingHabits.value : this.eatingHabits,
    allergiesJson: allergiesJson ?? this.allergiesJson,
    preferredFoodsJson: preferredFoodsJson ?? this.preferredFoodsJson,
    dislikedFoodsJson: dislikedFoodsJson ?? this.dislikedFoodsJson,
    calorieOverride: calorieOverride.present ? calorieOverride.value : this.calorieOverride,
    proteinOverrideG: proteinOverrideG.present ? proteinOverrideG.value : this.proteinOverrideG,
    proteinPerKg: proteinPerKg ?? this.proteinPerKg,
    fatPercent: fatPercent ?? this.fatPercent,
    fiberTargetG: fiberTargetG ?? this.fiberTargetG,
    waterOverrideMl: waterOverrideMl.present ? waterOverrideMl.value : this.waterOverrideMl,
    activityCreditPercent: activityCreditPercent ?? this.activityCreditPercent,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      displayName: data.displayName.present ? data.displayName.value : this.displayName,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      startWeightKg: data.startWeightKg.present ? data.startWeightKg.value : this.startWeightKg,
      targetWeightKg: data.targetWeightKg.present ? data.targetWeightKg.value : this.targetWeightKg,
      targetDate: data.targetDate.present ? data.targetDate.value : this.targetDate,
      bodyFatPercent: data.bodyFatPercent.present ? data.bodyFatPercent.value : this.bodyFatPercent,
      occupation: data.occupation.present ? data.occupation.value : this.occupation,
      jobActivity: data.jobActivity.present ? data.jobActivity.value : this.jobActivity,
      sportMinutesPerWeek: data.sportMinutesPerWeek.present ? data.sportMinutesPerWeek.value : this.sportMinutesPerWeek,
      sportNote: data.sportNote.present ? data.sportNote.value : this.sportNote,
      sleepHours: data.sleepHours.present ? data.sleepHours.value : this.sleepHours,
      dietStyle: data.dietStyle.present ? data.dietStyle.value : this.dietStyle,
      eatingHabits: data.eatingHabits.present ? data.eatingHabits.value : this.eatingHabits,
      allergiesJson: data.allergiesJson.present ? data.allergiesJson.value : this.allergiesJson,
      preferredFoodsJson: data.preferredFoodsJson.present ? data.preferredFoodsJson.value : this.preferredFoodsJson,
      dislikedFoodsJson: data.dislikedFoodsJson.present ? data.dislikedFoodsJson.value : this.dislikedFoodsJson,
      calorieOverride: data.calorieOverride.present ? data.calorieOverride.value : this.calorieOverride,
      proteinOverrideG: data.proteinOverrideG.present ? data.proteinOverrideG.value : this.proteinOverrideG,
      proteinPerKg: data.proteinPerKg.present ? data.proteinPerKg.value : this.proteinPerKg,
      fatPercent: data.fatPercent.present ? data.fatPercent.value : this.fatPercent,
      fiberTargetG: data.fiberTargetG.present ? data.fiberTargetG.value : this.fiberTargetG,
      waterOverrideMl: data.waterOverrideMl.present ? data.waterOverrideMl.value : this.waterOverrideMl,
      activityCreditPercent: data.activityCreditPercent.present
          ? data.activityCreditPercent.value
          : this.activityCreditPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('displayName: $displayName, ')
          ..write('sex: $sex, ')
          ..write('birthDate: $birthDate, ')
          ..write('heightCm: $heightCm, ')
          ..write('startWeightKg: $startWeightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('targetDate: $targetDate, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('occupation: $occupation, ')
          ..write('jobActivity: $jobActivity, ')
          ..write('sportMinutesPerWeek: $sportMinutesPerWeek, ')
          ..write('sportNote: $sportNote, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('dietStyle: $dietStyle, ')
          ..write('eatingHabits: $eatingHabits, ')
          ..write('allergiesJson: $allergiesJson, ')
          ..write('preferredFoodsJson: $preferredFoodsJson, ')
          ..write('dislikedFoodsJson: $dislikedFoodsJson, ')
          ..write('calorieOverride: $calorieOverride, ')
          ..write('proteinOverrideG: $proteinOverrideG, ')
          ..write('proteinPerKg: $proteinPerKg, ')
          ..write('fatPercent: $fatPercent, ')
          ..write('fiberTargetG: $fiberTargetG, ')
          ..write('waterOverrideMl: $waterOverrideMl, ')
          ..write('activityCreditPercent: $activityCreditPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    displayName,
    sex,
    birthDate,
    heightCm,
    startWeightKg,
    targetWeightKg,
    targetDate,
    bodyFatPercent,
    occupation,
    jobActivity,
    sportMinutesPerWeek,
    sportNote,
    sleepHours,
    dietStyle,
    eatingHabits,
    allergiesJson,
    preferredFoodsJson,
    dislikedFoodsJson,
    calorieOverride,
    proteinOverrideG,
    proteinPerKg,
    fatPercent,
    fiberTargetG,
    waterOverrideMl,
    activityCreditPercent,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.displayName == this.displayName &&
          other.sex == this.sex &&
          other.birthDate == this.birthDate &&
          other.heightCm == this.heightCm &&
          other.startWeightKg == this.startWeightKg &&
          other.targetWeightKg == this.targetWeightKg &&
          other.targetDate == this.targetDate &&
          other.bodyFatPercent == this.bodyFatPercent &&
          other.occupation == this.occupation &&
          other.jobActivity == this.jobActivity &&
          other.sportMinutesPerWeek == this.sportMinutesPerWeek &&
          other.sportNote == this.sportNote &&
          other.sleepHours == this.sleepHours &&
          other.dietStyle == this.dietStyle &&
          other.eatingHabits == this.eatingHabits &&
          other.allergiesJson == this.allergiesJson &&
          other.preferredFoodsJson == this.preferredFoodsJson &&
          other.dislikedFoodsJson == this.dislikedFoodsJson &&
          other.calorieOverride == this.calorieOverride &&
          other.proteinOverrideG == this.proteinOverrideG &&
          other.proteinPerKg == this.proteinPerKg &&
          other.fatPercent == this.fatPercent &&
          other.fiberTargetG == this.fiberTargetG &&
          other.waterOverrideMl == this.waterOverrideMl &&
          other.activityCreditPercent == this.activityCreditPercent);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String?> displayName;
  final Value<String> sex;
  final Value<DateTime> birthDate;
  final Value<double> heightCm;
  final Value<double> startWeightKg;
  final Value<double> targetWeightKg;
  final Value<DateTime?> targetDate;
  final Value<double?> bodyFatPercent;
  final Value<String?> occupation;
  final Value<String> jobActivity;
  final Value<int> sportMinutesPerWeek;
  final Value<String?> sportNote;
  final Value<double?> sleepHours;
  final Value<String?> dietStyle;
  final Value<String?> eatingHabits;
  final Value<String> allergiesJson;
  final Value<String> preferredFoodsJson;
  final Value<String> dislikedFoodsJson;
  final Value<int?> calorieOverride;
  final Value<int?> proteinOverrideG;
  final Value<double> proteinPerKg;
  final Value<double> fatPercent;
  final Value<double> fiberTargetG;
  final Value<int?> waterOverrideMl;
  final Value<int> activityCreditPercent;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.displayName = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.startWeightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.occupation = const Value.absent(),
    this.jobActivity = const Value.absent(),
    this.sportMinutesPerWeek = const Value.absent(),
    this.sportNote = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.dietStyle = const Value.absent(),
    this.eatingHabits = const Value.absent(),
    this.allergiesJson = const Value.absent(),
    this.preferredFoodsJson = const Value.absent(),
    this.dislikedFoodsJson = const Value.absent(),
    this.calorieOverride = const Value.absent(),
    this.proteinOverrideG = const Value.absent(),
    this.proteinPerKg = const Value.absent(),
    this.fatPercent = const Value.absent(),
    this.fiberTargetG = const Value.absent(),
    this.waterOverrideMl = const Value.absent(),
    this.activityCreditPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.displayName = const Value.absent(),
    required String sex,
    required DateTime birthDate,
    required double heightCm,
    required double startWeightKg,
    required double targetWeightKg,
    this.targetDate = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.occupation = const Value.absent(),
    required String jobActivity,
    this.sportMinutesPerWeek = const Value.absent(),
    this.sportNote = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.dietStyle = const Value.absent(),
    this.eatingHabits = const Value.absent(),
    this.allergiesJson = const Value.absent(),
    this.preferredFoodsJson = const Value.absent(),
    this.dislikedFoodsJson = const Value.absent(),
    this.calorieOverride = const Value.absent(),
    this.proteinOverrideG = const Value.absent(),
    this.proteinPerKg = const Value.absent(),
    this.fatPercent = const Value.absent(),
    this.fiberTargetG = const Value.absent(),
    this.waterOverrideMl = const Value.absent(),
    this.activityCreditPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sex = Value(sex),
       birthDate = Value(birthDate),
       heightCm = Value(heightCm),
       startWeightKg = Value(startWeightKg),
       targetWeightKg = Value(targetWeightKg),
       jobActivity = Value(jobActivity);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? displayName,
    Expression<String>? sex,
    Expression<DateTime>? birthDate,
    Expression<double>? heightCm,
    Expression<double>? startWeightKg,
    Expression<double>? targetWeightKg,
    Expression<DateTime>? targetDate,
    Expression<double>? bodyFatPercent,
    Expression<String>? occupation,
    Expression<String>? jobActivity,
    Expression<int>? sportMinutesPerWeek,
    Expression<String>? sportNote,
    Expression<double>? sleepHours,
    Expression<String>? dietStyle,
    Expression<String>? eatingHabits,
    Expression<String>? allergiesJson,
    Expression<String>? preferredFoodsJson,
    Expression<String>? dislikedFoodsJson,
    Expression<int>? calorieOverride,
    Expression<int>? proteinOverrideG,
    Expression<double>? proteinPerKg,
    Expression<double>? fatPercent,
    Expression<double>? fiberTargetG,
    Expression<int>? waterOverrideMl,
    Expression<int>? activityCreditPercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (displayName != null) 'display_name': displayName,
      if (sex != null) 'sex': sex,
      if (birthDate != null) 'birth_date': birthDate,
      if (heightCm != null) 'height_cm': heightCm,
      if (startWeightKg != null) 'start_weight_kg': startWeightKg,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (targetDate != null) 'target_date': targetDate,
      if (bodyFatPercent != null) 'body_fat_percent': bodyFatPercent,
      if (occupation != null) 'occupation': occupation,
      if (jobActivity != null) 'job_activity': jobActivity,
      if (sportMinutesPerWeek != null) 'sport_minutes_per_week': sportMinutesPerWeek,
      if (sportNote != null) 'sport_note': sportNote,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (dietStyle != null) 'diet_style': dietStyle,
      if (eatingHabits != null) 'eating_habits': eatingHabits,
      if (allergiesJson != null) 'allergies_json': allergiesJson,
      if (preferredFoodsJson != null) 'preferred_foods_json': preferredFoodsJson,
      if (dislikedFoodsJson != null) 'disliked_foods_json': dislikedFoodsJson,
      if (calorieOverride != null) 'calorie_override': calorieOverride,
      if (proteinOverrideG != null) 'protein_override_g': proteinOverrideG,
      if (proteinPerKg != null) 'protein_per_kg': proteinPerKg,
      if (fatPercent != null) 'fat_percent': fatPercent,
      if (fiberTargetG != null) 'fiber_target_g': fiberTargetG,
      if (waterOverrideMl != null) 'water_override_ml': waterOverrideMl,
      if (activityCreditPercent != null) 'activity_credit_percent': activityCreditPercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String?>? displayName,
    Value<String>? sex,
    Value<DateTime>? birthDate,
    Value<double>? heightCm,
    Value<double>? startWeightKg,
    Value<double>? targetWeightKg,
    Value<DateTime?>? targetDate,
    Value<double?>? bodyFatPercent,
    Value<String?>? occupation,
    Value<String>? jobActivity,
    Value<int>? sportMinutesPerWeek,
    Value<String?>? sportNote,
    Value<double?>? sleepHours,
    Value<String?>? dietStyle,
    Value<String?>? eatingHabits,
    Value<String>? allergiesJson,
    Value<String>? preferredFoodsJson,
    Value<String>? dislikedFoodsJson,
    Value<int?>? calorieOverride,
    Value<int?>? proteinOverrideG,
    Value<double>? proteinPerKg,
    Value<double>? fatPercent,
    Value<double>? fiberTargetG,
    Value<int?>? waterOverrideMl,
    Value<int>? activityCreditPercent,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      displayName: displayName ?? this.displayName,
      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      startWeightKg: startWeightKg ?? this.startWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      targetDate: targetDate ?? this.targetDate,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      occupation: occupation ?? this.occupation,
      jobActivity: jobActivity ?? this.jobActivity,
      sportMinutesPerWeek: sportMinutesPerWeek ?? this.sportMinutesPerWeek,
      sportNote: sportNote ?? this.sportNote,
      sleepHours: sleepHours ?? this.sleepHours,
      dietStyle: dietStyle ?? this.dietStyle,
      eatingHabits: eatingHabits ?? this.eatingHabits,
      allergiesJson: allergiesJson ?? this.allergiesJson,
      preferredFoodsJson: preferredFoodsJson ?? this.preferredFoodsJson,
      dislikedFoodsJson: dislikedFoodsJson ?? this.dislikedFoodsJson,
      calorieOverride: calorieOverride ?? this.calorieOverride,
      proteinOverrideG: proteinOverrideG ?? this.proteinOverrideG,
      proteinPerKg: proteinPerKg ?? this.proteinPerKg,
      fatPercent: fatPercent ?? this.fatPercent,
      fiberTargetG: fiberTargetG ?? this.fiberTargetG,
      waterOverrideMl: waterOverrideMl ?? this.waterOverrideMl,
      activityCreditPercent: activityCreditPercent ?? this.activityCreditPercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (startWeightKg.present) {
      map['start_weight_kg'] = Variable<double>(startWeightKg.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (bodyFatPercent.present) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent.value);
    }
    if (occupation.present) {
      map['occupation'] = Variable<String>(occupation.value);
    }
    if (jobActivity.present) {
      map['job_activity'] = Variable<String>(jobActivity.value);
    }
    if (sportMinutesPerWeek.present) {
      map['sport_minutes_per_week'] = Variable<int>(sportMinutesPerWeek.value);
    }
    if (sportNote.present) {
      map['sport_note'] = Variable<String>(sportNote.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (dietStyle.present) {
      map['diet_style'] = Variable<String>(dietStyle.value);
    }
    if (eatingHabits.present) {
      map['eating_habits'] = Variable<String>(eatingHabits.value);
    }
    if (allergiesJson.present) {
      map['allergies_json'] = Variable<String>(allergiesJson.value);
    }
    if (preferredFoodsJson.present) {
      map['preferred_foods_json'] = Variable<String>(preferredFoodsJson.value);
    }
    if (dislikedFoodsJson.present) {
      map['disliked_foods_json'] = Variable<String>(dislikedFoodsJson.value);
    }
    if (calorieOverride.present) {
      map['calorie_override'] = Variable<int>(calorieOverride.value);
    }
    if (proteinOverrideG.present) {
      map['protein_override_g'] = Variable<int>(proteinOverrideG.value);
    }
    if (proteinPerKg.present) {
      map['protein_per_kg'] = Variable<double>(proteinPerKg.value);
    }
    if (fatPercent.present) {
      map['fat_percent'] = Variable<double>(fatPercent.value);
    }
    if (fiberTargetG.present) {
      map['fiber_target_g'] = Variable<double>(fiberTargetG.value);
    }
    if (waterOverrideMl.present) {
      map['water_override_ml'] = Variable<int>(waterOverrideMl.value);
    }
    if (activityCreditPercent.present) {
      map['activity_credit_percent'] = Variable<int>(activityCreditPercent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('displayName: $displayName, ')
          ..write('sex: $sex, ')
          ..write('birthDate: $birthDate, ')
          ..write('heightCm: $heightCm, ')
          ..write('startWeightKg: $startWeightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('targetDate: $targetDate, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('occupation: $occupation, ')
          ..write('jobActivity: $jobActivity, ')
          ..write('sportMinutesPerWeek: $sportMinutesPerWeek, ')
          ..write('sportNote: $sportNote, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('dietStyle: $dietStyle, ')
          ..write('eatingHabits: $eatingHabits, ')
          ..write('allergiesJson: $allergiesJson, ')
          ..write('preferredFoodsJson: $preferredFoodsJson, ')
          ..write('dislikedFoodsJson: $dislikedFoodsJson, ')
          ..write('calorieOverride: $calorieOverride, ')
          ..write('proteinOverrideG: $proteinOverrideG, ')
          ..write('proteinPerKg: $proteinPerKg, ')
          ..write('fatPercent: $fatPercent, ')
          ..write('fiberTargetG: $fiberTargetG, ')
          ..write('waterOverrideMl: $waterOverrideMl, ')
          ..write('activityCreditPercent: $activityCreditPercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealSlotsTable extends MealSlots with TableInfo<$MealSlotsTable, MealSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteOfDayMeta = const VerificationMeta('minuteOfDay');
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
    'minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, deletedAt, name, minuteOfDay, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_slots';
  @override
  VerificationContext validateIntegrity(Insertable<MealSlot> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(_minuteOfDayMeta, minuteOfDay.isAcceptableOrUnknown(data['minute_of_day']!, _minuteOfDayMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealSlot(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      minuteOfDay: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}minute_of_day']),
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $MealSlotsTable createAlias(String alias) {
    return $MealSlotsTable(attachedDatabase, alias);
  }
}

class MealSlot extends DataClass implements Insertable<MealSlot> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final int? minuteOfDay;
  final int sortOrder;
  const MealSlot({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.minuteOfDay,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || minuteOfDay != null) {
      map['minute_of_day'] = Variable<int>(minuteOfDay);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MealSlotsCompanion toCompanion(bool nullToAbsent) {
    return MealSlotsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      name: Value(name),
      minuteOfDay: minuteOfDay == null && nullToAbsent ? const Value.absent() : Value(minuteOfDay),
      sortOrder: Value(sortOrder),
    );
  }

  factory MealSlot.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealSlot(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      minuteOfDay: serializer.fromJson<int?>(json['minuteOfDay']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'minuteOfDay': serializer.toJson<int?>(minuteOfDay),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  MealSlot copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<int?> minuteOfDay = const Value.absent(),
    int? sortOrder,
  }) => MealSlot(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    minuteOfDay: minuteOfDay.present ? minuteOfDay.value : this.minuteOfDay,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  MealSlot copyWithCompanion(MealSlotsCompanion data) {
    return MealSlot(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      minuteOfDay: data.minuteOfDay.present ? data.minuteOfDay.value : this.minuteOfDay,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealSlot(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, name, minuteOfDay, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealSlot &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.minuteOfDay == this.minuteOfDay &&
          other.sortOrder == this.sortOrder);
}

class MealSlotsCompanion extends UpdateCompanion<MealSlot> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<int?> minuteOfDay;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const MealSlotsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealSlotsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.minuteOfDay = const Value.absent(),
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<MealSlot> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<int>? minuteOfDay,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealSlotsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<int?>? minuteOfDay,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return MealSlotsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (minuteOfDay.present) {
      map['minute_of_day'] = Variable<int>(minuteOfDay.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodKeyMeta = const VerificationMeta('foodKey');
  @override
  late final GeneratedColumn<String> foodKey = GeneratedColumn<String>(
    'food_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('g'),
  );
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<double> kcal = GeneratedColumn<double>(
    'kcal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
    'sugar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saturatedFatMeta = const VerificationMeta('saturatedFat');
  @override
  late final GeneratedColumn<double> saturatedFat = GeneratedColumn<double>(
    'saturated_fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fiberMeta = const VerificationMeta('fiber');
  @override
  late final GeneratedColumn<double> fiber = GeneratedColumn<double>(
    'fiber',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<double> salt = GeneratedColumn<double>(
    'salt',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _servingAmountMeta = const VerificationMeta('servingAmount');
  @override
  late final GeneratedColumn<double> servingAmount = GeneratedColumn<double>(
    'serving_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingLabelMeta = const VerificationMeta('servingLabel');
  @override
  late final GeneratedColumn<String> servingLabel = GeneratedColumn<String>(
    'serving_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('user'),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    brand,
    foodKey,
    barcode,
    category,
    unit,
    kcal,
    protein,
    carbs,
    sugar,
    fat,
    saturatedFat,
    fiber,
    salt,
    servingAmount,
    servingLabel,
    source,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(Insertable<Food> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(_brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('food_key')) {
      context.handle(_foodKeyMeta, foodKey.isAcceptableOrUnknown(data['food_key']!, _foodKeyMeta));
    } else if (isInserting) {
      context.missing(_foodKeyMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta, barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(_unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('kcal')) {
      context.handle(_kcalMeta, kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta));
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta, protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(_carbsMeta, carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta));
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(_sugarMeta, sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(_fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('saturated_fat')) {
      context.handle(_saturatedFatMeta, saturatedFat.isAcceptableOrUnknown(data['saturated_fat']!, _saturatedFatMeta));
    }
    if (data.containsKey('fiber')) {
      context.handle(_fiberMeta, fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta));
    }
    if (data.containsKey('salt')) {
      context.handle(_saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    }
    if (data.containsKey('serving_amount')) {
      context.handle(
        _servingAmountMeta,
        servingAmount.isAcceptableOrUnknown(data['serving_amount']!, _servingAmountMeta),
      );
    }
    if (data.containsKey('serving_label')) {
      context.handle(_servingLabelMeta, servingLabel.isAcceptableOrUnknown(data['serving_label']!, _servingLabelMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(_isFavoriteMeta, isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}brand']),
      foodKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}food_key'])!,
      barcode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category']),
      unit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      kcal: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}kcal'])!,
      protein: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}protein'])!,
      carbs: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}carbs'])!,
      sugar: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}sugar'])!,
      fat: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}fat'])!,
      saturatedFat: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}saturated_fat'])!,
      fiber: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}fiber'])!,
      salt: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}salt'])!,
      servingAmount: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}serving_amount']),
      servingLabel: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}serving_label']),
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      isFavorite: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class Food extends DataClass implements Insertable<Food> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? brand;

  /// Normalised name|brand. Unique among live rows (deleted rows get a suffix).
  final String foodKey;
  final String? barcode;
  final String? category;
  final String unit;
  final double kcal;
  final double protein;
  final double carbs;
  final double sugar;
  final double fat;
  final double saturatedFat;
  final double fiber;
  final double salt;
  final double? servingAmount;
  final String? servingLabel;

  /// "base" = shipped reference values, "user" = created by the user.
  final String source;
  final bool isFavorite;
  const Food({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.brand,
    required this.foodKey,
    this.barcode,
    this.category,
    required this.unit,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.sugar,
    required this.fat,
    required this.saturatedFat,
    required this.fiber,
    required this.salt,
    this.servingAmount,
    this.servingLabel,
    required this.source,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['food_key'] = Variable<String>(foodKey);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['unit'] = Variable<String>(unit);
    map['kcal'] = Variable<double>(kcal);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['sugar'] = Variable<double>(sugar);
    map['fat'] = Variable<double>(fat);
    map['saturated_fat'] = Variable<double>(saturatedFat);
    map['fiber'] = Variable<double>(fiber);
    map['salt'] = Variable<double>(salt);
    if (!nullToAbsent || servingAmount != null) {
      map['serving_amount'] = Variable<double>(servingAmount);
    }
    if (!nullToAbsent || servingLabel != null) {
      map['serving_label'] = Variable<String>(servingLabel);
    }
    map['source'] = Variable<String>(source);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      name: Value(name),
      brand: brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      foodKey: Value(foodKey),
      barcode: barcode == null && nullToAbsent ? const Value.absent() : Value(barcode),
      category: category == null && nullToAbsent ? const Value.absent() : Value(category),
      unit: Value(unit),
      kcal: Value(kcal),
      protein: Value(protein),
      carbs: Value(carbs),
      sugar: Value(sugar),
      fat: Value(fat),
      saturatedFat: Value(saturatedFat),
      fiber: Value(fiber),
      salt: Value(salt),
      servingAmount: servingAmount == null && nullToAbsent ? const Value.absent() : Value(servingAmount),
      servingLabel: servingLabel == null && nullToAbsent ? const Value.absent() : Value(servingLabel),
      source: Value(source),
      isFavorite: Value(isFavorite),
    );
  }

  factory Food.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      foodKey: serializer.fromJson<String>(json['foodKey']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      category: serializer.fromJson<String?>(json['category']),
      unit: serializer.fromJson<String>(json['unit']),
      kcal: serializer.fromJson<double>(json['kcal']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      sugar: serializer.fromJson<double>(json['sugar']),
      fat: serializer.fromJson<double>(json['fat']),
      saturatedFat: serializer.fromJson<double>(json['saturatedFat']),
      fiber: serializer.fromJson<double>(json['fiber']),
      salt: serializer.fromJson<double>(json['salt']),
      servingAmount: serializer.fromJson<double?>(json['servingAmount']),
      servingLabel: serializer.fromJson<String?>(json['servingLabel']),
      source: serializer.fromJson<String>(json['source']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'foodKey': serializer.toJson<String>(foodKey),
      'barcode': serializer.toJson<String?>(barcode),
      'category': serializer.toJson<String?>(category),
      'unit': serializer.toJson<String>(unit),
      'kcal': serializer.toJson<double>(kcal),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'sugar': serializer.toJson<double>(sugar),
      'fat': serializer.toJson<double>(fat),
      'saturatedFat': serializer.toJson<double>(saturatedFat),
      'fiber': serializer.toJson<double>(fiber),
      'salt': serializer.toJson<double>(salt),
      'servingAmount': serializer.toJson<double?>(servingAmount),
      'servingLabel': serializer.toJson<String?>(servingLabel),
      'source': serializer.toJson<String>(source),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Food copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> brand = const Value.absent(),
    String? foodKey,
    Value<String?> barcode = const Value.absent(),
    Value<String?> category = const Value.absent(),
    String? unit,
    double? kcal,
    double? protein,
    double? carbs,
    double? sugar,
    double? fat,
    double? saturatedFat,
    double? fiber,
    double? salt,
    Value<double?> servingAmount = const Value.absent(),
    Value<String?> servingLabel = const Value.absent(),
    String? source,
    bool? isFavorite,
  }) => Food(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    foodKey: foodKey ?? this.foodKey,
    barcode: barcode.present ? barcode.value : this.barcode,
    category: category.present ? category.value : this.category,
    unit: unit ?? this.unit,
    kcal: kcal ?? this.kcal,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    sugar: sugar ?? this.sugar,
    fat: fat ?? this.fat,
    saturatedFat: saturatedFat ?? this.saturatedFat,
    fiber: fiber ?? this.fiber,
    salt: salt ?? this.salt,
    servingAmount: servingAmount.present ? servingAmount.value : this.servingAmount,
    servingLabel: servingLabel.present ? servingLabel.value : this.servingLabel,
    source: source ?? this.source,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      foodKey: data.foodKey.present ? data.foodKey.value : this.foodKey,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      category: data.category.present ? data.category.value : this.category,
      unit: data.unit.present ? data.unit.value : this.unit,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      fat: data.fat.present ? data.fat.value : this.fat,
      saturatedFat: data.saturatedFat.present ? data.saturatedFat.value : this.saturatedFat,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      salt: data.salt.present ? data.salt.value : this.salt,
      servingAmount: data.servingAmount.present ? data.servingAmount.value : this.servingAmount,
      servingLabel: data.servingLabel.present ? data.servingLabel.value : this.servingLabel,
      source: data.source.present ? data.source.value : this.source,
      isFavorite: data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('foodKey: $foodKey, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('kcal: $kcal, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('sugar: $sugar, ')
          ..write('fat: $fat, ')
          ..write('saturatedFat: $saturatedFat, ')
          ..write('fiber: $fiber, ')
          ..write('salt: $salt, ')
          ..write('servingAmount: $servingAmount, ')
          ..write('servingLabel: $servingLabel, ')
          ..write('source: $source, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    brand,
    foodKey,
    barcode,
    category,
    unit,
    kcal,
    protein,
    carbs,
    sugar,
    fat,
    saturatedFat,
    fiber,
    salt,
    servingAmount,
    servingLabel,
    source,
    isFavorite,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.foodKey == this.foodKey &&
          other.barcode == this.barcode &&
          other.category == this.category &&
          other.unit == this.unit &&
          other.kcal == this.kcal &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.sugar == this.sugar &&
          other.fat == this.fat &&
          other.saturatedFat == this.saturatedFat &&
          other.fiber == this.fiber &&
          other.salt == this.salt &&
          other.servingAmount == this.servingAmount &&
          other.servingLabel == this.servingLabel &&
          other.source == this.source &&
          other.isFavorite == this.isFavorite);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> foodKey;
  final Value<String?> barcode;
  final Value<String?> category;
  final Value<String> unit;
  final Value<double> kcal;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> sugar;
  final Value<double> fat;
  final Value<double> saturatedFat;
  final Value<double> fiber;
  final Value<double> salt;
  final Value<double?> servingAmount;
  final Value<String?> servingLabel;
  final Value<String> source;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.foodKey = const Value.absent(),
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    this.kcal = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.sugar = const Value.absent(),
    this.fat = const Value.absent(),
    this.saturatedFat = const Value.absent(),
    this.fiber = const Value.absent(),
    this.salt = const Value.absent(),
    this.servingAmount = const Value.absent(),
    this.servingLabel = const Value.absent(),
    this.source = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    required String foodKey,
    this.barcode = const Value.absent(),
    this.category = const Value.absent(),
    this.unit = const Value.absent(),
    required double kcal,
    required double protein,
    required double carbs,
    this.sugar = const Value.absent(),
    required double fat,
    this.saturatedFat = const Value.absent(),
    this.fiber = const Value.absent(),
    this.salt = const Value.absent(),
    this.servingAmount = const Value.absent(),
    this.servingLabel = const Value.absent(),
    this.source = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       foodKey = Value(foodKey),
       kcal = Value(kcal),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat);
  static Insertable<Food> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? foodKey,
    Expression<String>? barcode,
    Expression<String>? category,
    Expression<String>? unit,
    Expression<double>? kcal,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? sugar,
    Expression<double>? fat,
    Expression<double>? saturatedFat,
    Expression<double>? fiber,
    Expression<double>? salt,
    Expression<double>? servingAmount,
    Expression<String>? servingLabel,
    Expression<String>? source,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (foodKey != null) 'food_key': foodKey,
      if (barcode != null) 'barcode': barcode,
      if (category != null) 'category': category,
      if (unit != null) 'unit': unit,
      if (kcal != null) 'kcal': kcal,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (sugar != null) 'sugar': sugar,
      if (fat != null) 'fat': fat,
      if (saturatedFat != null) 'saturated_fat': saturatedFat,
      if (fiber != null) 'fiber': fiber,
      if (salt != null) 'salt': salt,
      if (servingAmount != null) 'serving_amount': servingAmount,
      if (servingLabel != null) 'serving_label': servingLabel,
      if (source != null) 'source': source,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? brand,
    Value<String>? foodKey,
    Value<String?>? barcode,
    Value<String?>? category,
    Value<String>? unit,
    Value<double>? kcal,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? sugar,
    Value<double>? fat,
    Value<double>? saturatedFat,
    Value<double>? fiber,
    Value<double>? salt,
    Value<double?>? servingAmount,
    Value<String?>? servingLabel,
    Value<String>? source,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      foodKey: foodKey ?? this.foodKey,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      kcal: kcal ?? this.kcal,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      sugar: sugar ?? this.sugar,
      fat: fat ?? this.fat,
      saturatedFat: saturatedFat ?? this.saturatedFat,
      fiber: fiber ?? this.fiber,
      salt: salt ?? this.salt,
      servingAmount: servingAmount ?? this.servingAmount,
      servingLabel: servingLabel ?? this.servingLabel,
      source: source ?? this.source,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (foodKey.present) {
      map['food_key'] = Variable<String>(foodKey.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<double>(kcal.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (saturatedFat.present) {
      map['saturated_fat'] = Variable<double>(saturatedFat.value);
    }
    if (fiber.present) {
      map['fiber'] = Variable<double>(fiber.value);
    }
    if (salt.present) {
      map['salt'] = Variable<double>(salt.value);
    }
    if (servingAmount.present) {
      map['serving_amount'] = Variable<double>(servingAmount.value);
    }
    if (servingLabel.present) {
      map['serving_label'] = Variable<String>(servingLabel.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('foodKey: $foodKey, ')
          ..write('barcode: $barcode, ')
          ..write('category: $category, ')
          ..write('unit: $unit, ')
          ..write('kcal: $kcal, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('sugar: $sugar, ')
          ..write('fat: $fat, ')
          ..write('saturatedFat: $saturatedFat, ')
          ..write('fiber: $fiber, ')
          ..write('salt: $salt, ')
          ..write('servingAmount: $servingAmount, ')
          ..write('servingLabel: $servingLabel, ')
          ..write('source: $source, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries with TableInfo<$DiaryEntriesTable, DiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealSlotIdMeta = const VerificationMeta('mealSlotId');
  @override
  late final GeneratedColumn<String> mealSlotId = GeneratedColumn<String>(
    'meal_slot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta('foodName');
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kcal100Meta = const VerificationMeta('kcal100');
  @override
  late final GeneratedColumn<double> kcal100 = GeneratedColumn<double>(
    'kcal100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protein100Meta = const VerificationMeta('protein100');
  @override
  late final GeneratedColumn<double> protein100 = GeneratedColumn<double>(
    'protein100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbs100Meta = const VerificationMeta('carbs100');
  @override
  late final GeneratedColumn<double> carbs100 = GeneratedColumn<double>(
    'carbs100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugar100Meta = const VerificationMeta('sugar100');
  @override
  late final GeneratedColumn<double> sugar100 = GeneratedColumn<double>(
    'sugar100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fat100Meta = const VerificationMeta('fat100');
  @override
  late final GeneratedColumn<double> fat100 = GeneratedColumn<double>(
    'fat100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saturatedFat100Meta = const VerificationMeta('saturatedFat100');
  @override
  late final GeneratedColumn<double> saturatedFat100 = GeneratedColumn<double>(
    'saturated_fat100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiber100Meta = const VerificationMeta('fiber100');
  @override
  late final GeneratedColumn<double> fiber100 = GeneratedColumn<double>(
    'fiber100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salt100Meta = const VerificationMeta('salt100');
  @override
  late final GeneratedColumn<double> salt100 = GeneratedColumn<double>(
    'salt100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    dayKey,
    mealSlotId,
    foodId,
    foodName,
    brand,
    unit,
    amount,
    kcal100,
    protein100,
    carbs100,
    sugar100,
    fat100,
    saturatedFat100,
    fiber100,
    salt100,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DiaryEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(_dayKeyMeta, dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta));
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('meal_slot_id')) {
      context.handle(_mealSlotIdMeta, mealSlotId.isAcceptableOrUnknown(data['meal_slot_id']!, _mealSlotIdMeta));
    } else if (isInserting) {
      context.missing(_mealSlotIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta, foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    }
    if (data.containsKey('food_name')) {
      context.handle(_foodNameMeta, foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta));
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(_brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(_unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('kcal100')) {
      context.handle(_kcal100Meta, kcal100.isAcceptableOrUnknown(data['kcal100']!, _kcal100Meta));
    } else if (isInserting) {
      context.missing(_kcal100Meta);
    }
    if (data.containsKey('protein100')) {
      context.handle(_protein100Meta, protein100.isAcceptableOrUnknown(data['protein100']!, _protein100Meta));
    } else if (isInserting) {
      context.missing(_protein100Meta);
    }
    if (data.containsKey('carbs100')) {
      context.handle(_carbs100Meta, carbs100.isAcceptableOrUnknown(data['carbs100']!, _carbs100Meta));
    } else if (isInserting) {
      context.missing(_carbs100Meta);
    }
    if (data.containsKey('sugar100')) {
      context.handle(_sugar100Meta, sugar100.isAcceptableOrUnknown(data['sugar100']!, _sugar100Meta));
    } else if (isInserting) {
      context.missing(_sugar100Meta);
    }
    if (data.containsKey('fat100')) {
      context.handle(_fat100Meta, fat100.isAcceptableOrUnknown(data['fat100']!, _fat100Meta));
    } else if (isInserting) {
      context.missing(_fat100Meta);
    }
    if (data.containsKey('saturated_fat100')) {
      context.handle(
        _saturatedFat100Meta,
        saturatedFat100.isAcceptableOrUnknown(data['saturated_fat100']!, _saturatedFat100Meta),
      );
    } else if (isInserting) {
      context.missing(_saturatedFat100Meta);
    }
    if (data.containsKey('fiber100')) {
      context.handle(_fiber100Meta, fiber100.isAcceptableOrUnknown(data['fiber100']!, _fiber100Meta));
    } else if (isInserting) {
      context.missing(_fiber100Meta);
    }
    if (data.containsKey('salt100')) {
      context.handle(_salt100Meta, salt100.isAcceptableOrUnknown(data['salt100']!, _salt100Meta));
    } else if (isInserting) {
      context.missing(_salt100Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      dayKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}day_key'])!,
      mealSlotId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}meal_slot_id'])!,
      foodId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}food_id']),
      foodName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}food_name'])!,
      brand: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}brand']),
      unit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      amount: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      kcal100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}kcal100'])!,
      protein100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}protein100'])!,
      carbs100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}carbs100'])!,
      sugar100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}sugar100'])!,
      fat100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}fat100'])!,
      saturatedFat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturated_fat100'],
      )!,
      fiber100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}fiber100'])!,
      salt100: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}salt100'])!,
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }
}

class DiaryEntry extends DataClass implements Insertable<DiaryEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String dayKey;
  final String mealSlotId;
  final String? foodId;
  final String foodName;
  final String? brand;
  final String unit;
  final double amount;
  final double kcal100;
  final double protein100;
  final double carbs100;
  final double sugar100;
  final double fat100;
  final double saturatedFat100;
  final double fiber100;
  final double salt100;
  const DiaryEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dayKey,
    required this.mealSlotId,
    this.foodId,
    required this.foodName,
    this.brand,
    required this.unit,
    required this.amount,
    required this.kcal100,
    required this.protein100,
    required this.carbs100,
    required this.sugar100,
    required this.fat100,
    required this.saturatedFat100,
    required this.fiber100,
    required this.salt100,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['day_key'] = Variable<String>(dayKey);
    map['meal_slot_id'] = Variable<String>(mealSlotId);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    map['food_name'] = Variable<String>(foodName);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['unit'] = Variable<String>(unit);
    map['amount'] = Variable<double>(amount);
    map['kcal100'] = Variable<double>(kcal100);
    map['protein100'] = Variable<double>(protein100);
    map['carbs100'] = Variable<double>(carbs100);
    map['sugar100'] = Variable<double>(sugar100);
    map['fat100'] = Variable<double>(fat100);
    map['saturated_fat100'] = Variable<double>(saturatedFat100);
    map['fiber100'] = Variable<double>(fiber100);
    map['salt100'] = Variable<double>(salt100);
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      dayKey: Value(dayKey),
      mealSlotId: Value(mealSlotId),
      foodId: foodId == null && nullToAbsent ? const Value.absent() : Value(foodId),
      foodName: Value(foodName),
      brand: brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      unit: Value(unit),
      amount: Value(amount),
      kcal100: Value(kcal100),
      protein100: Value(protein100),
      carbs100: Value(carbs100),
      sugar100: Value(sugar100),
      fat100: Value(fat100),
      saturatedFat100: Value(saturatedFat100),
      fiber100: Value(fiber100),
      salt100: Value(salt100),
    );
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      mealSlotId: serializer.fromJson<String>(json['mealSlotId']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      foodName: serializer.fromJson<String>(json['foodName']),
      brand: serializer.fromJson<String?>(json['brand']),
      unit: serializer.fromJson<String>(json['unit']),
      amount: serializer.fromJson<double>(json['amount']),
      kcal100: serializer.fromJson<double>(json['kcal100']),
      protein100: serializer.fromJson<double>(json['protein100']),
      carbs100: serializer.fromJson<double>(json['carbs100']),
      sugar100: serializer.fromJson<double>(json['sugar100']),
      fat100: serializer.fromJson<double>(json['fat100']),
      saturatedFat100: serializer.fromJson<double>(json['saturatedFat100']),
      fiber100: serializer.fromJson<double>(json['fiber100']),
      salt100: serializer.fromJson<double>(json['salt100']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dayKey': serializer.toJson<String>(dayKey),
      'mealSlotId': serializer.toJson<String>(mealSlotId),
      'foodId': serializer.toJson<String?>(foodId),
      'foodName': serializer.toJson<String>(foodName),
      'brand': serializer.toJson<String?>(brand),
      'unit': serializer.toJson<String>(unit),
      'amount': serializer.toJson<double>(amount),
      'kcal100': serializer.toJson<double>(kcal100),
      'protein100': serializer.toJson<double>(protein100),
      'carbs100': serializer.toJson<double>(carbs100),
      'sugar100': serializer.toJson<double>(sugar100),
      'fat100': serializer.toJson<double>(fat100),
      'saturatedFat100': serializer.toJson<double>(saturatedFat100),
      'fiber100': serializer.toJson<double>(fiber100),
      'salt100': serializer.toJson<double>(salt100),
    };
  }

  DiaryEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? dayKey,
    String? mealSlotId,
    Value<String?> foodId = const Value.absent(),
    String? foodName,
    Value<String?> brand = const Value.absent(),
    String? unit,
    double? amount,
    double? kcal100,
    double? protein100,
    double? carbs100,
    double? sugar100,
    double? fat100,
    double? saturatedFat100,
    double? fiber100,
    double? salt100,
  }) => DiaryEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dayKey: dayKey ?? this.dayKey,
    mealSlotId: mealSlotId ?? this.mealSlotId,
    foodId: foodId.present ? foodId.value : this.foodId,
    foodName: foodName ?? this.foodName,
    brand: brand.present ? brand.value : this.brand,
    unit: unit ?? this.unit,
    amount: amount ?? this.amount,
    kcal100: kcal100 ?? this.kcal100,
    protein100: protein100 ?? this.protein100,
    carbs100: carbs100 ?? this.carbs100,
    sugar100: sugar100 ?? this.sugar100,
    fat100: fat100 ?? this.fat100,
    saturatedFat100: saturatedFat100 ?? this.saturatedFat100,
    fiber100: fiber100 ?? this.fiber100,
    salt100: salt100 ?? this.salt100,
  );
  DiaryEntry copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      mealSlotId: data.mealSlotId.present ? data.mealSlotId.value : this.mealSlotId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      brand: data.brand.present ? data.brand.value : this.brand,
      unit: data.unit.present ? data.unit.value : this.unit,
      amount: data.amount.present ? data.amount.value : this.amount,
      kcal100: data.kcal100.present ? data.kcal100.value : this.kcal100,
      protein100: data.protein100.present ? data.protein100.value : this.protein100,
      carbs100: data.carbs100.present ? data.carbs100.value : this.carbs100,
      sugar100: data.sugar100.present ? data.sugar100.value : this.sugar100,
      fat100: data.fat100.present ? data.fat100.value : this.fat100,
      saturatedFat100: data.saturatedFat100.present ? data.saturatedFat100.value : this.saturatedFat100,
      fiber100: data.fiber100.present ? data.fiber100.value : this.fiber100,
      salt100: data.salt100.present ? data.salt100.value : this.salt100,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('brand: $brand, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('kcal100: $kcal100, ')
          ..write('protein100: $protein100, ')
          ..write('carbs100: $carbs100, ')
          ..write('sugar100: $sugar100, ')
          ..write('fat100: $fat100, ')
          ..write('saturatedFat100: $saturatedFat100, ')
          ..write('fiber100: $fiber100, ')
          ..write('salt100: $salt100')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    dayKey,
    mealSlotId,
    foodId,
    foodName,
    brand,
    unit,
    amount,
    kcal100,
    protein100,
    carbs100,
    sugar100,
    fat100,
    saturatedFat100,
    fiber100,
    salt100,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dayKey == this.dayKey &&
          other.mealSlotId == this.mealSlotId &&
          other.foodId == this.foodId &&
          other.foodName == this.foodName &&
          other.brand == this.brand &&
          other.unit == this.unit &&
          other.amount == this.amount &&
          other.kcal100 == this.kcal100 &&
          other.protein100 == this.protein100 &&
          other.carbs100 == this.carbs100 &&
          other.sugar100 == this.sugar100 &&
          other.fat100 == this.fat100 &&
          other.saturatedFat100 == this.saturatedFat100 &&
          other.fiber100 == this.fiber100 &&
          other.salt100 == this.salt100);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> dayKey;
  final Value<String> mealSlotId;
  final Value<String?> foodId;
  final Value<String> foodName;
  final Value<String?> brand;
  final Value<String> unit;
  final Value<double> amount;
  final Value<double> kcal100;
  final Value<double> protein100;
  final Value<double> carbs100;
  final Value<double> sugar100;
  final Value<double> fat100;
  final Value<double> saturatedFat100;
  final Value<double> fiber100;
  final Value<double> salt100;
  final Value<int> rowid;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.mealSlotId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.brand = const Value.absent(),
    this.unit = const Value.absent(),
    this.amount = const Value.absent(),
    this.kcal100 = const Value.absent(),
    this.protein100 = const Value.absent(),
    this.carbs100 = const Value.absent(),
    this.sugar100 = const Value.absent(),
    this.fat100 = const Value.absent(),
    this.saturatedFat100 = const Value.absent(),
    this.fiber100 = const Value.absent(),
    this.salt100 = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String dayKey,
    required String mealSlotId,
    this.foodId = const Value.absent(),
    required String foodName,
    this.brand = const Value.absent(),
    required String unit,
    required double amount,
    required double kcal100,
    required double protein100,
    required double carbs100,
    required double sugar100,
    required double fat100,
    required double saturatedFat100,
    required double fiber100,
    required double salt100,
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       mealSlotId = Value(mealSlotId),
       foodName = Value(foodName),
       unit = Value(unit),
       amount = Value(amount),
       kcal100 = Value(kcal100),
       protein100 = Value(protein100),
       carbs100 = Value(carbs100),
       sugar100 = Value(sugar100),
       fat100 = Value(fat100),
       saturatedFat100 = Value(saturatedFat100),
       fiber100 = Value(fiber100),
       salt100 = Value(salt100);
  static Insertable<DiaryEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? dayKey,
    Expression<String>? mealSlotId,
    Expression<String>? foodId,
    Expression<String>? foodName,
    Expression<String>? brand,
    Expression<String>? unit,
    Expression<double>? amount,
    Expression<double>? kcal100,
    Expression<double>? protein100,
    Expression<double>? carbs100,
    Expression<double>? sugar100,
    Expression<double>? fat100,
    Expression<double>? saturatedFat100,
    Expression<double>? fiber100,
    Expression<double>? salt100,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dayKey != null) 'day_key': dayKey,
      if (mealSlotId != null) 'meal_slot_id': mealSlotId,
      if (foodId != null) 'food_id': foodId,
      if (foodName != null) 'food_name': foodName,
      if (brand != null) 'brand': brand,
      if (unit != null) 'unit': unit,
      if (amount != null) 'amount': amount,
      if (kcal100 != null) 'kcal100': kcal100,
      if (protein100 != null) 'protein100': protein100,
      if (carbs100 != null) 'carbs100': carbs100,
      if (sugar100 != null) 'sugar100': sugar100,
      if (fat100 != null) 'fat100': fat100,
      if (saturatedFat100 != null) 'saturated_fat100': saturatedFat100,
      if (fiber100 != null) 'fiber100': fiber100,
      if (salt100 != null) 'salt100': salt100,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? dayKey,
    Value<String>? mealSlotId,
    Value<String?>? foodId,
    Value<String>? foodName,
    Value<String?>? brand,
    Value<String>? unit,
    Value<double>? amount,
    Value<double>? kcal100,
    Value<double>? protein100,
    Value<double>? carbs100,
    Value<double>? sugar100,
    Value<double>? fat100,
    Value<double>? saturatedFat100,
    Value<double>? fiber100,
    Value<double>? salt100,
    Value<int>? rowid,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dayKey: dayKey ?? this.dayKey,
      mealSlotId: mealSlotId ?? this.mealSlotId,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      amount: amount ?? this.amount,
      kcal100: kcal100 ?? this.kcal100,
      protein100: protein100 ?? this.protein100,
      carbs100: carbs100 ?? this.carbs100,
      sugar100: sugar100 ?? this.sugar100,
      fat100: fat100 ?? this.fat100,
      saturatedFat100: saturatedFat100 ?? this.saturatedFat100,
      fiber100: fiber100 ?? this.fiber100,
      salt100: salt100 ?? this.salt100,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (mealSlotId.present) {
      map['meal_slot_id'] = Variable<String>(mealSlotId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (kcal100.present) {
      map['kcal100'] = Variable<double>(kcal100.value);
    }
    if (protein100.present) {
      map['protein100'] = Variable<double>(protein100.value);
    }
    if (carbs100.present) {
      map['carbs100'] = Variable<double>(carbs100.value);
    }
    if (sugar100.present) {
      map['sugar100'] = Variable<double>(sugar100.value);
    }
    if (fat100.present) {
      map['fat100'] = Variable<double>(fat100.value);
    }
    if (saturatedFat100.present) {
      map['saturated_fat100'] = Variable<double>(saturatedFat100.value);
    }
    if (fiber100.present) {
      map['fiber100'] = Variable<double>(fiber100.value);
    }
    if (salt100.present) {
      map['salt100'] = Variable<double>(salt100.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('brand: $brand, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('kcal100: $kcal100, ')
          ..write('protein100: $protein100, ')
          ..write('carbs100: $carbs100, ')
          ..write('sugar100: $sugar100, ')
          ..write('fat100: $fat100, ')
          ..write('saturatedFat100: $saturatedFat100, ')
          ..write('fiber100: $fiber100, ')
          ..write('salt100: $salt100, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries with TableInfo<$WeightEntriesTable, WeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta('bodyFatPercent');
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta('waistCm');
  @override
  late final GeneratedColumn<double> waistCm = GeneratedColumn<double>(
    'waist_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    dayKey,
    weightKg,
    bodyFatPercent,
    waistCm,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WeightEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(_dayKeyMeta, dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta));
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta, weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(data['body_fat_percent']!, _bodyFatPercentMeta),
      );
    }
    if (data.containsKey('waist_cm')) {
      context.handle(_waistCmMeta, waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      dayKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}day_key'])!,
      weightKg: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      ),
      waistCm: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}waist_cm']),
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntry extends DataClass implements Insertable<WeightEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String dayKey;
  final double weightKg;
  final double? bodyFatPercent;
  final double? waistCm;
  final String? note;
  const WeightEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dayKey,
    required this.weightKg,
    this.bodyFatPercent,
    this.waistCm,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['day_key'] = Variable<String>(dayKey);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || bodyFatPercent != null) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent);
    }
    if (!nullToAbsent || waistCm != null) {
      map['waist_cm'] = Variable<double>(waistCm);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      dayKey: Value(dayKey),
      weightKg: Value(weightKg),
      bodyFatPercent: bodyFatPercent == null && nullToAbsent ? const Value.absent() : Value(bodyFatPercent),
      waistCm: waistCm == null && nullToAbsent ? const Value.absent() : Value(waistCm),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      bodyFatPercent: serializer.fromJson<double?>(json['bodyFatPercent']),
      waistCm: serializer.fromJson<double?>(json['waistCm']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dayKey': serializer.toJson<String>(dayKey),
      'weightKg': serializer.toJson<double>(weightKg),
      'bodyFatPercent': serializer.toJson<double?>(bodyFatPercent),
      'waistCm': serializer.toJson<double?>(waistCm),
      'note': serializer.toJson<String?>(note),
    };
  }

  WeightEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? dayKey,
    double? weightKg,
    Value<double?> bodyFatPercent = const Value.absent(),
    Value<double?> waistCm = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => WeightEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dayKey: dayKey ?? this.dayKey,
    weightKg: weightKg ?? this.weightKg,
    bodyFatPercent: bodyFatPercent.present ? bodyFatPercent.value : this.bodyFatPercent,
    waistCm: waistCm.present ? waistCm.value : this.waistCm,
    note: note.present ? note.value : this.note,
  );
  WeightEntry copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bodyFatPercent: data.bodyFatPercent.present ? data.bodyFatPercent.value : this.bodyFatPercent,
      waistCm: data.waistCm.present ? data.waistCm.value : this.waistCm,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('waistCm: $waistCm, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, dayKey, weightKg, bodyFatPercent, waistCm, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dayKey == this.dayKey &&
          other.weightKg == this.weightKg &&
          other.bodyFatPercent == this.bodyFatPercent &&
          other.waistCm == this.waistCm &&
          other.note == this.note);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> dayKey;
  final Value<double> weightKg;
  final Value<double?> bodyFatPercent;
  final Value<double?> waistCm;
  final Value<String?> note;
  final Value<int> rowid;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String dayKey,
    required double weightKg,
    this.bodyFatPercent = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       weightKg = Value(weightKg);
  static Insertable<WeightEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? dayKey,
    Expression<double>? weightKg,
    Expression<double>? bodyFatPercent,
    Expression<double>? waistCm,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dayKey != null) 'day_key': dayKey,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bodyFatPercent != null) 'body_fat_percent': bodyFatPercent,
      if (waistCm != null) 'waist_cm': waistCm,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? dayKey,
    Value<double>? weightKg,
    Value<double?>? bodyFatPercent,
    Value<double?>? waistCm,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dayKey: dayKey ?? this.dayKey,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      waistCm: waistCm ?? this.waistCm,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bodyFatPercent.present) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent.value);
    }
    if (waistCm.present) {
      map['waist_cm'] = Variable<double>(waistCm.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('waistCm: $waistCm, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterEntriesTable extends WaterEntries with TableInfo<$WaterEntriesTable, WaterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mlMeta = const VerificationMeta('ml');
  @override
  late final GeneratedColumn<int> ml = GeneratedColumn<int>(
    'ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, deletedAt, dayKey, ml];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WaterEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(_dayKeyMeta, dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta));
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('ml')) {
      context.handle(_mlMeta, ml.isAcceptableOrUnknown(data['ml']!, _mlMeta));
    } else if (isInserting) {
      context.missing(_mlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      dayKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}day_key'])!,
      ml: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}ml'])!,
    );
  }

  @override
  $WaterEntriesTable createAlias(String alias) {
    return $WaterEntriesTable(attachedDatabase, alias);
  }
}

class WaterEntry extends DataClass implements Insertable<WaterEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String dayKey;
  final int ml;
  const WaterEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dayKey,
    required this.ml,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['day_key'] = Variable<String>(dayKey);
    map['ml'] = Variable<int>(ml);
    return map;
  }

  WaterEntriesCompanion toCompanion(bool nullToAbsent) {
    return WaterEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      dayKey: Value(dayKey),
      ml: Value(ml),
    );
  }

  factory WaterEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      ml: serializer.fromJson<int>(json['ml']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dayKey': serializer.toJson<String>(dayKey),
      'ml': serializer.toJson<int>(ml),
    };
  }

  WaterEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? dayKey,
    int? ml,
  }) => WaterEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dayKey: dayKey ?? this.dayKey,
    ml: ml ?? this.ml,
  );
  WaterEntry copyWithCompanion(WaterEntriesCompanion data) {
    return WaterEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      ml: data.ml.present ? data.ml.value : this.ml,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('ml: $ml')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, deletedAt, dayKey, ml);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dayKey == this.dayKey &&
          other.ml == this.ml);
}

class WaterEntriesCompanion extends UpdateCompanion<WaterEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> dayKey;
  final Value<int> ml;
  final Value<int> rowid;
  const WaterEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.ml = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String dayKey,
    required int ml,
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       ml = Value(ml);
  static Insertable<WaterEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? dayKey,
    Expression<int>? ml,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dayKey != null) 'day_key': dayKey,
      if (ml != null) 'ml': ml,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? dayKey,
    Value<int>? ml,
    Value<int>? rowid,
  }) {
    return WaterEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dayKey: dayKey ?? this.dayKey,
      ml: ml ?? this.ml,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (ml.present) {
      map['ml'] = Variable<int>(ml.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('ml: $ml, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityEntriesTable extends ActivityEntries with TableInfo<$ActivityEntriesTable, ActivityEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta('minutes');
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<double> kcal = GeneratedColumn<double>(
    'kcal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta('externalId');
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    dayKey,
    label,
    minutes,
    kcal,
    steps,
    source,
    externalId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_entries';
  @override
  VerificationContext validateIntegrity(Insertable<ActivityEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(_dayKeyMeta, dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta));
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(_labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(_minutesMeta, minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta));
    }
    if (data.containsKey('kcal')) {
      context.handle(_kcalMeta, kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta));
    }
    if (data.containsKey('steps')) {
      context.handle(_stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(_externalIdMeta, externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      dayKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}day_key'])!,
      label: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      minutes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}minutes'])!,
      kcal: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}kcal'])!,
      steps: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}steps']),
      source: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      externalId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}external_id']),
    );
  }

  @override
  $ActivityEntriesTable createAlias(String alias) {
    return $ActivityEntriesTable(attachedDatabase, alias);
  }
}

class ActivityEntry extends DataClass implements Insertable<ActivityEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String dayKey;
  final String label;
  final int minutes;
  final double kcal;
  final int? steps;
  final String source;
  final String? externalId;
  const ActivityEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dayKey,
    required this.label,
    required this.minutes,
    required this.kcal,
    this.steps,
    required this.source,
    this.externalId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['day_key'] = Variable<String>(dayKey);
    map['label'] = Variable<String>(label);
    map['minutes'] = Variable<int>(minutes);
    map['kcal'] = Variable<double>(kcal);
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    return map;
  }

  ActivityEntriesCompanion toCompanion(bool nullToAbsent) {
    return ActivityEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      dayKey: Value(dayKey),
      label: Value(label),
      minutes: Value(minutes),
      kcal: Value(kcal),
      steps: steps == null && nullToAbsent ? const Value.absent() : Value(steps),
      source: Value(source),
      externalId: externalId == null && nullToAbsent ? const Value.absent() : Value(externalId),
    );
  }

  factory ActivityEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      label: serializer.fromJson<String>(json['label']),
      minutes: serializer.fromJson<int>(json['minutes']),
      kcal: serializer.fromJson<double>(json['kcal']),
      steps: serializer.fromJson<int?>(json['steps']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String?>(json['externalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dayKey': serializer.toJson<String>(dayKey),
      'label': serializer.toJson<String>(label),
      'minutes': serializer.toJson<int>(minutes),
      'kcal': serializer.toJson<double>(kcal),
      'steps': serializer.toJson<int?>(steps),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String?>(externalId),
    };
  }

  ActivityEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? dayKey,
    String? label,
    int? minutes,
    double? kcal,
    Value<int?> steps = const Value.absent(),
    String? source,
    Value<String?> externalId = const Value.absent(),
  }) => ActivityEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dayKey: dayKey ?? this.dayKey,
    label: label ?? this.label,
    minutes: minutes ?? this.minutes,
    kcal: kcal ?? this.kcal,
    steps: steps.present ? steps.value : this.steps,
    source: source ?? this.source,
    externalId: externalId.present ? externalId.value : this.externalId,
  );
  ActivityEntry copyWithCompanion(ActivityEntriesCompanion data) {
    return ActivityEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      label: data.label.present ? data.label.value : this.label,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      steps: data.steps.present ? data.steps.value : this.steps,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present ? data.externalId.value : this.externalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('label: $label, ')
          ..write('minutes: $minutes, ')
          ..write('kcal: $kcal, ')
          ..write('steps: $steps, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, dayKey, label, minutes, kcal, steps, source, externalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dayKey == this.dayKey &&
          other.label == this.label &&
          other.minutes == this.minutes &&
          other.kcal == this.kcal &&
          other.steps == this.steps &&
          other.source == this.source &&
          other.externalId == this.externalId);
}

class ActivityEntriesCompanion extends UpdateCompanion<ActivityEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> dayKey;
  final Value<String> label;
  final Value<int> minutes;
  final Value<double> kcal;
  final Value<int?> steps;
  final Value<String> source;
  final Value<String?> externalId;
  final Value<int> rowid;
  const ActivityEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.label = const Value.absent(),
    this.minutes = const Value.absent(),
    this.kcal = const Value.absent(),
    this.steps = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String dayKey,
    required String label,
    this.minutes = const Value.absent(),
    this.kcal = const Value.absent(),
    this.steps = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       label = Value(label);
  static Insertable<ActivityEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? dayKey,
    Expression<String>? label,
    Expression<int>? minutes,
    Expression<double>? kcal,
    Expression<int>? steps,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dayKey != null) 'day_key': dayKey,
      if (label != null) 'label': label,
      if (minutes != null) 'minutes': minutes,
      if (kcal != null) 'kcal': kcal,
      if (steps != null) 'steps': steps,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? dayKey,
    Value<String>? label,
    Value<int>? minutes,
    Value<double>? kcal,
    Value<int?>? steps,
    Value<String>? source,
    Value<String?>? externalId,
    Value<int>? rowid,
  }) {
    return ActivityEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dayKey: dayKey ?? this.dayKey,
      label: label ?? this.label,
      minutes: minutes ?? this.minutes,
      kcal: kcal ?? this.kcal,
      steps: steps ?? this.steps,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<double>(kcal.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('label: $label, ')
          ..write('minutes: $minutes, ')
          ..write('kcal: $kcal, ')
          ..write('steps: $steps, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(key: serializer.fromJson<String>(json['key']), value: serializer.fromJson<String>(json['value']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'key': serializer.toJson<String>(key), 'value': serializer.toJson<String>(value)};
  }

  Setting copyWith({String? key, String? value}) => Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({required String key, required String value, this.rowid = const Value.absent()})
    : key = Value(key),
      value = Value(value);
  static Insertable<Setting> custom({Expression<String>? key, Expression<String>? value, Expression<int>? rowid}) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsCompanion(key: key ?? this.key, value: value ?? this.value, rowid: rowid ?? this.rowid);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $MealSlotsTable mealSlots = $MealSlotsTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $WaterEntriesTable waterEntries = $WaterEntriesTable(this);
  late final $ActivityEntriesTable activityEntries = $ActivityEntriesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final Index foodsKey = Index('foods_key', 'CREATE UNIQUE INDEX foods_key ON foods (food_key)');
  late final Index foodsBarcode = Index('foods_barcode', 'CREATE UNIQUE INDEX foods_barcode ON foods (barcode)');
  late final Index diaryDay = Index('diary_day', 'CREATE INDEX diary_day ON diary_entries (day_key)');
  late final Index weightDay = Index('weight_day', 'CREATE UNIQUE INDEX weight_day ON weight_entries (day_key)');
  late final Index waterDay = Index('water_day', 'CREATE INDEX water_day ON water_entries (day_key)');
  late final Index activityDay = Index('activity_day', 'CREATE INDEX activity_day ON activity_entries (day_key)');
  late final Index activityExt = Index(
    'activity_ext',
    'CREATE UNIQUE INDEX activity_ext ON activity_entries (source, external_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    mealSlots,
    foods,
    diaryEntries,
    weightEntries,
    waterEntries,
    activityEntries,
    settings,
    foodsKey,
    foodsBarcode,
    diaryDay,
    weightDay,
    waterDay,
    activityDay,
    activityExt,
  ];
  @override
  DriftDatabaseOptions get options => const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> displayName,
  required String sex,
  required DateTime birthDate,
  required double heightCm,
  required double startWeightKg,
  required double targetWeightKg,
  Value<DateTime?> targetDate,
  Value<double?> bodyFatPercent,
  Value<String?> occupation,
  required String jobActivity,
  Value<int> sportMinutesPerWeek,
  Value<String?> sportNote,
  Value<double?> sleepHours,
  Value<String?> dietStyle,
  Value<String?> eatingHabits,
  Value<String> allergiesJson,
  Value<String> preferredFoodsJson,
  Value<String> dislikedFoodsJson,
  Value<int?> calorieOverride,
  Value<int?> proteinOverrideG,
  Value<double> proteinPerKg,
  Value<double> fatPercent,
  Value<double> fiberTargetG,
  Value<int?> waterOverrideMl,
  Value<int> activityCreditPercent,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String?> displayName,
  Value<String> sex,
  Value<DateTime> birthDate,
  Value<double> heightCm,
  Value<double> startWeightKg,
  Value<double> targetWeightKg,
  Value<DateTime?> targetDate,
  Value<double?> bodyFatPercent,
  Value<String?> occupation,
  Value<String> jobActivity,
  Value<int> sportMinutesPerWeek,
  Value<String?> sportNote,
  Value<double?> sleepHours,
  Value<String?> dietStyle,
  Value<String?> eatingHabits,
  Value<String> allergiesJson,
  Value<String> preferredFoodsJson,
  Value<String> dislikedFoodsJson,
  Value<int?> calorieOverride,
  Value<int?> proteinOverrideG,
  Value<double> proteinPerKg,
  Value<double> fatPercent,
  Value<double> fiberTargetG,
  Value<int?> waterOverrideMl,
  Value<int> activityCreditPercent,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get startWeightKg =>
      $composableBuilder(column: $table.startWeightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetWeightKg =>
      $composableBuilder(column: $table.targetWeightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate =>
      $composableBuilder(column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bodyFatPercent =>
      $composableBuilder(column: $table.bodyFatPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get occupation =>
      $composableBuilder(column: $table.occupation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jobActivity =>
      $composableBuilder(column: $table.jobActivity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sportMinutesPerWeek =>
      $composableBuilder(column: $table.sportMinutesPerWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sportNote =>
      $composableBuilder(column: $table.sportNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sleepHours =>
      $composableBuilder(column: $table.sleepHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dietStyle =>
      $composableBuilder(column: $table.dietStyle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eatingHabits =>
      $composableBuilder(column: $table.eatingHabits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergiesJson =>
      $composableBuilder(column: $table.allergiesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get preferredFoodsJson =>
      $composableBuilder(column: $table.preferredFoodsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dislikedFoodsJson =>
      $composableBuilder(column: $table.dislikedFoodsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calorieOverride =>
      $composableBuilder(column: $table.calorieOverride, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get proteinOverrideG =>
      $composableBuilder(column: $table.proteinOverrideG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinPerKg =>
      $composableBuilder(column: $table.proteinPerKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatPercent =>
      $composableBuilder(column: $table.fatPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fiberTargetG =>
      $composableBuilder(column: $table.fiberTargetG, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get waterOverrideMl =>
      $composableBuilder(column: $table.waterOverrideMl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activityCreditPercent =>
      $composableBuilder(column: $table.activityCreditPercent, builder: (column) => ColumnFilters(column));
}

class $$ProfilesTableOrderingComposer extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get startWeightKg =>
      $composableBuilder(column: $table.startWeightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetWeightKg =>
      $composableBuilder(column: $table.targetWeightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate =>
      $composableBuilder(column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bodyFatPercent =>
      $composableBuilder(column: $table.bodyFatPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get occupation =>
      $composableBuilder(column: $table.occupation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jobActivity =>
      $composableBuilder(column: $table.jobActivity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sportMinutesPerWeek =>
      $composableBuilder(column: $table.sportMinutesPerWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sportNote =>
      $composableBuilder(column: $table.sportNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sleepHours =>
      $composableBuilder(column: $table.sleepHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dietStyle =>
      $composableBuilder(column: $table.dietStyle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eatingHabits =>
      $composableBuilder(column: $table.eatingHabits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergiesJson =>
      $composableBuilder(column: $table.allergiesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get preferredFoodsJson =>
      $composableBuilder(column: $table.preferredFoodsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dislikedFoodsJson =>
      $composableBuilder(column: $table.dislikedFoodsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calorieOverride =>
      $composableBuilder(column: $table.calorieOverride, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get proteinOverrideG =>
      $composableBuilder(column: $table.proteinOverrideG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinPerKg =>
      $composableBuilder(column: $table.proteinPerKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatPercent =>
      $composableBuilder(column: $table.fatPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fiberTargetG =>
      $composableBuilder(column: $table.fiberTargetG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get waterOverrideMl =>
      $composableBuilder(column: $table.waterOverrideMl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activityCreditPercent =>
      $composableBuilder(column: $table.activityCreditPercent, builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get sex => $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate => $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<double> get heightCm => $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get startWeightKg =>
      $composableBuilder(column: $table.startWeightKg, builder: (column) => column);

  GeneratedColumn<double> get targetWeightKg =>
      $composableBuilder(column: $table.targetWeightKg, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate =>
      $composableBuilder(column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercent =>
      $composableBuilder(column: $table.bodyFatPercent, builder: (column) => column);

  GeneratedColumn<String> get occupation => $composableBuilder(column: $table.occupation, builder: (column) => column);

  GeneratedColumn<String> get jobActivity =>
      $composableBuilder(column: $table.jobActivity, builder: (column) => column);

  GeneratedColumn<int> get sportMinutesPerWeek =>
      $composableBuilder(column: $table.sportMinutesPerWeek, builder: (column) => column);

  GeneratedColumn<String> get sportNote => $composableBuilder(column: $table.sportNote, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(column: $table.sleepHours, builder: (column) => column);

  GeneratedColumn<String> get dietStyle => $composableBuilder(column: $table.dietStyle, builder: (column) => column);

  GeneratedColumn<String> get eatingHabits =>
      $composableBuilder(column: $table.eatingHabits, builder: (column) => column);

  GeneratedColumn<String> get allergiesJson =>
      $composableBuilder(column: $table.allergiesJson, builder: (column) => column);

  GeneratedColumn<String> get preferredFoodsJson =>
      $composableBuilder(column: $table.preferredFoodsJson, builder: (column) => column);

  GeneratedColumn<String> get dislikedFoodsJson =>
      $composableBuilder(column: $table.dislikedFoodsJson, builder: (column) => column);

  GeneratedColumn<int> get calorieOverride =>
      $composableBuilder(column: $table.calorieOverride, builder: (column) => column);

  GeneratedColumn<int> get proteinOverrideG =>
      $composableBuilder(column: $table.proteinOverrideG, builder: (column) => column);

  GeneratedColumn<double> get proteinPerKg =>
      $composableBuilder(column: $table.proteinPerKg, builder: (column) => column);

  GeneratedColumn<double> get fatPercent => $composableBuilder(column: $table.fatPercent, builder: (column) => column);

  GeneratedColumn<double> get fiberTargetG =>
      $composableBuilder(column: $table.fiberTargetG, builder: (column) => column);

  GeneratedColumn<int> get waterOverrideMl =>
      $composableBuilder(column: $table.waterOverrideMl, builder: (column) => column);

  GeneratedColumn<int> get activityCreditPercent =>
      $composableBuilder(column: $table.activityCreditPercent, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> startWeightKg = const Value.absent(),
                Value<double> targetWeightKg = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                Value<String> jobActivity = const Value.absent(),
                Value<int> sportMinutesPerWeek = const Value.absent(),
                Value<String?> sportNote = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> dietStyle = const Value.absent(),
                Value<String?> eatingHabits = const Value.absent(),
                Value<String> allergiesJson = const Value.absent(),
                Value<String> preferredFoodsJson = const Value.absent(),
                Value<String> dislikedFoodsJson = const Value.absent(),
                Value<int?> calorieOverride = const Value.absent(),
                Value<int?> proteinOverrideG = const Value.absent(),
                Value<double> proteinPerKg = const Value.absent(),
                Value<double> fatPercent = const Value.absent(),
                Value<double> fiberTargetG = const Value.absent(),
                Value<int?> waterOverrideMl = const Value.absent(),
                Value<int> activityCreditPercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                displayName: displayName,
                sex: sex,
                birthDate: birthDate,
                heightCm: heightCm,
                startWeightKg: startWeightKg,
                targetWeightKg: targetWeightKg,
                targetDate: targetDate,
                bodyFatPercent: bodyFatPercent,
                occupation: occupation,
                jobActivity: jobActivity,
                sportMinutesPerWeek: sportMinutesPerWeek,
                sportNote: sportNote,
                sleepHours: sleepHours,
                dietStyle: dietStyle,
                eatingHabits: eatingHabits,
                allergiesJson: allergiesJson,
                preferredFoodsJson: preferredFoodsJson,
                dislikedFoodsJson: dislikedFoodsJson,
                calorieOverride: calorieOverride,
                proteinOverrideG: proteinOverrideG,
                proteinPerKg: proteinPerKg,
                fatPercent: fatPercent,
                fiberTargetG: fiberTargetG,
                waterOverrideMl: waterOverrideMl,
                activityCreditPercent: activityCreditPercent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                required String sex,
                required DateTime birthDate,
                required double heightCm,
                required double startWeightKg,
                required double targetWeightKg,
                Value<DateTime?> targetDate = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<String?> occupation = const Value.absent(),
                required String jobActivity,
                Value<int> sportMinutesPerWeek = const Value.absent(),
                Value<String?> sportNote = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> dietStyle = const Value.absent(),
                Value<String?> eatingHabits = const Value.absent(),
                Value<String> allergiesJson = const Value.absent(),
                Value<String> preferredFoodsJson = const Value.absent(),
                Value<String> dislikedFoodsJson = const Value.absent(),
                Value<int?> calorieOverride = const Value.absent(),
                Value<int?> proteinOverrideG = const Value.absent(),
                Value<double> proteinPerKg = const Value.absent(),
                Value<double> fatPercent = const Value.absent(),
                Value<double> fiberTargetG = const Value.absent(),
                Value<int?> waterOverrideMl = const Value.absent(),
                Value<int> activityCreditPercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                displayName: displayName,
                sex: sex,
                birthDate: birthDate,
                heightCm: heightCm,
                startWeightKg: startWeightKg,
                targetWeightKg: targetWeightKg,
                targetDate: targetDate,
                bodyFatPercent: bodyFatPercent,
                occupation: occupation,
                jobActivity: jobActivity,
                sportMinutesPerWeek: sportMinutesPerWeek,
                sportNote: sportNote,
                sleepHours: sleepHours,
                dietStyle: dietStyle,
                eatingHabits: eatingHabits,
                allergiesJson: allergiesJson,
                preferredFoodsJson: preferredFoodsJson,
                dislikedFoodsJson: dislikedFoodsJson,
                calorieOverride: calorieOverride,
                proteinOverrideG: proteinOverrideG,
                proteinPerKg: proteinPerKg,
                fatPercent: fatPercent,
                fiberTargetG: fiberTargetG,
                waterOverrideMl: waterOverrideMl,
                activityCreditPercent: activityCreditPercent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$MealSlotsTableCreateCompanionBuilder = MealSlotsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  Value<int?> minuteOfDay,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$MealSlotsTableUpdateCompanionBuilder = MealSlotsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<int?> minuteOfDay,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$MealSlotsTableFilterComposer extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minuteOfDay =>
      $composableBuilder(column: $table.minuteOfDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$MealSlotsTableOrderingComposer extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minuteOfDay =>
      $composableBuilder(column: $table.minuteOfDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$MealSlotsTableAnnotationComposer extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get minuteOfDay => $composableBuilder(column: $table.minuteOfDay, builder: (column) => column);

  GeneratedColumn<int> get sortOrder => $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$MealSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealSlotsTable,
          MealSlot,
          $$MealSlotsTableFilterComposer,
          $$MealSlotsTableOrderingComposer,
          $$MealSlotsTableAnnotationComposer,
          $$MealSlotsTableCreateCompanionBuilder,
          $$MealSlotsTableUpdateCompanionBuilder,
          (MealSlot, BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlot>),
          MealSlot,
          PrefetchHooks Function()
        > {
  $$MealSlotsTableTableManager(_$AppDatabase db, $MealSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$MealSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$MealSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$MealSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> minuteOfDay = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealSlotsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                minuteOfDay: minuteOfDay,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<int?> minuteOfDay = const Value.absent(),
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => MealSlotsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                minuteOfDay: minuteOfDay,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealSlotsTable, MealSlot>(table),
                  BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlot>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealSlotsTable,
      MealSlot,
      $$MealSlotsTableFilterComposer,
      $$MealSlotsTableOrderingComposer,
      $$MealSlotsTableAnnotationComposer,
      $$MealSlotsTableCreateCompanionBuilder,
      $$MealSlotsTableUpdateCompanionBuilder,
      (MealSlot, BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlot>),
      MealSlot,
      PrefetchHooks Function()
    >;
typedef $$FoodsTableCreateCompanionBuilder = FoodsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  Value<String?> brand,
  required String foodKey,
  Value<String?> barcode,
  Value<String?> category,
  Value<String> unit,
  required double kcal,
  required double protein,
  required double carbs,
  Value<double> sugar,
  required double fat,
  Value<double> saturatedFat,
  Value<double> fiber,
  Value<double> salt,
  Value<double?> servingAmount,
  Value<String?> servingLabel,
  Value<String> source,
  Value<bool> isFavorite,
  Value<int> rowid,
});
typedef $$FoodsTableUpdateCompanionBuilder = FoodsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<String?> brand,
  Value<String> foodKey,
  Value<String?> barcode,
  Value<String?> category,
  Value<String> unit,
  Value<double> kcal,
  Value<double> protein,
  Value<double> carbs,
  Value<double> sugar,
  Value<double> fat,
  Value<double> saturatedFat,
  Value<double> fiber,
  Value<double> salt,
  Value<double?> servingAmount,
  Value<String?> servingLabel,
  Value<String> source,
  Value<bool> isFavorite,
  Value<int> rowid,
});

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodKey =>
      $composableBuilder(column: $table.foodKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kcal => $composableBuilder(column: $table.kcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get saturatedFat =>
      $composableBuilder(column: $table.saturatedFat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salt => $composableBuilder(column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get servingAmount =>
      $composableBuilder(column: $table.servingAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get servingLabel =>
      $composableBuilder(column: $table.servingLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnFilters(column));
}

class $$FoodsTableOrderingComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodKey =>
      $composableBuilder(column: $table.foodKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get saturatedFat =>
      $composableBuilder(column: $table.saturatedFat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get servingAmount =>
      $composableBuilder(column: $table.servingAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get servingLabel =>
      $composableBuilder(column: $table.servingLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite =>
      $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnOrderings(column));
}

class $$FoodsTableAnnotationComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand => $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get foodKey => $composableBuilder(column: $table.foodKey, builder: (column) => column);

  GeneratedColumn<String> get barcode => $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get category => $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit => $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get kcal => $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get protein => $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs => $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get sugar => $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<double> get fat => $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get saturatedFat =>
      $composableBuilder(column: $table.saturatedFat, builder: (column) => column);

  GeneratedColumn<double> get fiber => $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<double> get salt => $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<double> get servingAmount =>
      $composableBuilder(column: $table.servingAmount, builder: (column) => column);

  GeneratedColumn<String> get servingLabel =>
      $composableBuilder(column: $table.servingLabel, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(column: $table.isFavorite, builder: (column) => column);
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          Food,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (Food, BaseReferences<_$AppDatabase, $FoodsTable, Food>),
          Food,
          PrefetchHooks Function()
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> foodKey = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> kcal = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> sugar = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double> saturatedFat = const Value.absent(),
                Value<double> fiber = const Value.absent(),
                Value<double> salt = const Value.absent(),
                Value<double?> servingAmount = const Value.absent(),
                Value<String?> servingLabel = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                brand: brand,
                foodKey: foodKey,
                barcode: barcode,
                category: category,
                unit: unit,
                kcal: kcal,
                protein: protein,
                carbs: carbs,
                sugar: sugar,
                fat: fat,
                saturatedFat: saturatedFat,
                fiber: fiber,
                salt: salt,
                servingAmount: servingAmount,
                servingLabel: servingLabel,
                source: source,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String name,
                Value<String?> brand = const Value.absent(),
                required String foodKey,
                Value<String?> barcode = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> unit = const Value.absent(),
                required double kcal,
                required double protein,
                required double carbs,
                Value<double> sugar = const Value.absent(),
                required double fat,
                Value<double> saturatedFat = const Value.absent(),
                Value<double> fiber = const Value.absent(),
                Value<double> salt = const Value.absent(),
                Value<double?> servingAmount = const Value.absent(),
                Value<String?> servingLabel = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                brand: brand,
                foodKey: foodKey,
                barcode: barcode,
                category: category,
                unit: unit,
                kcal: kcal,
                protein: protein,
                carbs: carbs,
                sugar: sugar,
                fat: fat,
                saturatedFat: saturatedFat,
                fiber: fiber,
                salt: salt,
                servingAmount: servingAmount,
                servingLabel: servingLabel,
                source: source,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodsTable, Food>(table),
                  BaseReferences<_$AppDatabase, $FoodsTable, Food>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      Food,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (Food, BaseReferences<_$AppDatabase, $FoodsTable, Food>),
      Food,
      PrefetchHooks Function()
    >;
typedef $$DiaryEntriesTableCreateCompanionBuilder = DiaryEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String dayKey,
  required String mealSlotId,
  Value<String?> foodId,
  required String foodName,
  Value<String?> brand,
  required String unit,
  required double amount,
  required double kcal100,
  required double protein100,
  required double carbs100,
  required double sugar100,
  required double fat100,
  required double saturatedFat100,
  required double fiber100,
  required double salt100,
  Value<int> rowid,
});
typedef $$DiaryEntriesTableUpdateCompanionBuilder = DiaryEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> dayKey,
  Value<String> mealSlotId,
  Value<String?> foodId,
  Value<String> foodName,
  Value<String?> brand,
  Value<String> unit,
  Value<double> amount,
  Value<double> kcal100,
  Value<double> protein100,
  Value<double> carbs100,
  Value<double> sugar100,
  Value<double> fat100,
  Value<double> saturatedFat100,
  Value<double> fiber100,
  Value<double> salt100,
  Value<int> rowid,
});

class $$DiaryEntriesTableFilterComposer extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealSlotId =>
      $composableBuilder(column: $table.mealSlotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kcal100 =>
      $composableBuilder(column: $table.kcal100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein100 =>
      $composableBuilder(column: $table.protein100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs100 =>
      $composableBuilder(column: $table.carbs100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sugar100 =>
      $composableBuilder(column: $table.sugar100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat100 =>
      $composableBuilder(column: $table.fat100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get saturatedFat100 =>
      $composableBuilder(column: $table.saturatedFat100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fiber100 =>
      $composableBuilder(column: $table.fiber100, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get salt100 =>
      $composableBuilder(column: $table.salt100, builder: (column) => ColumnFilters(column));
}

class $$DiaryEntriesTableOrderingComposer extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealSlotId =>
      $composableBuilder(column: $table.mealSlotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kcal100 =>
      $composableBuilder(column: $table.kcal100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein100 =>
      $composableBuilder(column: $table.protein100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs100 =>
      $composableBuilder(column: $table.carbs100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sugar100 =>
      $composableBuilder(column: $table.sugar100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat100 =>
      $composableBuilder(column: $table.fat100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get saturatedFat100 =>
      $composableBuilder(column: $table.saturatedFat100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fiber100 =>
      $composableBuilder(column: $table.fiber100, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get salt100 =>
      $composableBuilder(column: $table.salt100, builder: (column) => ColumnOrderings(column));
}

class $$DiaryEntriesTableAnnotationComposer extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey => $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get mealSlotId => $composableBuilder(column: $table.mealSlotId, builder: (column) => column);

  GeneratedColumn<String> get foodId => $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get foodName => $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get brand => $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get unit => $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get amount => $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get kcal100 => $composableBuilder(column: $table.kcal100, builder: (column) => column);

  GeneratedColumn<double> get protein100 => $composableBuilder(column: $table.protein100, builder: (column) => column);

  GeneratedColumn<double> get carbs100 => $composableBuilder(column: $table.carbs100, builder: (column) => column);

  GeneratedColumn<double> get sugar100 => $composableBuilder(column: $table.sugar100, builder: (column) => column);

  GeneratedColumn<double> get fat100 => $composableBuilder(column: $table.fat100, builder: (column) => column);

  GeneratedColumn<double> get saturatedFat100 =>
      $composableBuilder(column: $table.saturatedFat100, builder: (column) => column);

  GeneratedColumn<double> get fiber100 => $composableBuilder(column: $table.fiber100, builder: (column) => column);

  GeneratedColumn<double> get salt100 => $composableBuilder(column: $table.salt100, builder: (column) => column);
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryEntriesTable,
          DiaryEntry,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (DiaryEntry, BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>),
          DiaryEntry,
          PrefetchHooks Function()
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> mealSlotId = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> kcal100 = const Value.absent(),
                Value<double> protein100 = const Value.absent(),
                Value<double> carbs100 = const Value.absent(),
                Value<double> sugar100 = const Value.absent(),
                Value<double> fat100 = const Value.absent(),
                Value<double> saturatedFat100 = const Value.absent(),
                Value<double> fiber100 = const Value.absent(),
                Value<double> salt100 = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                mealSlotId: mealSlotId,
                foodId: foodId,
                foodName: foodName,
                brand: brand,
                unit: unit,
                amount: amount,
                kcal100: kcal100,
                protein100: protein100,
                carbs100: carbs100,
                sugar100: sugar100,
                fat100: fat100,
                saturatedFat100: saturatedFat100,
                fiber100: fiber100,
                salt100: salt100,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String dayKey,
                required String mealSlotId,
                Value<String?> foodId = const Value.absent(),
                required String foodName,
                Value<String?> brand = const Value.absent(),
                required String unit,
                required double amount,
                required double kcal100,
                required double protein100,
                required double carbs100,
                required double sugar100,
                required double fat100,
                required double saturatedFat100,
                required double fiber100,
                required double salt100,
                Value<int> rowid = const Value.absent(),
              }) => DiaryEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                mealSlotId: mealSlotId,
                foodId: foodId,
                foodName: foodName,
                brand: brand,
                unit: unit,
                amount: amount,
                kcal100: kcal100,
                protein100: protein100,
                carbs100: carbs100,
                sugar100: sugar100,
                fat100: fat100,
                saturatedFat100: saturatedFat100,
                fiber100: fiber100,
                salt100: salt100,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiaryEntriesTable, DiaryEntry>(table),
                  BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryEntriesTable,
      DiaryEntry,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (DiaryEntry, BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>),
      DiaryEntry,
      PrefetchHooks Function()
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder = WeightEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String dayKey,
  required double weightKg,
  Value<double?> bodyFatPercent,
  Value<double?> waistCm,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$WeightEntriesTableUpdateCompanionBuilder = WeightEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> dayKey,
  Value<double> weightKg,
  Value<double?> bodyFatPercent,
  Value<double?> waistCm,
  Value<String?> note,
  Value<int> rowid,
});

class $$WeightEntriesTableFilterComposer extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bodyFatPercent =>
      $composableBuilder(column: $table.bodyFatPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));
}

class $$WeightEntriesTableOrderingComposer extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bodyFatPercent =>
      $composableBuilder(column: $table.bodyFatPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));
}

class $$WeightEntriesTableAnnotationComposer extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey => $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<double> get weightKg => $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercent =>
      $composableBuilder(column: $table.bodyFatPercent, builder: (column) => column);

  GeneratedColumn<double> get waistCm => $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$WeightEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightEntriesTable,
          WeightEntry,
          $$WeightEntriesTableFilterComposer,
          $$WeightEntriesTableOrderingComposer,
          $$WeightEntriesTableAnnotationComposer,
          $$WeightEntriesTableCreateCompanionBuilder,
          $$WeightEntriesTableUpdateCompanionBuilder,
          (WeightEntry, BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>),
          WeightEntry,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                weightKg: weightKg,
                bodyFatPercent: bodyFatPercent,
                waistCm: waistCm,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String dayKey,
                required double weightKg,
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                weightKg: weightKg,
                bodyFatPercent: bodyFatPercent,
                waistCm: waistCm,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeightEntriesTable, WeightEntry>(table),
                  BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightEntriesTable,
      WeightEntry,
      $$WeightEntriesTableFilterComposer,
      $$WeightEntriesTableOrderingComposer,
      $$WeightEntriesTableAnnotationComposer,
      $$WeightEntriesTableCreateCompanionBuilder,
      $$WeightEntriesTableUpdateCompanionBuilder,
      (WeightEntry, BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>),
      WeightEntry,
      PrefetchHooks Function()
    >;
typedef $$WaterEntriesTableCreateCompanionBuilder = WaterEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String dayKey,
  required int ml,
  Value<int> rowid,
});
typedef $$WaterEntriesTableUpdateCompanionBuilder = WaterEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> dayKey,
  Value<int> ml,
  Value<int> rowid,
});

class $$WaterEntriesTableFilterComposer extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ml => $composableBuilder(column: $table.ml, builder: (column) => ColumnFilters(column));
}

class $$WaterEntriesTableOrderingComposer extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ml => $composableBuilder(column: $table.ml, builder: (column) => ColumnOrderings(column));
}

class $$WaterEntriesTableAnnotationComposer extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey => $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get ml => $composableBuilder(column: $table.ml, builder: (column) => column);
}

class $$WaterEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterEntriesTable,
          WaterEntry,
          $$WaterEntriesTableFilterComposer,
          $$WaterEntriesTableOrderingComposer,
          $$WaterEntriesTableAnnotationComposer,
          $$WaterEntriesTableCreateCompanionBuilder,
          $$WaterEntriesTableUpdateCompanionBuilder,
          (WaterEntry, BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>),
          WaterEntry,
          PrefetchHooks Function()
        > {
  $$WaterEntriesTableTableManager(_$AppDatabase db, $WaterEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$WaterEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$WaterEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$WaterEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<int> ml = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                ml: ml,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String dayKey,
                required int ml,
                Value<int> rowid = const Value.absent(),
              }) => WaterEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                ml: ml,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WaterEntriesTable, WaterEntry>(table),
                  BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterEntriesTable,
      WaterEntry,
      $$WaterEntriesTableFilterComposer,
      $$WaterEntriesTableOrderingComposer,
      $$WaterEntriesTableAnnotationComposer,
      $$WaterEntriesTableCreateCompanionBuilder,
      $$WaterEntriesTableUpdateCompanionBuilder,
      (WaterEntry, BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>),
      WaterEntry,
      PrefetchHooks Function()
    >;
typedef $$ActivityEntriesTableCreateCompanionBuilder = ActivityEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String dayKey,
  required String label,
  Value<int> minutes,
  Value<double> kcal,
  Value<int?> steps,
  Value<String> source,
  Value<String?> externalId,
  Value<int> rowid,
});
typedef $$ActivityEntriesTableUpdateCompanionBuilder = ActivityEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> dayKey,
  Value<String> label,
  Value<int> minutes,
  Value<double> kcal,
  Value<int?> steps,
  Value<String> source,
  Value<String?> externalId,
  Value<int> rowid,
});

class $$ActivityEntriesTableFilterComposer extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kcal => $composableBuilder(column: $table.kcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalId =>
      $composableBuilder(column: $table.externalId, builder: (column) => ColumnFilters(column));
}

class $$ActivityEntriesTableOrderingComposer extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalId =>
      $composableBuilder(column: $table.externalId, builder: (column) => ColumnOrderings(column));
}

class $$ActivityEntriesTableAnnotationComposer extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt => $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey => $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get label => $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get minutes => $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<double> get kcal => $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<int> get steps => $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get source => $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(column: $table.externalId, builder: (column) => column);
}

class $$ActivityEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityEntriesTable,
          ActivityEntry,
          $$ActivityEntriesTableFilterComposer,
          $$ActivityEntriesTableOrderingComposer,
          $$ActivityEntriesTableAnnotationComposer,
          $$ActivityEntriesTableCreateCompanionBuilder,
          $$ActivityEntriesTableUpdateCompanionBuilder,
          (ActivityEntry, BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityEntry>),
          ActivityEntry,
          PrefetchHooks Function()
        > {
  $$ActivityEntriesTableTableManager(_$AppDatabase db, $ActivityEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ActivityEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ActivityEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ActivityEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<double> kcal = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                label: label,
                minutes: minutes,
                kcal: kcal,
                steps: steps,
                source: source,
                externalId: externalId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String dayKey,
                required String label,
                Value<int> minutes = const Value.absent(),
                Value<double> kcal = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                label: label,
                minutes: minutes,
                kcal: kcal,
                steps: steps,
                source: source,
                externalId: externalId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivityEntriesTable, ActivityEntry>(table),
                  BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityEntriesTable,
      ActivityEntry,
      $$ActivityEntriesTableFilterComposer,
      $$ActivityEntriesTableOrderingComposer,
      $$ActivityEntriesTableAnnotationComposer,
      $$ActivityEntriesTableCreateCompanionBuilder,
      $$ActivityEntriesTableUpdateCompanionBuilder,
      (ActivityEntry, BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityEntry>),
      ActivityEntry,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles => $$ProfilesTableTableManager(_db, _db.profiles);
  $$MealSlotsTableTableManager get mealSlots => $$MealSlotsTableTableManager(_db, _db.mealSlots);
  $$FoodsTableTableManager get foods => $$FoodsTableTableManager(_db, _db.foods);
  $$DiaryEntriesTableTableManager get diaryEntries => $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
  $$WeightEntriesTableTableManager get weightEntries => $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$WaterEntriesTableTableManager get waterEntries => $$WaterEntriesTableTableManager(_db, _db.waterEntries);
  $$ActivityEntriesTableTableManager get activityEntries =>
      $$ActivityEntriesTableTableManager(_db, _db.activityEntries);
  $$SettingsTableTableManager get settings => $$SettingsTableTableManager(_db, _db.settings);
}
