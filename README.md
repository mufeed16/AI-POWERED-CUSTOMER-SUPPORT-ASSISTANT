# Customer Support Assistant

A customer support assistant using Python (FastAPI), Ollama (local LLM), and Flutter.

## Prerequisites

1. **Ollama** - Install from ollama.ai
   ```bash
   ollama pull qwen2.5-coder:7b
   ollama serve
   ```

2. **Python 3.9+** with pip

3. **Flutter SDK 3.0+**

## Setup

### Backend

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Flutter App

```bash
cd ai_frontend
flutter pub get
flutter run
```

For Android emulator, the app connects to `http://10.0.2.2:8000`.
For iOS simulator, use `http://localhost:8000`.
For physical devices, use your computer's IP address.

## API Reference

### POST /chat

**Request:**
```json
{
  "message": "Show hotels in Dubai",
  "conversation_history": []
}
```

**Response:**
```json
{
  "intent": "hotel_search",
  "tool_called": "hotel_tool",
  "ui_type": "hotel_page",
  "message": "Found 3 hotel(s) in Dubai",
  "data": {
    "hotels": [
      {
        "id": "HTL-001",
        "name": "Grand Marina Resort",
        "location": "Dubai, UAE",
        "rating": 4.7,
        "reviews": 2341,
        "price_per_night": 189.00,
        "amenities": ["Pool", "Spa", "Free WiFi", "Gym", "Restaurant"],
        "available_rooms": 12
      }
    ]
  }
}
```

### GET /health

```json
{"status": "healthy", "ollama": "connected", "model": "qwen2.5-coder:7b"}
```

## Supported Intents

| Intent | UI Type | Tool |
|--------|---------|------|
| `order_tracking` | `tracking_page` | `tracking_tool` |
| `refund_request` | `refund_page` | `refund_tool` |
| `complaint` | `complaint_page` | `complaint_tool` |
| `escalation` | `escalation_page` | `escalation_tool` |
| `hotel_search` | `hotel_page` | `hotel_tool` |
| `flight_search` | `flight_page` | `flight_tool` |
| `greeting` | `message` | none |

## Project Structure

```
backend/
├── main.py              # FastAPI entry point
├── requirements.txt     # Dependencies
├── models/
│   └── schemas.py       # Pydantic models
├── services/
│   ├── chat_service.py  # Main logic + intent classification
│   └── ollama_service.py # LLM interaction
└── tools/
    └── mock_tools.py    # Mock tool implementations

ai_frontend/
├── lib/
│   ├── main.dart        # App entry point
│   ├── models/
│   │   └── models.dart   # Data models
│   ├── providers/
│   │   └── chat_provider.dart # State management
│   ├── screens/
│   │   └── chat_screen.dart  # Chat UI
│   ├── services/
│   │   └── api_service.dart  # HTTP client
│   └── widgets/
│       ├── hotel_widget.dart   # Hotel list
│       ├── flight_widget.dart  # Flight list
│       ├── tracking_widget.dart # Order tracking
│       └── message_widget.dart # Generic message
└── pubspec.yaml
```