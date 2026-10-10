// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RatingsTable extends Ratings with TableInfo<$RatingsTable, Rating> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _localImagePathMeta = const VerificationMeta(
    'localImagePath',
  );
  @override
  late final GeneratedColumn<String> localImagePath = GeneratedColumn<String>(
    'local_image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _creatorMeta = const VerificationMeta(
    'creator',
  );
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
    'creator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    defaultValue: currentDateAndTime,
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    score,
    tags,
    notes,
    imageUrl,
    sourceUrl,
    barcode,
    localImagePath,
    creator,
    year,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ratings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rating> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('local_image_path')) {
      context.handle(
        _localImagePathMeta,
        localImagePath.isAcceptableOrUnknown(
          data['local_image_path']!,
          _localImagePathMeta,
        ),
      );
    }
    if (data.containsKey('creator')) {
      context.handle(
        _creatorMeta,
        creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rating map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rating(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      localImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_image_path'],
      )!,
      creator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creator'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RatingsTable createAlias(String alias) {
    return $RatingsTable(attachedDatabase, alias);
  }
}

class Rating extends DataClass implements Insertable<Rating> {
  final int id;
  final String title;
  final double score;

  /// Comma-separated tag list, e.g. `"movie, sci-fi"`. Empty string = no tags.
  final String tags;
  final String notes;
  final String imageUrl;
  final String sourceUrl;
  final String barcode;

  /// Path to the locally downloaded copy of [imageUrl]. Empty if not yet
  /// downloaded or if the download failed. Display code should prefer this
  /// over [imageUrl] so the image remains available even after the remote URL
  /// goes stale.
  final String localImagePath;

  /// Author, manufacturer, brand or designer – whoever made the item.
  final String creator;

  /// Release or publication year as entered/fetched, e.g. "1995". Empty if unknown.
  final String year;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Rating({
    required this.id,
    required this.title,
    required this.score,
    required this.tags,
    required this.notes,
    required this.imageUrl,
    required this.sourceUrl,
    required this.barcode,
    required this.localImagePath,
    required this.creator,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['score'] = Variable<double>(score);
    map['tags'] = Variable<String>(tags);
    map['notes'] = Variable<String>(notes);
    map['image_url'] = Variable<String>(imageUrl);
    map['source_url'] = Variable<String>(sourceUrl);
    map['barcode'] = Variable<String>(barcode);
    map['local_image_path'] = Variable<String>(localImagePath);
    map['creator'] = Variable<String>(creator);
    map['year'] = Variable<String>(year);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RatingsCompanion toCompanion(bool nullToAbsent) {
    return RatingsCompanion(
      id: Value(id),
      title: Value(title),
      score: Value(score),
      tags: Value(tags),
      notes: Value(notes),
      imageUrl: Value(imageUrl),
      sourceUrl: Value(sourceUrl),
      barcode: Value(barcode),
      localImagePath: Value(localImagePath),
      creator: Value(creator),
      year: Value(year),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Rating.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rating(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      score: serializer.fromJson<double>(json['score']),
      tags: serializer.fromJson<String>(json['tags']),
      notes: serializer.fromJson<String>(json['notes']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      barcode: serializer.fromJson<String>(json['barcode']),
      localImagePath: serializer.fromJson<String>(json['localImagePath']),
      creator: serializer.fromJson<String>(json['creator']),
      year: serializer.fromJson<String>(json['year']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'score': serializer.toJson<double>(score),
      'tags': serializer.toJson<String>(tags),
      'notes': serializer.toJson<String>(notes),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'barcode': serializer.toJson<String>(barcode),
      'localImagePath': serializer.toJson<String>(localImagePath),
      'creator': serializer.toJson<String>(creator),
      'year': serializer.toJson<String>(year),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Rating copyWith({
    int? id,
    String? title,
    double? score,
    String? tags,
    String? notes,
    String? imageUrl,
    String? sourceUrl,
    String? barcode,
    String? localImagePath,
    String? creator,
    String? year,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Rating(
    id: id ?? this.id,
    title: title ?? this.title,
    score: score ?? this.score,
    tags: tags ?? this.tags,
    notes: notes ?? this.notes,
    imageUrl: imageUrl ?? this.imageUrl,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    barcode: barcode ?? this.barcode,
    localImagePath: localImagePath ?? this.localImagePath,
    creator: creator ?? this.creator,
    year: year ?? this.year,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Rating copyWithCompanion(RatingsCompanion data) {
    return Rating(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      score: data.score.present ? data.score.value : this.score,
      tags: data.tags.present ? data.tags.value : this.tags,
      notes: data.notes.present ? data.notes.value : this.notes,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      localImagePath: data.localImagePath.present
          ? data.localImagePath.value
          : this.localImagePath,
      creator: data.creator.present ? data.creator.value : this.creator,
      year: data.year.present ? data.year.value : this.year,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rating(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('score: $score, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('barcode: $barcode, ')
          ..write('localImagePath: $localImagePath, ')
          ..write('creator: $creator, ')
          ..write('year: $year, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    score,
    tags,
    notes,
    imageUrl,
    sourceUrl,
    barcode,
    localImagePath,
    creator,
    year,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rating &&
          other.id == this.id &&
          other.title == this.title &&
          other.score == this.score &&
          other.tags == this.tags &&
          other.notes == this.notes &&
          other.imageUrl == this.imageUrl &&
          other.sourceUrl == this.sourceUrl &&
          other.barcode == this.barcode &&
          other.localImagePath == this.localImagePath &&
          other.creator == this.creator &&
          other.year == this.year &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RatingsCompanion extends UpdateCompanion<Rating> {
  final Value<int> id;
  final Value<String> title;
  final Value<double> score;
  final Value<String> tags;
  final Value<String> notes;
  final Value<String> imageUrl;
  final Value<String> sourceUrl;
  final Value<String> barcode;
  final Value<String> localImagePath;
  final Value<String> creator;
  final Value<String> year;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const RatingsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.score = const Value.absent(),
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.barcode = const Value.absent(),
    this.localImagePath = const Value.absent(),
    this.creator = const Value.absent(),
    this.year = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RatingsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required double score,
    this.tags = const Value.absent(),
    this.notes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.barcode = const Value.absent(),
    this.localImagePath = const Value.absent(),
    this.creator = const Value.absent(),
    this.year = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       score = Value(score);
  static Insertable<Rating> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<double>? score,
    Expression<String>? tags,
    Expression<String>? notes,
    Expression<String>? imageUrl,
    Expression<String>? sourceUrl,
    Expression<String>? barcode,
    Expression<String>? localImagePath,
    Expression<String>? creator,
    Expression<String>? year,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (score != null) 'score': score,
      if (tags != null) 'tags': tags,
      if (notes != null) 'notes': notes,
      if (imageUrl != null) 'image_url': imageUrl,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (barcode != null) 'barcode': barcode,
      if (localImagePath != null) 'local_image_path': localImagePath,
      if (creator != null) 'creator': creator,
      if (year != null) 'year': year,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RatingsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<double>? score,
    Value<String>? tags,
    Value<String>? notes,
    Value<String>? imageUrl,
    Value<String>? sourceUrl,
    Value<String>? barcode,
    Value<String>? localImagePath,
    Value<String>? creator,
    Value<String>? year,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return RatingsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      score: score ?? this.score,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      barcode: barcode ?? this.barcode,
      localImagePath: localImagePath ?? this.localImagePath,
      creator: creator ?? this.creator,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (localImagePath.present) {
      map['local_image_path'] = Variable<String>(localImagePath.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatingsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('score: $score, ')
          ..write('tags: $tags, ')
          ..write('notes: $notes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('barcode: $barcode, ')
          ..write('localImagePath: $localImagePath, ')
          ..write('creator: $creator, ')
          ..write('year: $year, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RatingsTable ratings = $RatingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [ratings];
}

typedef $$RatingsTableCreateCompanionBuilder =
    RatingsCompanion Function({
      Value<int> id,
      required String title,
      required double score,
      Value<String> tags,
      Value<String> notes,
      Value<String> imageUrl,
      Value<String> sourceUrl,
      Value<String> barcode,
      Value<String> localImagePath,
      Value<String> creator,
      Value<String> year,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$RatingsTableUpdateCompanionBuilder =
    RatingsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<double> score,
      Value<String> tags,
      Value<String> notes,
      Value<String> imageUrl,
      Value<String> sourceUrl,
      Value<String> barcode,
      Value<String> localImagePath,
      Value<String> creator,
      Value<String> year,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$RatingsTableFilterComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get year => $composableBuilder(
    column: $table.year,
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
}

class $$RatingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creator => $composableBuilder(
    column: $table.creator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get year => $composableBuilder(
    column: $table.year,
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
}

class $$RatingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatingsTable> {
  $$RatingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumn<String> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RatingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatingsTable,
          Rating,
          $$RatingsTableFilterComposer,
          $$RatingsTableOrderingComposer,
          $$RatingsTableAnnotationComposer,
          $$RatingsTableCreateCompanionBuilder,
          $$RatingsTableUpdateCompanionBuilder,
          (Rating, BaseReferences<_$AppDatabase, $RatingsTable, Rating>),
          Rating,
          PrefetchHooks Function()
        > {
  $$RatingsTableTableManager(_$AppDatabase db, $RatingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> localImagePath = const Value.absent(),
                Value<String> creator = const Value.absent(),
                Value<String> year = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RatingsCompanion(
                id: id,
                title: title,
                score: score,
                tags: tags,
                notes: notes,
                imageUrl: imageUrl,
                sourceUrl: sourceUrl,
                barcode: barcode,
                localImagePath: localImagePath,
                creator: creator,
                year: year,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required double score,
                Value<String> tags = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<String> localImagePath = const Value.absent(),
                Value<String> creator = const Value.absent(),
                Value<String> year = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => RatingsCompanion.insert(
                id: id,
                title: title,
                score: score,
                tags: tags,
                notes: notes,
                imageUrl: imageUrl,
                sourceUrl: sourceUrl,
                barcode: barcode,
                localImagePath: localImagePath,
                creator: creator,
                year: year,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RatingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatingsTable,
      Rating,
      $$RatingsTableFilterComposer,
      $$RatingsTableOrderingComposer,
      $$RatingsTableAnnotationComposer,
      $$RatingsTableCreateCompanionBuilder,
      $$RatingsTableUpdateCompanionBuilder,
      (Rating, BaseReferences<_$AppDatabase, $RatingsTable, Rating>),
      Rating,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db, _db.ratings);
}
