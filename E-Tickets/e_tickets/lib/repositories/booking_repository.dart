import 'package:e_tickets/models/booking.dart';
import 'package:e_tickets/repositories/database_helper.dart';

class BookingRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertBooking(Booking booking) async {
    final db = await _dbHelper.database;
    await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getBookings() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('bookings');
    return List.generate(maps.length, (i) {
      return Booking(
        id: maps[i]['id'],
        ticketId: maps[i]['ticketId'],
        userId: maps[i]['userId'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        price: maps[i]['price'],
        date: maps[i]['date'],
        imageUrl: maps[i]['imageUrl'],
        bookingDate: maps[i]['bookingDate'],
        status: maps[i]['status'],
      );
    });
  }

  Future<void> deleteBooking(int id) async {
    final db = await _dbHelper.database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }
}
