import json
import logging
import requests

logger = logging.getLogger(__name__)

OLLAMA_BASE_URL = "http://localhost:11434"
MODEL_NAME = "qwen2.5-coder:7b"

class OllamaService:
    def __init__(self, base_url: str = OLLAMA_BASE_URL, model: str = MODEL_NAME):
        self.base_url = base_url
        self.model = model
        self.conversation_memory = []
        self.max_memory = 10

    def is_available(self) -> bool:
        try:
            response = requests.get(f"{self.base_url}/api/tags", timeout=5)
            return response.status_code == 200
        except:
            return False

    def _build_system_prompt(self) -> str:
        return """You are a customer support assistant. Your task is to:
1. Understand the user's message and classify their intent
2. Extract any relevant parameters for tool execution
3. Return your analysis as structured JSON

## Available Intents:
- order_tracking: Track an order/delivery. Extract tracking ID if provided.
- refund_request: Request a refund. Extract reason if provided.
- complaint: File a complaint. Extract topic if mentioned.
- escalation: Escalate an issue. Extract reason if provided.
- hotel_search: Search for hotels. Extract location, price range if mentioned.
- flight_search: Search for flights. Extract origin, destination, date if mentioned.
- greeting: Saying hello or just chatting

## Follow-up Detection:
If the message refers to previous context (like "show cheaper ones", "anything else", "the hotels from before"),
recognize it as a follow-up and maintain the previous intent.

## Important Rules:
- ALWAYS respond with valid JSON only (no markdown, no explanation)
- Include extracted parameters in the 'parameters' object
- If unclear, use 'unknown'

## Output Format:
{"intent": "intent_name", "is_follow_up": false, "parameters": {"key": "value"}, "response_text": "A friendly response"}"""

    def _build_context_prompt(self, conversation_history, current_message: str) -> str:
        context = ""
        if conversation_history:
            context += "## Recent Conversation:\n"
            for msg in conversation_history[-5:]:
                role = msg.get("role", "user")
                content = msg.get("content", "")
                context += f"{'User' if role == 'user' else 'Assistant'}: {content}\n"
        context += f"\n## Current Message:\nUser: {current_message}\n"
        return context

    def classify_intent(self, message: str, conversation_history=None):
        if conversation_history is None:
            conversation_history = []

        system_prompt = self._build_system_prompt()
        context_prompt = self._build_context_prompt(conversation_history, message)
        full_prompt = f"{system_prompt}\n\n{context_prompt}\n\nAnalyze the user's intent and respond with JSON:"

        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={"model": self.model, "prompt": full_prompt, "stream": False, "options": {"temperature": 0.1, "num_predict": 300}},
                timeout=60
            )

            if response.status_code == 200:
                result = response.json()
                llm_output = result.get("response", "{}")

                try:
                    if "```json" in llm_output:
                        llm_output = llm_output.split("```json")[1].split("```")[0]
                    elif "```" in llm_output:
                        llm_output = llm_output.split("```")[1].split("```")[0]
                    parsed = json.loads(llm_output.strip())
                    intent = parsed.get("intent", "unknown")
                    parameters = parsed.get("parameters", {})
                    response_text = parsed.get("response_text", "I'm here to help!")
                    return intent, parameters, response_text
                except json.JSONDecodeError as e:
                    logger.error(f"Failed to parse LLM response: {e}")
                    return "unknown", {}, "I'm sorry, I couldn't process that. Could you rephrase?"
            else:
                return "error", {}, "I'm having trouble connecting to the AI service."
        except requests.exceptions.Timeout:
            return "error", {}, "The request took too long."
        except requests.exceptions.ConnectionError:
            return "error", {}, "Could not connect to the AI service."
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            return "error", {}, "An unexpected error occurred."

    def update_memory(self, role: str, content: str):
        self.conversation_memory.append({"role": role, "content": content})
        if len(self.conversation_memory) > self.max_memory:
            self.conversation_memory = self.conversation_memory[-self.max_memory:]

    def clear_memory(self):
        self.conversation_memory = []

ollama_service = OllamaService()