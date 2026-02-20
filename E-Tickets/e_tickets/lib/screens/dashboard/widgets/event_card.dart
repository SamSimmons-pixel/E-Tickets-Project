import 'package:flutter/material.dart';
import '../../../models/ticket.dart';

class EventCard extends StatelessWidget {
  final Ticket ticket;
  const EventCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Event Image
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Image.network(
              ticket.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.event,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          // Event Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Title
                Text(
                  ticket.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Event Date & Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${ticket.date}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Event Location
                // Row(
                //   children: [
                //     const Icon(Icons.location_on, size: 16),
                //     const SizedBox(width: 4),
                //     Text(
                //       ticket.location,
                //       style: TextStyle(color: Colors.grey[600]),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 16),

                // Buy Tickets Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to ticket purchase screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Rp ${ticket.price}'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Buy Tickets'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
