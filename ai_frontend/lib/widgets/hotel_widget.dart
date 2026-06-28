import 'package:flutter/material.dart';
import '../models/models.dart';

class HotelWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const HotelWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final hotels = (data['hotels'] as List?)
        ?.map((h) => Hotel.fromJson(h as Map<String, dynamic>))
        .toList() ?? [];
    if (hotels.isEmpty) return const Center(child: Text('No hotels found'));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.hotel, size: 48, color: Colors.blue.shade700),
                ),
                const SizedBox(height: 12),
                Text(hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(hotel.location, style: TextStyle(color: Colors.grey.shade600)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(hotel.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Text('(${hotel.reviews} reviews)', style: TextStyle(color: Colors.grey.shade600)),
                ]),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: hotel.amenities.take(4).map((a) =>
                    Chip(label: Text(a, style: const TextStyle(fontSize: 10)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)
                  ).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${hotel.pricePerNight.toStringAsFixed(0)}/night',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      '${hotel.availableRooms} rooms left',
                      style: TextStyle(
                        color: hotel.availableRooms < 5 ? Colors.red : Colors.grey.shade600,
                        fontWeight: hotel.availableRooms < 5 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}