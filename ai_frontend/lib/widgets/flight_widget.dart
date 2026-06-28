import 'package:flutter/material.dart';
import '../models/models.dart';

class FlightWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const FlightWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final flights = (data['flights'] as List?)
        ?.map((f) => Flight.fromJson(f as Map<String, dynamic>))
        .toList() ?? [];
    if (flights.isEmpty) return const Center(child: Text('No flights found'));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final flight = flights[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.flight, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(flight.flightNumber, style: TextStyle(color: Colors.grey.shade600)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('\$${flight.price.toStringAsFixed(0)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  Text(flight.flightClass, style: TextStyle(color: Colors.grey.shade600)),
                ]),
              ]),
              const Divider(height: 24),
              Row(children: [
                Expanded(child: Column(children: [
                  Text(flight.departureTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(flight.origin, style: TextStyle(color: Colors.grey.shade600)),
                ])),
                Expanded(child: Column(children: [
                  Icon(Icons.arrow_forward, color: Colors.grey.shade400),
                  Text(flight.duration, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text(flight.stops == 0 ? "Non-stop" : "${flight.stops} stop(s)", style: TextStyle(fontSize: 12, color: flight.stops == 0 ? Colors.green : Colors.orange)),
                ])),
                Expanded(child: Column(children: [
                  Text(flight.arrivalTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(flight.destination, style: TextStyle(color: Colors.grey.shade600)),
                ])),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('${flight.availableSeats} seats left', style: TextStyle(
                  color: flight.availableSeats < 10 ? Colors.red : Colors.grey.shade600,
                  fontWeight: flight.availableSeats < 10 ? FontWeight.bold : FontWeight.normal,
                )),
              ]),
            ]),
          ),
        );
      },
    );
  }
}