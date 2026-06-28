import logging
from typing import Dict, Any, List
from .ollama_service import ollama_service
from ..tools.mock_tools import execute_tool

logger = logging.getLogger(__name__)

class ChatService:
    INTENT_TO_TOOL = {
        "order_tracking": "order_tracking",
        "refund_request": "refund_request",
        "complaint": "complaint",
        "escalation": "escalation",
        "hotel_search": "hotel_search",
        "flight_search": "flight_search",
    }

    INTENT_TO_UI_TYPE = {
        "order_tracking": "tracking_page",
        "refund_request": "refund_page",
        "complaint": "complaint_page",
        "escalation": "escalation_page",
        "hotel_search": "hotel_page",
        "flight_search": "flight_page",
        "greeting": "message",
        "unknown": "message",
        "error": "message",
    }

    def __init__(self):
        self.ollama = ollama_service

    def process_message(self, message: str, conversation_history: List[Dict[str, Any]] = None) -> Dict[str, Any]:
        if conversation_history is None:
            conversation_history = []

        logger.info(f"Processing message: {message}")
        intent, parameters, response_text = self.ollama.classify_intent(message, conversation_history)
        logger.info(f"Classified intent: {intent}, parameters: {parameters}")

        tool_data = {}
        final_message = response_text
        tool_called = "none"

        if intent in self.INTENT_TO_TOOL:
            tool_name = self.INTENT_TO_TOOL[intent]
            tool_called = tool_name
            tool_data = execute_tool(tool_name, **parameters)
            final_message = self._build_response_text(intent, parameters, tool_data)
        elif intent == "greeting":
            final_message = "Hello! I'm your customer support assistant. I can help you with:\n• Tracking orders\n• Requesting refunds\n• Filing complaints\n• Hotel searches\n• Flight searches\n\nWhat can I help you with today?"
        elif intent == "unknown":
            final_message = "I'm not sure I understood that. Could you please rephrase? I can help with:\n• Order tracking (e.g., 'track my order')\n• Refunds (e.g., 'I need a refund')\n• Complaints (e.g., 'I want to file a complaint')\n• Hotel search (e.g., 'show hotels in Dubai')\n• Flight search (e.g., 'find flights to Dubai')"

        ui_type = self.INTENT_TO_UI_TYPE.get(intent, "message")
        return {"intent": intent, "tool_called": tool_called, "ui_type": ui_type, "message": final_message, "data": tool_data}

    def _build_response_text(self, intent: str, parameters: Dict[str, Any], tool_data: Dict[str, Any]) -> str:
        if intent == "order_tracking":
            tracking_id = parameters.get("tracking_id") or tool_data.get("tracking_id", "your order")
            return f"I found your order {tracking_id}. It is currently {tool_data.get('status', 'being processed')} and expected to arrive by {tool_data.get('estimated_delivery', 'soon')}."
        elif intent == "refund_request":
            return f"I've initiated a refund request for you. Request ID: {tool_data.get('request_id')}. Amount: ${tool_data.get('refund_amount', 0):.2f}. Processing time: {tool_data.get('processing_time', '5-7 business days')}."
        elif intent == "complaint":
            return f"Thank you for your feedback. Your complaint has been registered with ID: {tool_data.get('complaint_id')}. {tool_data.get('acknowledgment', '')}"
        elif intent == "escalation":
            return tool_data.get("message", "Your request has been escalated. A senior representative will contact you soon.")
        elif intent == "hotel_search":
            location = parameters.get("location", "your destination")
            count = tool_data.get("search_results", 0)
            return f"I found {count} hotel(s) in {location}. Showing results sorted by price."
        elif intent == "flight_search":
            destination = parameters.get("destination", "your destination")
            count = tool_data.get("search_results", 0)
            return f"I found {count} flight(s) to {destination}. Showing available options."
        return "I've processed your request. Is there anything else I can help with?"

chat_service = ChatService()