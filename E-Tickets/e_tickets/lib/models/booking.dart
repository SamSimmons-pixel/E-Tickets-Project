class Booking {
  final int id;
  final int ticketId;
  final int userId;
  final String title;
  final String description;
  final int price;
  final String date;
  final String imageUrl;
  final String bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.date,
    required this.imageUrl,
    required this.bookingDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketId': ticketId,
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'date': date,
      'imageUrl': imageUrl,
      'bookingDate': bookingDate,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      ticketId: map['ticketId'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      date: map['date'],
      imageUrl: map['imageUrl'],
      bookingDate: map['bookingDate'],
      status: map['status'],
    );
  }
}