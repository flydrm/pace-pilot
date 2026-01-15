// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtUtcMillisMeta = const VerificationMeta(
    'dueAtUtcMillis',
  );
  @override
  late final GeneratedColumn<int> dueAtUtcMillis = GeneratedColumn<int>(
    'due_at_utc_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _estimatedPomodorosMeta =
      const VerificationMeta('estimatedPomodoros');
  @override
  late final GeneratedColumn<int> estimatedPomodoros = GeneratedColumn<int>(
    'estimated_pomodoros',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMillisMeta =
      const VerificationMeta('createdAtUtcMillis');
  @override
  late final GeneratedColumn<int> createdAtUtcMillis = GeneratedColumn<int>(
    'created_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    status,
    priority,
    dueAtUtcMillis,
    tagsJson,
    estimatedPomodoros,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('due_at_utc_millis')) {
      context.handle(
        _dueAtUtcMillisMeta,
        dueAtUtcMillis.isAcceptableOrUnknown(
          data['due_at_utc_millis']!,
          _dueAtUtcMillisMeta,
        ),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('estimated_pomodoros')) {
      context.handle(
        _estimatedPomodorosMeta,
        estimatedPomodoros.isAcceptableOrUnknown(
          data['estimated_pomodoros']!,
          _estimatedPomodorosMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc_millis')) {
      context.handle(
        _createdAtUtcMillisMeta,
        createdAtUtcMillis.isAcceptableOrUnknown(
          data['created_at_utc_millis']!,
          _createdAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMillisMeta);
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      dueAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_at_utc_millis'],
      ),
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      estimatedPomodoros: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_pomodoros'],
      ),
      createdAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_millis'],
      )!,
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String title;
  final String? description;
  final int status;
  final int priority;
  final int? dueAtUtcMillis;
  final String tagsJson;
  final int? estimatedPomodoros;
  final int createdAtUtcMillis;
  final int updatedAtUtcMillis;
  const TaskRow({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueAtUtcMillis,
    required this.tagsJson,
    this.estimatedPomodoros,
    required this.createdAtUtcMillis,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<int>(status);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || dueAtUtcMillis != null) {
      map['due_at_utc_millis'] = Variable<int>(dueAtUtcMillis);
    }
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || estimatedPomodoros != null) {
      map['estimated_pomodoros'] = Variable<int>(estimatedPomodoros);
    }
    map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis);
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      priority: Value(priority),
      dueAtUtcMillis: dueAtUtcMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAtUtcMillis),
      tagsJson: Value(tagsJson),
      estimatedPomodoros: estimatedPomodoros == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPomodoros),
      createdAtUtcMillis: Value(createdAtUtcMillis),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<int>(json['status']),
      priority: serializer.fromJson<int>(json['priority']),
      dueAtUtcMillis: serializer.fromJson<int?>(json['dueAtUtcMillis']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      estimatedPomodoros: serializer.fromJson<int?>(json['estimatedPomodoros']),
      createdAtUtcMillis: serializer.fromJson<int>(json['createdAtUtcMillis']),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<int>(status),
      'priority': serializer.toJson<int>(priority),
      'dueAtUtcMillis': serializer.toJson<int?>(dueAtUtcMillis),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'estimatedPomodoros': serializer.toJson<int?>(estimatedPomodoros),
      'createdAtUtcMillis': serializer.toJson<int>(createdAtUtcMillis),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  TaskRow copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    int? status,
    int? priority,
    Value<int?> dueAtUtcMillis = const Value.absent(),
    String? tagsJson,
    Value<int?> estimatedPomodoros = const Value.absent(),
    int? createdAtUtcMillis,
    int? updatedAtUtcMillis,
  }) => TaskRow(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    dueAtUtcMillis: dueAtUtcMillis.present
        ? dueAtUtcMillis.value
        : this.dueAtUtcMillis,
    tagsJson: tagsJson ?? this.tagsJson,
    estimatedPomodoros: estimatedPomodoros.present
        ? estimatedPomodoros.value
        : this.estimatedPomodoros,
    createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueAtUtcMillis: data.dueAtUtcMillis.present
          ? data.dueAtUtcMillis.value
          : this.dueAtUtcMillis,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      estimatedPomodoros: data.estimatedPomodoros.present
          ? data.estimatedPomodoros.value
          : this.estimatedPomodoros,
      createdAtUtcMillis: data.createdAtUtcMillis.present
          ? data.createdAtUtcMillis.value
          : this.createdAtUtcMillis,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueAtUtcMillis: $dueAtUtcMillis, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('estimatedPomodoros: $estimatedPomodoros, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    status,
    priority,
    dueAtUtcMillis,
    tagsJson,
    estimatedPomodoros,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.dueAtUtcMillis == this.dueAtUtcMillis &&
          other.tagsJson == this.tagsJson &&
          other.estimatedPomodoros == this.estimatedPomodoros &&
          other.createdAtUtcMillis == this.createdAtUtcMillis &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<int> status;
  final Value<int> priority;
  final Value<int?> dueAtUtcMillis;
  final Value<String> tagsJson;
  final Value<int?> estimatedPomodoros;
  final Value<int> createdAtUtcMillis;
  final Value<int> updatedAtUtcMillis;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAtUtcMillis = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.estimatedPomodoros = const Value.absent(),
    this.createdAtUtcMillis = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required int status,
    required int priority,
    this.dueAtUtcMillis = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.estimatedPomodoros = const Value.absent(),
    required int createdAtUtcMillis,
    required int updatedAtUtcMillis,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status),
       priority = Value(priority),
       createdAtUtcMillis = Value(createdAtUtcMillis),
       updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? status,
    Expression<int>? priority,
    Expression<int>? dueAtUtcMillis,
    Expression<String>? tagsJson,
    Expression<int>? estimatedPomodoros,
    Expression<int>? createdAtUtcMillis,
    Expression<int>? updatedAtUtcMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (dueAtUtcMillis != null) 'due_at_utc_millis': dueAtUtcMillis,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (estimatedPomodoros != null) 'estimated_pomodoros': estimatedPomodoros,
      if (createdAtUtcMillis != null)
        'created_at_utc_millis': createdAtUtcMillis,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<int>? status,
    Value<int>? priority,
    Value<int?>? dueAtUtcMillis,
    Value<String>? tagsJson,
    Value<int?>? estimatedPomodoros,
    Value<int>? createdAtUtcMillis,
    Value<int>? updatedAtUtcMillis,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueAtUtcMillis: dueAtUtcMillis ?? this.dueAtUtcMillis,
      tagsJson: tagsJson ?? this.tagsJson,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (dueAtUtcMillis.present) {
      map['due_at_utc_millis'] = Variable<int>(dueAtUtcMillis.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (estimatedPomodoros.present) {
      map['estimated_pomodoros'] = Variable<int>(estimatedPomodoros.value);
    }
    if (createdAtUtcMillis.present) {
      map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis.value);
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('dueAtUtcMillis: $dueAtUtcMillis, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('estimatedPomodoros: $estimatedPomodoros, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCheckItemsTable extends TaskCheckItems
    with TableInfo<$TaskCheckItemsTable, TaskCheckItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCheckItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMillisMeta =
      const VerificationMeta('createdAtUtcMillis');
  @override
  late final GeneratedColumn<int> createdAtUtcMillis = GeneratedColumn<int>(
    'created_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    title,
    isDone,
    orderIndex,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_check_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCheckItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at_utc_millis')) {
      context.handle(
        _createdAtUtcMillisMeta,
        createdAtUtcMillis.isAcceptableOrUnknown(
          data['created_at_utc_millis']!,
          _createdAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMillisMeta);
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCheckItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCheckItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_millis'],
      )!,
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $TaskCheckItemsTable createAlias(String alias) {
    return $TaskCheckItemsTable(attachedDatabase, alias);
  }
}

class TaskCheckItemRow extends DataClass
    implements Insertable<TaskCheckItemRow> {
  final String id;
  final String taskId;
  final String title;
  final bool isDone;
  final int orderIndex;
  final int createdAtUtcMillis;
  final int updatedAtUtcMillis;
  const TaskCheckItemRow({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
    required this.orderIndex,
    required this.createdAtUtcMillis,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['is_done'] = Variable<bool>(isDone);
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis);
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  TaskCheckItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskCheckItemsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      isDone: Value(isDone),
      orderIndex: Value(orderIndex),
      createdAtUtcMillis: Value(createdAtUtcMillis),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory TaskCheckItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCheckItemRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAtUtcMillis: serializer.fromJson<int>(json['createdAtUtcMillis']),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'isDone': serializer.toJson<bool>(isDone),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAtUtcMillis': serializer.toJson<int>(createdAtUtcMillis),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  TaskCheckItemRow copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isDone,
    int? orderIndex,
    int? createdAtUtcMillis,
    int? updatedAtUtcMillis,
  }) => TaskCheckItemRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    title: title ?? this.title,
    isDone: isDone ?? this.isDone,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  TaskCheckItemRow copyWithCompanion(TaskCheckItemsCompanion data) {
    return TaskCheckItemRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAtUtcMillis: data.createdAtUtcMillis.present
          ? data.createdAtUtcMillis.value
          : this.createdAtUtcMillis,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCheckItemRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('isDone: $isDone, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    title,
    isDone,
    orderIndex,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCheckItemRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.isDone == this.isDone &&
          other.orderIndex == this.orderIndex &&
          other.createdAtUtcMillis == this.createdAtUtcMillis &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class TaskCheckItemsCompanion extends UpdateCompanion<TaskCheckItemRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> isDone;
  final Value<int> orderIndex;
  final Value<int> createdAtUtcMillis;
  final Value<int> updatedAtUtcMillis;
  final Value<int> rowid;
  const TaskCheckItemsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.isDone = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAtUtcMillis = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCheckItemsCompanion.insert({
    required String id,
    required String taskId,
    required String title,
    this.isDone = const Value.absent(),
    required int orderIndex,
    required int createdAtUtcMillis,
    required int updatedAtUtcMillis,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       title = Value(title),
       orderIndex = Value(orderIndex),
       createdAtUtcMillis = Value(createdAtUtcMillis),
       updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<TaskCheckItemRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<bool>? isDone,
    Expression<int>? orderIndex,
    Expression<int>? createdAtUtcMillis,
    Expression<int>? updatedAtUtcMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (isDone != null) 'is_done': isDone,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAtUtcMillis != null)
        'created_at_utc_millis': createdAtUtcMillis,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCheckItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? title,
    Value<bool>? isDone,
    Value<int>? orderIndex,
    Value<int>? createdAtUtcMillis,
    Value<int>? updatedAtUtcMillis,
    Value<int>? rowid,
  }) {
    return TaskCheckItemsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAtUtcMillis.present) {
      map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis.value);
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCheckItemsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('isDone: $isDone, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivePomodorosTable extends ActivePomodoros
    with TableInfo<$ActivePomodorosTable, ActivePomodoroRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivePomodorosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<int> phase = GeneratedColumn<int>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startAtUtcMillisMeta = const VerificationMeta(
    'startAtUtcMillis',
  );
  @override
  late final GeneratedColumn<int> startAtUtcMillis = GeneratedColumn<int>(
    'start_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtUtcMillisMeta = const VerificationMeta(
    'endAtUtcMillis',
  );
  @override
  late final GeneratedColumn<int> endAtUtcMillis = GeneratedColumn<int>(
    'end_at_utc_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remainingMsMeta = const VerificationMeta(
    'remainingMs',
  );
  @override
  late final GeneratedColumn<int> remainingMs = GeneratedColumn<int>(
    'remaining_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    phase,
    status,
    startAtUtcMillis,
    endAtUtcMillis,
    remainingMs,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_pomodoros';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivePomodoroRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('start_at_utc_millis')) {
      context.handle(
        _startAtUtcMillisMeta,
        startAtUtcMillis.isAcceptableOrUnknown(
          data['start_at_utc_millis']!,
          _startAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startAtUtcMillisMeta);
    }
    if (data.containsKey('end_at_utc_millis')) {
      context.handle(
        _endAtUtcMillisMeta,
        endAtUtcMillis.isAcceptableOrUnknown(
          data['end_at_utc_millis']!,
          _endAtUtcMillisMeta,
        ),
      );
    }
    if (data.containsKey('remaining_ms')) {
      context.handle(
        _remainingMsMeta,
        remainingMs.isAcceptableOrUnknown(
          data['remaining_ms']!,
          _remainingMsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivePomodoroRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivePomodoroRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}phase'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      startAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_at_utc_millis'],
      )!,
      endAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_at_utc_millis'],
      ),
      remainingMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_ms'],
      ),
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $ActivePomodorosTable createAlias(String alias) {
    return $ActivePomodorosTable(attachedDatabase, alias);
  }
}

class ActivePomodoroRow extends DataClass
    implements Insertable<ActivePomodoroRow> {
  final int id;
  final String taskId;
  final int phase;
  final int status;
  final int startAtUtcMillis;
  final int? endAtUtcMillis;
  final int? remainingMs;
  final int updatedAtUtcMillis;
  const ActivePomodoroRow({
    required this.id,
    required this.taskId,
    required this.phase,
    required this.status,
    required this.startAtUtcMillis,
    this.endAtUtcMillis,
    this.remainingMs,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<String>(taskId);
    map['phase'] = Variable<int>(phase);
    map['status'] = Variable<int>(status);
    map['start_at_utc_millis'] = Variable<int>(startAtUtcMillis);
    if (!nullToAbsent || endAtUtcMillis != null) {
      map['end_at_utc_millis'] = Variable<int>(endAtUtcMillis);
    }
    if (!nullToAbsent || remainingMs != null) {
      map['remaining_ms'] = Variable<int>(remainingMs);
    }
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  ActivePomodorosCompanion toCompanion(bool nullToAbsent) {
    return ActivePomodorosCompanion(
      id: Value(id),
      taskId: Value(taskId),
      phase: Value(phase),
      status: Value(status),
      startAtUtcMillis: Value(startAtUtcMillis),
      endAtUtcMillis: endAtUtcMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(endAtUtcMillis),
      remainingMs: remainingMs == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingMs),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory ActivePomodoroRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivePomodoroRow(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      phase: serializer.fromJson<int>(json['phase']),
      status: serializer.fromJson<int>(json['status']),
      startAtUtcMillis: serializer.fromJson<int>(json['startAtUtcMillis']),
      endAtUtcMillis: serializer.fromJson<int?>(json['endAtUtcMillis']),
      remainingMs: serializer.fromJson<int?>(json['remainingMs']),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<String>(taskId),
      'phase': serializer.toJson<int>(phase),
      'status': serializer.toJson<int>(status),
      'startAtUtcMillis': serializer.toJson<int>(startAtUtcMillis),
      'endAtUtcMillis': serializer.toJson<int?>(endAtUtcMillis),
      'remainingMs': serializer.toJson<int?>(remainingMs),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  ActivePomodoroRow copyWith({
    int? id,
    String? taskId,
    int? phase,
    int? status,
    int? startAtUtcMillis,
    Value<int?> endAtUtcMillis = const Value.absent(),
    Value<int?> remainingMs = const Value.absent(),
    int? updatedAtUtcMillis,
  }) => ActivePomodoroRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    phase: phase ?? this.phase,
    status: status ?? this.status,
    startAtUtcMillis: startAtUtcMillis ?? this.startAtUtcMillis,
    endAtUtcMillis: endAtUtcMillis.present
        ? endAtUtcMillis.value
        : this.endAtUtcMillis,
    remainingMs: remainingMs.present ? remainingMs.value : this.remainingMs,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  ActivePomodoroRow copyWithCompanion(ActivePomodorosCompanion data) {
    return ActivePomodoroRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      phase: data.phase.present ? data.phase.value : this.phase,
      status: data.status.present ? data.status.value : this.status,
      startAtUtcMillis: data.startAtUtcMillis.present
          ? data.startAtUtcMillis.value
          : this.startAtUtcMillis,
      endAtUtcMillis: data.endAtUtcMillis.present
          ? data.endAtUtcMillis.value
          : this.endAtUtcMillis,
      remainingMs: data.remainingMs.present
          ? data.remainingMs.value
          : this.remainingMs,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivePomodoroRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('phase: $phase, ')
          ..write('status: $status, ')
          ..write('startAtUtcMillis: $startAtUtcMillis, ')
          ..write('endAtUtcMillis: $endAtUtcMillis, ')
          ..write('remainingMs: $remainingMs, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    phase,
    status,
    startAtUtcMillis,
    endAtUtcMillis,
    remainingMs,
    updatedAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivePomodoroRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.phase == this.phase &&
          other.status == this.status &&
          other.startAtUtcMillis == this.startAtUtcMillis &&
          other.endAtUtcMillis == this.endAtUtcMillis &&
          other.remainingMs == this.remainingMs &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class ActivePomodorosCompanion extends UpdateCompanion<ActivePomodoroRow> {
  final Value<int> id;
  final Value<String> taskId;
  final Value<int> phase;
  final Value<int> status;
  final Value<int> startAtUtcMillis;
  final Value<int?> endAtUtcMillis;
  final Value<int?> remainingMs;
  final Value<int> updatedAtUtcMillis;
  const ActivePomodorosCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.phase = const Value.absent(),
    this.status = const Value.absent(),
    this.startAtUtcMillis = const Value.absent(),
    this.endAtUtcMillis = const Value.absent(),
    this.remainingMs = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
  });
  ActivePomodorosCompanion.insert({
    this.id = const Value.absent(),
    required String taskId,
    this.phase = const Value.absent(),
    required int status,
    required int startAtUtcMillis,
    this.endAtUtcMillis = const Value.absent(),
    this.remainingMs = const Value.absent(),
    required int updatedAtUtcMillis,
  }) : taskId = Value(taskId),
       status = Value(status),
       startAtUtcMillis = Value(startAtUtcMillis),
       updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<ActivePomodoroRow> custom({
    Expression<int>? id,
    Expression<String>? taskId,
    Expression<int>? phase,
    Expression<int>? status,
    Expression<int>? startAtUtcMillis,
    Expression<int>? endAtUtcMillis,
    Expression<int>? remainingMs,
    Expression<int>? updatedAtUtcMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (phase != null) 'phase': phase,
      if (status != null) 'status': status,
      if (startAtUtcMillis != null) 'start_at_utc_millis': startAtUtcMillis,
      if (endAtUtcMillis != null) 'end_at_utc_millis': endAtUtcMillis,
      if (remainingMs != null) 'remaining_ms': remainingMs,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
    });
  }

  ActivePomodorosCompanion copyWith({
    Value<int>? id,
    Value<String>? taskId,
    Value<int>? phase,
    Value<int>? status,
    Value<int>? startAtUtcMillis,
    Value<int?>? endAtUtcMillis,
    Value<int?>? remainingMs,
    Value<int>? updatedAtUtcMillis,
  }) {
    return ActivePomodorosCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      phase: phase ?? this.phase,
      status: status ?? this.status,
      startAtUtcMillis: startAtUtcMillis ?? this.startAtUtcMillis,
      endAtUtcMillis: endAtUtcMillis ?? this.endAtUtcMillis,
      remainingMs: remainingMs ?? this.remainingMs,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (phase.present) {
      map['phase'] = Variable<int>(phase.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (startAtUtcMillis.present) {
      map['start_at_utc_millis'] = Variable<int>(startAtUtcMillis.value);
    }
    if (endAtUtcMillis.present) {
      map['end_at_utc_millis'] = Variable<int>(endAtUtcMillis.value);
    }
    if (remainingMs.present) {
      map['remaining_ms'] = Variable<int>(remainingMs.value);
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivePomodorosCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('phase: $phase, ')
          ..write('status: $status, ')
          ..write('startAtUtcMillis: $startAtUtcMillis, ')
          ..write('endAtUtcMillis: $endAtUtcMillis, ')
          ..write('remainingMs: $remainingMs, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }
}

class $PomodoroSessionsTable extends PomodoroSessions
    with TableInfo<$PomodoroSessionsTable, PomodoroSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startAtUtcMillisMeta = const VerificationMeta(
    'startAtUtcMillis',
  );
  @override
  late final GeneratedColumn<int> startAtUtcMillis = GeneratedColumn<int>(
    'start_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtUtcMillisMeta = const VerificationMeta(
    'endAtUtcMillis',
  );
  @override
  late final GeneratedColumn<int> endAtUtcMillis = GeneratedColumn<int>(
    'end_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDraftMeta = const VerificationMeta(
    'isDraft',
  );
  @override
  late final GeneratedColumn<bool> isDraft = GeneratedColumn<bool>(
    'is_draft',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_draft" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _progressNoteMeta = const VerificationMeta(
    'progressNote',
  );
  @override
  late final GeneratedColumn<String> progressNote = GeneratedColumn<String>(
    'progress_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMillisMeta =
      const VerificationMeta('createdAtUtcMillis');
  @override
  late final GeneratedColumn<int> createdAtUtcMillis = GeneratedColumn<int>(
    'created_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    startAtUtcMillis,
    endAtUtcMillis,
    isDraft,
    progressNote,
    createdAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('start_at_utc_millis')) {
      context.handle(
        _startAtUtcMillisMeta,
        startAtUtcMillis.isAcceptableOrUnknown(
          data['start_at_utc_millis']!,
          _startAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startAtUtcMillisMeta);
    }
    if (data.containsKey('end_at_utc_millis')) {
      context.handle(
        _endAtUtcMillisMeta,
        endAtUtcMillis.isAcceptableOrUnknown(
          data['end_at_utc_millis']!,
          _endAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endAtUtcMillisMeta);
    }
    if (data.containsKey('is_draft')) {
      context.handle(
        _isDraftMeta,
        isDraft.isAcceptableOrUnknown(data['is_draft']!, _isDraftMeta),
      );
    }
    if (data.containsKey('progress_note')) {
      context.handle(
        _progressNoteMeta,
        progressNote.isAcceptableOrUnknown(
          data['progress_note']!,
          _progressNoteMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc_millis')) {
      context.handle(
        _createdAtUtcMillisMeta,
        createdAtUtcMillis.isAcceptableOrUnknown(
          data['created_at_utc_millis']!,
          _createdAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      startAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_at_utc_millis'],
      )!,
      endAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_at_utc_millis'],
      )!,
      isDraft: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_draft'],
      )!,
      progressNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}progress_note'],
      ),
      createdAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_millis'],
      )!,
    );
  }

  @override
  $PomodoroSessionsTable createAlias(String alias) {
    return $PomodoroSessionsTable(attachedDatabase, alias);
  }
}

class PomodoroSessionRow extends DataClass
    implements Insertable<PomodoroSessionRow> {
  final String id;
  final String taskId;
  final int startAtUtcMillis;
  final int endAtUtcMillis;
  final bool isDraft;
  final String? progressNote;
  final int createdAtUtcMillis;
  const PomodoroSessionRow({
    required this.id,
    required this.taskId,
    required this.startAtUtcMillis,
    required this.endAtUtcMillis,
    required this.isDraft,
    this.progressNote,
    required this.createdAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['start_at_utc_millis'] = Variable<int>(startAtUtcMillis);
    map['end_at_utc_millis'] = Variable<int>(endAtUtcMillis);
    map['is_draft'] = Variable<bool>(isDraft);
    if (!nullToAbsent || progressNote != null) {
      map['progress_note'] = Variable<String>(progressNote);
    }
    map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis);
    return map;
  }

  PomodoroSessionsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroSessionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      startAtUtcMillis: Value(startAtUtcMillis),
      endAtUtcMillis: Value(endAtUtcMillis),
      isDraft: Value(isDraft),
      progressNote: progressNote == null && nullToAbsent
          ? const Value.absent()
          : Value(progressNote),
      createdAtUtcMillis: Value(createdAtUtcMillis),
    );
  }

  factory PomodoroSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroSessionRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      startAtUtcMillis: serializer.fromJson<int>(json['startAtUtcMillis']),
      endAtUtcMillis: serializer.fromJson<int>(json['endAtUtcMillis']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      progressNote: serializer.fromJson<String?>(json['progressNote']),
      createdAtUtcMillis: serializer.fromJson<int>(json['createdAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'startAtUtcMillis': serializer.toJson<int>(startAtUtcMillis),
      'endAtUtcMillis': serializer.toJson<int>(endAtUtcMillis),
      'isDraft': serializer.toJson<bool>(isDraft),
      'progressNote': serializer.toJson<String?>(progressNote),
      'createdAtUtcMillis': serializer.toJson<int>(createdAtUtcMillis),
    };
  }

  PomodoroSessionRow copyWith({
    String? id,
    String? taskId,
    int? startAtUtcMillis,
    int? endAtUtcMillis,
    bool? isDraft,
    Value<String?> progressNote = const Value.absent(),
    int? createdAtUtcMillis,
  }) => PomodoroSessionRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    startAtUtcMillis: startAtUtcMillis ?? this.startAtUtcMillis,
    endAtUtcMillis: endAtUtcMillis ?? this.endAtUtcMillis,
    isDraft: isDraft ?? this.isDraft,
    progressNote: progressNote.present ? progressNote.value : this.progressNote,
    createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
  );
  PomodoroSessionRow copyWithCompanion(PomodoroSessionsCompanion data) {
    return PomodoroSessionRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startAtUtcMillis: data.startAtUtcMillis.present
          ? data.startAtUtcMillis.value
          : this.startAtUtcMillis,
      endAtUtcMillis: data.endAtUtcMillis.present
          ? data.endAtUtcMillis.value
          : this.endAtUtcMillis,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      progressNote: data.progressNote.present
          ? data.progressNote.value
          : this.progressNote,
      createdAtUtcMillis: data.createdAtUtcMillis.present
          ? data.createdAtUtcMillis.value
          : this.createdAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startAtUtcMillis: $startAtUtcMillis, ')
          ..write('endAtUtcMillis: $endAtUtcMillis, ')
          ..write('isDraft: $isDraft, ')
          ..write('progressNote: $progressNote, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    startAtUtcMillis,
    endAtUtcMillis,
    isDraft,
    progressNote,
    createdAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroSessionRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.startAtUtcMillis == this.startAtUtcMillis &&
          other.endAtUtcMillis == this.endAtUtcMillis &&
          other.isDraft == this.isDraft &&
          other.progressNote == this.progressNote &&
          other.createdAtUtcMillis == this.createdAtUtcMillis);
}

class PomodoroSessionsCompanion extends UpdateCompanion<PomodoroSessionRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int> startAtUtcMillis;
  final Value<int> endAtUtcMillis;
  final Value<bool> isDraft;
  final Value<String?> progressNote;
  final Value<int> createdAtUtcMillis;
  final Value<int> rowid;
  const PomodoroSessionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startAtUtcMillis = const Value.absent(),
    this.endAtUtcMillis = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.progressNote = const Value.absent(),
    this.createdAtUtcMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PomodoroSessionsCompanion.insert({
    required String id,
    required String taskId,
    required int startAtUtcMillis,
    required int endAtUtcMillis,
    this.isDraft = const Value.absent(),
    this.progressNote = const Value.absent(),
    required int createdAtUtcMillis,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       startAtUtcMillis = Value(startAtUtcMillis),
       endAtUtcMillis = Value(endAtUtcMillis),
       createdAtUtcMillis = Value(createdAtUtcMillis);
  static Insertable<PomodoroSessionRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? startAtUtcMillis,
    Expression<int>? endAtUtcMillis,
    Expression<bool>? isDraft,
    Expression<String>? progressNote,
    Expression<int>? createdAtUtcMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (startAtUtcMillis != null) 'start_at_utc_millis': startAtUtcMillis,
      if (endAtUtcMillis != null) 'end_at_utc_millis': endAtUtcMillis,
      if (isDraft != null) 'is_draft': isDraft,
      if (progressNote != null) 'progress_note': progressNote,
      if (createdAtUtcMillis != null)
        'created_at_utc_millis': createdAtUtcMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PomodoroSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<int>? startAtUtcMillis,
    Value<int>? endAtUtcMillis,
    Value<bool>? isDraft,
    Value<String?>? progressNote,
    Value<int>? createdAtUtcMillis,
    Value<int>? rowid,
  }) {
    return PomodoroSessionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startAtUtcMillis: startAtUtcMillis ?? this.startAtUtcMillis,
      endAtUtcMillis: endAtUtcMillis ?? this.endAtUtcMillis,
      isDraft: isDraft ?? this.isDraft,
      progressNote: progressNote ?? this.progressNote,
      createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (startAtUtcMillis.present) {
      map['start_at_utc_millis'] = Variable<int>(startAtUtcMillis.value);
    }
    if (endAtUtcMillis.present) {
      map['end_at_utc_millis'] = Variable<int>(endAtUtcMillis.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (progressNote.present) {
      map['progress_note'] = Variable<String>(progressNote.value);
    }
    if (createdAtUtcMillis.present) {
      map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSessionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('startAtUtcMillis: $startAtUtcMillis, ')
          ..write('endAtUtcMillis: $endAtUtcMillis, ')
          ..write('isDraft: $isDraft, ')
          ..write('progressNote: $progressNote, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMillisMeta =
      const VerificationMeta('createdAtUtcMillis');
  @override
  late final GeneratedColumn<int> createdAtUtcMillis = GeneratedColumn<int>(
    'created_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    tagsJson,
    taskId,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('created_at_utc_millis')) {
      context.handle(
        _createdAtUtcMillisMeta,
        createdAtUtcMillis.isAcceptableOrUnknown(
          data['created_at_utc_millis']!,
          _createdAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMillisMeta);
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      createdAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_millis'],
      )!,
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String id;
  final String title;
  final String body;
  final String tagsJson;
  final String? taskId;
  final int createdAtUtcMillis;
  final int updatedAtUtcMillis;
  const NoteRow({
    required this.id,
    required this.title,
    required this.body,
    required this.tagsJson,
    this.taskId,
    required this.createdAtUtcMillis,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['tags_json'] = Variable<String>(tagsJson);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis);
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      tagsJson: Value(tagsJson),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      createdAtUtcMillis: Value(createdAtUtcMillis),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory NoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      createdAtUtcMillis: serializer.fromJson<int>(json['createdAtUtcMillis']),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'taskId': serializer.toJson<String?>(taskId),
      'createdAtUtcMillis': serializer.toJson<int>(createdAtUtcMillis),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  NoteRow copyWith({
    String? id,
    String? title,
    String? body,
    String? tagsJson,
    Value<String?> taskId = const Value.absent(),
    int? createdAtUtcMillis,
    int? updatedAtUtcMillis,
  }) => NoteRow(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    tagsJson: tagsJson ?? this.tagsJson,
    taskId: taskId.present ? taskId.value : this.taskId,
    createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      createdAtUtcMillis: data.createdAtUtcMillis.present
          ? data.createdAtUtcMillis.value
          : this.createdAtUtcMillis,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('taskId: $taskId, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    body,
    tagsJson,
    taskId,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.tagsJson == this.tagsJson &&
          other.taskId == this.taskId &&
          other.createdAtUtcMillis == this.createdAtUtcMillis &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> tagsJson;
  final Value<String?> taskId;
  final Value<int> createdAtUtcMillis;
  final Value<int> updatedAtUtcMillis;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.taskId = const Value.absent(),
    this.createdAtUtcMillis = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    this.body = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.taskId = const Value.absent(),
    required int createdAtUtcMillis,
    required int updatedAtUtcMillis,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAtUtcMillis = Value(createdAtUtcMillis),
       updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<NoteRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? tagsJson,
    Expression<String>? taskId,
    Expression<int>? createdAtUtcMillis,
    Expression<int>? updatedAtUtcMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (taskId != null) 'task_id': taskId,
      if (createdAtUtcMillis != null)
        'created_at_utc_millis': createdAtUtcMillis,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String>? tagsJson,
    Value<String?>? taskId,
    Value<int>? createdAtUtcMillis,
    Value<int>? updatedAtUtcMillis,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      tagsJson: tagsJson ?? this.tagsJson,
      taskId: taskId ?? this.taskId,
      createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (createdAtUtcMillis.present) {
      map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis.value);
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('taskId: $taskId, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PomodoroConfigsTable extends PomodoroConfigs
    with TableInfo<$PomodoroConfigsTable, PomodoroConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workDurationMinutesMeta =
      const VerificationMeta('workDurationMinutes');
  @override
  late final GeneratedColumn<int> workDurationMinutes = GeneratedColumn<int>(
    'work_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _shortBreakMinutesMeta = const VerificationMeta(
    'shortBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> shortBreakMinutes = GeneratedColumn<int>(
    'short_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _longBreakMinutesMeta = const VerificationMeta(
    'longBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> longBreakMinutes = GeneratedColumn<int>(
    'long_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _longBreakEveryMeta = const VerificationMeta(
    'longBreakEvery',
  );
  @override
  late final GeneratedColumn<int> longBreakEvery = GeneratedColumn<int>(
    'long_break_every',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _autoStartBreakMeta = const VerificationMeta(
    'autoStartBreak',
  );
  @override
  late final GeneratedColumn<bool> autoStartBreak = GeneratedColumn<bool>(
    'auto_start_break',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_break" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoStartFocusMeta = const VerificationMeta(
    'autoStartFocus',
  );
  @override
  late final GeneratedColumn<bool> autoStartFocus = GeneratedColumn<bool>(
    'auto_start_focus',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_focus" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationSoundMeta = const VerificationMeta(
    'notificationSound',
  );
  @override
  late final GeneratedColumn<bool> notificationSound = GeneratedColumn<bool>(
    'notification_sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notification_sound" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationVibrationMeta =
      const VerificationMeta('notificationVibration');
  @override
  late final GeneratedColumn<bool> notificationVibration =
      GeneratedColumn<bool>(
        'notification_vibration',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notification_vibration" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workDurationMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    longBreakEvery,
    autoStartBreak,
    autoStartFocus,
    notificationSound,
    notificationVibration,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroConfigRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_duration_minutes')) {
      context.handle(
        _workDurationMinutesMeta,
        workDurationMinutes.isAcceptableOrUnknown(
          data['work_duration_minutes']!,
          _workDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('short_break_minutes')) {
      context.handle(
        _shortBreakMinutesMeta,
        shortBreakMinutes.isAcceptableOrUnknown(
          data['short_break_minutes']!,
          _shortBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('long_break_minutes')) {
      context.handle(
        _longBreakMinutesMeta,
        longBreakMinutes.isAcceptableOrUnknown(
          data['long_break_minutes']!,
          _longBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('long_break_every')) {
      context.handle(
        _longBreakEveryMeta,
        longBreakEvery.isAcceptableOrUnknown(
          data['long_break_every']!,
          _longBreakEveryMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_break')) {
      context.handle(
        _autoStartBreakMeta,
        autoStartBreak.isAcceptableOrUnknown(
          data['auto_start_break']!,
          _autoStartBreakMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_focus')) {
      context.handle(
        _autoStartFocusMeta,
        autoStartFocus.isAcceptableOrUnknown(
          data['auto_start_focus']!,
          _autoStartFocusMeta,
        ),
      );
    }
    if (data.containsKey('notification_sound')) {
      context.handle(
        _notificationSoundMeta,
        notificationSound.isAcceptableOrUnknown(
          data['notification_sound']!,
          _notificationSoundMeta,
        ),
      );
    }
    if (data.containsKey('notification_vibration')) {
      context.handle(
        _notificationVibrationMeta,
        notificationVibration.isAcceptableOrUnknown(
          data['notification_vibration']!,
          _notificationVibrationMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroConfigRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_duration_minutes'],
      )!,
      shortBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_minutes'],
      )!,
      longBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_minutes'],
      )!,
      longBreakEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_every'],
      )!,
      autoStartBreak: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_break'],
      )!,
      autoStartFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_focus'],
      )!,
      notificationSound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_sound'],
      )!,
      notificationVibration: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notification_vibration'],
      )!,
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $PomodoroConfigsTable createAlias(String alias) {
    return $PomodoroConfigsTable(attachedDatabase, alias);
  }
}

class PomodoroConfigRow extends DataClass
    implements Insertable<PomodoroConfigRow> {
  final int id;
  final int workDurationMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int longBreakEvery;
  final bool autoStartBreak;
  final bool autoStartFocus;
  final bool notificationSound;
  final bool notificationVibration;
  final int updatedAtUtcMillis;
  const PomodoroConfigRow({
    required this.id,
    required this.workDurationMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.longBreakEvery,
    required this.autoStartBreak,
    required this.autoStartFocus,
    required this.notificationSound,
    required this.notificationVibration,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_duration_minutes'] = Variable<int>(workDurationMinutes);
    map['short_break_minutes'] = Variable<int>(shortBreakMinutes);
    map['long_break_minutes'] = Variable<int>(longBreakMinutes);
    map['long_break_every'] = Variable<int>(longBreakEvery);
    map['auto_start_break'] = Variable<bool>(autoStartBreak);
    map['auto_start_focus'] = Variable<bool>(autoStartFocus);
    map['notification_sound'] = Variable<bool>(notificationSound);
    map['notification_vibration'] = Variable<bool>(notificationVibration);
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  PomodoroConfigsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroConfigsCompanion(
      id: Value(id),
      workDurationMinutes: Value(workDurationMinutes),
      shortBreakMinutes: Value(shortBreakMinutes),
      longBreakMinutes: Value(longBreakMinutes),
      longBreakEvery: Value(longBreakEvery),
      autoStartBreak: Value(autoStartBreak),
      autoStartFocus: Value(autoStartFocus),
      notificationSound: Value(notificationSound),
      notificationVibration: Value(notificationVibration),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory PomodoroConfigRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroConfigRow(
      id: serializer.fromJson<int>(json['id']),
      workDurationMinutes: serializer.fromJson<int>(
        json['workDurationMinutes'],
      ),
      shortBreakMinutes: serializer.fromJson<int>(json['shortBreakMinutes']),
      longBreakMinutes: serializer.fromJson<int>(json['longBreakMinutes']),
      longBreakEvery: serializer.fromJson<int>(json['longBreakEvery']),
      autoStartBreak: serializer.fromJson<bool>(json['autoStartBreak']),
      autoStartFocus: serializer.fromJson<bool>(json['autoStartFocus']),
      notificationSound: serializer.fromJson<bool>(json['notificationSound']),
      notificationVibration: serializer.fromJson<bool>(
        json['notificationVibration'],
      ),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workDurationMinutes': serializer.toJson<int>(workDurationMinutes),
      'shortBreakMinutes': serializer.toJson<int>(shortBreakMinutes),
      'longBreakMinutes': serializer.toJson<int>(longBreakMinutes),
      'longBreakEvery': serializer.toJson<int>(longBreakEvery),
      'autoStartBreak': serializer.toJson<bool>(autoStartBreak),
      'autoStartFocus': serializer.toJson<bool>(autoStartFocus),
      'notificationSound': serializer.toJson<bool>(notificationSound),
      'notificationVibration': serializer.toJson<bool>(notificationVibration),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  PomodoroConfigRow copyWith({
    int? id,
    int? workDurationMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? longBreakEvery,
    bool? autoStartBreak,
    bool? autoStartFocus,
    bool? notificationSound,
    bool? notificationVibration,
    int? updatedAtUtcMillis,
  }) => PomodoroConfigRow(
    id: id ?? this.id,
    workDurationMinutes: workDurationMinutes ?? this.workDurationMinutes,
    shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
    longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
    longBreakEvery: longBreakEvery ?? this.longBreakEvery,
    autoStartBreak: autoStartBreak ?? this.autoStartBreak,
    autoStartFocus: autoStartFocus ?? this.autoStartFocus,
    notificationSound: notificationSound ?? this.notificationSound,
    notificationVibration: notificationVibration ?? this.notificationVibration,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  PomodoroConfigRow copyWithCompanion(PomodoroConfigsCompanion data) {
    return PomodoroConfigRow(
      id: data.id.present ? data.id.value : this.id,
      workDurationMinutes: data.workDurationMinutes.present
          ? data.workDurationMinutes.value
          : this.workDurationMinutes,
      shortBreakMinutes: data.shortBreakMinutes.present
          ? data.shortBreakMinutes.value
          : this.shortBreakMinutes,
      longBreakMinutes: data.longBreakMinutes.present
          ? data.longBreakMinutes.value
          : this.longBreakMinutes,
      longBreakEvery: data.longBreakEvery.present
          ? data.longBreakEvery.value
          : this.longBreakEvery,
      autoStartBreak: data.autoStartBreak.present
          ? data.autoStartBreak.value
          : this.autoStartBreak,
      autoStartFocus: data.autoStartFocus.present
          ? data.autoStartFocus.value
          : this.autoStartFocus,
      notificationSound: data.notificationSound.present
          ? data.notificationSound.value
          : this.notificationSound,
      notificationVibration: data.notificationVibration.present
          ? data.notificationVibration.value
          : this.notificationVibration,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroConfigRow(')
          ..write('id: $id, ')
          ..write('workDurationMinutes: $workDurationMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('longBreakEvery: $longBreakEvery, ')
          ..write('autoStartBreak: $autoStartBreak, ')
          ..write('autoStartFocus: $autoStartFocus, ')
          ..write('notificationSound: $notificationSound, ')
          ..write('notificationVibration: $notificationVibration, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workDurationMinutes,
    shortBreakMinutes,
    longBreakMinutes,
    longBreakEvery,
    autoStartBreak,
    autoStartFocus,
    notificationSound,
    notificationVibration,
    updatedAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroConfigRow &&
          other.id == this.id &&
          other.workDurationMinutes == this.workDurationMinutes &&
          other.shortBreakMinutes == this.shortBreakMinutes &&
          other.longBreakMinutes == this.longBreakMinutes &&
          other.longBreakEvery == this.longBreakEvery &&
          other.autoStartBreak == this.autoStartBreak &&
          other.autoStartFocus == this.autoStartFocus &&
          other.notificationSound == this.notificationSound &&
          other.notificationVibration == this.notificationVibration &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class PomodoroConfigsCompanion extends UpdateCompanion<PomodoroConfigRow> {
  final Value<int> id;
  final Value<int> workDurationMinutes;
  final Value<int> shortBreakMinutes;
  final Value<int> longBreakMinutes;
  final Value<int> longBreakEvery;
  final Value<bool> autoStartBreak;
  final Value<bool> autoStartFocus;
  final Value<bool> notificationSound;
  final Value<bool> notificationVibration;
  final Value<int> updatedAtUtcMillis;
  const PomodoroConfigsCompanion({
    this.id = const Value.absent(),
    this.workDurationMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.longBreakEvery = const Value.absent(),
    this.autoStartBreak = const Value.absent(),
    this.autoStartFocus = const Value.absent(),
    this.notificationSound = const Value.absent(),
    this.notificationVibration = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
  });
  PomodoroConfigsCompanion.insert({
    this.id = const Value.absent(),
    this.workDurationMinutes = const Value.absent(),
    this.shortBreakMinutes = const Value.absent(),
    this.longBreakMinutes = const Value.absent(),
    this.longBreakEvery = const Value.absent(),
    this.autoStartBreak = const Value.absent(),
    this.autoStartFocus = const Value.absent(),
    this.notificationSound = const Value.absent(),
    this.notificationVibration = const Value.absent(),
    required int updatedAtUtcMillis,
  }) : updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<PomodoroConfigRow> custom({
    Expression<int>? id,
    Expression<int>? workDurationMinutes,
    Expression<int>? shortBreakMinutes,
    Expression<int>? longBreakMinutes,
    Expression<int>? longBreakEvery,
    Expression<bool>? autoStartBreak,
    Expression<bool>? autoStartFocus,
    Expression<bool>? notificationSound,
    Expression<bool>? notificationVibration,
    Expression<int>? updatedAtUtcMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workDurationMinutes != null)
        'work_duration_minutes': workDurationMinutes,
      if (shortBreakMinutes != null) 'short_break_minutes': shortBreakMinutes,
      if (longBreakMinutes != null) 'long_break_minutes': longBreakMinutes,
      if (longBreakEvery != null) 'long_break_every': longBreakEvery,
      if (autoStartBreak != null) 'auto_start_break': autoStartBreak,
      if (autoStartFocus != null) 'auto_start_focus': autoStartFocus,
      if (notificationSound != null) 'notification_sound': notificationSound,
      if (notificationVibration != null)
        'notification_vibration': notificationVibration,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
    });
  }

  PomodoroConfigsCompanion copyWith({
    Value<int>? id,
    Value<int>? workDurationMinutes,
    Value<int>? shortBreakMinutes,
    Value<int>? longBreakMinutes,
    Value<int>? longBreakEvery,
    Value<bool>? autoStartBreak,
    Value<bool>? autoStartFocus,
    Value<bool>? notificationSound,
    Value<bool>? notificationVibration,
    Value<int>? updatedAtUtcMillis,
  }) {
    return PomodoroConfigsCompanion(
      id: id ?? this.id,
      workDurationMinutes: workDurationMinutes ?? this.workDurationMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      longBreakEvery: longBreakEvery ?? this.longBreakEvery,
      autoStartBreak: autoStartBreak ?? this.autoStartBreak,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      notificationSound: notificationSound ?? this.notificationSound,
      notificationVibration:
          notificationVibration ?? this.notificationVibration,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workDurationMinutes.present) {
      map['work_duration_minutes'] = Variable<int>(workDurationMinutes.value);
    }
    if (shortBreakMinutes.present) {
      map['short_break_minutes'] = Variable<int>(shortBreakMinutes.value);
    }
    if (longBreakMinutes.present) {
      map['long_break_minutes'] = Variable<int>(longBreakMinutes.value);
    }
    if (longBreakEvery.present) {
      map['long_break_every'] = Variable<int>(longBreakEvery.value);
    }
    if (autoStartBreak.present) {
      map['auto_start_break'] = Variable<bool>(autoStartBreak.value);
    }
    if (autoStartFocus.present) {
      map['auto_start_focus'] = Variable<bool>(autoStartFocus.value);
    }
    if (notificationSound.present) {
      map['notification_sound'] = Variable<bool>(notificationSound.value);
    }
    if (notificationVibration.present) {
      map['notification_vibration'] = Variable<bool>(
        notificationVibration.value,
      );
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroConfigsCompanion(')
          ..write('id: $id, ')
          ..write('workDurationMinutes: $workDurationMinutes, ')
          ..write('shortBreakMinutes: $shortBreakMinutes, ')
          ..write('longBreakMinutes: $longBreakMinutes, ')
          ..write('longBreakEvery: $longBreakEvery, ')
          ..write('autoStartBreak: $autoStartBreak, ')
          ..write('autoStartFocus: $autoStartFocus, ')
          ..write('notificationSound: $notificationSound, ')
          ..write('notificationVibration: $notificationVibration, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }
}

class $AppearanceConfigsTable extends AppearanceConfigs
    with TableInfo<$AppearanceConfigsTable, AppearanceConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppearanceConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<int> themeMode = GeneratedColumn<int>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _densityMeta = const VerificationMeta(
    'density',
  );
  @override
  late final GeneratedColumn<int> density = GeneratedColumn<int>(
    'density',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _accentMeta = const VerificationMeta('accent');
  @override
  late final GeneratedColumn<int> accent = GeneratedColumn<int>(
    'accent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    density,
    accent,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appearance_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppearanceConfigRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('density')) {
      context.handle(
        _densityMeta,
        density.isAcceptableOrUnknown(data['density']!, _densityMeta),
      );
    }
    if (data.containsKey('accent')) {
      context.handle(
        _accentMeta,
        accent.isAcceptableOrUnknown(data['accent']!, _accentMeta),
      );
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppearanceConfigRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppearanceConfigRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}theme_mode'],
      )!,
      density: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}density'],
      )!,
      accent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent'],
      )!,
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $AppearanceConfigsTable createAlias(String alias) {
    return $AppearanceConfigsTable(attachedDatabase, alias);
  }
}

class AppearanceConfigRow extends DataClass
    implements Insertable<AppearanceConfigRow> {
  final int id;
  final int themeMode;
  final int density;
  final int accent;
  final int updatedAtUtcMillis;
  const AppearanceConfigRow({
    required this.id,
    required this.themeMode,
    required this.density,
    required this.accent,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<int>(themeMode);
    map['density'] = Variable<int>(density);
    map['accent'] = Variable<int>(accent);
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  AppearanceConfigsCompanion toCompanion(bool nullToAbsent) {
    return AppearanceConfigsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      density: Value(density),
      accent: Value(accent),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory AppearanceConfigRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppearanceConfigRow(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<int>(json['themeMode']),
      density: serializer.fromJson<int>(json['density']),
      accent: serializer.fromJson<int>(json['accent']),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<int>(themeMode),
      'density': serializer.toJson<int>(density),
      'accent': serializer.toJson<int>(accent),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  AppearanceConfigRow copyWith({
    int? id,
    int? themeMode,
    int? density,
    int? accent,
    int? updatedAtUtcMillis,
  }) => AppearanceConfigRow(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    density: density ?? this.density,
    accent: accent ?? this.accent,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  AppearanceConfigRow copyWithCompanion(AppearanceConfigsCompanion data) {
    return AppearanceConfigRow(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      density: data.density.present ? data.density.value : this.density,
      accent: data.accent.present ? data.accent.value : this.accent,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppearanceConfigRow(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('density: $density, ')
          ..write('accent: $accent, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, themeMode, density, accent, updatedAtUtcMillis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppearanceConfigRow &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.density == this.density &&
          other.accent == this.accent &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class AppearanceConfigsCompanion extends UpdateCompanion<AppearanceConfigRow> {
  final Value<int> id;
  final Value<int> themeMode;
  final Value<int> density;
  final Value<int> accent;
  final Value<int> updatedAtUtcMillis;
  const AppearanceConfigsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.density = const Value.absent(),
    this.accent = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
  });
  AppearanceConfigsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.density = const Value.absent(),
    this.accent = const Value.absent(),
    required int updatedAtUtcMillis,
  }) : updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<AppearanceConfigRow> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
    Expression<int>? density,
    Expression<int>? accent,
    Expression<int>? updatedAtUtcMillis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (density != null) 'density': density,
      if (accent != null) 'accent': accent,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
    });
  }

  AppearanceConfigsCompanion copyWith({
    Value<int>? id,
    Value<int>? themeMode,
    Value<int>? density,
    Value<int>? accent,
    Value<int>? updatedAtUtcMillis,
  }) {
    return AppearanceConfigsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      density: density ?? this.density,
      accent: accent ?? this.accent,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(themeMode.value);
    }
    if (density.present) {
      map['density'] = Variable<int>(density.value);
    }
    if (accent.present) {
      map['accent'] = Variable<int>(accent.value);
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppearanceConfigsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('density: $density, ')
          ..write('accent: $accent, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }
}

class $TodayPlanItemsTable extends TodayPlanItems
    with TableInfo<$TodayPlanItemsTable, TodayPlanItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodayPlanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMillisMeta =
      const VerificationMeta('createdAtUtcMillis');
  @override
  late final GeneratedColumn<int> createdAtUtcMillis = GeneratedColumn<int>(
    'created_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMillisMeta =
      const VerificationMeta('updatedAtUtcMillis');
  @override
  late final GeneratedColumn<int> updatedAtUtcMillis = GeneratedColumn<int>(
    'updated_at_utc_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dayKey,
    taskId,
    orderIndex,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'today_plan_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodayPlanItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at_utc_millis')) {
      context.handle(
        _createdAtUtcMillisMeta,
        createdAtUtcMillis.isAcceptableOrUnknown(
          data['created_at_utc_millis']!,
          _createdAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMillisMeta);
    }
    if (data.containsKey('updated_at_utc_millis')) {
      context.handle(
        _updatedAtUtcMillisMeta,
        updatedAtUtcMillis.isAcceptableOrUnknown(
          data['updated_at_utc_millis']!,
          _updatedAtUtcMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMillisMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dayKey, taskId};
  @override
  TodayPlanItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodayPlanItemRow(
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_millis'],
      )!,
      updatedAtUtcMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_millis'],
      )!,
    );
  }

  @override
  $TodayPlanItemsTable createAlias(String alias) {
    return $TodayPlanItemsTable(attachedDatabase, alias);
  }
}

class TodayPlanItemRow extends DataClass
    implements Insertable<TodayPlanItemRow> {
  /// Local day key, formatted as YYYY-MM-DD.
  final String dayKey;
  final String taskId;
  final int orderIndex;
  final int createdAtUtcMillis;
  final int updatedAtUtcMillis;
  const TodayPlanItemRow({
    required this.dayKey,
    required this.taskId,
    required this.orderIndex,
    required this.createdAtUtcMillis,
    required this.updatedAtUtcMillis,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day_key'] = Variable<String>(dayKey);
    map['task_id'] = Variable<String>(taskId);
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis);
    map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis);
    return map;
  }

  TodayPlanItemsCompanion toCompanion(bool nullToAbsent) {
    return TodayPlanItemsCompanion(
      dayKey: Value(dayKey),
      taskId: Value(taskId),
      orderIndex: Value(orderIndex),
      createdAtUtcMillis: Value(createdAtUtcMillis),
      updatedAtUtcMillis: Value(updatedAtUtcMillis),
    );
  }

  factory TodayPlanItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodayPlanItemRow(
      dayKey: serializer.fromJson<String>(json['dayKey']),
      taskId: serializer.fromJson<String>(json['taskId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAtUtcMillis: serializer.fromJson<int>(json['createdAtUtcMillis']),
      updatedAtUtcMillis: serializer.fromJson<int>(json['updatedAtUtcMillis']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dayKey': serializer.toJson<String>(dayKey),
      'taskId': serializer.toJson<String>(taskId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAtUtcMillis': serializer.toJson<int>(createdAtUtcMillis),
      'updatedAtUtcMillis': serializer.toJson<int>(updatedAtUtcMillis),
    };
  }

  TodayPlanItemRow copyWith({
    String? dayKey,
    String? taskId,
    int? orderIndex,
    int? createdAtUtcMillis,
    int? updatedAtUtcMillis,
  }) => TodayPlanItemRow(
    dayKey: dayKey ?? this.dayKey,
    taskId: taskId ?? this.taskId,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
    updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
  );
  TodayPlanItemRow copyWithCompanion(TodayPlanItemsCompanion data) {
    return TodayPlanItemRow(
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAtUtcMillis: data.createdAtUtcMillis.present
          ? data.createdAtUtcMillis.value
          : this.createdAtUtcMillis,
      updatedAtUtcMillis: data.updatedAtUtcMillis.present
          ? data.updatedAtUtcMillis.value
          : this.updatedAtUtcMillis,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodayPlanItemRow(')
          ..write('dayKey: $dayKey, ')
          ..write('taskId: $taskId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dayKey,
    taskId,
    orderIndex,
    createdAtUtcMillis,
    updatedAtUtcMillis,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodayPlanItemRow &&
          other.dayKey == this.dayKey &&
          other.taskId == this.taskId &&
          other.orderIndex == this.orderIndex &&
          other.createdAtUtcMillis == this.createdAtUtcMillis &&
          other.updatedAtUtcMillis == this.updatedAtUtcMillis);
}

class TodayPlanItemsCompanion extends UpdateCompanion<TodayPlanItemRow> {
  final Value<String> dayKey;
  final Value<String> taskId;
  final Value<int> orderIndex;
  final Value<int> createdAtUtcMillis;
  final Value<int> updatedAtUtcMillis;
  final Value<int> rowid;
  const TodayPlanItemsCompanion({
    this.dayKey = const Value.absent(),
    this.taskId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAtUtcMillis = const Value.absent(),
    this.updatedAtUtcMillis = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodayPlanItemsCompanion.insert({
    required String dayKey,
    required String taskId,
    required int orderIndex,
    required int createdAtUtcMillis,
    required int updatedAtUtcMillis,
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       taskId = Value(taskId),
       orderIndex = Value(orderIndex),
       createdAtUtcMillis = Value(createdAtUtcMillis),
       updatedAtUtcMillis = Value(updatedAtUtcMillis);
  static Insertable<TodayPlanItemRow> custom({
    Expression<String>? dayKey,
    Expression<String>? taskId,
    Expression<int>? orderIndex,
    Expression<int>? createdAtUtcMillis,
    Expression<int>? updatedAtUtcMillis,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dayKey != null) 'day_key': dayKey,
      if (taskId != null) 'task_id': taskId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAtUtcMillis != null)
        'created_at_utc_millis': createdAtUtcMillis,
      if (updatedAtUtcMillis != null)
        'updated_at_utc_millis': updatedAtUtcMillis,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodayPlanItemsCompanion copyWith({
    Value<String>? dayKey,
    Value<String>? taskId,
    Value<int>? orderIndex,
    Value<int>? createdAtUtcMillis,
    Value<int>? updatedAtUtcMillis,
    Value<int>? rowid,
  }) {
    return TodayPlanItemsCompanion(
      dayKey: dayKey ?? this.dayKey,
      taskId: taskId ?? this.taskId,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAtUtcMillis: createdAtUtcMillis ?? this.createdAtUtcMillis,
      updatedAtUtcMillis: updatedAtUtcMillis ?? this.updatedAtUtcMillis,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAtUtcMillis.present) {
      map['created_at_utc_millis'] = Variable<int>(createdAtUtcMillis.value);
    }
    if (updatedAtUtcMillis.present) {
      map['updated_at_utc_millis'] = Variable<int>(updatedAtUtcMillis.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodayPlanItemsCompanion(')
          ..write('dayKey: $dayKey, ')
          ..write('taskId: $taskId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAtUtcMillis: $createdAtUtcMillis, ')
          ..write('updatedAtUtcMillis: $updatedAtUtcMillis, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TaskCheckItemsTable taskCheckItems = $TaskCheckItemsTable(this);
  late final $ActivePomodorosTable activePomodoros = $ActivePomodorosTable(
    this,
  );
  late final $PomodoroSessionsTable pomodoroSessions = $PomodoroSessionsTable(
    this,
  );
  late final $NotesTable notes = $NotesTable(this);
  late final $PomodoroConfigsTable pomodoroConfigs = $PomodoroConfigsTable(
    this,
  );
  late final $AppearanceConfigsTable appearanceConfigs =
      $AppearanceConfigsTable(this);
  late final $TodayPlanItemsTable todayPlanItems = $TodayPlanItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasks,
    taskCheckItems,
    activePomodoros,
    pomodoroSessions,
    notes,
    pomodoroConfigs,
    appearanceConfigs,
    todayPlanItems,
  ];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      required int status,
      required int priority,
      Value<int?> dueAtUtcMillis,
      Value<String> tagsJson,
      Value<int?> estimatedPomodoros,
      required int createdAtUtcMillis,
      required int updatedAtUtcMillis,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<int> status,
      Value<int> priority,
      Value<int?> dueAtUtcMillis,
      Value<String> tagsJson,
      Value<int?> estimatedPomodoros,
      Value<int> createdAtUtcMillis,
      Value<int> updatedAtUtcMillis,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAtUtcMillis => $composableBuilder(
    column: $table.dueAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPomodoros => $composableBuilder(
    column: $table.estimatedPomodoros,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAtUtcMillis => $composableBuilder(
    column: $table.dueAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPomodoros => $composableBuilder(
    column: $table.estimatedPomodoros,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get dueAtUtcMillis => $composableBuilder(
    column: $table.dueAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<int> get estimatedPomodoros => $composableBuilder(
    column: $table.estimatedPomodoros,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int?> dueAtUtcMillis = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int?> estimatedPomodoros = const Value.absent(),
                Value<int> createdAtUtcMillis = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                status: status,
                priority: priority,
                dueAtUtcMillis: dueAtUtcMillis,
                tagsJson: tagsJson,
                estimatedPomodoros: estimatedPomodoros,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                required int status,
                required int priority,
                Value<int?> dueAtUtcMillis = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int?> estimatedPomodoros = const Value.absent(),
                required int createdAtUtcMillis,
                required int updatedAtUtcMillis,
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                status: status,
                priority: priority,
                dueAtUtcMillis: dueAtUtcMillis,
                tagsJson: tagsJson,
                estimatedPomodoros: estimatedPomodoros,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
typedef $$TaskCheckItemsTableCreateCompanionBuilder =
    TaskCheckItemsCompanion Function({
      required String id,
      required String taskId,
      required String title,
      Value<bool> isDone,
      required int orderIndex,
      required int createdAtUtcMillis,
      required int updatedAtUtcMillis,
      Value<int> rowid,
    });
typedef $$TaskCheckItemsTableUpdateCompanionBuilder =
    TaskCheckItemsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> title,
      Value<bool> isDone,
      Value<int> orderIndex,
      Value<int> createdAtUtcMillis,
      Value<int> updatedAtUtcMillis,
      Value<int> rowid,
    });

class $$TaskCheckItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCheckItemsTable> {
  $$TaskCheckItemsTableFilterComposer({
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

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskCheckItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCheckItemsTable> {
  $$TaskCheckItemsTableOrderingComposer({
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

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskCheckItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCheckItemsTable> {
  $$TaskCheckItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$TaskCheckItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCheckItemsTable,
          TaskCheckItemRow,
          $$TaskCheckItemsTableFilterComposer,
          $$TaskCheckItemsTableOrderingComposer,
          $$TaskCheckItemsTableAnnotationComposer,
          $$TaskCheckItemsTableCreateCompanionBuilder,
          $$TaskCheckItemsTableUpdateCompanionBuilder,
          (
            TaskCheckItemRow,
            BaseReferences<
              _$AppDatabase,
              $TaskCheckItemsTable,
              TaskCheckItemRow
            >,
          ),
          TaskCheckItemRow,
          PrefetchHooks Function()
        > {
  $$TaskCheckItemsTableTableManager(
    _$AppDatabase db,
    $TaskCheckItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCheckItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCheckItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCheckItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> createdAtUtcMillis = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCheckItemsCompanion(
                id: id,
                taskId: taskId,
                title: title,
                isDone: isDone,
                orderIndex: orderIndex,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String title,
                Value<bool> isDone = const Value.absent(),
                required int orderIndex,
                required int createdAtUtcMillis,
                required int updatedAtUtcMillis,
                Value<int> rowid = const Value.absent(),
              }) => TaskCheckItemsCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                isDone: isDone,
                orderIndex: orderIndex,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskCheckItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCheckItemsTable,
      TaskCheckItemRow,
      $$TaskCheckItemsTableFilterComposer,
      $$TaskCheckItemsTableOrderingComposer,
      $$TaskCheckItemsTableAnnotationComposer,
      $$TaskCheckItemsTableCreateCompanionBuilder,
      $$TaskCheckItemsTableUpdateCompanionBuilder,
      (
        TaskCheckItemRow,
        BaseReferences<_$AppDatabase, $TaskCheckItemsTable, TaskCheckItemRow>,
      ),
      TaskCheckItemRow,
      PrefetchHooks Function()
    >;
typedef $$ActivePomodorosTableCreateCompanionBuilder =
    ActivePomodorosCompanion Function({
      Value<int> id,
      required String taskId,
      Value<int> phase,
      required int status,
      required int startAtUtcMillis,
      Value<int?> endAtUtcMillis,
      Value<int?> remainingMs,
      required int updatedAtUtcMillis,
    });
typedef $$ActivePomodorosTableUpdateCompanionBuilder =
    ActivePomodorosCompanion Function({
      Value<int> id,
      Value<String> taskId,
      Value<int> phase,
      Value<int> status,
      Value<int> startAtUtcMillis,
      Value<int?> endAtUtcMillis,
      Value<int?> remainingMs,
      Value<int> updatedAtUtcMillis,
    });

class $$ActivePomodorosTableFilterComposer
    extends Composer<_$AppDatabase, $ActivePomodorosTable> {
  $$ActivePomodorosTableFilterComposer({
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

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startAtUtcMillis => $composableBuilder(
    column: $table.startAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endAtUtcMillis => $composableBuilder(
    column: $table.endAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingMs => $composableBuilder(
    column: $table.remainingMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivePomodorosTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivePomodorosTable> {
  $$ActivePomodorosTableOrderingComposer({
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

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startAtUtcMillis => $composableBuilder(
    column: $table.startAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endAtUtcMillis => $composableBuilder(
    column: $table.endAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingMs => $composableBuilder(
    column: $table.remainingMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivePomodorosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivePomodorosTable> {
  $$ActivePomodorosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get startAtUtcMillis => $composableBuilder(
    column: $table.startAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endAtUtcMillis => $composableBuilder(
    column: $table.endAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingMs => $composableBuilder(
    column: $table.remainingMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$ActivePomodorosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivePomodorosTable,
          ActivePomodoroRow,
          $$ActivePomodorosTableFilterComposer,
          $$ActivePomodorosTableOrderingComposer,
          $$ActivePomodorosTableAnnotationComposer,
          $$ActivePomodorosTableCreateCompanionBuilder,
          $$ActivePomodorosTableUpdateCompanionBuilder,
          (
            ActivePomodoroRow,
            BaseReferences<
              _$AppDatabase,
              $ActivePomodorosTable,
              ActivePomodoroRow
            >,
          ),
          ActivePomodoroRow,
          PrefetchHooks Function()
        > {
  $$ActivePomodorosTableTableManager(
    _$AppDatabase db,
    $ActivePomodorosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivePomodorosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivePomodorosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivePomodorosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> phase = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> startAtUtcMillis = const Value.absent(),
                Value<int?> endAtUtcMillis = const Value.absent(),
                Value<int?> remainingMs = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
              }) => ActivePomodorosCompanion(
                id: id,
                taskId: taskId,
                phase: phase,
                status: status,
                startAtUtcMillis: startAtUtcMillis,
                endAtUtcMillis: endAtUtcMillis,
                remainingMs: remainingMs,
                updatedAtUtcMillis: updatedAtUtcMillis,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taskId,
                Value<int> phase = const Value.absent(),
                required int status,
                required int startAtUtcMillis,
                Value<int?> endAtUtcMillis = const Value.absent(),
                Value<int?> remainingMs = const Value.absent(),
                required int updatedAtUtcMillis,
              }) => ActivePomodorosCompanion.insert(
                id: id,
                taskId: taskId,
                phase: phase,
                status: status,
                startAtUtcMillis: startAtUtcMillis,
                endAtUtcMillis: endAtUtcMillis,
                remainingMs: remainingMs,
                updatedAtUtcMillis: updatedAtUtcMillis,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivePomodorosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivePomodorosTable,
      ActivePomodoroRow,
      $$ActivePomodorosTableFilterComposer,
      $$ActivePomodorosTableOrderingComposer,
      $$ActivePomodorosTableAnnotationComposer,
      $$ActivePomodorosTableCreateCompanionBuilder,
      $$ActivePomodorosTableUpdateCompanionBuilder,
      (
        ActivePomodoroRow,
        BaseReferences<_$AppDatabase, $ActivePomodorosTable, ActivePomodoroRow>,
      ),
      ActivePomodoroRow,
      PrefetchHooks Function()
    >;
typedef $$PomodoroSessionsTableCreateCompanionBuilder =
    PomodoroSessionsCompanion Function({
      required String id,
      required String taskId,
      required int startAtUtcMillis,
      required int endAtUtcMillis,
      Value<bool> isDraft,
      Value<String?> progressNote,
      required int createdAtUtcMillis,
      Value<int> rowid,
    });
typedef $$PomodoroSessionsTableUpdateCompanionBuilder =
    PomodoroSessionsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<int> startAtUtcMillis,
      Value<int> endAtUtcMillis,
      Value<bool> isDraft,
      Value<String?> progressNote,
      Value<int> createdAtUtcMillis,
      Value<int> rowid,
    });

class $$PomodoroSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroSessionsTable> {
  $$PomodoroSessionsTableFilterComposer({
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

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startAtUtcMillis => $composableBuilder(
    column: $table.startAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endAtUtcMillis => $composableBuilder(
    column: $table.endAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get progressNote => $composableBuilder(
    column: $table.progressNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroSessionsTable> {
  $$PomodoroSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startAtUtcMillis => $composableBuilder(
    column: $table.startAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endAtUtcMillis => $composableBuilder(
    column: $table.endAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progressNote => $composableBuilder(
    column: $table.progressNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroSessionsTable> {
  $$PomodoroSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get startAtUtcMillis => $composableBuilder(
    column: $table.startAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endAtUtcMillis => $composableBuilder(
    column: $table.endAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<String> get progressNote => $composableBuilder(
    column: $table.progressNote,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => column,
  );
}

class $$PomodoroSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroSessionsTable,
          PomodoroSessionRow,
          $$PomodoroSessionsTableFilterComposer,
          $$PomodoroSessionsTableOrderingComposer,
          $$PomodoroSessionsTableAnnotationComposer,
          $$PomodoroSessionsTableCreateCompanionBuilder,
          $$PomodoroSessionsTableUpdateCompanionBuilder,
          (
            PomodoroSessionRow,
            BaseReferences<
              _$AppDatabase,
              $PomodoroSessionsTable,
              PomodoroSessionRow
            >,
          ),
          PomodoroSessionRow,
          PrefetchHooks Function()
        > {
  $$PomodoroSessionsTableTableManager(
    _$AppDatabase db,
    $PomodoroSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PomodoroSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> startAtUtcMillis = const Value.absent(),
                Value<int> endAtUtcMillis = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<String?> progressNote = const Value.absent(),
                Value<int> createdAtUtcMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PomodoroSessionsCompanion(
                id: id,
                taskId: taskId,
                startAtUtcMillis: startAtUtcMillis,
                endAtUtcMillis: endAtUtcMillis,
                isDraft: isDraft,
                progressNote: progressNote,
                createdAtUtcMillis: createdAtUtcMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required int startAtUtcMillis,
                required int endAtUtcMillis,
                Value<bool> isDraft = const Value.absent(),
                Value<String?> progressNote = const Value.absent(),
                required int createdAtUtcMillis,
                Value<int> rowid = const Value.absent(),
              }) => PomodoroSessionsCompanion.insert(
                id: id,
                taskId: taskId,
                startAtUtcMillis: startAtUtcMillis,
                endAtUtcMillis: endAtUtcMillis,
                isDraft: isDraft,
                progressNote: progressNote,
                createdAtUtcMillis: createdAtUtcMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroSessionsTable,
      PomodoroSessionRow,
      $$PomodoroSessionsTableFilterComposer,
      $$PomodoroSessionsTableOrderingComposer,
      $$PomodoroSessionsTableAnnotationComposer,
      $$PomodoroSessionsTableCreateCompanionBuilder,
      $$PomodoroSessionsTableUpdateCompanionBuilder,
      (
        PomodoroSessionRow,
        BaseReferences<
          _$AppDatabase,
          $PomodoroSessionsTable,
          PomodoroSessionRow
        >,
      ),
      PomodoroSessionRow,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String title,
      Value<String> body,
      Value<String> tagsJson,
      Value<String?> taskId,
      required int createdAtUtcMillis,
      required int updatedAtUtcMillis,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> body,
      Value<String> tagsJson,
      Value<String?> taskId,
      Value<int> createdAtUtcMillis,
      Value<int> updatedAtUtcMillis,
      Value<int> rowid,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          NoteRow,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (NoteRow, BaseReferences<_$AppDatabase, $NotesTable, NoteRow>),
          NoteRow,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> createdAtUtcMillis = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                title: title,
                body: body,
                tagsJson: tagsJson,
                taskId: taskId,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> body = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                required int createdAtUtcMillis,
                required int updatedAtUtcMillis,
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                title: title,
                body: body,
                tagsJson: tagsJson,
                taskId: taskId,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      NoteRow,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (NoteRow, BaseReferences<_$AppDatabase, $NotesTable, NoteRow>),
      NoteRow,
      PrefetchHooks Function()
    >;
typedef $$PomodoroConfigsTableCreateCompanionBuilder =
    PomodoroConfigsCompanion Function({
      Value<int> id,
      Value<int> workDurationMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> longBreakEvery,
      Value<bool> autoStartBreak,
      Value<bool> autoStartFocus,
      Value<bool> notificationSound,
      Value<bool> notificationVibration,
      required int updatedAtUtcMillis,
    });
typedef $$PomodoroConfigsTableUpdateCompanionBuilder =
    PomodoroConfigsCompanion Function({
      Value<int> id,
      Value<int> workDurationMinutes,
      Value<int> shortBreakMinutes,
      Value<int> longBreakMinutes,
      Value<int> longBreakEvery,
      Value<bool> autoStartBreak,
      Value<bool> autoStartFocus,
      Value<bool> notificationSound,
      Value<bool> notificationVibration,
      Value<int> updatedAtUtcMillis,
    });

class $$PomodoroConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroConfigsTable> {
  $$PomodoroConfigsTableFilterComposer({
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

  ColumnFilters<int> get workDurationMinutes => $composableBuilder(
    column: $table.workDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakEvery => $composableBuilder(
    column: $table.longBreakEvery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartBreak => $composableBuilder(
    column: $table.autoStartBreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationSound => $composableBuilder(
    column: $table.notificationSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationVibration => $composableBuilder(
    column: $table.notificationVibration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroConfigsTable> {
  $$PomodoroConfigsTableOrderingComposer({
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

  ColumnOrderings<int> get workDurationMinutes => $composableBuilder(
    column: $table.workDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakEvery => $composableBuilder(
    column: $table.longBreakEvery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartBreak => $composableBuilder(
    column: $table.autoStartBreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationSound => $composableBuilder(
    column: $table.notificationSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationVibration => $composableBuilder(
    column: $table.notificationVibration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroConfigsTable> {
  $$PomodoroConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workDurationMinutes => $composableBuilder(
    column: $table.workDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakMinutes => $composableBuilder(
    column: $table.shortBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakMinutes => $composableBuilder(
    column: $table.longBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakEvery => $composableBuilder(
    column: $table.longBreakEvery,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartBreak => $composableBuilder(
    column: $table.autoStartBreak,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartFocus => $composableBuilder(
    column: $table.autoStartFocus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationSound => $composableBuilder(
    column: $table.notificationSound,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationVibration => $composableBuilder(
    column: $table.notificationVibration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$PomodoroConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroConfigsTable,
          PomodoroConfigRow,
          $$PomodoroConfigsTableFilterComposer,
          $$PomodoroConfigsTableOrderingComposer,
          $$PomodoroConfigsTableAnnotationComposer,
          $$PomodoroConfigsTableCreateCompanionBuilder,
          $$PomodoroConfigsTableUpdateCompanionBuilder,
          (
            PomodoroConfigRow,
            BaseReferences<
              _$AppDatabase,
              $PomodoroConfigsTable,
              PomodoroConfigRow
            >,
          ),
          PomodoroConfigRow,
          PrefetchHooks Function()
        > {
  $$PomodoroConfigsTableTableManager(
    _$AppDatabase db,
    $PomodoroConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PomodoroConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workDurationMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> longBreakEvery = const Value.absent(),
                Value<bool> autoStartBreak = const Value.absent(),
                Value<bool> autoStartFocus = const Value.absent(),
                Value<bool> notificationSound = const Value.absent(),
                Value<bool> notificationVibration = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
              }) => PomodoroConfigsCompanion(
                id: id,
                workDurationMinutes: workDurationMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                longBreakEvery: longBreakEvery,
                autoStartBreak: autoStartBreak,
                autoStartFocus: autoStartFocus,
                notificationSound: notificationSound,
                notificationVibration: notificationVibration,
                updatedAtUtcMillis: updatedAtUtcMillis,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workDurationMinutes = const Value.absent(),
                Value<int> shortBreakMinutes = const Value.absent(),
                Value<int> longBreakMinutes = const Value.absent(),
                Value<int> longBreakEvery = const Value.absent(),
                Value<bool> autoStartBreak = const Value.absent(),
                Value<bool> autoStartFocus = const Value.absent(),
                Value<bool> notificationSound = const Value.absent(),
                Value<bool> notificationVibration = const Value.absent(),
                required int updatedAtUtcMillis,
              }) => PomodoroConfigsCompanion.insert(
                id: id,
                workDurationMinutes: workDurationMinutes,
                shortBreakMinutes: shortBreakMinutes,
                longBreakMinutes: longBreakMinutes,
                longBreakEvery: longBreakEvery,
                autoStartBreak: autoStartBreak,
                autoStartFocus: autoStartFocus,
                notificationSound: notificationSound,
                notificationVibration: notificationVibration,
                updatedAtUtcMillis: updatedAtUtcMillis,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroConfigsTable,
      PomodoroConfigRow,
      $$PomodoroConfigsTableFilterComposer,
      $$PomodoroConfigsTableOrderingComposer,
      $$PomodoroConfigsTableAnnotationComposer,
      $$PomodoroConfigsTableCreateCompanionBuilder,
      $$PomodoroConfigsTableUpdateCompanionBuilder,
      (
        PomodoroConfigRow,
        BaseReferences<_$AppDatabase, $PomodoroConfigsTable, PomodoroConfigRow>,
      ),
      PomodoroConfigRow,
      PrefetchHooks Function()
    >;
typedef $$AppearanceConfigsTableCreateCompanionBuilder =
    AppearanceConfigsCompanion Function({
      Value<int> id,
      Value<int> themeMode,
      Value<int> density,
      Value<int> accent,
      required int updatedAtUtcMillis,
    });
typedef $$AppearanceConfigsTableUpdateCompanionBuilder =
    AppearanceConfigsCompanion Function({
      Value<int> id,
      Value<int> themeMode,
      Value<int> density,
      Value<int> accent,
      Value<int> updatedAtUtcMillis,
    });

class $$AppearanceConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $AppearanceConfigsTable> {
  $$AppearanceConfigsTableFilterComposer({
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

  ColumnFilters<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get density => $composableBuilder(
    column: $table.density,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppearanceConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppearanceConfigsTable> {
  $$AppearanceConfigsTableOrderingComposer({
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

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get density => $composableBuilder(
    column: $table.density,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppearanceConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppearanceConfigsTable> {
  $$AppearanceConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get density =>
      $composableBuilder(column: $table.density, builder: (column) => column);

  GeneratedColumn<int> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$AppearanceConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppearanceConfigsTable,
          AppearanceConfigRow,
          $$AppearanceConfigsTableFilterComposer,
          $$AppearanceConfigsTableOrderingComposer,
          $$AppearanceConfigsTableAnnotationComposer,
          $$AppearanceConfigsTableCreateCompanionBuilder,
          $$AppearanceConfigsTableUpdateCompanionBuilder,
          (
            AppearanceConfigRow,
            BaseReferences<
              _$AppDatabase,
              $AppearanceConfigsTable,
              AppearanceConfigRow
            >,
          ),
          AppearanceConfigRow,
          PrefetchHooks Function()
        > {
  $$AppearanceConfigsTableTableManager(
    _$AppDatabase db,
    $AppearanceConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppearanceConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppearanceConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppearanceConfigsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
                Value<int> density = const Value.absent(),
                Value<int> accent = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
              }) => AppearanceConfigsCompanion(
                id: id,
                themeMode: themeMode,
                density: density,
                accent: accent,
                updatedAtUtcMillis: updatedAtUtcMillis,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> themeMode = const Value.absent(),
                Value<int> density = const Value.absent(),
                Value<int> accent = const Value.absent(),
                required int updatedAtUtcMillis,
              }) => AppearanceConfigsCompanion.insert(
                id: id,
                themeMode: themeMode,
                density: density,
                accent: accent,
                updatedAtUtcMillis: updatedAtUtcMillis,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppearanceConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppearanceConfigsTable,
      AppearanceConfigRow,
      $$AppearanceConfigsTableFilterComposer,
      $$AppearanceConfigsTableOrderingComposer,
      $$AppearanceConfigsTableAnnotationComposer,
      $$AppearanceConfigsTableCreateCompanionBuilder,
      $$AppearanceConfigsTableUpdateCompanionBuilder,
      (
        AppearanceConfigRow,
        BaseReferences<
          _$AppDatabase,
          $AppearanceConfigsTable,
          AppearanceConfigRow
        >,
      ),
      AppearanceConfigRow,
      PrefetchHooks Function()
    >;
typedef $$TodayPlanItemsTableCreateCompanionBuilder =
    TodayPlanItemsCompanion Function({
      required String dayKey,
      required String taskId,
      required int orderIndex,
      required int createdAtUtcMillis,
      required int updatedAtUtcMillis,
      Value<int> rowid,
    });
typedef $$TodayPlanItemsTableUpdateCompanionBuilder =
    TodayPlanItemsCompanion Function({
      Value<String> dayKey,
      Value<String> taskId,
      Value<int> orderIndex,
      Value<int> createdAtUtcMillis,
      Value<int> updatedAtUtcMillis,
      Value<int> rowid,
    });

class $$TodayPlanItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TodayPlanItemsTable> {
  $$TodayPlanItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodayPlanItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TodayPlanItemsTable> {
  $$TodayPlanItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodayPlanItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodayPlanItemsTable> {
  $$TodayPlanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMillis => $composableBuilder(
    column: $table.createdAtUtcMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMillis => $composableBuilder(
    column: $table.updatedAtUtcMillis,
    builder: (column) => column,
  );
}

class $$TodayPlanItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodayPlanItemsTable,
          TodayPlanItemRow,
          $$TodayPlanItemsTableFilterComposer,
          $$TodayPlanItemsTableOrderingComposer,
          $$TodayPlanItemsTableAnnotationComposer,
          $$TodayPlanItemsTableCreateCompanionBuilder,
          $$TodayPlanItemsTableUpdateCompanionBuilder,
          (
            TodayPlanItemRow,
            BaseReferences<
              _$AppDatabase,
              $TodayPlanItemsTable,
              TodayPlanItemRow
            >,
          ),
          TodayPlanItemRow,
          PrefetchHooks Function()
        > {
  $$TodayPlanItemsTableTableManager(
    _$AppDatabase db,
    $TodayPlanItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodayPlanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodayPlanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodayPlanItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dayKey = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> createdAtUtcMillis = const Value.absent(),
                Value<int> updatedAtUtcMillis = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodayPlanItemsCompanion(
                dayKey: dayKey,
                taskId: taskId,
                orderIndex: orderIndex,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dayKey,
                required String taskId,
                required int orderIndex,
                required int createdAtUtcMillis,
                required int updatedAtUtcMillis,
                Value<int> rowid = const Value.absent(),
              }) => TodayPlanItemsCompanion.insert(
                dayKey: dayKey,
                taskId: taskId,
                orderIndex: orderIndex,
                createdAtUtcMillis: createdAtUtcMillis,
                updatedAtUtcMillis: updatedAtUtcMillis,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodayPlanItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodayPlanItemsTable,
      TodayPlanItemRow,
      $$TodayPlanItemsTableFilterComposer,
      $$TodayPlanItemsTableOrderingComposer,
      $$TodayPlanItemsTableAnnotationComposer,
      $$TodayPlanItemsTableCreateCompanionBuilder,
      $$TodayPlanItemsTableUpdateCompanionBuilder,
      (
        TodayPlanItemRow,
        BaseReferences<_$AppDatabase, $TodayPlanItemsTable, TodayPlanItemRow>,
      ),
      TodayPlanItemRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TaskCheckItemsTableTableManager get taskCheckItems =>
      $$TaskCheckItemsTableTableManager(_db, _db.taskCheckItems);
  $$ActivePomodorosTableTableManager get activePomodoros =>
      $$ActivePomodorosTableTableManager(_db, _db.activePomodoros);
  $$PomodoroSessionsTableTableManager get pomodoroSessions =>
      $$PomodoroSessionsTableTableManager(_db, _db.pomodoroSessions);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$PomodoroConfigsTableTableManager get pomodoroConfigs =>
      $$PomodoroConfigsTableTableManager(_db, _db.pomodoroConfigs);
  $$AppearanceConfigsTableTableManager get appearanceConfigs =>
      $$AppearanceConfigsTableTableManager(_db, _db.appearanceConfigs);
  $$TodayPlanItemsTableTableManager get todayPlanItems =>
      $$TodayPlanItemsTableTableManager(_db, _db.todayPlanItems);
}
