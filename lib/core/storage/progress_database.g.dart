// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_database.dart';

// ignore_for_file: type=lint
class $PuzzleScoresTable extends PuzzleScores
    with TableInfo<$PuzzleScoresTable, PuzzleScore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuzzleScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<int> stars = GeneratedColumn<int>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movesMeta = const VerificationMeta('moves');
  @override
  late final GeneratedColumn<int> moves = GeneratedColumn<int>(
    'moves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [size, seed, version, stars, moves];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'puzzle_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<PuzzleScore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('moves')) {
      context.handle(
        _movesMeta,
        moves.isAcceptableOrUnknown(data['moves']!, _movesMeta),
      );
    } else if (isInserting) {
      context.missing(_movesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {size, seed, version};
  @override
  PuzzleScore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PuzzleScore(
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stars'],
      )!,
      moves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moves'],
      )!,
    );
  }

  @override
  $PuzzleScoresTable createAlias(String alias) {
    return $PuzzleScoresTable(attachedDatabase, alias);
  }
}

class PuzzleScore extends DataClass implements Insertable<PuzzleScore> {
  final int size;
  final int seed;
  final int version;
  final int stars;
  final int moves;
  const PuzzleScore({
    required this.size,
    required this.seed,
    required this.version,
    required this.stars,
    required this.moves,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['size'] = Variable<int>(size);
    map['seed'] = Variable<int>(seed);
    map['version'] = Variable<int>(version);
    map['stars'] = Variable<int>(stars);
    map['moves'] = Variable<int>(moves);
    return map;
  }

  PuzzleScoresCompanion toCompanion(bool nullToAbsent) {
    return PuzzleScoresCompanion(
      size: Value(size),
      seed: Value(seed),
      version: Value(version),
      stars: Value(stars),
      moves: Value(moves),
    );
  }

  factory PuzzleScore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PuzzleScore(
      size: serializer.fromJson<int>(json['size']),
      seed: serializer.fromJson<int>(json['seed']),
      version: serializer.fromJson<int>(json['version']),
      stars: serializer.fromJson<int>(json['stars']),
      moves: serializer.fromJson<int>(json['moves']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'size': serializer.toJson<int>(size),
      'seed': serializer.toJson<int>(seed),
      'version': serializer.toJson<int>(version),
      'stars': serializer.toJson<int>(stars),
      'moves': serializer.toJson<int>(moves),
    };
  }

  PuzzleScore copyWith({
    int? size,
    int? seed,
    int? version,
    int? stars,
    int? moves,
  }) => PuzzleScore(
    size: size ?? this.size,
    seed: seed ?? this.seed,
    version: version ?? this.version,
    stars: stars ?? this.stars,
    moves: moves ?? this.moves,
  );
  PuzzleScore copyWithCompanion(PuzzleScoresCompanion data) {
    return PuzzleScore(
      size: data.size.present ? data.size.value : this.size,
      seed: data.seed.present ? data.seed.value : this.seed,
      version: data.version.present ? data.version.value : this.version,
      stars: data.stars.present ? data.stars.value : this.stars,
      moves: data.moves.present ? data.moves.value : this.moves,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PuzzleScore(')
          ..write('size: $size, ')
          ..write('seed: $seed, ')
          ..write('version: $version, ')
          ..write('stars: $stars, ')
          ..write('moves: $moves')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(size, seed, version, stars, moves);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PuzzleScore &&
          other.size == this.size &&
          other.seed == this.seed &&
          other.version == this.version &&
          other.stars == this.stars &&
          other.moves == this.moves);
}

class PuzzleScoresCompanion extends UpdateCompanion<PuzzleScore> {
  final Value<int> size;
  final Value<int> seed;
  final Value<int> version;
  final Value<int> stars;
  final Value<int> moves;
  final Value<int> rowid;
  const PuzzleScoresCompanion({
    this.size = const Value.absent(),
    this.seed = const Value.absent(),
    this.version = const Value.absent(),
    this.stars = const Value.absent(),
    this.moves = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PuzzleScoresCompanion.insert({
    required int size,
    required int seed,
    required int version,
    required int stars,
    required int moves,
    this.rowid = const Value.absent(),
  }) : size = Value(size),
       seed = Value(seed),
       version = Value(version),
       stars = Value(stars),
       moves = Value(moves);
  static Insertable<PuzzleScore> custom({
    Expression<int>? size,
    Expression<int>? seed,
    Expression<int>? version,
    Expression<int>? stars,
    Expression<int>? moves,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (size != null) 'size': size,
      if (seed != null) 'seed': seed,
      if (version != null) 'version': version,
      if (stars != null) 'stars': stars,
      if (moves != null) 'moves': moves,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PuzzleScoresCompanion copyWith({
    Value<int>? size,
    Value<int>? seed,
    Value<int>? version,
    Value<int>? stars,
    Value<int>? moves,
    Value<int>? rowid,
  }) {
    return PuzzleScoresCompanion(
      size: size ?? this.size,
      seed: seed ?? this.seed,
      version: version ?? this.version,
      stars: stars ?? this.stars,
      moves: moves ?? this.moves,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (stars.present) {
      map['stars'] = Variable<int>(stars.value);
    }
    if (moves.present) {
      map['moves'] = Variable<int>(moves.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuzzleScoresCompanion(')
          ..write('size: $size, ')
          ..write('seed: $seed, ')
          ..write('version: $version, ')
          ..write('stars: $stars, ')
          ..write('moves: $moves, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LevelWinsTable extends LevelWins
    with TableInfo<$LevelWinsTable, LevelWin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelWinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _levelIdMeta = const VerificationMeta(
    'levelId',
  );
  @override
  late final GeneratedColumn<String> levelId = GeneratedColumn<String>(
    'level_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextIdMeta = const VerificationMeta('nextId');
  @override
  late final GeneratedColumn<String> nextId = GeneratedColumn<String>(
    'next_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewardMeta = const VerificationMeta('reward');
  @override
  late final GeneratedColumn<int> reward = GeneratedColumn<int>(
    'reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [levelId, nextId, reward];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_wins';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelWin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('level_id')) {
      context.handle(
        _levelIdMeta,
        levelId.isAcceptableOrUnknown(data['level_id']!, _levelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_levelIdMeta);
    }
    if (data.containsKey('next_id')) {
      context.handle(
        _nextIdMeta,
        nextId.isAcceptableOrUnknown(data['next_id']!, _nextIdMeta),
      );
    }
    if (data.containsKey('reward')) {
      context.handle(
        _rewardMeta,
        reward.isAcceptableOrUnknown(data['reward']!, _rewardMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {levelId};
  @override
  LevelWin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelWin(
      levelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_id'],
      )!,
      nextId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_id'],
      ),
      reward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward'],
      )!,
    );
  }

  @override
  $LevelWinsTable createAlias(String alias) {
    return $LevelWinsTable(attachedDatabase, alias);
  }
}

class LevelWin extends DataClass implements Insertable<LevelWin> {
  final String levelId;
  final String? nextId;
  final int reward;
  const LevelWin({required this.levelId, this.nextId, required this.reward});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['level_id'] = Variable<String>(levelId);
    if (!nullToAbsent || nextId != null) {
      map['next_id'] = Variable<String>(nextId);
    }
    map['reward'] = Variable<int>(reward);
    return map;
  }

  LevelWinsCompanion toCompanion(bool nullToAbsent) {
    return LevelWinsCompanion(
      levelId: Value(levelId),
      nextId: nextId == null && nullToAbsent
          ? const Value.absent()
          : Value(nextId),
      reward: Value(reward),
    );
  }

  factory LevelWin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelWin(
      levelId: serializer.fromJson<String>(json['levelId']),
      nextId: serializer.fromJson<String?>(json['nextId']),
      reward: serializer.fromJson<int>(json['reward']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'levelId': serializer.toJson<String>(levelId),
      'nextId': serializer.toJson<String?>(nextId),
      'reward': serializer.toJson<int>(reward),
    };
  }

  LevelWin copyWith({
    String? levelId,
    Value<String?> nextId = const Value.absent(),
    int? reward,
  }) => LevelWin(
    levelId: levelId ?? this.levelId,
    nextId: nextId.present ? nextId.value : this.nextId,
    reward: reward ?? this.reward,
  );
  LevelWin copyWithCompanion(LevelWinsCompanion data) {
    return LevelWin(
      levelId: data.levelId.present ? data.levelId.value : this.levelId,
      nextId: data.nextId.present ? data.nextId.value : this.nextId,
      reward: data.reward.present ? data.reward.value : this.reward,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelWin(')
          ..write('levelId: $levelId, ')
          ..write('nextId: $nextId, ')
          ..write('reward: $reward')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(levelId, nextId, reward);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelWin &&
          other.levelId == this.levelId &&
          other.nextId == this.nextId &&
          other.reward == this.reward);
}

class LevelWinsCompanion extends UpdateCompanion<LevelWin> {
  final Value<String> levelId;
  final Value<String?> nextId;
  final Value<int> reward;
  final Value<int> rowid;
  const LevelWinsCompanion({
    this.levelId = const Value.absent(),
    this.nextId = const Value.absent(),
    this.reward = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelWinsCompanion.insert({
    required String levelId,
    this.nextId = const Value.absent(),
    required int reward,
    this.rowid = const Value.absent(),
  }) : levelId = Value(levelId),
       reward = Value(reward);
  static Insertable<LevelWin> custom({
    Expression<String>? levelId,
    Expression<String>? nextId,
    Expression<int>? reward,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (levelId != null) 'level_id': levelId,
      if (nextId != null) 'next_id': nextId,
      if (reward != null) 'reward': reward,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelWinsCompanion copyWith({
    Value<String>? levelId,
    Value<String?>? nextId,
    Value<int>? reward,
    Value<int>? rowid,
  }) {
    return LevelWinsCompanion(
      levelId: levelId ?? this.levelId,
      nextId: nextId ?? this.nextId,
      reward: reward ?? this.reward,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (levelId.present) {
      map['level_id'] = Variable<String>(levelId.value);
    }
    if (nextId.present) {
      map['next_id'] = Variable<String>(nextId.value);
    }
    if (reward.present) {
      map['reward'] = Variable<int>(reward.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelWinsCompanion(')
          ..write('levelId: $levelId, ')
          ..write('nextId: $nextId, ')
          ..write('reward: $reward, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ProgressDatabase extends GeneratedDatabase {
  _$ProgressDatabase(QueryExecutor e) : super(e);
  $ProgressDatabaseManager get managers => $ProgressDatabaseManager(this);
  late final $PuzzleScoresTable puzzleScores = $PuzzleScoresTable(this);
  late final $LevelWinsTable levelWins = $LevelWinsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [puzzleScores, levelWins];
}

typedef $$PuzzleScoresTableCreateCompanionBuilder =
    PuzzleScoresCompanion Function({
      required int size,
      required int seed,
      required int version,
      required int stars,
      required int moves,
      Value<int> rowid,
    });
typedef $$PuzzleScoresTableUpdateCompanionBuilder =
    PuzzleScoresCompanion Function({
      Value<int> size,
      Value<int> seed,
      Value<int> version,
      Value<int> stars,
      Value<int> moves,
      Value<int> rowid,
    });

class $$PuzzleScoresTableFilterComposer
    extends Composer<_$ProgressDatabase, $PuzzleScoresTable> {
  $$PuzzleScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moves => $composableBuilder(
    column: $table.moves,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PuzzleScoresTableOrderingComposer
    extends Composer<_$ProgressDatabase, $PuzzleScoresTable> {
  $$PuzzleScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moves => $composableBuilder(
    column: $table.moves,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PuzzleScoresTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $PuzzleScoresTable> {
  $$PuzzleScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<int> get moves =>
      $composableBuilder(column: $table.moves, builder: (column) => column);
}

class $$PuzzleScoresTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $PuzzleScoresTable,
          PuzzleScore,
          $$PuzzleScoresTableFilterComposer,
          $$PuzzleScoresTableOrderingComposer,
          $$PuzzleScoresTableAnnotationComposer,
          $$PuzzleScoresTableCreateCompanionBuilder,
          $$PuzzleScoresTableUpdateCompanionBuilder,
          (
            PuzzleScore,
            BaseReferences<_$ProgressDatabase, $PuzzleScoresTable, PuzzleScore>,
          ),
          PuzzleScore,
          PrefetchHooks Function()
        > {
  $$PuzzleScoresTableTableManager(
    _$ProgressDatabase db,
    $PuzzleScoresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PuzzleScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PuzzleScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PuzzleScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> size = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> stars = const Value.absent(),
                Value<int> moves = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PuzzleScoresCompanion(
                size: size,
                seed: seed,
                version: version,
                stars: stars,
                moves: moves,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int size,
                required int seed,
                required int version,
                required int stars,
                required int moves,
                Value<int> rowid = const Value.absent(),
              }) => PuzzleScoresCompanion.insert(
                size: size,
                seed: seed,
                version: version,
                stars: stars,
                moves: moves,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PuzzleScoresTable, PuzzleScore>(table),
                  BaseReferences<
                    _$ProgressDatabase,
                    $PuzzleScoresTable,
                    PuzzleScore
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PuzzleScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $PuzzleScoresTable,
      PuzzleScore,
      $$PuzzleScoresTableFilterComposer,
      $$PuzzleScoresTableOrderingComposer,
      $$PuzzleScoresTableAnnotationComposer,
      $$PuzzleScoresTableCreateCompanionBuilder,
      $$PuzzleScoresTableUpdateCompanionBuilder,
      (
        PuzzleScore,
        BaseReferences<_$ProgressDatabase, $PuzzleScoresTable, PuzzleScore>,
      ),
      PuzzleScore,
      PrefetchHooks Function()
    >;
typedef $$LevelWinsTableCreateCompanionBuilder = LevelWinsCompanion Function({
  required String levelId,
  Value<String?> nextId,
  required int reward,
  Value<int> rowid,
});
typedef $$LevelWinsTableUpdateCompanionBuilder = LevelWinsCompanion Function({
  Value<String> levelId,
  Value<String?> nextId,
  Value<int> reward,
  Value<int> rowid,
});

class $$LevelWinsTableFilterComposer
    extends Composer<_$ProgressDatabase, $LevelWinsTable> {
  $$LevelWinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextId => $composableBuilder(
    column: $table.nextId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reward => $composableBuilder(
    column: $table.reward,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelWinsTableOrderingComposer
    extends Composer<_$ProgressDatabase, $LevelWinsTable> {
  $$LevelWinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get levelId => $composableBuilder(
    column: $table.levelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextId => $composableBuilder(
    column: $table.nextId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reward => $composableBuilder(
    column: $table.reward,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelWinsTableAnnotationComposer
    extends Composer<_$ProgressDatabase, $LevelWinsTable> {
  $$LevelWinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get levelId =>
      $composableBuilder(column: $table.levelId, builder: (column) => column);

  GeneratedColumn<String> get nextId =>
      $composableBuilder(column: $table.nextId, builder: (column) => column);

  GeneratedColumn<int> get reward =>
      $composableBuilder(column: $table.reward, builder: (column) => column);
}

class $$LevelWinsTableTableManager
    extends
        RootTableManager<
          _$ProgressDatabase,
          $LevelWinsTable,
          LevelWin,
          $$LevelWinsTableFilterComposer,
          $$LevelWinsTableOrderingComposer,
          $$LevelWinsTableAnnotationComposer,
          $$LevelWinsTableCreateCompanionBuilder,
          $$LevelWinsTableUpdateCompanionBuilder,
          (
            LevelWin,
            BaseReferences<_$ProgressDatabase, $LevelWinsTable, LevelWin>,
          ),
          LevelWin,
          PrefetchHooks Function()
        > {
  $$LevelWinsTableTableManager(_$ProgressDatabase db, $LevelWinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelWinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelWinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelWinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> levelId = const Value.absent(),
                Value<String?> nextId = const Value.absent(),
                Value<int> reward = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelWinsCompanion(
                levelId: levelId,
                nextId: nextId,
                reward: reward,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String levelId,
                Value<String?> nextId = const Value.absent(),
                required int reward,
                Value<int> rowid = const Value.absent(),
              }) => LevelWinsCompanion.insert(
                levelId: levelId,
                nextId: nextId,
                reward: reward,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LevelWinsTable, LevelWin>(table),
                  BaseReferences<_$ProgressDatabase, $LevelWinsTable, LevelWin>(
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

typedef $$LevelWinsTableProcessedTableManager =
    ProcessedTableManager<
      _$ProgressDatabase,
      $LevelWinsTable,
      LevelWin,
      $$LevelWinsTableFilterComposer,
      $$LevelWinsTableOrderingComposer,
      $$LevelWinsTableAnnotationComposer,
      $$LevelWinsTableCreateCompanionBuilder,
      $$LevelWinsTableUpdateCompanionBuilder,
      (LevelWin, BaseReferences<_$ProgressDatabase, $LevelWinsTable, LevelWin>),
      LevelWin,
      PrefetchHooks Function()
    >;

class $ProgressDatabaseManager {
  final _$ProgressDatabase _db;
  $ProgressDatabaseManager(this._db);
  $$PuzzleScoresTableTableManager get puzzleScores =>
      $$PuzzleScoresTableTableManager(_db, _db.puzzleScores);
  $$LevelWinsTableTableManager get levelWins =>
      $$LevelWinsTableTableManager(_db, _db.levelWins);
}
