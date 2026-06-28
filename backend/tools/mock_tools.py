from typing import Dict, Any

def tracking_tool(tracking_id: str = None) -> Dict[str, Any]:
    return {
        "tracking_id": tracking_id or "ORD-2024-78432",
        "status": "in_transit",
        "estimated_delivery": "2024-06-15",
        "current_location": "Distribution Center, Chicago IL",
        "order_date": "2024-06-08",
        "items": [
            {"name": "Wireless Bluetooth Headphones", "quantity": 1, "price": 79.99},
            {"name": "USB-C Charging Cable", "quantity": 2, "price": 12.99}
        ],
        "shipping_method": "Standard Shipping (5-7 days)",
        "tracking_history": [
            {"date": "2024-06-08 10:30", "status": "Order Placed", "location": "Online"},
            {"date": "2024-06-09 14:20", "status": "Shipped", "location": "Warehouse, CA"},
            {"date": "2024-06-10 09:15", "status": "In Transit", "location": "Distribution Center, Chicago IL"},
        ]
    }

def refund_tool(refund_reason: str = None) -> Dict[str, Any]:
    return {
        "request_id": "REF-2024-15847",
        "status": "processing",
        "reason": refund_reason or "Product not as described",
        "refund_amount": 105.97,
        "processing_time": "5-7 business days",
        "form_fields": [
            {"type": "text", "name": "bank_name", "label": "Bank Name", "required": True},
            {"type": "text", "name": "account_number", "label": "Account Number", "required": True},
            {"type": "text", "name": "routing_number", "label": "Routing Number", "required": True},
        ]
    }

def complaint_tool(topic: str = None) -> Dict[str, Any]:
    return {
        "complaint_id": "CMP-2024-38921",
        "status": "received",
        "acknowledgment": "Thank you for bringing this to our attention. Our customer service team will review your complaint within 24 hours.",
        "ticket_priority": "medium",
        "expected_response": "Within 24-48 hours",
        "form_fields": [
            {"type": "textarea", "name": "additional_details", "label": "Additional Details", "required": False},
        ]
    }

def escalation_tool(escalation_reason: str = None) -> Dict[str, Any]:
    return {
        "escalation_id": "ESC-2024-76234",
        "status": "escalated",
        "message": "Your request has been escalated to our specialized support team. A senior representative will contact you within 2-4 hours.",
        "team": "Senior Support Team",
        "contact_available": "24/7",
        "estimated_wait": "2-4 hours"
    }

def hotel_tool(location: str = None, min_price: float = None, max_price: float = None, sort_by: str = "price") -> Dict[str, Any]:
    all_hotels = [
        {"id": "HTL-001", "name": "Grand Marina Resort", "location": "Dubai, UAE", "rating": 4.7, "reviews": 2341, "price_per_night": 189.00, "amenities": ["Pool", "Spa", "Free WiFi", "Gym", "Restaurant"], "available_rooms": 12},
        {"id": "HTL-002", "name": "Seaside Paradise Hotel", "location": "Dubai, UAE", "rating": 4.5, "reviews": 1876, "price_per_night": 145.00, "amenities": ["Beach Access", "Pool", "Free WiFi", "Bar"], "available_rooms": 8},
        {"id": "HTL-003", "name": "Budget Stay Inn", "location": "Dubai, UAE", "rating": 3.9, "reviews": 543, "price_per_night": 55.00, "amenities": ["Free WiFi", "Parking", "AC"], "available_rooms": 25},
        {"id": "HTL-004", "name": "Luxury Palace Dubai", "location": "Dubai, UAE", "rating": 4.9, "reviews": 3421, "price_per_night": 450.00, "amenities": ["Pool", "Spa", "Free WiFi", "Gym", "Restaurant", "Concierge", "Valet"], "available_rooms": 5},
        {"id": "HTL-005", "name": "City Center Hotel", "location": "Dubai, UAE", "rating": 4.2, "reviews": 1234, "price_per_night": 98.00, "amenities": ["Free WiFi", "Gym", "Business Center"], "available_rooms": 18},
        {"id": "HTL-006", "name": "Desert Oasis Resort", "location": "Dubai, UAE", "rating": 4.6, "reviews": 2109, "price_per_night": 220.00, "amenities": ["Pool", "Spa", "Free WiFi", "Restaurant", "Desert Tours"], "available_rooms": 10},
        {"id": "HTL-101", "name": "Eiffel Tower View Hotel", "location": "Paris, France", "rating": 4.8, "reviews": 3210, "price_per_night": 320.00, "amenities": ["View", "Free WiFi", "Restaurant", "Bar", "Concierge"], "available_rooms": 6},
        {"id": "HTL-102", "name": "Montmartre Boutique Hotel", "location": "Paris, France", "rating": 4.4, "reviews": 1567, "price_per_night": 140.00, "amenities": ["Free WiFi", "Breakfast", "Garden"], "available_rooms": 14},
        {"id": "HTL-201", "name": "Manhattan Luxury Suites", "location": "New York, USA", "rating": 4.7, "reviews": 4521, "price_per_night": 380.00, "amenities": ["Pool", "Gym", "Free WiFi", "Restaurant", "Spa"], "available_rooms": 8},
        {"id": "HTL-202", "name": "Times Square Inn", "location": "New York, USA", "rating": 4.1, "reviews": 2890, "price_per_night": 199.00, "amenities": ["Free WiFi", "Breakfast", "Location"], "available_rooms": 22},
    ]
    filtered = all_hotels
    if location:
        filtered = [h for h in filtered if location.lower() in h["location"].lower()]
    if min_price is not None:
        filtered = [h for h in filtered if h["price_per_night"] >= min_price]
    if max_price is not None:
        filtered = [h for h in filtered if h["price_per_night"] <= max_price]
    if sort_by == "price":
        filtered.sort(key=lambda x: x["price_per_night"])
    elif sort_by == "rating":
        filtered.sort(key=lambda x: x["rating"], reverse=True)
    elif sort_by == "reviews":
        filtered.sort(key=lambda x: x["reviews"], reverse=True)
    return {"location": location or "all destinations", "search_results": len(filtered), "hotels": filtered}

def flight_tool(origin: str = None, destination: str = None, date: str = None) -> Dict[str, Any]:
    all_flights = [
        {"id": "FLT-001", "airline": "Emirates", "flight_number": "EK 203", "origin": "New York (JFK)", "destination": "Dubai (DXB)", "departure_time": "22:00", "arrival_time": "07:30 +1", "duration": "12h 30m", "price": 850.00, "class": "Economy", "stops": 0, "available_seats": 45},
        {"id": "FLT-002", "airline": "Emirates", "flight_number": "EK 201", "origin": "New York (JFK)", "destination": "Dubai (DXB)", "departure_time": "03:00", "arrival_time": "19:30", "duration": "13h 30m", "price": 920.00, "class": "Economy", "stops": 0, "available_seats": 28},
        {"id": "FLT-003", "airline": "Qatar Airways", "flight_number": "QR 702", "origin": "New York (JFK)", "destination": "Dubai (DXB)", "departure_time": "01:15", "arrival_time": "19:45", "duration": "15h 30m", "price": 780.00, "class": "Economy", "stops": 1, "available_seats": 67},
        {"id": "FLT-004", "airline": "Etihad", "flight_number": "EY 100", "origin": "New York (JFK)", "destination": "Dubai (DXB)", "departure_time": "22:30", "arrival_time": "19:00 +1", "duration": "13h 30m", "price": 890.00, "class": "Economy", "stops": 0, "available_seats": 34},
        {"id": "FLT-005", "airline": "British Airways", "flight_number": "BA 178", "origin": "New York (JFK)", "destination": "London (LHR)", "departure_time": "19:00", "arrival_time": "07:00 +1", "duration": "7h 00m", "price": 550.00, "class": "Economy", "stops": 0, "available_seats": 89},
        {"id": "FLT-006", "airline": "Air France", "flight_number": "AF 11", "origin": "New York (JFK)", "destination": "Paris (CDG)", "departure_time": "17:30", "arrival_time": "06:30 +1", "duration": "7h 00m", "price": 620.00, "class": "Economy", "stops": 0, "available_seats": 56},
        {"id": "FLT-007", "airline": "Singapore Airlines", "flight_number": "SQ 25", "origin": "New York (JFK)", "destination": "Singapore (SIN)", "departure_time": "23:45", "arrival_time": "06:45 +2", "duration": "18h 00m", "price": 1200.00, "class": "Economy", "stops": 0, "available_seats": 41},
        {"id": "FLT-008", "airline": "Emirates", "flight_number": "EK 241", "origin": "London (LHR)", "destination": "Dubai (DXB)", "departure_time": "10:00", "arrival_time": "19:30", "duration": "6h 30m", "price": 450.00, "class": "Economy", "stops": 0, "available_seats": 120},
    ]
    filtered = all_flights
    if origin:
        filtered = [f for f in filtered if origin.lower() in f["origin"].lower()]
    if destination:
        filtered = [f for f in filtered if destination.lower() in f["destination"].lower()]
    filtered.sort(key=lambda x: x["price"])
    return {"origin": origin or "all origins", "destination": destination or "all destinations", "date": date or "any date", "search_results": len(filtered), "flights": filtered}

TOOLS = {
    "order_tracking": tracking_tool,
    "refund_request": refund_tool,
    "complaint": complaint_tool,
    "escalation": escalation_tool,
    "hotel_search": hotel_tool,
    "flight_search": flight_tool,
}

def execute_tool(tool_name: str, **kwargs) -> Dict[str, Any]:
    tool_func = TOOLS.get(tool_name)
    if not tool_func:
        return {"error": f"Unknown tool: {tool_name}"}
    try:
        return tool_func(**kwargs)
    except Exception as e:
        return {"error": str(e)}