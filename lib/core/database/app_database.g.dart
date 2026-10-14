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

class $RatingListsTable extends RatingLists
    with TableInfo<$RatingListsTable, RatingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RatingListsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkableMeta = const VerificationMeta(
    'checkable',
  );
  @override
  late final GeneratedColumn<bool> checkable = GeneratedColumn<bool>(
    'checkable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checkable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  @override
  List<GeneratedColumn> get $columns => [id, name, checkable, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rating_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<RatingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('checkable')) {
      context.handle(
        _checkableMeta,
        checkable.isAcceptableOrUnknown(data['checkable']!, _checkableMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RatingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RatingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      checkable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checkable'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RatingListsTable createAlias(String alias) {
    return $RatingListsTable(attachedDatabase, alias);
  }
}

class RatingList extends DataClass implements Insertable<RatingList> {
  final int id;
  final String name;

  /// Whether entries are ticked off (shopping) or just collected (gift ideas).
  final bool checkable;
  final DateTime createdAt;
  const RatingList({
    required this.id,
    required this.name,
    required this.checkable,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['checkable'] = Variable<bool>(checkable);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RatingListsCompanion toCompanion(bool nullToAbsent) {
    return RatingListsCompanion(
      id: Value(id),
      name: Value(name),
      checkable: Value(checkable),
      createdAt: Value(createdAt),
    );
  }

  factory RatingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RatingList(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      checkable: serializer.fromJson<bool>(json['checkable']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'checkable': serializer.toJson<bool>(checkable),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RatingList copyWith({
    int? id,
    String? name,
    bool? checkable,
    DateTime? createdAt,
  }) => RatingList(
    id: id ?? this.id,
    name: name ?? this.name,
    checkable: checkable ?? this.checkable,
    createdAt: createdAt ?? this.createdAt,
  );
  RatingList copyWithCompanion(RatingListsCompanion data) {
    return RatingList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      checkable: data.checkable.present ? data.checkable.value : this.checkable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RatingList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('checkable: $checkable, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, checkable, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RatingList &&
          other.id == this.id &&
          other.name == this.name &&
          other.checkable == this.checkable &&
          other.createdAt == this.createdAt);
}

class RatingListsCompanion extends UpdateCompanion<RatingList> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> checkable;
  final Value<DateTime> createdAt;
  const RatingListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.checkable = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RatingListsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.checkable = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<RatingList> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? checkable,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (checkable != null) 'checkable': checkable,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RatingListsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? checkable,
    Value<DateTime>? createdAt,
  }) {
    return RatingListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      checkable: checkable ?? this.checkable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (checkable.present) {
      map['checkable'] = Variable<bool>(checkable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RatingListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('checkable: $checkable, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ListEntriesTable extends ListEntries
    with TableInfo<$ListEntriesTable, ListEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rating_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ratingIdMeta = const VerificationMeta(
    'ratingId',
  );
  @override
  late final GeneratedColumn<int> ratingId = GeneratedColumn<int>(
    'rating_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ratings (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    ratingId,
    label,
    checked,
    position,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('rating_id')) {
      context.handle(
        _ratingIdMeta,
        ratingId.isAcceptableOrUnknown(data['rating_id']!, _ratingIdMeta),
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
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      ratingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ListEntriesTable createAlias(String alias) {
    return $ListEntriesTable(attachedDatabase, alias);
  }
}

class ListEntry extends DataClass implements Insertable<ListEntry> {
  final int id;
  final int listId;

  /// The linked rating, if any. Set to null when the rating is deleted; the
  /// entry then lives on with its [label].
  final int? ratingId;

  /// What the entry says. For a linked rating, its title when it was added.
  final String label;
  final bool checked;

  /// Order within the list, ascending. New entries go to the end.
  final int position;
  final DateTime createdAt;
  const ListEntry({
    required this.id,
    required this.listId,
    this.ratingId,
    required this.label,
    required this.checked,
    required this.position,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    if (!nullToAbsent || ratingId != null) {
      map['rating_id'] = Variable<int>(ratingId);
    }
    map['label'] = Variable<String>(label);
    map['checked'] = Variable<bool>(checked);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ListEntriesCompanion toCompanion(bool nullToAbsent) {
    return ListEntriesCompanion(
      id: Value(id),
      listId: Value(listId),
      ratingId: ratingId == null && nullToAbsent
          ? const Value.absent()
          : Value(ratingId),
      label: Value(label),
      checked: Value(checked),
      position: Value(position),
      createdAt: Value(createdAt),
    );
  }

  factory ListEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListEntry(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      ratingId: serializer.fromJson<int?>(json['ratingId']),
      label: serializer.fromJson<String>(json['label']),
      checked: serializer.fromJson<bool>(json['checked']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'ratingId': serializer.toJson<int?>(ratingId),
      'label': serializer.toJson<String>(label),
      'checked': serializer.toJson<bool>(checked),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ListEntry copyWith({
    int? id,
    int? listId,
    Value<int?> ratingId = const Value.absent(),
    String? label,
    bool? checked,
    int? position,
    DateTime? createdAt,
  }) => ListEntry(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    ratingId: ratingId.present ? ratingId.value : this.ratingId,
    label: label ?? this.label,
    checked: checked ?? this.checked,
    position: position ?? this.position,
    createdAt: createdAt ?? this.createdAt,
  );
  ListEntry copyWithCompanion(ListEntriesCompanion data) {
    return ListEntry(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      ratingId: data.ratingId.present ? data.ratingId.value : this.ratingId,
      label: data.label.present ? data.label.value : this.label,
      checked: data.checked.present ? data.checked.value : this.checked,
      position: data.position.present ? data.position.value : this.position,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListEntry(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('ratingId: $ratingId, ')
          ..write('label: $label, ')
          ..write('checked: $checked, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, listId, ratingId, label, checked, position, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListEntry &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.ratingId == this.ratingId &&
          other.label == this.label &&
          other.checked == this.checked &&
          other.position == this.position &&
          other.createdAt == this.createdAt);
}

class ListEntriesCompanion extends UpdateCompanion<ListEntry> {
  final Value<int> id;
  final Value<int> listId;
  final Value<int?> ratingId;
  final Value<String> label;
  final Value<bool> checked;
  final Value<int> position;
  final Value<DateTime> createdAt;
  const ListEntriesCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.ratingId = const Value.absent(),
    this.label = const Value.absent(),
    this.checked = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ListEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    this.ratingId = const Value.absent(),
    required String label,
    this.checked = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : listId = Value(listId),
       label = Value(label);
  static Insertable<ListEntry> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<int>? ratingId,
    Expression<String>? label,
    Expression<bool>? checked,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (ratingId != null) 'rating_id': ratingId,
      if (label != null) 'label': label,
      if (checked != null) 'checked': checked,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ListEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? listId,
    Value<int?>? ratingId,
    Value<String>? label,
    Value<bool>? checked,
    Value<int>? position,
    Value<DateTime>? createdAt,
  }) {
    return ListEntriesCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      ratingId: ratingId ?? this.ratingId,
      label: label ?? this.label,
      checked: checked ?? this.checked,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (ratingId.present) {
      map['rating_id'] = Variable<int>(ratingId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListEntriesCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('ratingId: $ratingId, ')
          ..write('label: $label, ')
          ..write('checked: $checked, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RatingsTable ratings = $RatingsTable(this);
  late final $RatingListsTable ratingLists = $RatingListsTable(this);
  late final $ListEntriesTable listEntries = $ListEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ratings,
    ratingLists,
    listEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'rating_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('list_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ratings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('list_entries', kind: UpdateKind.update)],
    ),
  ]);
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

final class $$RatingsTableReferences
    extends BaseReferences<_$AppDatabase, $RatingsTable, Rating> {
  $$RatingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ListEntriesTable, List<ListEntry>>
  _listEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.listEntries,
    aliasName: $_aliasNameGenerator(db.ratings.id, db.listEntries.ratingId),
  );

  $$ListEntriesTableProcessedTableManager get listEntriesRefs {
    final manager = $$ListEntriesTableTableManager(
      $_db,
      $_db.listEntries,
    ).filter((f) => f.ratingId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> listEntriesRefs(
    Expression<bool> Function($$ListEntriesTableFilterComposer f) f,
  ) {
    final $$ListEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listEntries,
      getReferencedColumn: (t) => t.ratingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListEntriesTableFilterComposer(
            $db: $db,
            $table: $db.listEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> listEntriesRefs<T extends Object>(
    Expression<T> Function($$ListEntriesTableAnnotationComposer a) f,
  ) {
    final $$ListEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listEntries,
      getReferencedColumn: (t) => t.ratingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.listEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Rating, $$RatingsTableReferences),
          Rating,
          PrefetchHooks Function({bool listEntriesRefs})
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$RatingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listEntriesRefs) db.listEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listEntriesRefs)
                    await $_getPrefetchedData<Rating, $RatingsTable, ListEntry>(
                      currentTable: table,
                      referencedTable: $$RatingsTableReferences
                          ._listEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$RatingsTableReferences(
                        db,
                        table,
                        p0,
                      ).listEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ratingId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Rating, $$RatingsTableReferences),
      Rating,
      PrefetchHooks Function({bool listEntriesRefs})
    >;
typedef $$RatingListsTableCreateCompanionBuilder =
    RatingListsCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> checkable,
      Value<DateTime> createdAt,
    });
typedef $$RatingListsTableUpdateCompanionBuilder =
    RatingListsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> checkable,
      Value<DateTime> createdAt,
    });

final class $$RatingListsTableReferences
    extends BaseReferences<_$AppDatabase, $RatingListsTable, RatingList> {
  $$RatingListsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ListEntriesTable, List<ListEntry>>
  _listEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.listEntries,
    aliasName: $_aliasNameGenerator(db.ratingLists.id, db.listEntries.listId),
  );

  $$ListEntriesTableProcessedTableManager get listEntriesRefs {
    final manager = $$ListEntriesTableTableManager(
      $_db,
      $_db.listEntries,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_listEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RatingListsTableFilterComposer
    extends Composer<_$AppDatabase, $RatingListsTable> {
  $$RatingListsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checkable => $composableBuilder(
    column: $table.checkable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> listEntriesRefs(
    Expression<bool> Function($$ListEntriesTableFilterComposer f) f,
  ) {
    final $$ListEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listEntries,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListEntriesTableFilterComposer(
            $db: $db,
            $table: $db.listEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RatingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $RatingListsTable> {
  $$RatingListsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checkable => $composableBuilder(
    column: $table.checkable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RatingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RatingListsTable> {
  $$RatingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get checkable =>
      $composableBuilder(column: $table.checkable, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> listEntriesRefs<T extends Object>(
    Expression<T> Function($$ListEntriesTableAnnotationComposer a) f,
  ) {
    final $$ListEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.listEntries,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ListEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.listEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RatingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RatingListsTable,
          RatingList,
          $$RatingListsTableFilterComposer,
          $$RatingListsTableOrderingComposer,
          $$RatingListsTableAnnotationComposer,
          $$RatingListsTableCreateCompanionBuilder,
          $$RatingListsTableUpdateCompanionBuilder,
          (RatingList, $$RatingListsTableReferences),
          RatingList,
          PrefetchHooks Function({bool listEntriesRefs})
        > {
  $$RatingListsTableTableManager(_$AppDatabase db, $RatingListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RatingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RatingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RatingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> checkable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RatingListsCompanion(
                id: id,
                name: name,
                checkable: checkable,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> checkable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RatingListsCompanion.insert(
                id: id,
                name: name,
                checkable: checkable,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RatingListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (listEntriesRefs) db.listEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (listEntriesRefs)
                    await $_getPrefetchedData<
                      RatingList,
                      $RatingListsTable,
                      ListEntry
                    >(
                      currentTable: table,
                      referencedTable: $$RatingListsTableReferences
                          ._listEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RatingListsTableReferences(
                            db,
                            table,
                            p0,
                          ).listEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RatingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RatingListsTable,
      RatingList,
      $$RatingListsTableFilterComposer,
      $$RatingListsTableOrderingComposer,
      $$RatingListsTableAnnotationComposer,
      $$RatingListsTableCreateCompanionBuilder,
      $$RatingListsTableUpdateCompanionBuilder,
      (RatingList, $$RatingListsTableReferences),
      RatingList,
      PrefetchHooks Function({bool listEntriesRefs})
    >;
typedef $$ListEntriesTableCreateCompanionBuilder =
    ListEntriesCompanion Function({
      Value<int> id,
      required int listId,
      Value<int?> ratingId,
      required String label,
      Value<bool> checked,
      Value<int> position,
      Value<DateTime> createdAt,
    });
typedef $$ListEntriesTableUpdateCompanionBuilder =
    ListEntriesCompanion Function({
      Value<int> id,
      Value<int> listId,
      Value<int?> ratingId,
      Value<String> label,
      Value<bool> checked,
      Value<int> position,
      Value<DateTime> createdAt,
    });

final class $$ListEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $ListEntriesTable, ListEntry> {
  $$ListEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RatingListsTable _listIdTable(_$AppDatabase db) =>
      db.ratingLists.createAlias(
        $_aliasNameGenerator(db.listEntries.listId, db.ratingLists.id),
      );

  $$RatingListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$RatingListsTableTableManager(
      $_db,
      $_db.ratingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RatingsTable _ratingIdTable(_$AppDatabase db) =>
      db.ratings.createAlias(
        $_aliasNameGenerator(db.listEntries.ratingId, db.ratings.id),
      );

  $$RatingsTableProcessedTableManager? get ratingId {
    final $_column = $_itemColumn<int>('rating_id');
    if ($_column == null) return null;
    final manager = $$RatingsTableTableManager(
      $_db,
      $_db.ratings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ratingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ListEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ListEntriesTable> {
  $$ListEntriesTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RatingListsTableFilterComposer get listId {
    final $$RatingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.ratingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingListsTableFilterComposer(
            $db: $db,
            $table: $db.ratingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RatingsTableFilterComposer get ratingId {
    final $$RatingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ratingId,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableFilterComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ListEntriesTable> {
  $$ListEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RatingListsTableOrderingComposer get listId {
    final $$RatingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.ratingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingListsTableOrderingComposer(
            $db: $db,
            $table: $db.ratingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RatingsTableOrderingComposer get ratingId {
    final $$RatingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ratingId,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableOrderingComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListEntriesTable> {
  $$ListEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RatingListsTableAnnotationComposer get listId {
    final $$RatingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.ratingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RatingsTableAnnotationComposer get ratingId {
    final $$RatingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ratingId,
      referencedTable: $db.ratings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RatingsTableAnnotationComposer(
            $db: $db,
            $table: $db.ratings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ListEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListEntriesTable,
          ListEntry,
          $$ListEntriesTableFilterComposer,
          $$ListEntriesTableOrderingComposer,
          $$ListEntriesTableAnnotationComposer,
          $$ListEntriesTableCreateCompanionBuilder,
          $$ListEntriesTableUpdateCompanionBuilder,
          (ListEntry, $$ListEntriesTableReferences),
          ListEntry,
          PrefetchHooks Function({bool listId, bool ratingId})
        > {
  $$ListEntriesTableTableManager(_$AppDatabase db, $ListEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int?> ratingId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ListEntriesCompanion(
                id: id,
                listId: listId,
                ratingId: ratingId,
                label: label,
                checked: checked,
                position: position,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listId,
                Value<int?> ratingId = const Value.absent(),
                required String label,
                Value<bool> checked = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ListEntriesCompanion.insert(
                id: id,
                listId: listId,
                ratingId: ratingId,
                label: label,
                checked: checked,
                position: position,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ListEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false, ratingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable: $$ListEntriesTableReferences
                                    ._listIdTable(db),
                                referencedColumn: $$ListEntriesTableReferences
                                    ._listIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (ratingId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ratingId,
                                referencedTable: $$ListEntriesTableReferences
                                    ._ratingIdTable(db),
                                referencedColumn: $$ListEntriesTableReferences
                                    ._ratingIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ListEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListEntriesTable,
      ListEntry,
      $$ListEntriesTableFilterComposer,
      $$ListEntriesTableOrderingComposer,
      $$ListEntriesTableAnnotationComposer,
      $$ListEntriesTableCreateCompanionBuilder,
      $$ListEntriesTableUpdateCompanionBuilder,
      (ListEntry, $$ListEntriesTableReferences),
      ListEntry,
      PrefetchHooks Function({bool listId, bool ratingId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RatingsTableTableManager get ratings =>
      $$RatingsTableTableManager(_db, _db.ratings);
  $$RatingListsTableTableManager get ratingLists =>
      $$RatingListsTableTableManager(_db, _db.ratingLists);
  $$ListEntriesTableTableManager get listEntries =>
      $$ListEntriesTableTableManager(_db, _db.listEntries);
}
