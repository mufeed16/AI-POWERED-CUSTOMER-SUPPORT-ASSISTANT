class Message {
  final String role;
  final String content;
  final String? uiType;
  final Map<String, dynamic>? data;
  Message({required this.role, required this.content, this.uiType, this.data});
  factory Message.fromJson(Map<String, dynamic> json) => Message(role: json['role'] ?? 'user', content: json['content'] ?? '', uiType: json['ui_type'], data: json['data']);
  Map<String, dynamic> toJson() => {'role': role, 'content': content, if (uiType != null) 'ui_type': uiType, if (data != null) 'data': data};
}

class ChatRequest {
  final String message;
  final List<Message> conversationHistory;
  ChatRequest({required this.message, required this.conversationHistory});
  Map<String, dynamic> toJson() => {'message': message, 'conversation_history': conversationHistory.map((m) => m.toJson()).toList()};
}

class ChatResponse {
  final String intent;
  final String toolCalled;
  final String uiType;
  final String message;
  final Map<String, dynamic> data;
  ChatResponse({required this.intent, required this.toolCalled, required this.uiType, required this.message, required this.data});
  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(intent: json['intent'] ?? 'unknown', toolCalled: json['tool_called'] ?? 'none', uiType: json['ui_type'] ?? 'message', message: json['message'] ?? '', data: json['data'] ?? {});
}

class Hotel {
  final String id, name, location, imageUrl;
  final double rating, pricePerNight;
  final int reviews, availableRooms;
  final List<String> amenities;
  Hotel({required this.id, required this.name, required this.location, required this.rating, required this.reviews, required this.pricePerNight, required this.amenities, required this.imageUrl, required this.availableRooms});
  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(id: json['id'] ?? '', name: json['name'] ?? '', location: json['location'] ?? '', rating: (json['rating'] ?? 0).toDouble(), reviews: json['reviews'] ?? 0, pricePerNight: (json['price_per_night'] ?? 0).toDouble(), amenities: List<String>.from(json['amenities'] ?? []), imageUrl: json['image_url'] ?? '', availableRooms: json['available_rooms'] ?? 0);
}

class Flight {
  final String id, airline, flightNumber, origin, destination, departureTime, arrivalTime, duration, flightClass;
  final double price;
  final int stops, availableSeats;
  Flight({required this.id, required this.airline, required this.flightNumber, required this.origin, required this.destination, required this.departureTime, required this.arrivalTime, required this.duration, required this.price, required this.flightClass, required this.stops, required this.availableSeats});
  factory Flight.fromJson(Map<String, dynamic> json) => Flight(id: json['id'] ?? '', airline: json['airline'] ?? '', flightNumber: json['flight_number'] ?? '', origin: json['origin'] ?? '', destination: json['destination'] ?? '', departureTime: json['departure_time'] ?? '', arrivalTime: json['arrival_time'] ?? '', duration: json['duration'] ?? '', price: (json['price'] ?? 0).toDouble(), flightClass: json['class'] ?? 'Economy', stops: json['stops'] ?? 0, availableSeats: json['available_seats'] ?? 0);
}

class OrderTracking {
  final String trackingId, status, estimatedDelivery, currentLocation, orderDate;
  OrderTracking({required this.trackingId, required this.status, required this.estimatedDelivery, required this.currentLocation, required this.orderDate});
  factory OrderTracking.fromJson(Map<String, dynamic> json) => OrderTracking(trackingId: json['tracking_id'] ?? '', status: json['status'] ?? '', estimatedDelivery: json['estimated_delivery'] ?? '', currentLocation: json['current_location'] ?? '', orderDate: json['order_date'] ?? '');
}