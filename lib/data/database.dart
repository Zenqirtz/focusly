import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Task {
  final int? id;
  final String title;
  final String category;
  final double priority;
  final int createdAt;
  final int repeat;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.createdAt,
    this.repeat = 1,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'priority': priority,
    'created_at': createdAt,
    'repeat_count': repeat,
  };

  static Task fromMap(Map<String, Object?> map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    category: map['category'] as String,
    priority: (map['priority'] as num).toDouble(),
    createdAt: map['created_at'] as int,
    repeat: ((map['repeat_count'] as num?) ?? 1).toInt(),
  );
}

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    return await openDatabase(
      'focusly.db',
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            priority REAL NOT NULL,
            created_at INTEGER NOT NULL,
            repeat_count INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            nickname TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_title TEXT,
            category TEXT,
            duration_minutes INTEGER,
            breaks_count INTEGER DEFAULT 0,
            reward_points INTEGER DEFAULT 0,
            started_at INTEGER,
            microritual_started_at INTEGER,
            pomodoro_started_at INTEGER,
            break_started_at INTEGER,
            ended_at INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE task_subtasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_id INTEGER NOT NULL,
            title TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE session_subtasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            done INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users(
              id INTEGER PRIMARY KEY,
              name TEXT,
              nickname TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sessions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task_title TEXT,
              category TEXT,
              duration_minutes INTEGER,
              breaks_count INTEGER DEFAULT 0,
              reward_points INTEGER DEFAULT 0,
              started_at INTEGER,
              microritual_started_at INTEGER,
              pomodoro_started_at INTEGER,
              break_started_at INTEGER,
              ended_at INTEGER
            )
          ''');
        }
        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS task_subtasks(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task_id INTEGER NOT NULL,
              title TEXT NOT NULL
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS session_subtasks(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              session_id INTEGER NOT NULL,
              title TEXT NOT NULL,
              done INTEGER NOT NULL DEFAULT 0
            )
          ''');
        }
        if (oldVersion < 4) {
          try {
            await db.execute(
              'ALTER TABLE tasks ADD COLUMN repeat_count INTEGER NOT NULL DEFAULT 1',
            );
          } catch (_) {}
        }
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final d = await db;
    return d.insert('tasks', task.toMap());
  }

  Future<List<Task>> listTasks() async {
    final d = await db;
    final rows = await d.query('tasks', orderBy: 'created_at DESC');
    return rows.map(Task.fromMap).toList();
  }

  Future<int> deleteTask(int id) async {
    final d = await db;
    return d.delete('tasks', where: 'id=?', whereArgs: [id]);
  }

  Future<void> upsertUser(String name, String nickname) async {
    final d = await db;
    final existing = await d.query('users', limit: 1);
    if (existing.isEmpty) {
      await d.insert('users', {'id': 1, 'name': name, 'nickname': nickname});
    } else {
      await d.update(
        'users',
        {'name': name, 'nickname': nickname},
        where: 'id=?',
        whereArgs: [1],
      );
    }
  }

  Future<Map<String, Object?>?> getUser() async {
    final d = await db;
    final rows = await d.query('users', limit: 1);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<int> createSession({
    required String title,
    required String category,
    required int durationMinutes,
  }) async {
    final d = await db;
    return d.insert('sessions', {
      'task_title': title,
      'category': category,
      'duration_minutes': durationMinutes,
      'started_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> markMicroritualStart(int sessionId) async {
    final d = await db;
    await d.update(
      'sessions',
      {'microritual_started_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id=?',
      whereArgs: [sessionId],
    );
  }

  Future<void> markPomodoroStart(int sessionId) async {
    final d = await db;
    await d.update(
      'sessions',
      {'pomodoro_started_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id=?',
      whereArgs: [sessionId],
    );
  }

  Future<void> incrementBreak(int sessionId) async {
    final d = await db;
    final rows = await d.query(
      'sessions',
      columns: ['breaks_count'],
      where: 'id=?',
      whereArgs: [sessionId],
      limit: 1,
    );
    final current = rows.isEmpty
        ? 0
        : (rows.first['breaks_count'] as int? ?? 0);
    await d.update(
      'sessions',
      {
        'breaks_count': current + 1,
        'break_started_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id=?',
      whereArgs: [sessionId],
    );
  }

  Future<void> finishSession(int sessionId, {required int rewardPoints}) async {
    final d = await db;
    await d.update(
      'sessions',
      {
        'ended_at': DateTime.now().millisecondsSinceEpoch,
        'reward_points': rewardPoints,
      },
      where: 'id=?',
      whereArgs: [sessionId],
    );
  }

  Future<int> tasksCount() async {
    final d = await db;
    final result = await d.rawQuery('SELECT COUNT(*) AS c FROM tasks');
    return (result.first['c'] as int?) ?? 0;
  }

  Future<int> totalMinutes() async {
    final d = await db;
    final result = await d.rawQuery(
      'SELECT SUM(duration_minutes) AS m FROM sessions',
    );
    final num? minutes = result.first['m'] as num?;
    return (minutes ?? 0).toInt();
  }

  Future<int> completedSessionsCount() async {
    final d = await db;
    final result = await d.rawQuery(
      'SELECT COUNT(*) AS c FROM sessions WHERE ended_at IS NOT NULL',
    );
    return (result.first['c'] as int? ?? 0);
  }

  Future<int> totalEnergyPoints() async {
    final d = await db;
    final result = await d.rawQuery(
      'SELECT SUM(reward_points) AS e FROM sessions',
    );
    final num? e = result.first['e'] as num?;
    return (e ?? 0).toInt();
  }

  Future<Map<String, Object?>?> getSession(int id) async {
    final d = await db;
    final rows = await d.query(
      'sessions',
      where: 'id=?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<Map<String, Object?>?> latestSessionByTitle(String title) async {
    final d = await db;
    final rows = await d.query(
      'sessions',
      where: 'task_title=?',
      whereArgs: [title],
      orderBy: 'started_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<void> insertTaskSubtasks(int taskId, List<String> titles) async {
    if (titles.isEmpty) return;
    final d = await db;
    final batch = d.batch();
    for (final t in titles) {
      if (t.trim().isEmpty) continue;
      batch.insert('task_subtasks', {'task_id': taskId, 'title': t.trim()});
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, Object?>>> listTaskSubtasks(int taskId) async {
    final d = await db;
    return d.query('task_subtasks', where: 'task_id=?', whereArgs: [taskId]);
  }

  Future<void> insertSessionSubtasks(int sessionId, List<String> titles) async {
    if (titles.isEmpty) return;
    final d = await db;
    await d.execute('''
      CREATE TABLE IF NOT EXISTS session_subtasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
      )
    ''');
    final batch = d.batch();
    for (final t in titles) {
      if (t.trim().isEmpty) continue;
      batch.insert('session_subtasks', {
        'session_id': sessionId,
        'title': t.trim(),
        'done': 0,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, Object?>>> listSessionSubtasks(int sessionId) async {
    final d = await db;
    return d.query(
      'session_subtasks',
      where: 'session_id=?',
      whereArgs: [sessionId],
    );
  }

  Future<void> setSessionSubtaskDone(int subtaskId, bool done) async {
    final d = await db;
    await d.execute('''
      CREATE TABLE IF NOT EXISTS session_subtasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        done INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await d.update(
      'session_subtasks',
      {'done': done ? 1 : 0},
      where: 'id=?',
      whereArgs: [subtaskId],
    );
  }
}
