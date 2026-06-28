import 'package:flutter/material.dart';
import '../models/models.dart';

class TrackingWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const TrackingWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tracking = OrderTracking.fromJson(data);
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.local_shipping, color: Colors.blue.shade700, size: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Order Tracking', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)), Text(tracking.trackingId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))])),
      ]),
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 16),
      Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade200)), child: Row(children: [Icon(Icons.check_circle, color: Colors.green.shade700), const SizedBox(width: 8), Text(tracking.status.toUpperCase(), style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold))])),
      const SizedBox(height: 16),
      _detailRow('Order Date', tracking.orderDate),
      _detailRow('Estimated Delivery', tracking.estimatedDelivery),
      _detailRow('Current Location', tracking.currentLocation),
      const SizedBox(height: 16),
      const Divider(),
      const SizedBox(height: 8),
      const Text('Tracking History', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      ...[{'date': '2024-06-08 10:30', 'status': 'Order Placed', 'location': 'Online'}, {'date': '2024-06-09 14:20', 'status': 'Shipped', 'location': 'Warehouse, CA'}, {'date': '2024-06-10 09:15', 'status': 'In Transit', 'location': 'Distribution Center'}].map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Icon(Icons.circle, size: 10, color: Colors.green.shade400), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e['status']!, style: const TextStyle(fontWeight: FontWeight.w500)), Text('${e['date']} - ${e['location']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))]))])))
    ])));
  }

  Widget _detailRow(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(color: Colors.grey.shade600)), Text(value, style: const TextStyle(fontWeight: FontWeight.w500))]));
}