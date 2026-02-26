import 'package:e_tickets/models/ticket.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'tickets.db';
  static const int _databaseVersion = 3;
  static final DatabaseHelper instance = DatabaseHelper._Init();

  static Database? _database;
  DatabaseHelper._Init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String dbpath = await getDatabasesPath();
    final path = join(dbpath, 'tickets.db');

    return await openDatabase(
      path,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      version: _databaseVersion,
    );
  }

  _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Drop and recreate tables on upgrade
      await db.execute('DROP TABLE IF EXISTS $tableBookings');
      await db.execute('DROP TABLE IF EXISTS $tableTickets');
      await _createDB(db, newVersion);
    }
  }

  // Future<void> insertTicket(Ticket ticket) async {
  //   final db = await database;
  //   await db.insert('tickets', ticket.toMap());
  // }

  Future<List<Ticket>> getTickets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tickets');
    return List.generate(maps.length, (i) {
      return Ticket(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        date: maps[i]['date'],
        imageUrl: maps[i]['imageUrl'],
        userId: maps[i]['userId'],
      );
    });
  }

  static const String tableBookings = 'bookings';
  static const String tableTickets = 'tickets';

  _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableBookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ticketId INTEGER NOT NULL,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        price INTEGER NOT NULL,
        date TEXT NOT NULL,
        imageUrl TEXT,
        bookingDate TEXT,
        status TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableTickets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        date TEXT NOT NULL,
        imageUrl TEXT,
        userId INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Future<void> deleteTicket(int id) async {
  //   final db = await database;
  //   await db.delete('tickets', where: 'id = ?', whereArgs: [id]);
  // }

  // Future<void> deleteBooking(int id) async {
  //   final db = await database;
  //   await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  // }

  // Future<void> insertBooking(Booking booking) async {
  //   final db = await database;
  //   await db.insert('bookings', booking.toMap());
  // }

  // Future<List<Booking>> getBookings() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query('bookings');
  //   return List.generate(maps.length, (i) {
  //     return Booking(
  //       id: maps[i]['id'],
  //       ticketId: maps[i]['ticketId'],
  //       userId: maps[i]['userId'],
  //       title: maps[i]['title'],
  //       description: maps[i]['description'],
  //       price: maps[i]['price'],
  //       date: maps[i]['date'],
  //       imageUrl: maps[i]['imageUrl'],
  //       bookingDate: maps[i]['bookingDate'],
  //       status: maps[i]['status'],
  //     );
  //   });
  // }
}
