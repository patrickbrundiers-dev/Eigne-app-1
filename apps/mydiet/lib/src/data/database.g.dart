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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
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
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startWeightKgMeta = const VerificationMeta(
    'startWeightKg',
  );
  @override
  late final GeneratedColumn<double> startWeightKg = GeneratedColumn<double>(
    'start_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta(
    'bodyFatPercent',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupationMeta = const VerificationMeta(
    'occupation',
  );
  @override
  late final GeneratedColumn<String> occupation = GeneratedColumn<String>(
    'occupation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _jobActivityMeta = const VerificationMeta(
    'jobActivity',
  );
  @override
  late final GeneratedColumn<String> jobActivity = GeneratedColumn<String>(
    'job_activity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sportMinutesPerWeekMeta =
      const VerificationMeta('sportMinutesPerWeek');
  @override
  late final GeneratedColumn<int> sportMinutesPerWeek = GeneratedColumn<int>(
    'sport_minutes_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sportNoteMeta = const VerificationMeta(
    'sportNote',
  );
  @override
  late final GeneratedColumn<String> sportNote = GeneratedColumn<String>(
    'sport_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dietStyleMeta = const VerificationMeta(
    'dietStyle',
  );
  @override
  late final GeneratedColumn<String> dietStyle = GeneratedColumn<String>(
    'diet_style',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eatingHabitsMeta = const VerificationMeta(
    'eatingHabits',
  );
  @override
  late final GeneratedColumn<String> eatingHabits = GeneratedColumn<String>(
    'eating_habits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesJsonMeta = const VerificationMeta(
    'allergiesJson',
  );
  @override
  late final GeneratedColumn<String> allergiesJson = GeneratedColumn<String>(
    'allergies_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _preferredFoodsJsonMeta =
      const VerificationMeta('preferredFoodsJson');
  @override
  late final GeneratedColumn<String> preferredFoodsJson =
      GeneratedColumn<String>(
        'preferred_foods_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _dislikedFoodsJsonMeta = const VerificationMeta(
    'dislikedFoodsJson',
  );
  @override
  late final GeneratedColumn<String> dislikedFoodsJson =
      GeneratedColumn<String>(
        'disliked_foods_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _calorieOverrideMeta = const VerificationMeta(
    'calorieOverride',
  );
  @override
  late final GeneratedColumn<int> calorieOverride = GeneratedColumn<int>(
    'calorie_override',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinOverrideGMeta = const VerificationMeta(
    'proteinOverrideG',
  );
  @override
  late final GeneratedColumn<int> proteinOverrideG = GeneratedColumn<int>(
    'protein_override_g',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinPerKgMeta = const VerificationMeta(
    'proteinPerKg',
  );
  @override
  late final GeneratedColumn<double> proteinPerKg = GeneratedColumn<double>(
    'protein_per_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.8),
  );
  static const VerificationMeta _fatPercentMeta = const VerificationMeta(
    'fatPercent',
  );
  @override
  late final GeneratedColumn<double> fatPercent = GeneratedColumn<double>(
    'fat_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _carbCapGMeta = const VerificationMeta(
    'carbCapG',
  );
  @override
  late final GeneratedColumn<double> carbCapG = GeneratedColumn<double>(
    'carb_cap_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiberTargetGMeta = const VerificationMeta(
    'fiberTargetG',
  );
  @override
  late final GeneratedColumn<double> fiberTargetG = GeneratedColumn<double>(
    'fiber_target_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _waterOverrideMlMeta = const VerificationMeta(
    'waterOverrideMl',
  );
  @override
  late final GeneratedColumn<int> waterOverrideMl = GeneratedColumn<int>(
    'water_override_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityCreditPercentMeta =
      const VerificationMeta('activityCreditPercent');
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
    carbCapG,
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
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('start_weight_kg')) {
      context.handle(
        _startWeightKgMeta,
        startWeightKg.isAcceptableOrUnknown(
          data['start_weight_kg']!,
          _startWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startWeightKgMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetWeightKgMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(
          data['body_fat_percent']!,
          _bodyFatPercentMeta,
        ),
      );
    }
    if (data.containsKey('occupation')) {
      context.handle(
        _occupationMeta,
        occupation.isAcceptableOrUnknown(data['occupation']!, _occupationMeta),
      );
    }
    if (data.containsKey('job_activity')) {
      context.handle(
        _jobActivityMeta,
        jobActivity.isAcceptableOrUnknown(
          data['job_activity']!,
          _jobActivityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jobActivityMeta);
    }
    if (data.containsKey('sport_minutes_per_week')) {
      context.handle(
        _sportMinutesPerWeekMeta,
        sportMinutesPerWeek.isAcceptableOrUnknown(
          data['sport_minutes_per_week']!,
          _sportMinutesPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('sport_note')) {
      context.handle(
        _sportNoteMeta,
        sportNote.isAcceptableOrUnknown(data['sport_note']!, _sportNoteMeta),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('diet_style')) {
      context.handle(
        _dietStyleMeta,
        dietStyle.isAcceptableOrUnknown(data['diet_style']!, _dietStyleMeta),
      );
    }
    if (data.containsKey('eating_habits')) {
      context.handle(
        _eatingHabitsMeta,
        eatingHabits.isAcceptableOrUnknown(
          data['eating_habits']!,
          _eatingHabitsMeta,
        ),
      );
    }
    if (data.containsKey('allergies_json')) {
      context.handle(
        _allergiesJsonMeta,
        allergiesJson.isAcceptableOrUnknown(
          data['allergies_json']!,
          _allergiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('preferred_foods_json')) {
      context.handle(
        _preferredFoodsJsonMeta,
        preferredFoodsJson.isAcceptableOrUnknown(
          data['preferred_foods_json']!,
          _preferredFoodsJsonMeta,
        ),
      );
    }
    if (data.containsKey('disliked_foods_json')) {
      context.handle(
        _dislikedFoodsJsonMeta,
        dislikedFoodsJson.isAcceptableOrUnknown(
          data['disliked_foods_json']!,
          _dislikedFoodsJsonMeta,
        ),
      );
    }
    if (data.containsKey('calorie_override')) {
      context.handle(
        _calorieOverrideMeta,
        calorieOverride.isAcceptableOrUnknown(
          data['calorie_override']!,
          _calorieOverrideMeta,
        ),
      );
    }
    if (data.containsKey('protein_override_g')) {
      context.handle(
        _proteinOverrideGMeta,
        proteinOverrideG.isAcceptableOrUnknown(
          data['protein_override_g']!,
          _proteinOverrideGMeta,
        ),
      );
    }
    if (data.containsKey('protein_per_kg')) {
      context.handle(
        _proteinPerKgMeta,
        proteinPerKg.isAcceptableOrUnknown(
          data['protein_per_kg']!,
          _proteinPerKgMeta,
        ),
      );
    }
    if (data.containsKey('fat_percent')) {
      context.handle(
        _fatPercentMeta,
        fatPercent.isAcceptableOrUnknown(data['fat_percent']!, _fatPercentMeta),
      );
    }
    if (data.containsKey('carb_cap_g')) {
      context.handle(
        _carbCapGMeta,
        carbCapG.isAcceptableOrUnknown(data['carb_cap_g']!, _carbCapGMeta),
      );
    }
    if (data.containsKey('fiber_target_g')) {
      context.handle(
        _fiberTargetGMeta,
        fiberTargetG.isAcceptableOrUnknown(
          data['fiber_target_g']!,
          _fiberTargetGMeta,
        ),
      );
    }
    if (data.containsKey('water_override_ml')) {
      context.handle(
        _waterOverrideMlMeta,
        waterOverrideMl.isAcceptableOrUnknown(
          data['water_override_ml']!,
          _waterOverrideMlMeta,
        ),
      );
    }
    if (data.containsKey('activity_credit_percent')) {
      context.handle(
        _activityCreditPercentMeta,
        activityCreditPercent.isAcceptableOrUnknown(
          data['activity_credit_percent']!,
          _activityCreditPercentMeta,
        ),
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      startWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_weight_kg'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      ),
      occupation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupation'],
      ),
      jobActivity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_activity'],
      )!,
      sportMinutesPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sport_minutes_per_week'],
      )!,
      sportNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sport_note'],
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      dietStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_style'],
      ),
      eatingHabits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}eating_habits'],
      ),
      allergiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies_json'],
      )!,
      preferredFoodsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_foods_json'],
      )!,
      dislikedFoodsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}disliked_foods_json'],
      )!,
      calorieOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calorie_override'],
      ),
      proteinOverrideG: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein_override_g'],
      ),
      proteinPerKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per_kg'],
      )!,
      fatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_percent'],
      )!,
      carbCapG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carb_cap_g'],
      ),
      fiberTargetG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_target_g'],
      )!,
      waterOverrideMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_override_ml'],
      ),
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

  /// Upper limit for carbohydrates in g (schema 4), e.g. low carb.
  final double? carbCapG;
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
    this.carbCapG,
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
    if (!nullToAbsent || carbCapG != null) {
      map['carb_cap_g'] = Variable<double>(carbCapG);
    }
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
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      sex: Value(sex),
      birthDate: Value(birthDate),
      heightCm: Value(heightCm),
      startWeightKg: Value(startWeightKg),
      targetWeightKg: Value(targetWeightKg),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      bodyFatPercent: bodyFatPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercent),
      occupation: occupation == null && nullToAbsent
          ? const Value.absent()
          : Value(occupation),
      jobActivity: Value(jobActivity),
      sportMinutesPerWeek: Value(sportMinutesPerWeek),
      sportNote: sportNote == null && nullToAbsent
          ? const Value.absent()
          : Value(sportNote),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      dietStyle: dietStyle == null && nullToAbsent
          ? const Value.absent()
          : Value(dietStyle),
      eatingHabits: eatingHabits == null && nullToAbsent
          ? const Value.absent()
          : Value(eatingHabits),
      allergiesJson: Value(allergiesJson),
      preferredFoodsJson: Value(preferredFoodsJson),
      dislikedFoodsJson: Value(dislikedFoodsJson),
      calorieOverride: calorieOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieOverride),
      proteinOverrideG: proteinOverrideG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinOverrideG),
      proteinPerKg: Value(proteinPerKg),
      fatPercent: Value(fatPercent),
      carbCapG: carbCapG == null && nullToAbsent
          ? const Value.absent()
          : Value(carbCapG),
      fiberTargetG: Value(fiberTargetG),
      waterOverrideMl: waterOverrideMl == null && nullToAbsent
          ? const Value.absent()
          : Value(waterOverrideMl),
      activityCreditPercent: Value(activityCreditPercent),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      sportMinutesPerWeek: serializer.fromJson<int>(
        json['sportMinutesPerWeek'],
      ),
      sportNote: serializer.fromJson<String?>(json['sportNote']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      dietStyle: serializer.fromJson<String?>(json['dietStyle']),
      eatingHabits: serializer.fromJson<String?>(json['eatingHabits']),
      allergiesJson: serializer.fromJson<String>(json['allergiesJson']),
      preferredFoodsJson: serializer.fromJson<String>(
        json['preferredFoodsJson'],
      ),
      dislikedFoodsJson: serializer.fromJson<String>(json['dislikedFoodsJson']),
      calorieOverride: serializer.fromJson<int?>(json['calorieOverride']),
      proteinOverrideG: serializer.fromJson<int?>(json['proteinOverrideG']),
      proteinPerKg: serializer.fromJson<double>(json['proteinPerKg']),
      fatPercent: serializer.fromJson<double>(json['fatPercent']),
      carbCapG: serializer.fromJson<double?>(json['carbCapG']),
      fiberTargetG: serializer.fromJson<double>(json['fiberTargetG']),
      waterOverrideMl: serializer.fromJson<int?>(json['waterOverrideMl']),
      activityCreditPercent: serializer.fromJson<int>(
        json['activityCreditPercent'],
      ),
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
      'carbCapG': serializer.toJson<double?>(carbCapG),
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
    Value<double?> carbCapG = const Value.absent(),
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
    bodyFatPercent: bodyFatPercent.present
        ? bodyFatPercent.value
        : this.bodyFatPercent,
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
    calorieOverride: calorieOverride.present
        ? calorieOverride.value
        : this.calorieOverride,
    proteinOverrideG: proteinOverrideG.present
        ? proteinOverrideG.value
        : this.proteinOverrideG,
    proteinPerKg: proteinPerKg ?? this.proteinPerKg,
    fatPercent: fatPercent ?? this.fatPercent,
    carbCapG: carbCapG.present ? carbCapG.value : this.carbCapG,
    fiberTargetG: fiberTargetG ?? this.fiberTargetG,
    waterOverrideMl: waterOverrideMl.present
        ? waterOverrideMl.value
        : this.waterOverrideMl,
    activityCreditPercent: activityCreditPercent ?? this.activityCreditPercent,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      startWeightKg: data.startWeightKg.present
          ? data.startWeightKg.value
          : this.startWeightKg,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      bodyFatPercent: data.bodyFatPercent.present
          ? data.bodyFatPercent.value
          : this.bodyFatPercent,
      occupation: data.occupation.present
          ? data.occupation.value
          : this.occupation,
      jobActivity: data.jobActivity.present
          ? data.jobActivity.value
          : this.jobActivity,
      sportMinutesPerWeek: data.sportMinutesPerWeek.present
          ? data.sportMinutesPerWeek.value
          : this.sportMinutesPerWeek,
      sportNote: data.sportNote.present ? data.sportNote.value : this.sportNote,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      dietStyle: data.dietStyle.present ? data.dietStyle.value : this.dietStyle,
      eatingHabits: data.eatingHabits.present
          ? data.eatingHabits.value
          : this.eatingHabits,
      allergiesJson: data.allergiesJson.present
          ? data.allergiesJson.value
          : this.allergiesJson,
      preferredFoodsJson: data.preferredFoodsJson.present
          ? data.preferredFoodsJson.value
          : this.preferredFoodsJson,
      dislikedFoodsJson: data.dislikedFoodsJson.present
          ? data.dislikedFoodsJson.value
          : this.dislikedFoodsJson,
      calorieOverride: data.calorieOverride.present
          ? data.calorieOverride.value
          : this.calorieOverride,
      proteinOverrideG: data.proteinOverrideG.present
          ? data.proteinOverrideG.value
          : this.proteinOverrideG,
      proteinPerKg: data.proteinPerKg.present
          ? data.proteinPerKg.value
          : this.proteinPerKg,
      fatPercent: data.fatPercent.present
          ? data.fatPercent.value
          : this.fatPercent,
      carbCapG: data.carbCapG.present ? data.carbCapG.value : this.carbCapG,
      fiberTargetG: data.fiberTargetG.present
          ? data.fiberTargetG.value
          : this.fiberTargetG,
      waterOverrideMl: data.waterOverrideMl.present
          ? data.waterOverrideMl.value
          : this.waterOverrideMl,
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
          ..write('carbCapG: $carbCapG, ')
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
    carbCapG,
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
          other.carbCapG == this.carbCapG &&
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
  final Value<double?> carbCapG;
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
    this.carbCapG = const Value.absent(),
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
    this.carbCapG = const Value.absent(),
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
    Expression<double>? carbCapG,
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
      if (sportMinutesPerWeek != null)
        'sport_minutes_per_week': sportMinutesPerWeek,
      if (sportNote != null) 'sport_note': sportNote,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (dietStyle != null) 'diet_style': dietStyle,
      if (eatingHabits != null) 'eating_habits': eatingHabits,
      if (allergiesJson != null) 'allergies_json': allergiesJson,
      if (preferredFoodsJson != null)
        'preferred_foods_json': preferredFoodsJson,
      if (dislikedFoodsJson != null) 'disliked_foods_json': dislikedFoodsJson,
      if (calorieOverride != null) 'calorie_override': calorieOverride,
      if (proteinOverrideG != null) 'protein_override_g': proteinOverrideG,
      if (proteinPerKg != null) 'protein_per_kg': proteinPerKg,
      if (fatPercent != null) 'fat_percent': fatPercent,
      if (carbCapG != null) 'carb_cap_g': carbCapG,
      if (fiberTargetG != null) 'fiber_target_g': fiberTargetG,
      if (waterOverrideMl != null) 'water_override_ml': waterOverrideMl,
      if (activityCreditPercent != null)
        'activity_credit_percent': activityCreditPercent,
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
    Value<double?>? carbCapG,
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
      carbCapG: carbCapG ?? this.carbCapG,
      fiberTargetG: fiberTargetG ?? this.fiberTargetG,
      waterOverrideMl: waterOverrideMl ?? this.waterOverrideMl,
      activityCreditPercent:
          activityCreditPercent ?? this.activityCreditPercent,
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
    if (carbCapG.present) {
      map['carb_cap_g'] = Variable<double>(carbCapG.value);
    }
    if (fiberTargetG.present) {
      map['fiber_target_g'] = Variable<double>(fiberTargetG.value);
    }
    if (waterOverrideMl.present) {
      map['water_override_ml'] = Variable<int>(waterOverrideMl.value);
    }
    if (activityCreditPercent.present) {
      map['activity_credit_percent'] = Variable<int>(
        activityCreditPercent.value,
      );
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
          ..write('carbCapG: $carbCapG, ')
          ..write('fiberTargetG: $fiberTargetG, ')
          ..write('waterOverrideMl: $waterOverrideMl, ')
          ..write('activityCreditPercent: $activityCreditPercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealSlotsTable extends MealSlots
    with TableInfo<$MealSlotsTable, MealSlot> {
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteOfDayMeta = const VerificationMeta(
    'minuteOfDay',
  );
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
    'minute_of_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    minuteOfDay,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealSlot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
        _minuteOfDayMeta,
        minuteOfDay.isAcceptableOrUnknown(
          data['minute_of_day']!,
          _minuteOfDayMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      minuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute_of_day'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
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
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      minuteOfDay: minuteOfDay == null && nullToAbsent
          ? const Value.absent()
          : Value(minuteOfDay),
      sortOrder: Value(sortOrder),
    );
  }

  factory MealSlot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      minuteOfDay: data.minuteOfDay.present
          ? data.minuteOfDay.value
          : this.minuteOfDay,
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
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    minuteOfDay,
    sortOrder,
  );
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
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
  static const VerificationMeta _foodKeyMeta = const VerificationMeta(
    'foodKey',
  );
  @override
  late final GeneratedColumn<String> foodKey = GeneratedColumn<String>(
    'food_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
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
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
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
  static const VerificationMeta _saturatedFatMeta = const VerificationMeta(
    'saturatedFat',
  );
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
  static const VerificationMeta _servingAmountMeta = const VerificationMeta(
    'servingAmount',
  );
  @override
  late final GeneratedColumn<double> servingAmount = GeneratedColumn<double>(
    'serving_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingLabelMeta = const VerificationMeta(
    'servingLabel',
  );
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
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
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
  VerificationContext validateIntegrity(
    Insertable<Food> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('food_key')) {
      context.handle(
        _foodKeyMeta,
        foodKey.isAcceptableOrUnknown(data['food_key']!, _foodKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_foodKeyMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('kcal')) {
      context.handle(
        _kcalMeta,
        kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta),
      );
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(
        _sugarMeta,
        sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta),
      );
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('saturated_fat')) {
      context.handle(
        _saturatedFatMeta,
        saturatedFat.isAcceptableOrUnknown(
          data['saturated_fat']!,
          _saturatedFatMeta,
        ),
      );
    }
    if (data.containsKey('fiber')) {
      context.handle(
        _fiberMeta,
        fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta),
      );
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    }
    if (data.containsKey('serving_amount')) {
      context.handle(
        _servingAmountMeta,
        servingAmount.isAcceptableOrUnknown(
          data['serving_amount']!,
          _servingAmountMeta,
        ),
      );
    }
    if (data.containsKey('serving_label')) {
      context.handle(
        _servingLabelMeta,
        servingLabel.isAcceptableOrUnknown(
          data['serving_label']!,
          _servingLabelMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      foodKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_key'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      kcal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      sugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      saturatedFat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturated_fat'],
      )!,
      fiber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber'],
      )!,
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salt'],
      )!,
      servingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_amount'],
      ),
      servingLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_label'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
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
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      foodKey: Value(foodKey),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      unit: Value(unit),
      kcal: Value(kcal),
      protein: Value(protein),
      carbs: Value(carbs),
      sugar: Value(sugar),
      fat: Value(fat),
      saturatedFat: Value(saturatedFat),
      fiber: Value(fiber),
      salt: Value(salt),
      servingAmount: servingAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(servingAmount),
      servingLabel: servingLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(servingLabel),
      source: Value(source),
      isFavorite: Value(isFavorite),
    );
  }

  factory Food.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
    servingAmount: servingAmount.present
        ? servingAmount.value
        : this.servingAmount,
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
      saturatedFat: data.saturatedFat.present
          ? data.saturatedFat.value
          : this.saturatedFat,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      salt: data.salt.present ? data.salt.value : this.salt,
      servingAmount: data.servingAmount.present
          ? data.servingAmount.value
          : this.servingAmount,
      servingLabel: data.servingLabel.present
          ? data.servingLabel.value
          : this.servingLabel,
      source: data.source.present ? data.source.value : this.source,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
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

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntry> {
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
  static const VerificationMeta _mealSlotIdMeta = const VerificationMeta(
    'mealSlotId',
  );
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
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
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
  static const VerificationMeta _kcal100Meta = const VerificationMeta(
    'kcal100',
  );
  @override
  late final GeneratedColumn<double> kcal100 = GeneratedColumn<double>(
    'kcal100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protein100Meta = const VerificationMeta(
    'protein100',
  );
  @override
  late final GeneratedColumn<double> protein100 = GeneratedColumn<double>(
    'protein100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbs100Meta = const VerificationMeta(
    'carbs100',
  );
  @override
  late final GeneratedColumn<double> carbs100 = GeneratedColumn<double>(
    'carbs100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugar100Meta = const VerificationMeta(
    'sugar100',
  );
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
  static const VerificationMeta _saturatedFat100Meta = const VerificationMeta(
    'saturatedFat100',
  );
  @override
  late final GeneratedColumn<double> saturatedFat100 = GeneratedColumn<double>(
    'saturated_fat100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiber100Meta = const VerificationMeta(
    'fiber100',
  );
  @override
  late final GeneratedColumn<double> fiber100 = GeneratedColumn<double>(
    'fiber100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salt100Meta = const VerificationMeta(
    'salt100',
  );
  @override
  late final GeneratedColumn<double> salt100 = GeneratedColumn<double>(
    'salt100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
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
    recipeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('meal_slot_id')) {
      context.handle(
        _mealSlotIdMeta,
        mealSlotId.isAcceptableOrUnknown(
          data['meal_slot_id']!,
          _mealSlotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealSlotIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('kcal100')) {
      context.handle(
        _kcal100Meta,
        kcal100.isAcceptableOrUnknown(data['kcal100']!, _kcal100Meta),
      );
    } else if (isInserting) {
      context.missing(_kcal100Meta);
    }
    if (data.containsKey('protein100')) {
      context.handle(
        _protein100Meta,
        protein100.isAcceptableOrUnknown(data['protein100']!, _protein100Meta),
      );
    } else if (isInserting) {
      context.missing(_protein100Meta);
    }
    if (data.containsKey('carbs100')) {
      context.handle(
        _carbs100Meta,
        carbs100.isAcceptableOrUnknown(data['carbs100']!, _carbs100Meta),
      );
    } else if (isInserting) {
      context.missing(_carbs100Meta);
    }
    if (data.containsKey('sugar100')) {
      context.handle(
        _sugar100Meta,
        sugar100.isAcceptableOrUnknown(data['sugar100']!, _sugar100Meta),
      );
    } else if (isInserting) {
      context.missing(_sugar100Meta);
    }
    if (data.containsKey('fat100')) {
      context.handle(
        _fat100Meta,
        fat100.isAcceptableOrUnknown(data['fat100']!, _fat100Meta),
      );
    } else if (isInserting) {
      context.missing(_fat100Meta);
    }
    if (data.containsKey('saturated_fat100')) {
      context.handle(
        _saturatedFat100Meta,
        saturatedFat100.isAcceptableOrUnknown(
          data['saturated_fat100']!,
          _saturatedFat100Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saturatedFat100Meta);
    }
    if (data.containsKey('fiber100')) {
      context.handle(
        _fiber100Meta,
        fiber100.isAcceptableOrUnknown(data['fiber100']!, _fiber100Meta),
      );
    } else if (isInserting) {
      context.missing(_fiber100Meta);
    }
    if (data.containsKey('salt100')) {
      context.handle(
        _salt100Meta,
        salt100.isAcceptableOrUnknown(data['salt100']!, _salt100Meta),
      );
    } else if (isInserting) {
      context.missing(_salt100Meta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      mealSlotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_slot_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      kcal100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal100'],
      )!,
      protein100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein100'],
      )!,
      carbs100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs100'],
      )!,
      sugar100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar100'],
      )!,
      fat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat100'],
      )!,
      saturatedFat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturated_fat100'],
      )!,
      fiber100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber100'],
      )!,
      salt100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salt100'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      ),
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

  /// Set when the entry was logged from a recipe (schema 2). Values are still a copy.
  final String? recipeId;
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
    this.recipeId,
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
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dayKey: Value(dayKey),
      mealSlotId: Value(mealSlotId),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      foodName: Value(foodName),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
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
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
    );
  }

  factory DiaryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      recipeId: serializer.fromJson<String?>(json['recipeId']),
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
      'recipeId': serializer.toJson<String?>(recipeId),
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
    Value<String?> recipeId = const Value.absent(),
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
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
  );
  DiaryEntry copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      mealSlotId: data.mealSlotId.present
          ? data.mealSlotId.value
          : this.mealSlotId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      brand: data.brand.present ? data.brand.value : this.brand,
      unit: data.unit.present ? data.unit.value : this.unit,
      amount: data.amount.present ? data.amount.value : this.amount,
      kcal100: data.kcal100.present ? data.kcal100.value : this.kcal100,
      protein100: data.protein100.present
          ? data.protein100.value
          : this.protein100,
      carbs100: data.carbs100.present ? data.carbs100.value : this.carbs100,
      sugar100: data.sugar100.present ? data.sugar100.value : this.sugar100,
      fat100: data.fat100.present ? data.fat100.value : this.fat100,
      saturatedFat100: data.saturatedFat100.present
          ? data.saturatedFat100.value
          : this.saturatedFat100,
      fiber100: data.fiber100.present ? data.fiber100.value : this.fiber100,
      salt100: data.salt100.present ? data.salt100.value : this.salt100,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
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
          ..write('salt100: $salt100, ')
          ..write('recipeId: $recipeId')
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
    recipeId,
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
          other.salt100 == this.salt100 &&
          other.recipeId == this.recipeId);
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
  final Value<String?> recipeId;
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
    this.recipeId = const Value.absent(),
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
    this.recipeId = const Value.absent(),
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
    Expression<String>? recipeId,
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
      if (recipeId != null) 'recipe_id': recipeId,
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
    Value<String?>? recipeId,
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
      recipeId: recipeId ?? this.recipeId,
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
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
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
          ..write('recipeId: $recipeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntry> {
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta(
    'bodyFatPercent',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta(
    'waistCm',
  );
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
  VerificationContext validateIntegrity(
    Insertable<WeightEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(
          data['body_fat_percent']!,
          _bodyFatPercentMeta,
        ),
      );
    }
    if (data.containsKey('waist_cm')) {
      context.handle(
        _waistCmMeta,
        waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      ),
      waistCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist_cm'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
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
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dayKey: Value(dayKey),
      weightKg: Value(weightKg),
      bodyFatPercent: bodyFatPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercent),
      waistCm: waistCm == null && nullToAbsent
          ? const Value.absent()
          : Value(waistCm),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WeightEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
    bodyFatPercent: bodyFatPercent.present
        ? bodyFatPercent.value
        : this.bodyFatPercent,
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
      bodyFatPercent: data.bodyFatPercent.present
          ? data.bodyFatPercent.value
          : this.bodyFatPercent,
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
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    dayKey,
    weightKg,
    bodyFatPercent,
    waistCm,
    note,
  );
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

class $WaterEntriesTable extends WaterEntries
    with TableInfo<$WaterEntriesTable, WaterEntry> {
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    dayKey,
    ml,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
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
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      ml: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ml'],
      )!,
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
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dayKey: Value(dayKey),
      ml: Value(ml),
    );
  }

  factory WaterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, deletedAt, dayKey, ml);
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

class $ActivityEntriesTable extends ActivityEntries
    with TableInfo<$ActivityEntriesTable, ActivityEntry> {
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
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
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
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
  VerificationContext validateIntegrity(
    Insertable<ActivityEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('kcal')) {
      context.handle(
        _kcalMeta,
        kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      kcal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
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
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dayKey: Value(dayKey),
      label: Value(label),
      minutes: Value(minutes),
      kcal: Value(kcal),
      steps: steps == null && nullToAbsent
          ? const Value.absent()
          : Value(steps),
      source: Value(source),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
    );
  }

  factory ActivityEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
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
  int get hashCode => Object.hash(
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
  );
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
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
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
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
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

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
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
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
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
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
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

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookedWeightGMeta = const VerificationMeta(
    'cookedWeightG',
  );
  @override
  late final GeneratedColumn<double> cookedWeightG = GeneratedColumn<double>(
    'cooked_weight_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prepMinutesMeta = const VerificationMeta(
    'prepMinutes',
  );
  @override
  late final GeneratedColumn<int> prepMinutes = GeneratedColumn<int>(
    'prep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    nameKey,
    servings,
    cookedWeightG,
    prepMinutes,
    instructions,
    tagsJson,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    } else if (isInserting) {
      context.missing(_servingsMeta);
    }
    if (data.containsKey('cooked_weight_g')) {
      context.handle(
        _cookedWeightGMeta,
        cookedWeightG.isAcceptableOrUnknown(
          data['cooked_weight_g']!,
          _cookedWeightGMeta,
        ),
      );
    }
    if (data.containsKey('prep_minutes')) {
      context.handle(
        _prepMinutesMeta,
        prepMinutes.isAcceptableOrUnknown(
          data['prep_minutes']!,
          _prepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      )!,
      cookedWeightG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cooked_weight_g'],
      ),
      prepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_minutes'],
      ),
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;

  /// Normalised name. Unique among live rows (deleted rows get a suffix).
  final String nameKey;
  final double servings;

  /// Weight of the finished dish in g, if weighed. Changes the values per 100 g.
  final double? cookedWeightG;
  final int? prepMinutes;
  final String? instructions;
  final String tagsJson;
  final bool isFavorite;
  const Recipe({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.nameKey,
    required this.servings,
    this.cookedWeightG,
    this.prepMinutes,
    this.instructions,
    required this.tagsJson,
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
    map['name_key'] = Variable<String>(nameKey);
    map['servings'] = Variable<double>(servings);
    if (!nullToAbsent || cookedWeightG != null) {
      map['cooked_weight_g'] = Variable<double>(cookedWeightG);
    }
    if (!nullToAbsent || prepMinutes != null) {
      map['prep_minutes'] = Variable<int>(prepMinutes);
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['tags_json'] = Variable<String>(tagsJson);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      nameKey: Value(nameKey),
      servings: Value(servings),
      cookedWeightG: cookedWeightG == null && nullToAbsent
          ? const Value.absent()
          : Value(cookedWeightG),
      prepMinutes: prepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(prepMinutes),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      tagsJson: Value(tagsJson),
      isFavorite: Value(isFavorite),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      servings: serializer.fromJson<double>(json['servings']),
      cookedWeightG: serializer.fromJson<double?>(json['cookedWeightG']),
      prepMinutes: serializer.fromJson<int?>(json['prepMinutes']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
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
      'nameKey': serializer.toJson<String>(nameKey),
      'servings': serializer.toJson<double>(servings),
      'cookedWeightG': serializer.toJson<double?>(cookedWeightG),
      'prepMinutes': serializer.toJson<int?>(prepMinutes),
      'instructions': serializer.toJson<String?>(instructions),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  Recipe copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    String? nameKey,
    double? servings,
    Value<double?> cookedWeightG = const Value.absent(),
    Value<int?> prepMinutes = const Value.absent(),
    Value<String?> instructions = const Value.absent(),
    String? tagsJson,
    bool? isFavorite,
  }) => Recipe(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    nameKey: nameKey ?? this.nameKey,
    servings: servings ?? this.servings,
    cookedWeightG: cookedWeightG.present
        ? cookedWeightG.value
        : this.cookedWeightG,
    prepMinutes: prepMinutes.present ? prepMinutes.value : this.prepMinutes,
    instructions: instructions.present ? instructions.value : this.instructions,
    tagsJson: tagsJson ?? this.tagsJson,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      servings: data.servings.present ? data.servings.value : this.servings,
      cookedWeightG: data.cookedWeightG.present
          ? data.cookedWeightG.value
          : this.cookedWeightG,
      prepMinutes: data.prepMinutes.present
          ? data.prepMinutes.value
          : this.prepMinutes,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('servings: $servings, ')
          ..write('cookedWeightG: $cookedWeightG, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('instructions: $instructions, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    nameKey,
    servings,
    cookedWeightG,
    prepMinutes,
    instructions,
    tagsJson,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.nameKey == this.nameKey &&
          other.servings == this.servings &&
          other.cookedWeightG == this.cookedWeightG &&
          other.prepMinutes == this.prepMinutes &&
          other.instructions == this.instructions &&
          other.tagsJson == this.tagsJson &&
          other.isFavorite == this.isFavorite);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String> nameKey;
  final Value<double> servings;
  final Value<double?> cookedWeightG;
  final Value<int?> prepMinutes;
  final Value<String?> instructions;
  final Value<String> tagsJson;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.servings = const Value.absent(),
    this.cookedWeightG = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.instructions = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    required String nameKey,
    required double servings,
    this.cookedWeightG = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.instructions = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       nameKey = Value(nameKey),
       servings = Value(servings);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? nameKey,
    Expression<double>? servings,
    Expression<double>? cookedWeightG,
    Expression<int>? prepMinutes,
    Expression<String>? instructions,
    Expression<String>? tagsJson,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (nameKey != null) 'name_key': nameKey,
      if (servings != null) 'servings': servings,
      if (cookedWeightG != null) 'cooked_weight_g': cookedWeightG,
      if (prepMinutes != null) 'prep_minutes': prepMinutes,
      if (instructions != null) 'instructions': instructions,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String>? nameKey,
    Value<double>? servings,
    Value<double?>? cookedWeightG,
    Value<int?>? prepMinutes,
    Value<String?>? instructions,
    Value<String>? tagsJson,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      nameKey: nameKey ?? this.nameKey,
      servings: servings ?? this.servings,
      cookedWeightG: cookedWeightG ?? this.cookedWeightG,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      instructions: instructions ?? this.instructions,
      tagsJson: tagsJson ?? this.tagsJson,
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
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (cookedWeightG.present) {
      map['cooked_weight_g'] = Variable<double>(cookedWeightG.value);
    }
    if (prepMinutes.present) {
      map['prep_minutes'] = Variable<int>(prepMinutes.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
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
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('nameKey: $nameKey, ')
          ..write('servings: $servings, ')
          ..write('cookedWeightG: $cookedWeightG, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('instructions: $instructions, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTable extends RecipeItems
    with TableInfo<$RecipeItemsTable, RecipeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
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
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kcal100Meta = const VerificationMeta(
    'kcal100',
  );
  @override
  late final GeneratedColumn<double> kcal100 = GeneratedColumn<double>(
    'kcal100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protein100Meta = const VerificationMeta(
    'protein100',
  );
  @override
  late final GeneratedColumn<double> protein100 = GeneratedColumn<double>(
    'protein100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbs100Meta = const VerificationMeta(
    'carbs100',
  );
  @override
  late final GeneratedColumn<double> carbs100 = GeneratedColumn<double>(
    'carbs100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugar100Meta = const VerificationMeta(
    'sugar100',
  );
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
  static const VerificationMeta _saturatedFat100Meta = const VerificationMeta(
    'saturatedFat100',
  );
  @override
  late final GeneratedColumn<double> saturatedFat100 = GeneratedColumn<double>(
    'saturated_fat100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiber100Meta = const VerificationMeta(
    'fiber100',
  );
  @override
  late final GeneratedColumn<double> fiber100 = GeneratedColumn<double>(
    'fiber100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salt100Meta = const VerificationMeta(
    'salt100',
  );
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
    recipeId,
    foodId,
    foodName,
    brand,
    unit,
    amount,
    sortOrder,
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
  static const String $name = 'recipe_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('kcal100')) {
      context.handle(
        _kcal100Meta,
        kcal100.isAcceptableOrUnknown(data['kcal100']!, _kcal100Meta),
      );
    } else if (isInserting) {
      context.missing(_kcal100Meta);
    }
    if (data.containsKey('protein100')) {
      context.handle(
        _protein100Meta,
        protein100.isAcceptableOrUnknown(data['protein100']!, _protein100Meta),
      );
    } else if (isInserting) {
      context.missing(_protein100Meta);
    }
    if (data.containsKey('carbs100')) {
      context.handle(
        _carbs100Meta,
        carbs100.isAcceptableOrUnknown(data['carbs100']!, _carbs100Meta),
      );
    } else if (isInserting) {
      context.missing(_carbs100Meta);
    }
    if (data.containsKey('sugar100')) {
      context.handle(
        _sugar100Meta,
        sugar100.isAcceptableOrUnknown(data['sugar100']!, _sugar100Meta),
      );
    } else if (isInserting) {
      context.missing(_sugar100Meta);
    }
    if (data.containsKey('fat100')) {
      context.handle(
        _fat100Meta,
        fat100.isAcceptableOrUnknown(data['fat100']!, _fat100Meta),
      );
    } else if (isInserting) {
      context.missing(_fat100Meta);
    }
    if (data.containsKey('saturated_fat100')) {
      context.handle(
        _saturatedFat100Meta,
        saturatedFat100.isAcceptableOrUnknown(
          data['saturated_fat100']!,
          _saturatedFat100Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saturatedFat100Meta);
    }
    if (data.containsKey('fiber100')) {
      context.handle(
        _fiber100Meta,
        fiber100.isAcceptableOrUnknown(data['fiber100']!, _fiber100Meta),
      );
    } else if (isInserting) {
      context.missing(_fiber100Meta);
    }
    if (data.containsKey('salt100')) {
      context.handle(
        _salt100Meta,
        salt100.isAcceptableOrUnknown(data['salt100']!, _salt100Meta),
      );
    } else if (isInserting) {
      context.missing(_salt100Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      kcal100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal100'],
      )!,
      protein100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein100'],
      )!,
      carbs100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs100'],
      )!,
      sugar100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar100'],
      )!,
      fat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat100'],
      )!,
      saturatedFat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturated_fat100'],
      )!,
      fiber100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber100'],
      )!,
      salt100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salt100'],
      )!,
    );
  }

  @override
  $RecipeItemsTable createAlias(String alias) {
    return $RecipeItemsTable(attachedDatabase, alias);
  }
}

class RecipeItem extends DataClass implements Insertable<RecipeItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String recipeId;
  final String? foodId;
  final String foodName;
  final String? brand;
  final String unit;
  final double amount;
  final int sortOrder;
  final double kcal100;
  final double protein100;
  final double carbs100;
  final double sugar100;
  final double fat100;
  final double saturatedFat100;
  final double fiber100;
  final double salt100;
  const RecipeItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.recipeId,
    this.foodId,
    required this.foodName,
    this.brand,
    required this.unit,
    required this.amount,
    required this.sortOrder,
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
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    map['food_name'] = Variable<String>(foodName);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['unit'] = Variable<String>(unit);
    map['amount'] = Variable<double>(amount);
    map['sort_order'] = Variable<int>(sortOrder);
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

  RecipeItemsCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      recipeId: Value(recipeId),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      foodName: Value(foodName),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      unit: Value(unit),
      amount: Value(amount),
      sortOrder: Value(sortOrder),
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

  factory RecipeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      foodName: serializer.fromJson<String>(json['foodName']),
      brand: serializer.fromJson<String?>(json['brand']),
      unit: serializer.fromJson<String>(json['unit']),
      amount: serializer.fromJson<double>(json['amount']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
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
      'recipeId': serializer.toJson<String>(recipeId),
      'foodId': serializer.toJson<String?>(foodId),
      'foodName': serializer.toJson<String>(foodName),
      'brand': serializer.toJson<String?>(brand),
      'unit': serializer.toJson<String>(unit),
      'amount': serializer.toJson<double>(amount),
      'sortOrder': serializer.toJson<int>(sortOrder),
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

  RecipeItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? recipeId,
    Value<String?> foodId = const Value.absent(),
    String? foodName,
    Value<String?> brand = const Value.absent(),
    String? unit,
    double? amount,
    int? sortOrder,
    double? kcal100,
    double? protein100,
    double? carbs100,
    double? sugar100,
    double? fat100,
    double? saturatedFat100,
    double? fiber100,
    double? salt100,
  }) => RecipeItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    recipeId: recipeId ?? this.recipeId,
    foodId: foodId.present ? foodId.value : this.foodId,
    foodName: foodName ?? this.foodName,
    brand: brand.present ? brand.value : this.brand,
    unit: unit ?? this.unit,
    amount: amount ?? this.amount,
    sortOrder: sortOrder ?? this.sortOrder,
    kcal100: kcal100 ?? this.kcal100,
    protein100: protein100 ?? this.protein100,
    carbs100: carbs100 ?? this.carbs100,
    sugar100: sugar100 ?? this.sugar100,
    fat100: fat100 ?? this.fat100,
    saturatedFat100: saturatedFat100 ?? this.saturatedFat100,
    fiber100: fiber100 ?? this.fiber100,
    salt100: salt100 ?? this.salt100,
  );
  RecipeItem copyWithCompanion(RecipeItemsCompanion data) {
    return RecipeItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      brand: data.brand.present ? data.brand.value : this.brand,
      unit: data.unit.present ? data.unit.value : this.unit,
      amount: data.amount.present ? data.amount.value : this.amount,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      kcal100: data.kcal100.present ? data.kcal100.value : this.kcal100,
      protein100: data.protein100.present
          ? data.protein100.value
          : this.protein100,
      carbs100: data.carbs100.present ? data.carbs100.value : this.carbs100,
      sugar100: data.sugar100.present ? data.sugar100.value : this.sugar100,
      fat100: data.fat100.present ? data.fat100.value : this.fat100,
      saturatedFat100: data.saturatedFat100.present
          ? data.saturatedFat100.value
          : this.saturatedFat100,
      fiber100: data.fiber100.present ? data.fiber100.value : this.fiber100,
      salt100: data.salt100.present ? data.salt100.value : this.salt100,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('recipeId: $recipeId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('brand: $brand, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('sortOrder: $sortOrder, ')
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
    recipeId,
    foodId,
    foodName,
    brand,
    unit,
    amount,
    sortOrder,
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
      (other is RecipeItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.recipeId == this.recipeId &&
          other.foodId == this.foodId &&
          other.foodName == this.foodName &&
          other.brand == this.brand &&
          other.unit == this.unit &&
          other.amount == this.amount &&
          other.sortOrder == this.sortOrder &&
          other.kcal100 == this.kcal100 &&
          other.protein100 == this.protein100 &&
          other.carbs100 == this.carbs100 &&
          other.sugar100 == this.sugar100 &&
          other.fat100 == this.fat100 &&
          other.saturatedFat100 == this.saturatedFat100 &&
          other.fiber100 == this.fiber100 &&
          other.salt100 == this.salt100);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> recipeId;
  final Value<String?> foodId;
  final Value<String> foodName;
  final Value<String?> brand;
  final Value<String> unit;
  final Value<double> amount;
  final Value<int> sortOrder;
  final Value<double> kcal100;
  final Value<double> protein100;
  final Value<double> carbs100;
  final Value<double> sugar100;
  final Value<double> fat100;
  final Value<double> saturatedFat100;
  final Value<double> fiber100;
  final Value<double> salt100;
  final Value<int> rowid;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.brand = const Value.absent(),
    this.unit = const Value.absent(),
    this.amount = const Value.absent(),
    this.sortOrder = const Value.absent(),
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
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String recipeId,
    this.foodId = const Value.absent(),
    required String foodName,
    this.brand = const Value.absent(),
    required String unit,
    required double amount,
    required int sortOrder,
    required double kcal100,
    required double protein100,
    required double carbs100,
    required double sugar100,
    required double fat100,
    required double saturatedFat100,
    required double fiber100,
    required double salt100,
    this.rowid = const Value.absent(),
  }) : recipeId = Value(recipeId),
       foodName = Value(foodName),
       unit = Value(unit),
       amount = Value(amount),
       sortOrder = Value(sortOrder),
       kcal100 = Value(kcal100),
       protein100 = Value(protein100),
       carbs100 = Value(carbs100),
       sugar100 = Value(sugar100),
       fat100 = Value(fat100),
       saturatedFat100 = Value(saturatedFat100),
       fiber100 = Value(fiber100),
       salt100 = Value(salt100);
  static Insertable<RecipeItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? recipeId,
    Expression<String>? foodId,
    Expression<String>? foodName,
    Expression<String>? brand,
    Expression<String>? unit,
    Expression<double>? amount,
    Expression<int>? sortOrder,
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
      if (recipeId != null) 'recipe_id': recipeId,
      if (foodId != null) 'food_id': foodId,
      if (foodName != null) 'food_name': foodName,
      if (brand != null) 'brand': brand,
      if (unit != null) 'unit': unit,
      if (amount != null) 'amount': amount,
      if (sortOrder != null) 'sort_order': sortOrder,
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

  RecipeItemsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? recipeId,
    Value<String?>? foodId,
    Value<String>? foodName,
    Value<String?>? brand,
    Value<String>? unit,
    Value<double>? amount,
    Value<int>? sortOrder,
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
    return RecipeItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      recipeId: recipeId ?? this.recipeId,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      amount: amount ?? this.amount,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
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
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('RecipeItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('recipeId: $recipeId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('brand: $brand, ')
          ..write('unit: $unit, ')
          ..write('amount: $amount, ')
          ..write('sortOrder: $sortOrder, ')
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

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemKeyMeta = const VerificationMeta(
    'itemKey',
  );
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
    'item_key',
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
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromRecipesMeta = const VerificationMeta(
    'fromRecipes',
  );
  @override
  late final GeneratedColumn<String> fromRecipes = GeneratedColumn<String>(
    'from_recipes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    label,
    itemKey,
    amount,
    unit,
    foodId,
    category,
    fromRecipes,
    checked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('item_key')) {
      context.handle(
        _itemKeyMeta,
        itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('from_recipes')) {
      context.handle(
        _fromRecipesMeta,
        fromRecipes.isAcceptableOrUnknown(
          data['from_recipes']!,
          _fromRecipesMeta,
        ),
      );
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      itemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_key'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      fromRecipes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_recipes'],
      ),
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String label;

  /// foodId if known, else the normalised label. Used to merge lines.
  final String itemKey;
  final double? amount;
  final String? unit;
  final String? foodId;
  final String? category;

  /// Names of the recipes this line came from, for display.
  final String? fromRecipes;
  final bool checked;
  const ShoppingItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.label,
    required this.itemKey,
    this.amount,
    this.unit,
    this.foodId,
    this.category,
    this.fromRecipes,
    required this.checked,
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
    map['label'] = Variable<String>(label);
    map['item_key'] = Variable<String>(itemKey);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<String>(foodId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || fromRecipes != null) {
      map['from_recipes'] = Variable<String>(fromRecipes);
    }
    map['checked'] = Variable<bool>(checked);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      label: Value(label),
      itemKey: Value(itemKey),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      fromRecipes: fromRecipes == null && nullToAbsent
          ? const Value.absent()
          : Value(fromRecipes),
      checked: Value(checked),
    );
  }

  factory ShoppingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      label: serializer.fromJson<String>(json['label']),
      itemKey: serializer.fromJson<String>(json['itemKey']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      category: serializer.fromJson<String?>(json['category']),
      fromRecipes: serializer.fromJson<String?>(json['fromRecipes']),
      checked: serializer.fromJson<bool>(json['checked']),
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
      'label': serializer.toJson<String>(label),
      'itemKey': serializer.toJson<String>(itemKey),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'foodId': serializer.toJson<String?>(foodId),
      'category': serializer.toJson<String?>(category),
      'fromRecipes': serializer.toJson<String?>(fromRecipes),
      'checked': serializer.toJson<bool>(checked),
    };
  }

  ShoppingItem copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? label,
    String? itemKey,
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> foodId = const Value.absent(),
    Value<String?> category = const Value.absent(),
    Value<String?> fromRecipes = const Value.absent(),
    bool? checked,
  }) => ShoppingItem(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    label: label ?? this.label,
    itemKey: itemKey ?? this.itemKey,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
    foodId: foodId.present ? foodId.value : this.foodId,
    category: category.present ? category.value : this.category,
    fromRecipes: fromRecipes.present ? fromRecipes.value : this.fromRecipes,
    checked: checked ?? this.checked,
  );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      label: data.label.present ? data.label.value : this.label,
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      category: data.category.present ? data.category.value : this.category,
      fromRecipes: data.fromRecipes.present
          ? data.fromRecipes.value
          : this.fromRecipes,
      checked: data.checked.present ? data.checked.value : this.checked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('label: $label, ')
          ..write('itemKey: $itemKey, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('foodId: $foodId, ')
          ..write('category: $category, ')
          ..write('fromRecipes: $fromRecipes, ')
          ..write('checked: $checked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    label,
    itemKey,
    amount,
    unit,
    foodId,
    category,
    fromRecipes,
    checked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.label == this.label &&
          other.itemKey == this.itemKey &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.foodId == this.foodId &&
          other.category == this.category &&
          other.fromRecipes == this.fromRecipes &&
          other.checked == this.checked);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> label;
  final Value<String> itemKey;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> foodId;
  final Value<String?> category;
  final Value<String?> fromRecipes;
  final Value<bool> checked;
  final Value<int> rowid;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.label = const Value.absent(),
    this.itemKey = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.foodId = const Value.absent(),
    this.category = const Value.absent(),
    this.fromRecipes = const Value.absent(),
    this.checked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String label,
    required String itemKey,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.foodId = const Value.absent(),
    this.category = const Value.absent(),
    this.fromRecipes = const Value.absent(),
    this.checked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : label = Value(label),
       itemKey = Value(itemKey);
  static Insertable<ShoppingItem> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? label,
    Expression<String>? itemKey,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? foodId,
    Expression<String>? category,
    Expression<String>? fromRecipes,
    Expression<bool>? checked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (label != null) 'label': label,
      if (itemKey != null) 'item_key': itemKey,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (foodId != null) 'food_id': foodId,
      if (category != null) 'category': category,
      if (fromRecipes != null) 'from_recipes': fromRecipes,
      if (checked != null) 'checked': checked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? label,
    Value<String>? itemKey,
    Value<double?>? amount,
    Value<String?>? unit,
    Value<String?>? foodId,
    Value<String?>? category,
    Value<String?>? fromRecipes,
    Value<bool>? checked,
    Value<int>? rowid,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      label: label ?? this.label,
      itemKey: itemKey ?? this.itemKey,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      foodId: foodId ?? this.foodId,
      category: category ?? this.category,
      fromRecipes: fromRecipes ?? this.fromRecipes,
      checked: checked ?? this.checked,
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
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (fromRecipes.present) {
      map['from_recipes'] = Variable<String>(fromRecipes.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('label: $label, ')
          ..write('itemKey: $itemKey, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('foodId: $foodId, ')
          ..write('category: $category, ')
          ..write('fromRecipes: $fromRecipes, ')
          ..write('checked: $checked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplementsTable extends Supplements
    with TableInfo<$SupplementsTable, Supplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
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
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingLabelMeta = const VerificationMeta(
    'servingLabel',
  );
  @override
  late final GeneratedColumn<String> servingLabel = GeneratedColumn<String>(
    'serving_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Portion'),
  );
  static const VerificationMeta _manufacturerDoseMeta = const VerificationMeta(
    'manufacturerDose',
  );
  @override
  late final GeneratedColumn<String> manufacturerDose = GeneratedColumn<String>(
    'manufacturer_dose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingsPerDayMeta = const VerificationMeta(
    'servingsPerDay',
  );
  @override
  late final GeneratedColumn<double> servingsPerDay = GeneratedColumn<double>(
    'servings_per_day',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _timesJsonMeta = const VerificationMeta(
    'timesJson',
  );
  @override
  late final GeneratedColumn<String> timesJson = GeneratedColumn<String>(
    'times_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _stockServingsMeta = const VerificationMeta(
    'stockServings',
  );
  @override
  late final GeneratedColumn<double> stockServings = GeneratedColumn<double>(
    'stock_servings',
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
    name,
    brand,
    nameKey,
    form,
    servingLabel,
    manufacturerDose,
    servingsPerDay,
    timesJson,
    active,
    stockServings,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    }
    if (data.containsKey('serving_label')) {
      context.handle(
        _servingLabelMeta,
        servingLabel.isAcceptableOrUnknown(
          data['serving_label']!,
          _servingLabelMeta,
        ),
      );
    }
    if (data.containsKey('manufacturer_dose')) {
      context.handle(
        _manufacturerDoseMeta,
        manufacturerDose.isAcceptableOrUnknown(
          data['manufacturer_dose']!,
          _manufacturerDoseMeta,
        ),
      );
    }
    if (data.containsKey('servings_per_day')) {
      context.handle(
        _servingsPerDayMeta,
        servingsPerDay.isAcceptableOrUnknown(
          data['servings_per_day']!,
          _servingsPerDayMeta,
        ),
      );
    }
    if (data.containsKey('times_json')) {
      context.handle(
        _timesJsonMeta,
        timesJson.isAcceptableOrUnknown(data['times_json']!, _timesJsonMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('stock_servings')) {
      context.handle(
        _stockServingsMeta,
        stockServings.isAcceptableOrUnknown(
          data['stock_servings']!,
          _stockServingsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      ),
      servingLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_label'],
      )!,
      manufacturerDose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer_dose'],
      ),
      servingsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings_per_day'],
      )!,
      timesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times_json'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      stockServings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_servings'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SupplementsTable createAlias(String alias) {
    return $SupplementsTable(attachedDatabase, alias);
  }
}

class Supplement extends DataClass implements Insertable<Supplement> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String? brand;

  /// Normalised name|brand. Unique among live rows (deleted rows get a suffix).
  final String nameKey;
  final String? form;
  final String servingLabel;

  /// Manufacturer's recommendation as printed on the pack (free text, not a recommendation of the app).
  final String? manufacturerDose;
  final double servingsPerDay;

  /// Planned intake times as JSON list of minutes after midnight.
  final String timesJson;
  final bool active;
  final double? stockServings;
  final String? note;
  const Supplement({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    this.brand,
    required this.nameKey,
    this.form,
    required this.servingLabel,
    this.manufacturerDose,
    required this.servingsPerDay,
    required this.timesJson,
    required this.active,
    this.stockServings,
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
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['name_key'] = Variable<String>(nameKey);
    if (!nullToAbsent || form != null) {
      map['form'] = Variable<String>(form);
    }
    map['serving_label'] = Variable<String>(servingLabel);
    if (!nullToAbsent || manufacturerDose != null) {
      map['manufacturer_dose'] = Variable<String>(manufacturerDose);
    }
    map['servings_per_day'] = Variable<double>(servingsPerDay);
    map['times_json'] = Variable<String>(timesJson);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || stockServings != null) {
      map['stock_servings'] = Variable<double>(stockServings);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SupplementsCompanion toCompanion(bool nullToAbsent) {
    return SupplementsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      nameKey: Value(nameKey),
      form: form == null && nullToAbsent ? const Value.absent() : Value(form),
      servingLabel: Value(servingLabel),
      manufacturerDose: manufacturerDose == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturerDose),
      servingsPerDay: Value(servingsPerDay),
      timesJson: Value(timesJson),
      active: Value(active),
      stockServings: stockServings == null && nullToAbsent
          ? const Value.absent()
          : Value(stockServings),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Supplement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplement(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      form: serializer.fromJson<String?>(json['form']),
      servingLabel: serializer.fromJson<String>(json['servingLabel']),
      manufacturerDose: serializer.fromJson<String?>(json['manufacturerDose']),
      servingsPerDay: serializer.fromJson<double>(json['servingsPerDay']),
      timesJson: serializer.fromJson<String>(json['timesJson']),
      active: serializer.fromJson<bool>(json['active']),
      stockServings: serializer.fromJson<double?>(json['stockServings']),
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
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'nameKey': serializer.toJson<String>(nameKey),
      'form': serializer.toJson<String?>(form),
      'servingLabel': serializer.toJson<String>(servingLabel),
      'manufacturerDose': serializer.toJson<String?>(manufacturerDose),
      'servingsPerDay': serializer.toJson<double>(servingsPerDay),
      'timesJson': serializer.toJson<String>(timesJson),
      'active': serializer.toJson<bool>(active),
      'stockServings': serializer.toJson<double?>(stockServings),
      'note': serializer.toJson<String?>(note),
    };
  }

  Supplement copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? name,
    Value<String?> brand = const Value.absent(),
    String? nameKey,
    Value<String?> form = const Value.absent(),
    String? servingLabel,
    Value<String?> manufacturerDose = const Value.absent(),
    double? servingsPerDay,
    String? timesJson,
    bool? active,
    Value<double?> stockServings = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Supplement(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    nameKey: nameKey ?? this.nameKey,
    form: form.present ? form.value : this.form,
    servingLabel: servingLabel ?? this.servingLabel,
    manufacturerDose: manufacturerDose.present
        ? manufacturerDose.value
        : this.manufacturerDose,
    servingsPerDay: servingsPerDay ?? this.servingsPerDay,
    timesJson: timesJson ?? this.timesJson,
    active: active ?? this.active,
    stockServings: stockServings.present
        ? stockServings.value
        : this.stockServings,
    note: note.present ? note.value : this.note,
  );
  Supplement copyWithCompanion(SupplementsCompanion data) {
    return Supplement(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      form: data.form.present ? data.form.value : this.form,
      servingLabel: data.servingLabel.present
          ? data.servingLabel.value
          : this.servingLabel,
      manufacturerDose: data.manufacturerDose.present
          ? data.manufacturerDose.value
          : this.manufacturerDose,
      servingsPerDay: data.servingsPerDay.present
          ? data.servingsPerDay.value
          : this.servingsPerDay,
      timesJson: data.timesJson.present ? data.timesJson.value : this.timesJson,
      active: data.active.present ? data.active.value : this.active,
      stockServings: data.stockServings.present
          ? data.stockServings.value
          : this.stockServings,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplement(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('nameKey: $nameKey, ')
          ..write('form: $form, ')
          ..write('servingLabel: $servingLabel, ')
          ..write('manufacturerDose: $manufacturerDose, ')
          ..write('servingsPerDay: $servingsPerDay, ')
          ..write('timesJson: $timesJson, ')
          ..write('active: $active, ')
          ..write('stockServings: $stockServings, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    name,
    brand,
    nameKey,
    form,
    servingLabel,
    manufacturerDose,
    servingsPerDay,
    timesJson,
    active,
    stockServings,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplement &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.nameKey == this.nameKey &&
          other.form == this.form &&
          other.servingLabel == this.servingLabel &&
          other.manufacturerDose == this.manufacturerDose &&
          other.servingsPerDay == this.servingsPerDay &&
          other.timesJson == this.timesJson &&
          other.active == this.active &&
          other.stockServings == this.stockServings &&
          other.note == this.note);
}

class SupplementsCompanion extends UpdateCompanion<Supplement> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String> nameKey;
  final Value<String?> form;
  final Value<String> servingLabel;
  final Value<String?> manufacturerDose;
  final Value<double> servingsPerDay;
  final Value<String> timesJson;
  final Value<bool> active;
  final Value<double?> stockServings;
  final Value<String?> note;
  final Value<int> rowid;
  const SupplementsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.form = const Value.absent(),
    this.servingLabel = const Value.absent(),
    this.manufacturerDose = const Value.absent(),
    this.servingsPerDay = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.active = const Value.absent(),
    this.stockServings = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplementsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    required String nameKey,
    this.form = const Value.absent(),
    this.servingLabel = const Value.absent(),
    this.manufacturerDose = const Value.absent(),
    this.servingsPerDay = const Value.absent(),
    this.timesJson = const Value.absent(),
    this.active = const Value.absent(),
    this.stockServings = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       nameKey = Value(nameKey);
  static Insertable<Supplement> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? nameKey,
    Expression<String>? form,
    Expression<String>? servingLabel,
    Expression<String>? manufacturerDose,
    Expression<double>? servingsPerDay,
    Expression<String>? timesJson,
    Expression<bool>? active,
    Expression<double>? stockServings,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (nameKey != null) 'name_key': nameKey,
      if (form != null) 'form': form,
      if (servingLabel != null) 'serving_label': servingLabel,
      if (manufacturerDose != null) 'manufacturer_dose': manufacturerDose,
      if (servingsPerDay != null) 'servings_per_day': servingsPerDay,
      if (timesJson != null) 'times_json': timesJson,
      if (active != null) 'active': active,
      if (stockServings != null) 'stock_servings': stockServings,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplementsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? name,
    Value<String?>? brand,
    Value<String>? nameKey,
    Value<String?>? form,
    Value<String>? servingLabel,
    Value<String?>? manufacturerDose,
    Value<double>? servingsPerDay,
    Value<String>? timesJson,
    Value<bool>? active,
    Value<double?>? stockServings,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SupplementsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      nameKey: nameKey ?? this.nameKey,
      form: form ?? this.form,
      servingLabel: servingLabel ?? this.servingLabel,
      manufacturerDose: manufacturerDose ?? this.manufacturerDose,
      servingsPerDay: servingsPerDay ?? this.servingsPerDay,
      timesJson: timesJson ?? this.timesJson,
      active: active ?? this.active,
      stockServings: stockServings ?? this.stockServings,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (servingLabel.present) {
      map['serving_label'] = Variable<String>(servingLabel.value);
    }
    if (manufacturerDose.present) {
      map['manufacturer_dose'] = Variable<String>(manufacturerDose.value);
    }
    if (servingsPerDay.present) {
      map['servings_per_day'] = Variable<double>(servingsPerDay.value);
    }
    if (timesJson.present) {
      map['times_json'] = Variable<String>(timesJson.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (stockServings.present) {
      map['stock_servings'] = Variable<double>(stockServings.value);
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
    return (StringBuffer('SupplementsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('nameKey: $nameKey, ')
          ..write('form: $form, ')
          ..write('servingLabel: $servingLabel, ')
          ..write('manufacturerDose: $manufacturerDose, ')
          ..write('servingsPerDay: $servingsPerDay, ')
          ..write('timesJson: $timesJson, ')
          ..write('active: $active, ')
          ..write('stockServings: $stockServings, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplementIngredientsTable extends SupplementIngredients
    with TableInfo<$SupplementIngredientsTable, SupplementIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementIngredientsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplementIdMeta = const VerificationMeta(
    'supplementId',
  );
  @override
  late final GeneratedColumn<String> supplementId = GeneratedColumn<String>(
    'supplement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nutrientIdMeta = const VerificationMeta(
    'nutrientId',
  );
  @override
  late final GeneratedColumn<String> nutrientId = GeneratedColumn<String>(
    'nutrient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    supplementId,
    nutrientId,
    name,
    amount,
    unit,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplement_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('supplement_id')) {
      context.handle(
        _supplementIdMeta,
        supplementId.isAcceptableOrUnknown(
          data['supplement_id']!,
          _supplementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementIdMeta);
    }
    if (data.containsKey('nutrient_id')) {
      context.handle(
        _nutrientIdMeta,
        nutrientId.isAcceptableOrUnknown(data['nutrient_id']!, _nutrientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nutrientIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementIngredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      supplementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplement_id'],
      )!,
      nutrientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutrient_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SupplementIngredientsTable createAlias(String alias) {
    return $SupplementIngredientsTable(attachedDatabase, alias);
  }
}

class SupplementIngredient extends DataClass
    implements Insertable<SupplementIngredient> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String supplementId;

  /// Catalogue id (core/supplements.dart) or `custom:NAME`.
  final String nutrientId;
  final String? name;
  final double amount;
  final String unit;
  final int sortOrder;
  const SupplementIngredient({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.supplementId,
    required this.nutrientId,
    this.name,
    required this.amount,
    required this.unit,
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
    map['supplement_id'] = Variable<String>(supplementId);
    map['nutrient_id'] = Variable<String>(nutrientId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SupplementIngredientsCompanion toCompanion(bool nullToAbsent) {
    return SupplementIngredientsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      supplementId: Value(supplementId),
      nutrientId: Value(nutrientId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      amount: Value(amount),
      unit: Value(unit),
      sortOrder: Value(sortOrder),
    );
  }

  factory SupplementIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementIngredient(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      supplementId: serializer.fromJson<String>(json['supplementId']),
      nutrientId: serializer.fromJson<String>(json['nutrientId']),
      name: serializer.fromJson<String?>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
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
      'supplementId': serializer.toJson<String>(supplementId),
      'nutrientId': serializer.toJson<String>(nutrientId),
      'name': serializer.toJson<String?>(name),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SupplementIngredient copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? supplementId,
    String? nutrientId,
    Value<String?> name = const Value.absent(),
    double? amount,
    String? unit,
    int? sortOrder,
  }) => SupplementIngredient(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    supplementId: supplementId ?? this.supplementId,
    nutrientId: nutrientId ?? this.nutrientId,
    name: name.present ? name.value : this.name,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SupplementIngredient copyWithCompanion(SupplementIngredientsCompanion data) {
    return SupplementIngredient(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      supplementId: data.supplementId.present
          ? data.supplementId.value
          : this.supplementId,
      nutrientId: data.nutrientId.present
          ? data.nutrientId.value
          : this.nutrientId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementIngredient(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('supplementId: $supplementId, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    supplementId,
    nutrientId,
    name,
    amount,
    unit,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementIngredient &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.supplementId == this.supplementId &&
          other.nutrientId == this.nutrientId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.sortOrder == this.sortOrder);
}

class SupplementIngredientsCompanion
    extends UpdateCompanion<SupplementIngredient> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> supplementId;
  final Value<String> nutrientId;
  final Value<String?> name;
  final Value<double> amount;
  final Value<String> unit;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SupplementIngredientsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.supplementId = const Value.absent(),
    this.nutrientId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplementIngredientsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String supplementId,
    required String nutrientId,
    this.name = const Value.absent(),
    required double amount,
    required String unit,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : supplementId = Value(supplementId),
       nutrientId = Value(nutrientId),
       amount = Value(amount),
       unit = Value(unit),
       sortOrder = Value(sortOrder);
  static Insertable<SupplementIngredient> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? supplementId,
    Expression<String>? nutrientId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (supplementId != null) 'supplement_id': supplementId,
      if (nutrientId != null) 'nutrient_id': nutrientId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplementIngredientsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? supplementId,
    Value<String>? nutrientId,
    Value<String?>? name,
    Value<double>? amount,
    Value<String>? unit,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return SupplementIngredientsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      supplementId: supplementId ?? this.supplementId,
      nutrientId: nutrientId ?? this.nutrientId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
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
    if (supplementId.present) {
      map['supplement_id'] = Variable<String>(supplementId.value);
    }
    if (nutrientId.present) {
      map['nutrient_id'] = Variable<String>(nutrientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
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
    return (StringBuffer('SupplementIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('supplementId: $supplementId, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplementIntakesTable extends SupplementIntakes
    with TableInfo<$SupplementIntakesTable, SupplementIntake> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementIntakesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplementIdMeta = const VerificationMeta(
    'supplementId',
  );
  @override
  late final GeneratedColumn<String> supplementId = GeneratedColumn<String>(
    'supplement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _plannedMinuteMeta = const VerificationMeta(
    'plannedMinute',
  );
  @override
  late final GeneratedColumn<int> plannedMinute = GeneratedColumn<int>(
    'planned_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
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
    supplementId,
    dayKey,
    plannedMinute,
    servings,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplement_intakes';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementIntake> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('supplement_id')) {
      context.handle(
        _supplementIdMeta,
        supplementId.isAcceptableOrUnknown(
          data['supplement_id']!,
          _supplementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementIdMeta);
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('planned_minute')) {
      context.handle(
        _plannedMinuteMeta,
        plannedMinute.isAcceptableOrUnknown(
          data['planned_minute']!,
          _plannedMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinuteMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    } else if (isInserting) {
      context.missing(_servingsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementIntake map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementIntake(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      supplementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplement_id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      plannedMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minute'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      )!,
    );
  }

  @override
  $SupplementIntakesTable createAlias(String alias) {
    return $SupplementIntakesTable(attachedDatabase, alias);
  }
}

class SupplementIntake extends DataClass
    implements Insertable<SupplementIntake> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String supplementId;
  final String dayKey;
  final int plannedMinute;
  final double servings;
  const SupplementIntake({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.supplementId,
    required this.dayKey,
    required this.plannedMinute,
    required this.servings,
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
    map['supplement_id'] = Variable<String>(supplementId);
    map['day_key'] = Variable<String>(dayKey);
    map['planned_minute'] = Variable<int>(plannedMinute);
    map['servings'] = Variable<double>(servings);
    return map;
  }

  SupplementIntakesCompanion toCompanion(bool nullToAbsent) {
    return SupplementIntakesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      supplementId: Value(supplementId),
      dayKey: Value(dayKey),
      plannedMinute: Value(plannedMinute),
      servings: Value(servings),
    );
  }

  factory SupplementIntake.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementIntake(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      supplementId: serializer.fromJson<String>(json['supplementId']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      plannedMinute: serializer.fromJson<int>(json['plannedMinute']),
      servings: serializer.fromJson<double>(json['servings']),
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
      'supplementId': serializer.toJson<String>(supplementId),
      'dayKey': serializer.toJson<String>(dayKey),
      'plannedMinute': serializer.toJson<int>(plannedMinute),
      'servings': serializer.toJson<double>(servings),
    };
  }

  SupplementIntake copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? supplementId,
    String? dayKey,
    int? plannedMinute,
    double? servings,
  }) => SupplementIntake(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    supplementId: supplementId ?? this.supplementId,
    dayKey: dayKey ?? this.dayKey,
    plannedMinute: plannedMinute ?? this.plannedMinute,
    servings: servings ?? this.servings,
  );
  SupplementIntake copyWithCompanion(SupplementIntakesCompanion data) {
    return SupplementIntake(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      supplementId: data.supplementId.present
          ? data.supplementId.value
          : this.supplementId,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      plannedMinute: data.plannedMinute.present
          ? data.plannedMinute.value
          : this.plannedMinute,
      servings: data.servings.present ? data.servings.value : this.servings,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementIntake(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('supplementId: $supplementId, ')
          ..write('dayKey: $dayKey, ')
          ..write('plannedMinute: $plannedMinute, ')
          ..write('servings: $servings')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    supplementId,
    dayKey,
    plannedMinute,
    servings,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementIntake &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.supplementId == this.supplementId &&
          other.dayKey == this.dayKey &&
          other.plannedMinute == this.plannedMinute &&
          other.servings == this.servings);
}

class SupplementIntakesCompanion extends UpdateCompanion<SupplementIntake> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> supplementId;
  final Value<String> dayKey;
  final Value<int> plannedMinute;
  final Value<double> servings;
  final Value<int> rowid;
  const SupplementIntakesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.supplementId = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.plannedMinute = const Value.absent(),
    this.servings = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplementIntakesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String supplementId,
    required String dayKey,
    required int plannedMinute,
    required double servings,
    this.rowid = const Value.absent(),
  }) : supplementId = Value(supplementId),
       dayKey = Value(dayKey),
       plannedMinute = Value(plannedMinute),
       servings = Value(servings);
  static Insertable<SupplementIntake> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? supplementId,
    Expression<String>? dayKey,
    Expression<int>? plannedMinute,
    Expression<double>? servings,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (supplementId != null) 'supplement_id': supplementId,
      if (dayKey != null) 'day_key': dayKey,
      if (plannedMinute != null) 'planned_minute': plannedMinute,
      if (servings != null) 'servings': servings,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplementIntakesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? supplementId,
    Value<String>? dayKey,
    Value<int>? plannedMinute,
    Value<double>? servings,
    Value<int>? rowid,
  }) {
    return SupplementIntakesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      supplementId: supplementId ?? this.supplementId,
      dayKey: dayKey ?? this.dayKey,
      plannedMinute: plannedMinute ?? this.plannedMinute,
      servings: servings ?? this.servings,
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
    if (supplementId.present) {
      map['supplement_id'] = Variable<String>(supplementId.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (plannedMinute.present) {
      map['planned_minute'] = Variable<int>(plannedMinute.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementIntakesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('supplementId: $supplementId, ')
          ..write('dayKey: $dayKey, ')
          ..write('plannedMinute: $plannedMinute, ')
          ..write('servings: $servings, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPlanEntriesTable extends MealPlanEntries
    with TableInfo<$MealPlanEntriesTable, MealPlanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlanEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
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
  static const VerificationMeta _mealSlotIdMeta = const VerificationMeta(
    'mealSlotId',
  );
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
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _kcal100Meta = const VerificationMeta(
    'kcal100',
  );
  @override
  late final GeneratedColumn<double> kcal100 = GeneratedColumn<double>(
    'kcal100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _protein100Meta = const VerificationMeta(
    'protein100',
  );
  @override
  late final GeneratedColumn<double> protein100 = GeneratedColumn<double>(
    'protein100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbs100Meta = const VerificationMeta(
    'carbs100',
  );
  @override
  late final GeneratedColumn<double> carbs100 = GeneratedColumn<double>(
    'carbs100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugar100Meta = const VerificationMeta(
    'sugar100',
  );
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
  static const VerificationMeta _saturatedFat100Meta = const VerificationMeta(
    'saturatedFat100',
  );
  @override
  late final GeneratedColumn<double> saturatedFat100 = GeneratedColumn<double>(
    'saturated_fat100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiber100Meta = const VerificationMeta(
    'fiber100',
  );
  @override
  late final GeneratedColumn<double> fiber100 = GeneratedColumn<double>(
    'fiber100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salt100Meta = const VerificationMeta(
    'salt100',
  );
  @override
  late final GeneratedColumn<double> salt100 = GeneratedColumn<double>(
    'salt100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaryEntryIdMeta = const VerificationMeta(
    'diaryEntryId',
  );
  @override
  late final GeneratedColumn<String> diaryEntryId = GeneratedColumn<String>(
    'diary_entry_id',
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
    mealSlotId,
    foodId,
    recipeId,
    name,
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
    diaryEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPlanEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('meal_slot_id')) {
      context.handle(
        _mealSlotIdMeta,
        mealSlotId.isAcceptableOrUnknown(
          data['meal_slot_id']!,
          _mealSlotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealSlotIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('kcal100')) {
      context.handle(
        _kcal100Meta,
        kcal100.isAcceptableOrUnknown(data['kcal100']!, _kcal100Meta),
      );
    } else if (isInserting) {
      context.missing(_kcal100Meta);
    }
    if (data.containsKey('protein100')) {
      context.handle(
        _protein100Meta,
        protein100.isAcceptableOrUnknown(data['protein100']!, _protein100Meta),
      );
    } else if (isInserting) {
      context.missing(_protein100Meta);
    }
    if (data.containsKey('carbs100')) {
      context.handle(
        _carbs100Meta,
        carbs100.isAcceptableOrUnknown(data['carbs100']!, _carbs100Meta),
      );
    } else if (isInserting) {
      context.missing(_carbs100Meta);
    }
    if (data.containsKey('sugar100')) {
      context.handle(
        _sugar100Meta,
        sugar100.isAcceptableOrUnknown(data['sugar100']!, _sugar100Meta),
      );
    } else if (isInserting) {
      context.missing(_sugar100Meta);
    }
    if (data.containsKey('fat100')) {
      context.handle(
        _fat100Meta,
        fat100.isAcceptableOrUnknown(data['fat100']!, _fat100Meta),
      );
    } else if (isInserting) {
      context.missing(_fat100Meta);
    }
    if (data.containsKey('saturated_fat100')) {
      context.handle(
        _saturatedFat100Meta,
        saturatedFat100.isAcceptableOrUnknown(
          data['saturated_fat100']!,
          _saturatedFat100Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saturatedFat100Meta);
    }
    if (data.containsKey('fiber100')) {
      context.handle(
        _fiber100Meta,
        fiber100.isAcceptableOrUnknown(data['fiber100']!, _fiber100Meta),
      );
    } else if (isInserting) {
      context.missing(_fiber100Meta);
    }
    if (data.containsKey('salt100')) {
      context.handle(
        _salt100Meta,
        salt100.isAcceptableOrUnknown(data['salt100']!, _salt100Meta),
      );
    } else if (isInserting) {
      context.missing(_salt100Meta);
    }
    if (data.containsKey('diary_entry_id')) {
      context.handle(
        _diaryEntryIdMeta,
        diaryEntryId.isAcceptableOrUnknown(
          data['diary_entry_id']!,
          _diaryEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      mealSlotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_slot_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      ),
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      kcal100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal100'],
      )!,
      protein100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein100'],
      )!,
      carbs100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs100'],
      )!,
      sugar100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar100'],
      )!,
      fat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat100'],
      )!,
      saturatedFat100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturated_fat100'],
      )!,
      fiber100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber100'],
      )!,
      salt100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}salt100'],
      )!,
      diaryEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diary_entry_id'],
      ),
    );
  }

  @override
  $MealPlanEntriesTable createAlias(String alias) {
    return $MealPlanEntriesTable(attachedDatabase, alias);
  }
}

class MealPlanEntry extends DataClass implements Insertable<MealPlanEntry> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String dayKey;
  final String mealSlotId;
  final String? foodId;
  final String? recipeId;
  final String name;
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

  /// Set when the planned entry was put into the diary.
  final String? diaryEntryId;
  const MealPlanEntry({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dayKey,
    required this.mealSlotId,
    this.foodId,
    this.recipeId,
    required this.name,
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
    this.diaryEntryId,
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
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    map['name'] = Variable<String>(name);
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
    if (!nullToAbsent || diaryEntryId != null) {
      map['diary_entry_id'] = Variable<String>(diaryEntryId);
    }
    return map;
  }

  MealPlanEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealPlanEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dayKey: Value(dayKey),
      mealSlotId: Value(mealSlotId),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      name: Value(name),
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
      diaryEntryId: diaryEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(diaryEntryId),
    );
  }

  factory MealPlanEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanEntry(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      mealSlotId: serializer.fromJson<String>(json['mealSlotId']),
      foodId: serializer.fromJson<String?>(json['foodId']),
      recipeId: serializer.fromJson<String?>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
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
      diaryEntryId: serializer.fromJson<String?>(json['diaryEntryId']),
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
      'recipeId': serializer.toJson<String?>(recipeId),
      'name': serializer.toJson<String>(name),
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
      'diaryEntryId': serializer.toJson<String?>(diaryEntryId),
    };
  }

  MealPlanEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? dayKey,
    String? mealSlotId,
    Value<String?> foodId = const Value.absent(),
    Value<String?> recipeId = const Value.absent(),
    String? name,
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
    Value<String?> diaryEntryId = const Value.absent(),
  }) => MealPlanEntry(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dayKey: dayKey ?? this.dayKey,
    mealSlotId: mealSlotId ?? this.mealSlotId,
    foodId: foodId.present ? foodId.value : this.foodId,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    name: name ?? this.name,
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
    diaryEntryId: diaryEntryId.present ? diaryEntryId.value : this.diaryEntryId,
  );
  MealPlanEntry copyWithCompanion(MealPlanEntriesCompanion data) {
    return MealPlanEntry(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      mealSlotId: data.mealSlotId.present
          ? data.mealSlotId.value
          : this.mealSlotId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      amount: data.amount.present ? data.amount.value : this.amount,
      kcal100: data.kcal100.present ? data.kcal100.value : this.kcal100,
      protein100: data.protein100.present
          ? data.protein100.value
          : this.protein100,
      carbs100: data.carbs100.present ? data.carbs100.value : this.carbs100,
      sugar100: data.sugar100.present ? data.sugar100.value : this.sugar100,
      fat100: data.fat100.present ? data.fat100.value : this.fat100,
      saturatedFat100: data.saturatedFat100.present
          ? data.saturatedFat100.value
          : this.saturatedFat100,
      fiber100: data.fiber100.present ? data.fiber100.value : this.fiber100,
      salt100: data.salt100.present ? data.salt100.value : this.salt100,
      diaryEntryId: data.diaryEntryId.present
          ? data.diaryEntryId.value
          : this.diaryEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntry(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('foodId: $foodId, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
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
          ..write('diaryEntryId: $diaryEntryId')
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
    recipeId,
    name,
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
    diaryEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanEntry &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.dayKey == this.dayKey &&
          other.mealSlotId == this.mealSlotId &&
          other.foodId == this.foodId &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.amount == this.amount &&
          other.kcal100 == this.kcal100 &&
          other.protein100 == this.protein100 &&
          other.carbs100 == this.carbs100 &&
          other.sugar100 == this.sugar100 &&
          other.fat100 == this.fat100 &&
          other.saturatedFat100 == this.saturatedFat100 &&
          other.fiber100 == this.fiber100 &&
          other.salt100 == this.salt100 &&
          other.diaryEntryId == this.diaryEntryId);
}

class MealPlanEntriesCompanion extends UpdateCompanion<MealPlanEntry> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> dayKey;
  final Value<String> mealSlotId;
  final Value<String?> foodId;
  final Value<String?> recipeId;
  final Value<String> name;
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
  final Value<String?> diaryEntryId;
  final Value<int> rowid;
  const MealPlanEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.mealSlotId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
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
    this.diaryEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlanEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String dayKey,
    required String mealSlotId,
    this.foodId = const Value.absent(),
    this.recipeId = const Value.absent(),
    required String name,
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
    this.diaryEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       mealSlotId = Value(mealSlotId),
       name = Value(name),
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
  static Insertable<MealPlanEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? dayKey,
    Expression<String>? mealSlotId,
    Expression<String>? foodId,
    Expression<String>? recipeId,
    Expression<String>? name,
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
    Expression<String>? diaryEntryId,
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
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
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
      if (diaryEntryId != null) 'diary_entry_id': diaryEntryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlanEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? dayKey,
    Value<String>? mealSlotId,
    Value<String?>? foodId,
    Value<String?>? recipeId,
    Value<String>? name,
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
    Value<String?>? diaryEntryId,
    Value<int>? rowid,
  }) {
    return MealPlanEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dayKey: dayKey ?? this.dayKey,
      mealSlotId: mealSlotId ?? this.mealSlotId,
      foodId: foodId ?? this.foodId,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
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
      diaryEntryId: diaryEntryId ?? this.diaryEntryId,
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
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
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
    if (diaryEntryId.present) {
      map['diary_entry_id'] = Variable<String>(diaryEntryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dayKey: $dayKey, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('foodId: $foodId, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
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
          ..write('diaryEntryId: $diaryEntryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FastingSessionsTable extends FastingSessions
    with TableInfo<$FastingSessionsTable, FastingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastingSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetHoursMeta = const VerificationMeta(
    'targetHours',
  );
  @override
  late final GeneratedColumn<double> targetHours = GeneratedColumn<double>(
    'target_hours',
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
    startAt,
    endAt,
    targetHours,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fasting_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('target_hours')) {
      context.handle(
        _targetHoursMeta,
        targetHours.isAcceptableOrUnknown(
          data['target_hours']!,
          _targetHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetHoursMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FastingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      )!,
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      ),
      targetHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_hours'],
      )!,
    );
  }

  @override
  $FastingSessionsTable createAlias(String alias) {
    return $FastingSessionsTable(attachedDatabase, alias);
  }
}

class FastingSession extends DataClass implements Insertable<FastingSession> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime startAt;
  final DateTime? endAt;
  final double targetHours;
  const FastingSession({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.startAt,
    this.endAt,
    required this.targetHours,
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
    map['start_at'] = Variable<DateTime>(startAt);
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    map['target_hours'] = Variable<double>(targetHours);
    return map;
  }

  FastingSessionsCompanion toCompanion(bool nullToAbsent) {
    return FastingSessionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      startAt: Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      targetHours: Value(targetHours),
    );
  }

  factory FastingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastingSession(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      targetHours: serializer.fromJson<double>(json['targetHours']),
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
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'targetHours': serializer.toJson<double>(targetHours),
    };
  }

  FastingSession copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? startAt,
    Value<DateTime?> endAt = const Value.absent(),
    double? targetHours,
  }) => FastingSession(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    startAt: startAt ?? this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    targetHours: targetHours ?? this.targetHours,
  );
  FastingSession copyWithCompanion(FastingSessionsCompanion data) {
    return FastingSession(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      targetHours: data.targetHours.present
          ? data.targetHours.value
          : this.targetHours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastingSession(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('targetHours: $targetHours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    startAt,
    endAt,
    targetHours,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastingSession &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.targetHours == this.targetHours);
}

class FastingSessionsCompanion extends UpdateCompanion<FastingSession> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> startAt;
  final Value<DateTime?> endAt;
  final Value<double> targetHours;
  final Value<int> rowid;
  const FastingSessionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.targetHours = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FastingSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime startAt,
    this.endAt = const Value.absent(),
    required double targetHours,
    this.rowid = const Value.absent(),
  }) : startAt = Value(startAt),
       targetHours = Value(targetHours);
  static Insertable<FastingSession> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<double>? targetHours,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (targetHours != null) 'target_hours': targetHours,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FastingSessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? startAt,
    Value<DateTime?>? endAt,
    Value<double>? targetHours,
    Value<int>? rowid,
  }) {
    return FastingSessionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      targetHours: targetHours ?? this.targetHours,
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
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (targetHours.present) {
      map['target_hours'] = Variable<double>(targetHours.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('targetHours: $targetHours, ')
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
  late final $ActivityEntriesTable activityEntries = $ActivityEntriesTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final $SupplementIngredientsTable supplementIngredients =
      $SupplementIngredientsTable(this);
  late final $SupplementIntakesTable supplementIntakes =
      $SupplementIntakesTable(this);
  late final $MealPlanEntriesTable mealPlanEntries = $MealPlanEntriesTable(
    this,
  );
  late final $FastingSessionsTable fastingSessions = $FastingSessionsTable(
    this,
  );
  late final Index foodsKey = Index(
    'foods_key',
    'CREATE UNIQUE INDEX foods_key ON foods (food_key)',
  );
  late final Index foodsBarcode = Index(
    'foods_barcode',
    'CREATE UNIQUE INDEX foods_barcode ON foods (barcode)',
  );
  late final Index diaryDay = Index(
    'diary_day',
    'CREATE INDEX diary_day ON diary_entries (day_key)',
  );
  late final Index weightDay = Index(
    'weight_day',
    'CREATE UNIQUE INDEX weight_day ON weight_entries (day_key)',
  );
  late final Index waterDay = Index(
    'water_day',
    'CREATE INDEX water_day ON water_entries (day_key)',
  );
  late final Index activityDay = Index(
    'activity_day',
    'CREATE INDEX activity_day ON activity_entries (day_key)',
  );
  late final Index activityExt = Index(
    'activity_ext',
    'CREATE UNIQUE INDEX activity_ext ON activity_entries (source, external_id)',
  );
  late final Index recipesKey = Index(
    'recipes_key',
    'CREATE UNIQUE INDEX recipes_key ON recipes (name_key)',
  );
  late final Index recipeItemsRecipe = Index(
    'recipe_items_recipe',
    'CREATE INDEX recipe_items_recipe ON recipe_items (recipe_id)',
  );
  late final Index supplementsKey = Index(
    'supplements_key',
    'CREATE UNIQUE INDEX supplements_key ON supplements (name_key)',
  );
  late final Index supplementIngredientsSup = Index(
    'supplement_ingredients_sup',
    'CREATE INDEX supplement_ingredients_sup ON supplement_ingredients (supplement_id)',
  );
  late final Index supplementIntakeSlot = Index(
    'supplement_intake_slot',
    'CREATE UNIQUE INDEX supplement_intake_slot ON supplement_intakes (supplement_id, day_key, planned_minute)',
  );
  late final Index supplementIntakeDay = Index(
    'supplement_intake_day',
    'CREATE INDEX supplement_intake_day ON supplement_intakes (day_key)',
  );
  late final Index mealPlanDay = Index(
    'meal_plan_day',
    'CREATE INDEX meal_plan_day ON meal_plan_entries (day_key)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
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
    recipes,
    recipeItems,
    shoppingItems,
    supplements,
    supplementIngredients,
    supplementIntakes,
    mealPlanEntries,
    fastingSessions,
    foodsKey,
    foodsBarcode,
    diaryDay,
    weightDay,
    waterDay,
    activityDay,
    activityExt,
    recipesKey,
    recipeItemsRecipe,
    supplementsKey,
    supplementIngredientsSup,
    supplementIntakeSlot,
    supplementIntakeDay,
    mealPlanDay,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
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
  Value<double?> carbCapG,
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
  Value<double?> carbCapG,
  Value<double> fiberTargetG,
  Value<int?> waterOverrideMl,
  Value<int> activityCreditPercent,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobActivity => $composableBuilder(
    column: $table.jobActivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sportMinutesPerWeek => $composableBuilder(
    column: $table.sportMinutesPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sportNote => $composableBuilder(
    column: $table.sportNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietStyle => $composableBuilder(
    column: $table.dietStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eatingHabits => $composableBuilder(
    column: $table.eatingHabits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergiesJson => $composableBuilder(
    column: $table.allergiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredFoodsJson => $composableBuilder(
    column: $table.preferredFoodsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dislikedFoodsJson => $composableBuilder(
    column: $table.dislikedFoodsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calorieOverride => $composableBuilder(
    column: $table.calorieOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proteinOverrideG => $composableBuilder(
    column: $table.proteinOverrideG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPerKg => $composableBuilder(
    column: $table.proteinPerKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPercent => $composableBuilder(
    column: $table.fatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbCapG => $composableBuilder(
    column: $table.carbCapG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberTargetG => $composableBuilder(
    column: $table.fiberTargetG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterOverrideMl => $composableBuilder(
    column: $table.waterOverrideMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activityCreditPercent => $composableBuilder(
    column: $table.activityCreditPercent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobActivity => $composableBuilder(
    column: $table.jobActivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sportMinutesPerWeek => $composableBuilder(
    column: $table.sportMinutesPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sportNote => $composableBuilder(
    column: $table.sportNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietStyle => $composableBuilder(
    column: $table.dietStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eatingHabits => $composableBuilder(
    column: $table.eatingHabits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergiesJson => $composableBuilder(
    column: $table.allergiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredFoodsJson => $composableBuilder(
    column: $table.preferredFoodsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dislikedFoodsJson => $composableBuilder(
    column: $table.dislikedFoodsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calorieOverride => $composableBuilder(
    column: $table.calorieOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proteinOverrideG => $composableBuilder(
    column: $table.proteinOverrideG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPerKg => $composableBuilder(
    column: $table.proteinPerKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPercent => $composableBuilder(
    column: $table.fatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbCapG => $composableBuilder(
    column: $table.carbCapG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberTargetG => $composableBuilder(
    column: $table.fiberTargetG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterOverrideMl => $composableBuilder(
    column: $table.waterOverrideMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityCreditPercent => $composableBuilder(
    column: $table.activityCreditPercent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get startWeightKg => $composableBuilder(
    column: $table.startWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occupation => $composableBuilder(
    column: $table.occupation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jobActivity => $composableBuilder(
    column: $table.jobActivity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sportMinutesPerWeek => $composableBuilder(
    column: $table.sportMinutesPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sportNote =>
      $composableBuilder(column: $table.sportNote, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietStyle =>
      $composableBuilder(column: $table.dietStyle, builder: (column) => column);

  GeneratedColumn<String> get eatingHabits => $composableBuilder(
    column: $table.eatingHabits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergiesJson => $composableBuilder(
    column: $table.allergiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredFoodsJson => $composableBuilder(
    column: $table.preferredFoodsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dislikedFoodsJson => $composableBuilder(
    column: $table.dislikedFoodsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calorieOverride => $composableBuilder(
    column: $table.calorieOverride,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proteinOverrideG => $composableBuilder(
    column: $table.proteinOverrideG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPerKg => $composableBuilder(
    column: $table.proteinPerKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPercent => $composableBuilder(
    column: $table.fatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbCapG =>
      $composableBuilder(column: $table.carbCapG, builder: (column) => column);

  GeneratedColumn<double> get fiberTargetG => $composableBuilder(
    column: $table.fiberTargetG,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterOverrideMl => $composableBuilder(
    column: $table.waterOverrideMl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activityCreditPercent => $composableBuilder(
    column: $table.activityCreditPercent,
    builder: (column) => column,
  );
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
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
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
                Value<double?> carbCapG = const Value.absent(),
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
                carbCapG: carbCapG,
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
                Value<double?> carbCapG = const Value.absent(),
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
                carbCapG: carbCapG,
                fiberTargetG: fiberTargetG,
                waterOverrideMl: waterOverrideMl,
                activityCreditPercent: activityCreditPercent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
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

class $$MealSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
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
          createFilteringComposer: () =>
              $$MealSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealSlotsTableAnnotationComposer($db: db, $table: table),
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
                  BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlot>(
                    db,
                    table,
                    e,
                  ),
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
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodKey => $composableBuilder(
    column: $table.foodKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saturatedFat => $composableBuilder(
    column: $table.saturatedFat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiber => $composableBuilder(
    column: $table.fiber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingAmount => $composableBuilder(
    column: $table.servingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodKey => $composableBuilder(
    column: $table.foodKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saturatedFat => $composableBuilder(
    column: $table.saturatedFat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiber => $composableBuilder(
    column: $table.fiber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingAmount => $composableBuilder(
    column: $table.servingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get foodKey =>
      $composableBuilder(column: $table.foodKey, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get saturatedFat => $composableBuilder(
    column: $table.saturatedFat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<double> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<double> get servingAmount => $composableBuilder(
    column: $table.servingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
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
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
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
                  BaseReferences<_$AppDatabase, $FoodsTable, Food>(
                    db,
                    table,
                    e,
                  ),
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
typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
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
      Value<String?> recipeId,
      Value<int> rowid,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
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
      Value<String?> recipeId,
      Value<int> rowid,
    });

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealSlotId => $composableBuilder(
    column: $table.mealSlotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal100 => $composableBuilder(
    column: $table.kcal100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs100 => $composableBuilder(
    column: $table.carbs100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar100 => $composableBuilder(
    column: $table.sugar100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat100 => $composableBuilder(
    column: $table.fat100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiber100 => $composableBuilder(
    column: $table.fiber100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salt100 => $composableBuilder(
    column: $table.salt100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealSlotId => $composableBuilder(
    column: $table.mealSlotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal100 => $composableBuilder(
    column: $table.kcal100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs100 => $composableBuilder(
    column: $table.carbs100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar100 => $composableBuilder(
    column: $table.sugar100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat100 => $composableBuilder(
    column: $table.fat100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiber100 => $composableBuilder(
    column: $table.fiber100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salt100 => $composableBuilder(
    column: $table.salt100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get mealSlotId => $composableBuilder(
    column: $table.mealSlotId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get kcal100 =>
      $composableBuilder(column: $table.kcal100, builder: (column) => column);

  GeneratedColumn<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbs100 =>
      $composableBuilder(column: $table.carbs100, builder: (column) => column);

  GeneratedColumn<double> get sugar100 =>
      $composableBuilder(column: $table.sugar100, builder: (column) => column);

  GeneratedColumn<double> get fat100 =>
      $composableBuilder(column: $table.fat100, builder: (column) => column);

  GeneratedColumn<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiber100 =>
      $composableBuilder(column: $table.fiber100, builder: (column) => column);

  GeneratedColumn<double> get salt100 =>
      $composableBuilder(column: $table.salt100, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);
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
          (
            DiaryEntry,
            BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>,
          ),
          DiaryEntry,
          PrefetchHooks Function()
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
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
                Value<String?> recipeId = const Value.absent(),
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
                recipeId: recipeId,
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
                Value<String?> recipeId = const Value.absent(),
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
                recipeId: recipeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DiaryEntriesTable, DiaryEntry>(table),
                  BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>(
                    db,
                    table,
                    e,
                  ),
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
      (
        DiaryEntry,
        BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>,
      ),
      DiaryEntry,
      PrefetchHooks Function()
    >;
typedef $$WeightEntriesTableCreateCompanionBuilder =
    WeightEntriesCompanion Function({
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
typedef $$WeightEntriesTableUpdateCompanionBuilder =
    WeightEntriesCompanion Function({
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

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
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
          (
            WeightEntry,
            BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
          ),
          WeightEntry,
          PrefetchHooks Function()
        > {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
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
                  BaseReferences<
                    _$AppDatabase,
                    $WeightEntriesTable,
                    WeightEntry
                  >(db, table, e),
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
      (
        WeightEntry,
        BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntry>,
      ),
      WeightEntry,
      PrefetchHooks Function()
    >;
typedef $$WaterEntriesTableCreateCompanionBuilder =
    WaterEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String dayKey,
      required int ml,
      Value<int> rowid,
    });
typedef $$WaterEntriesTableUpdateCompanionBuilder =
    WaterEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> dayKey,
      Value<int> ml,
      Value<int> rowid,
    });

class $$WaterEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ml => $composableBuilder(
    column: $table.ml,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ml => $composableBuilder(
    column: $table.ml,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterEntriesTable> {
  $$WaterEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get ml =>
      $composableBuilder(column: $table.ml, builder: (column) => column);
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
          (
            WaterEntry,
            BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>,
          ),
          WaterEntry,
          PrefetchHooks Function()
        > {
  $$WaterEntriesTableTableManager(_$AppDatabase db, $WaterEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterEntriesTableAnnotationComposer($db: db, $table: table),
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
                  BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>(
                    db,
                    table,
                    e,
                  ),
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
      (
        WaterEntry,
        BaseReferences<_$AppDatabase, $WaterEntriesTable, WaterEntry>,
      ),
      WaterEntry,
      PrefetchHooks Function()
    >;
typedef $$ActivityEntriesTableCreateCompanionBuilder =
    ActivityEntriesCompanion Function({
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
typedef $$ActivityEntriesTableUpdateCompanionBuilder =
    ActivityEntriesCompanion Function({
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

class $$ActivityEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal => $composableBuilder(
    column: $table.kcal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityEntriesTable> {
  $$ActivityEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );
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
          (
            ActivityEntry,
            BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityEntry>,
          ),
          ActivityEntry,
          PrefetchHooks Function()
        > {
  $$ActivityEntriesTableTableManager(
    _$AppDatabase db,
    $ActivityEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityEntriesTableAnnotationComposer($db: db, $table: table),
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
                  BaseReferences<
                    _$AppDatabase,
                    $ActivityEntriesTable,
                    ActivityEntry
                  >(db, table, e),
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
      (
        ActivityEntry,
        BaseReferences<_$AppDatabase, $ActivityEntriesTable, ActivityEntry>,
      ),
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

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
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
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
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
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
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
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String name,
  required String nameKey,
  required double servings,
  Value<double?> cookedWeightG,
  Value<int?> prepMinutes,
  Value<String?> instructions,
  Value<String> tagsJson,
  Value<bool> isFavorite,
  Value<int> rowid,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> name,
  Value<String> nameKey,
  Value<double> servings,
  Value<double?> cookedWeightG,
  Value<int?> prepMinutes,
  Value<String?> instructions,
  Value<String> tagsJson,
  Value<bool> isFavorite,
  Value<int> rowid,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cookedWeightG => $composableBuilder(
    column: $table.cookedWeightG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cookedWeightG => $composableBuilder(
    column: $table.cookedWeightG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<double> get cookedWeightG => $composableBuilder(
    column: $table.cookedWeightG,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
          Recipe,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<double?> cookedWeightG = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                nameKey: nameKey,
                servings: servings,
                cookedWeightG: cookedWeightG,
                prepMinutes: prepMinutes,
                instructions: instructions,
                tagsJson: tagsJson,
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
                required String nameKey,
                required double servings,
                Value<double?> cookedWeightG = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                nameKey: nameKey,
                servings: servings,
                cookedWeightG: cookedWeightG,
                prepMinutes: prepMinutes,
                instructions: instructions,
                tagsJson: tagsJson,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, Recipe>(table),
                  BaseReferences<_$AppDatabase, $RecipesTable, Recipe>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
      Recipe,
      PrefetchHooks Function()
    >;
typedef $$RecipeItemsTableCreateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String recipeId,
      Value<String?> foodId,
      required String foodName,
      Value<String?> brand,
      required String unit,
      required double amount,
      required int sortOrder,
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
typedef $$RecipeItemsTableUpdateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> recipeId,
      Value<String?> foodId,
      Value<String> foodName,
      Value<String?> brand,
      Value<String> unit,
      Value<double> amount,
      Value<int> sortOrder,
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

class $$RecipeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal100 => $composableBuilder(
    column: $table.kcal100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs100 => $composableBuilder(
    column: $table.carbs100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar100 => $composableBuilder(
    column: $table.sugar100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat100 => $composableBuilder(
    column: $table.fat100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiber100 => $composableBuilder(
    column: $table.fiber100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salt100 => $composableBuilder(
    column: $table.salt100,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal100 => $composableBuilder(
    column: $table.kcal100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs100 => $composableBuilder(
    column: $table.carbs100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar100 => $composableBuilder(
    column: $table.sugar100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat100 => $composableBuilder(
    column: $table.fat100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiber100 => $composableBuilder(
    column: $table.fiber100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salt100 => $composableBuilder(
    column: $table.salt100,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<double> get kcal100 =>
      $composableBuilder(column: $table.kcal100, builder: (column) => column);

  GeneratedColumn<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbs100 =>
      $composableBuilder(column: $table.carbs100, builder: (column) => column);

  GeneratedColumn<double> get sugar100 =>
      $composableBuilder(column: $table.sugar100, builder: (column) => column);

  GeneratedColumn<double> get fat100 =>
      $composableBuilder(column: $table.fat100, builder: (column) => column);

  GeneratedColumn<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiber100 =>
      $composableBuilder(column: $table.fiber100, builder: (column) => column);

  GeneratedColumn<double> get salt100 =>
      $composableBuilder(column: $table.salt100, builder: (column) => column);
}

class $$RecipeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeItemsTable,
          RecipeItem,
          $$RecipeItemsTableFilterComposer,
          $$RecipeItemsTableOrderingComposer,
          $$RecipeItemsTableAnnotationComposer,
          $$RecipeItemsTableCreateCompanionBuilder,
          $$RecipeItemsTableUpdateCompanionBuilder,
          (
            RecipeItem,
            BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItem>,
          ),
          RecipeItem,
          PrefetchHooks Function()
        > {
  $$RecipeItemsTableTableManager(_$AppDatabase db, $RecipeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<double> kcal100 = const Value.absent(),
                Value<double> protein100 = const Value.absent(),
                Value<double> carbs100 = const Value.absent(),
                Value<double> sugar100 = const Value.absent(),
                Value<double> fat100 = const Value.absent(),
                Value<double> saturatedFat100 = const Value.absent(),
                Value<double> fiber100 = const Value.absent(),
                Value<double> salt100 = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                recipeId: recipeId,
                foodId: foodId,
                foodName: foodName,
                brand: brand,
                unit: unit,
                amount: amount,
                sortOrder: sortOrder,
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
                required String recipeId,
                Value<String?> foodId = const Value.absent(),
                required String foodName,
                Value<String?> brand = const Value.absent(),
                required String unit,
                required double amount,
                required int sortOrder,
                required double kcal100,
                required double protein100,
                required double carbs100,
                required double sugar100,
                required double fat100,
                required double saturatedFat100,
                required double fiber100,
                required double salt100,
                Value<int> rowid = const Value.absent(),
              }) => RecipeItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                recipeId: recipeId,
                foodId: foodId,
                foodName: foodName,
                brand: brand,
                unit: unit,
                amount: amount,
                sortOrder: sortOrder,
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
                  e.readTable<$RecipeItemsTable, RecipeItem>(table),
                  BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeItemsTable,
      RecipeItem,
      $$RecipeItemsTableFilterComposer,
      $$RecipeItemsTableOrderingComposer,
      $$RecipeItemsTableAnnotationComposer,
      $$RecipeItemsTableCreateCompanionBuilder,
      $$RecipeItemsTableUpdateCompanionBuilder,
      (
        RecipeItem,
        BaseReferences<_$AppDatabase, $RecipeItemsTable, RecipeItem>,
      ),
      RecipeItem,
      PrefetchHooks Function()
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String label,
      required String itemKey,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> foodId,
      Value<String?> category,
      Value<String?> fromRecipes,
      Value<bool> checked,
      Value<int> rowid,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> label,
      Value<String> itemKey,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> foodId,
      Value<String?> category,
      Value<String?> fromRecipes,
      Value<bool> checked,
      Value<int> rowid,
    });

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromRecipes => $composableBuilder(
    column: $table.fromRecipes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromRecipes => $composableBuilder(
    column: $table.fromRecipes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get fromRecipes => $composableBuilder(
    column: $table.fromRecipes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemsTable,
          ShoppingItem,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (
            ShoppingItem,
            BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>,
          ),
          ShoppingItem,
          PrefetchHooks Function()
        > {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> itemKey = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> fromRecipes = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                label: label,
                itemKey: itemKey,
                amount: amount,
                unit: unit,
                foodId: foodId,
                category: category,
                fromRecipes: fromRecipes,
                checked: checked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String label,
                required String itemKey,
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> fromRecipes = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                label: label,
                itemKey: itemKey,
                amount: amount,
                unit: unit,
                foodId: foodId,
                category: category,
                fromRecipes: fromRecipes,
                checked: checked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingItemsTable, ShoppingItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ShoppingItemsTable,
                    ShoppingItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemsTable,
      ShoppingItem,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (
        ShoppingItem,
        BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>,
      ),
      ShoppingItem,
      PrefetchHooks Function()
    >;
typedef $$SupplementsTableCreateCompanionBuilder =
    SupplementsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String name,
      Value<String?> brand,
      required String nameKey,
      Value<String?> form,
      Value<String> servingLabel,
      Value<String?> manufacturerDose,
      Value<double> servingsPerDay,
      Value<String> timesJson,
      Value<bool> active,
      Value<double?> stockServings,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$SupplementsTableUpdateCompanionBuilder =
    SupplementsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> name,
      Value<String?> brand,
      Value<String> nameKey,
      Value<String?> form,
      Value<String> servingLabel,
      Value<String?> manufacturerDose,
      Value<double> servingsPerDay,
      Value<String> timesJson,
      Value<bool> active,
      Value<double?> stockServings,
      Value<String?> note,
      Value<int> rowid,
    });

class $$SupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturerDose => $composableBuilder(
    column: $table.manufacturerDose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingsPerDay => $composableBuilder(
    column: $table.servingsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timesJson => $composableBuilder(
    column: $table.timesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockServings => $composableBuilder(
    column: $table.stockServings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturerDose => $composableBuilder(
    column: $table.manufacturerDose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingsPerDay => $composableBuilder(
    column: $table.servingsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timesJson => $composableBuilder(
    column: $table.timesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockServings => $composableBuilder(
    column: $table.stockServings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturerDose => $composableBuilder(
    column: $table.manufacturerDose,
    builder: (column) => column,
  );

  GeneratedColumn<double> get servingsPerDay => $composableBuilder(
    column: $table.servingsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timesJson =>
      $composableBuilder(column: $table.timesJson, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<double> get stockServings => $composableBuilder(
    column: $table.stockServings,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementsTable,
          Supplement,
          $$SupplementsTableFilterComposer,
          $$SupplementsTableOrderingComposer,
          $$SupplementsTableAnnotationComposer,
          $$SupplementsTableCreateCompanionBuilder,
          $$SupplementsTableUpdateCompanionBuilder,
          (
            Supplement,
            BaseReferences<_$AppDatabase, $SupplementsTable, Supplement>,
          ),
          Supplement,
          PrefetchHooks Function()
        > {
  $$SupplementsTableTableManager(_$AppDatabase db, $SupplementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<String?> form = const Value.absent(),
                Value<String> servingLabel = const Value.absent(),
                Value<String?> manufacturerDose = const Value.absent(),
                Value<double> servingsPerDay = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<double?> stockServings = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                brand: brand,
                nameKey: nameKey,
                form: form,
                servingLabel: servingLabel,
                manufacturerDose: manufacturerDose,
                servingsPerDay: servingsPerDay,
                timesJson: timesJson,
                active: active,
                stockServings: stockServings,
                note: note,
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
                required String nameKey,
                Value<String?> form = const Value.absent(),
                Value<String> servingLabel = const Value.absent(),
                Value<String?> manufacturerDose = const Value.absent(),
                Value<double> servingsPerDay = const Value.absent(),
                Value<String> timesJson = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<double?> stockServings = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                name: name,
                brand: brand,
                nameKey: nameKey,
                form: form,
                servingLabel: servingLabel,
                manufacturerDose: manufacturerDose,
                servingsPerDay: servingsPerDay,
                timesJson: timesJson,
                active: active,
                stockServings: stockServings,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupplementsTable, Supplement>(table),
                  BaseReferences<_$AppDatabase, $SupplementsTable, Supplement>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementsTable,
      Supplement,
      $$SupplementsTableFilterComposer,
      $$SupplementsTableOrderingComposer,
      $$SupplementsTableAnnotationComposer,
      $$SupplementsTableCreateCompanionBuilder,
      $$SupplementsTableUpdateCompanionBuilder,
      (
        Supplement,
        BaseReferences<_$AppDatabase, $SupplementsTable, Supplement>,
      ),
      Supplement,
      PrefetchHooks Function()
    >;
typedef $$SupplementIngredientsTableCreateCompanionBuilder =
    SupplementIngredientsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String supplementId,
      required String nutrientId,
      Value<String?> name,
      required double amount,
      required String unit,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$SupplementIngredientsTableUpdateCompanionBuilder =
    SupplementIngredientsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> supplementId,
      Value<String> nutrientId,
      Value<String?> name,
      Value<double> amount,
      Value<String> unit,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$SupplementIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementIngredientsTable> {
  $$SupplementIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementIngredientsTable> {
  $$SupplementIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementIngredientsTable> {
  $$SupplementIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SupplementIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementIngredientsTable,
          SupplementIngredient,
          $$SupplementIngredientsTableFilterComposer,
          $$SupplementIngredientsTableOrderingComposer,
          $$SupplementIngredientsTableAnnotationComposer,
          $$SupplementIngredientsTableCreateCompanionBuilder,
          $$SupplementIngredientsTableUpdateCompanionBuilder,
          (
            SupplementIngredient,
            BaseReferences<
              _$AppDatabase,
              $SupplementIngredientsTable,
              SupplementIngredient
            >,
          ),
          SupplementIngredient,
          PrefetchHooks Function()
        > {
  $$SupplementIngredientsTableTableManager(
    _$AppDatabase db,
    $SupplementIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementIngredientsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SupplementIngredientsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SupplementIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> supplementId = const Value.absent(),
                Value<String> nutrientId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementIngredientsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                supplementId: supplementId,
                nutrientId: nutrientId,
                name: name,
                amount: amount,
                unit: unit,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String supplementId,
                required String nutrientId,
                Value<String?> name = const Value.absent(),
                required double amount,
                required String unit,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => SupplementIngredientsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                supplementId: supplementId,
                nutrientId: nutrientId,
                name: name,
                amount: amount,
                unit: unit,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $SupplementIngredientsTable,
                    SupplementIngredient
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SupplementIngredientsTable,
                    SupplementIngredient
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementIngredientsTable,
      SupplementIngredient,
      $$SupplementIngredientsTableFilterComposer,
      $$SupplementIngredientsTableOrderingComposer,
      $$SupplementIngredientsTableAnnotationComposer,
      $$SupplementIngredientsTableCreateCompanionBuilder,
      $$SupplementIngredientsTableUpdateCompanionBuilder,
      (
        SupplementIngredient,
        BaseReferences<
          _$AppDatabase,
          $SupplementIngredientsTable,
          SupplementIngredient
        >,
      ),
      SupplementIngredient,
      PrefetchHooks Function()
    >;
typedef $$SupplementIntakesTableCreateCompanionBuilder =
    SupplementIntakesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String supplementId,
      required String dayKey,
      required int plannedMinute,
      required double servings,
      Value<int> rowid,
    });
typedef $$SupplementIntakesTableUpdateCompanionBuilder =
    SupplementIntakesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> supplementId,
      Value<String> dayKey,
      Value<int> plannedMinute,
      Value<double> servings,
      Value<int> rowid,
    });

class $$SupplementIntakesTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementIntakesTable> {
  $$SupplementIntakesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinute => $composableBuilder(
    column: $table.plannedMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementIntakesTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementIntakesTable> {
  $$SupplementIntakesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinute => $composableBuilder(
    column: $table.plannedMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementIntakesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementIntakesTable> {
  $$SupplementIntakesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get supplementId => $composableBuilder(
    column: $table.supplementId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<int> get plannedMinute => $composableBuilder(
    column: $table.plannedMinute,
    builder: (column) => column,
  );

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);
}

class $$SupplementIntakesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementIntakesTable,
          SupplementIntake,
          $$SupplementIntakesTableFilterComposer,
          $$SupplementIntakesTableOrderingComposer,
          $$SupplementIntakesTableAnnotationComposer,
          $$SupplementIntakesTableCreateCompanionBuilder,
          $$SupplementIntakesTableUpdateCompanionBuilder,
          (
            SupplementIntake,
            BaseReferences<
              _$AppDatabase,
              $SupplementIntakesTable,
              SupplementIntake
            >,
          ),
          SupplementIntake,
          PrefetchHooks Function()
        > {
  $$SupplementIntakesTableTableManager(
    _$AppDatabase db,
    $SupplementIntakesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementIntakesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementIntakesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementIntakesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> supplementId = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<int> plannedMinute = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplementIntakesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                supplementId: supplementId,
                dayKey: dayKey,
                plannedMinute: plannedMinute,
                servings: servings,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String supplementId,
                required String dayKey,
                required int plannedMinute,
                required double servings,
                Value<int> rowid = const Value.absent(),
              }) => SupplementIntakesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                supplementId: supplementId,
                dayKey: dayKey,
                plannedMinute: plannedMinute,
                servings: servings,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupplementIntakesTable, SupplementIntake>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SupplementIntakesTable,
                    SupplementIntake
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementIntakesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementIntakesTable,
      SupplementIntake,
      $$SupplementIntakesTableFilterComposer,
      $$SupplementIntakesTableOrderingComposer,
      $$SupplementIntakesTableAnnotationComposer,
      $$SupplementIntakesTableCreateCompanionBuilder,
      $$SupplementIntakesTableUpdateCompanionBuilder,
      (
        SupplementIntake,
        BaseReferences<
          _$AppDatabase,
          $SupplementIntakesTable,
          SupplementIntake
        >,
      ),
      SupplementIntake,
      PrefetchHooks Function()
    >;
typedef $$MealPlanEntriesTableCreateCompanionBuilder =
    MealPlanEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String dayKey,
      required String mealSlotId,
      Value<String?> foodId,
      Value<String?> recipeId,
      required String name,
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
      Value<String?> diaryEntryId,
      Value<int> rowid,
    });
typedef $$MealPlanEntriesTableUpdateCompanionBuilder =
    MealPlanEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> dayKey,
      Value<String> mealSlotId,
      Value<String?> foodId,
      Value<String?> recipeId,
      Value<String> name,
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
      Value<String?> diaryEntryId,
      Value<int> rowid,
    });

class $$MealPlanEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlanEntriesTable> {
  $$MealPlanEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealSlotId => $composableBuilder(
    column: $table.mealSlotId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcal100 => $composableBuilder(
    column: $table.kcal100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs100 => $composableBuilder(
    column: $table.carbs100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar100 => $composableBuilder(
    column: $table.sugar100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat100 => $composableBuilder(
    column: $table.fat100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiber100 => $composableBuilder(
    column: $table.fiber100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salt100 => $composableBuilder(
    column: $table.salt100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diaryEntryId => $composableBuilder(
    column: $table.diaryEntryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealPlanEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlanEntriesTable> {
  $$MealPlanEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealSlotId => $composableBuilder(
    column: $table.mealSlotId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcal100 => $composableBuilder(
    column: $table.kcal100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs100 => $composableBuilder(
    column: $table.carbs100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar100 => $composableBuilder(
    column: $table.sugar100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat100 => $composableBuilder(
    column: $table.fat100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiber100 => $composableBuilder(
    column: $table.fiber100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salt100 => $composableBuilder(
    column: $table.salt100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diaryEntryId => $composableBuilder(
    column: $table.diaryEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealPlanEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlanEntriesTable> {
  $$MealPlanEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get mealSlotId => $composableBuilder(
    column: $table.mealSlotId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get kcal100 =>
      $composableBuilder(column: $table.kcal100, builder: (column) => column);

  GeneratedColumn<double> get protein100 => $composableBuilder(
    column: $table.protein100,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbs100 =>
      $composableBuilder(column: $table.carbs100, builder: (column) => column);

  GeneratedColumn<double> get sugar100 =>
      $composableBuilder(column: $table.sugar100, builder: (column) => column);

  GeneratedColumn<double> get fat100 =>
      $composableBuilder(column: $table.fat100, builder: (column) => column);

  GeneratedColumn<double> get saturatedFat100 => $composableBuilder(
    column: $table.saturatedFat100,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiber100 =>
      $composableBuilder(column: $table.fiber100, builder: (column) => column);

  GeneratedColumn<double> get salt100 =>
      $composableBuilder(column: $table.salt100, builder: (column) => column);

  GeneratedColumn<String> get diaryEntryId => $composableBuilder(
    column: $table.diaryEntryId,
    builder: (column) => column,
  );
}

class $$MealPlanEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPlanEntriesTable,
          MealPlanEntry,
          $$MealPlanEntriesTableFilterComposer,
          $$MealPlanEntriesTableOrderingComposer,
          $$MealPlanEntriesTableAnnotationComposer,
          $$MealPlanEntriesTableCreateCompanionBuilder,
          $$MealPlanEntriesTableUpdateCompanionBuilder,
          (
            MealPlanEntry,
            BaseReferences<_$AppDatabase, $MealPlanEntriesTable, MealPlanEntry>,
          ),
          MealPlanEntry,
          PrefetchHooks Function()
        > {
  $$MealPlanEntriesTableTableManager(
    _$AppDatabase db,
    $MealPlanEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlanEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlanEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlanEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> mealSlotId = const Value.absent(),
                Value<String?> foodId = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<String> name = const Value.absent(),
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
                Value<String?> diaryEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlanEntriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                mealSlotId: mealSlotId,
                foodId: foodId,
                recipeId: recipeId,
                name: name,
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
                diaryEntryId: diaryEntryId,
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
                Value<String?> recipeId = const Value.absent(),
                required String name,
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
                Value<String?> diaryEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlanEntriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                dayKey: dayKey,
                mealSlotId: mealSlotId,
                foodId: foodId,
                recipeId: recipeId,
                name: name,
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
                diaryEntryId: diaryEntryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealPlanEntriesTable, MealPlanEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MealPlanEntriesTable,
                    MealPlanEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealPlanEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPlanEntriesTable,
      MealPlanEntry,
      $$MealPlanEntriesTableFilterComposer,
      $$MealPlanEntriesTableOrderingComposer,
      $$MealPlanEntriesTableAnnotationComposer,
      $$MealPlanEntriesTableCreateCompanionBuilder,
      $$MealPlanEntriesTableUpdateCompanionBuilder,
      (
        MealPlanEntry,
        BaseReferences<_$AppDatabase, $MealPlanEntriesTable, MealPlanEntry>,
      ),
      MealPlanEntry,
      PrefetchHooks Function()
    >;
typedef $$FastingSessionsTableCreateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required DateTime startAt,
      Value<DateTime?> endAt,
      required double targetHours,
      Value<int> rowid,
    });
typedef $$FastingSessionsTableUpdateCompanionBuilder =
    FastingSessionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime> startAt,
      Value<DateTime?> endAt,
      Value<double> targetHours,
      Value<int> rowid,
    });

class $$FastingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FastingSessionsTable> {
  $$FastingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<double> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => column,
  );
}

class $$FastingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FastingSessionsTable,
          FastingSession,
          $$FastingSessionsTableFilterComposer,
          $$FastingSessionsTableOrderingComposer,
          $$FastingSessionsTableAnnotationComposer,
          $$FastingSessionsTableCreateCompanionBuilder,
          $$FastingSessionsTableUpdateCompanionBuilder,
          (
            FastingSession,
            BaseReferences<
              _$AppDatabase,
              $FastingSessionsTable,
              FastingSession
            >,
          ),
          FastingSession,
          PrefetchHooks Function()
        > {
  $$FastingSessionsTableTableManager(
    _$AppDatabase db,
    $FastingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FastingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FastingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FastingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<double> targetHours = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FastingSessionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                startAt: startAt,
                endAt: endAt,
                targetHours: targetHours,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required DateTime startAt,
                Value<DateTime?> endAt = const Value.absent(),
                required double targetHours,
                Value<int> rowid = const Value.absent(),
              }) => FastingSessionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                startAt: startAt,
                endAt: endAt,
                targetHours: targetHours,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FastingSessionsTable, FastingSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FastingSessionsTable,
                    FastingSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FastingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FastingSessionsTable,
      FastingSession,
      $$FastingSessionsTableFilterComposer,
      $$FastingSessionsTableOrderingComposer,
      $$FastingSessionsTableAnnotationComposer,
      $$FastingSessionsTableCreateCompanionBuilder,
      $$FastingSessionsTableUpdateCompanionBuilder,
      (
        FastingSession,
        BaseReferences<_$AppDatabase, $FastingSessionsTable, FastingSession>,
      ),
      FastingSession,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$MealSlotsTableTableManager get mealSlots =>
      $$MealSlotsTableTableManager(_db, _db.mealSlots);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$WaterEntriesTableTableManager get waterEntries =>
      $$WaterEntriesTableTableManager(_db, _db.waterEntries);
  $$ActivityEntriesTableTableManager get activityEntries =>
      $$ActivityEntriesTableTableManager(_db, _db.activityEntries);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$SupplementsTableTableManager get supplements =>
      $$SupplementsTableTableManager(_db, _db.supplements);
  $$SupplementIngredientsTableTableManager get supplementIngredients =>
      $$SupplementIngredientsTableTableManager(_db, _db.supplementIngredients);
  $$SupplementIntakesTableTableManager get supplementIntakes =>
      $$SupplementIntakesTableTableManager(_db, _db.supplementIntakes);
  $$MealPlanEntriesTableTableManager get mealPlanEntries =>
      $$MealPlanEntriesTableTableManager(_db, _db.mealPlanEntries);
  $$FastingSessionsTableTableManager get fastingSessions =>
      $$FastingSessionsTableTableManager(_db, _db.fastingSessions);
}
