from typing import List, Dict, Any
from models.schemas import Message

class MemoryService:
    def __init__(self, max_turns: int = 5):
        self.max_turns = max_turns
        self.conversations: Dict[str, List[Message]] = {}

    def add_message(self, session_id: str, role: str, content: str, ui_type: str = None, data: Dict[str, Any] = None):
        if session_id not in self.conversations:
            self.conversations[session_id] = []
        message = Message(role=role, content=content, ui_type=ui_type, data=data)
        self.conversations[session_id].append(message)
        if len(self.conversations[session_id]) > self.max_turns:
            self.conversations[session_id] = self.conversations[session_id][-self.max_turns:]

    def get_history(self, session_id: str) -> List[Message]:
        return self.conversations.get(session_id, [])

    def get_context_summary(self, session_id: str) -> str:
        history = self.get_history(session_id)
        if not history:
            return "No previous conversation."
        context_lines = []
        for msg in history[-3:]:
            role_label = "User" if msg.role == "user" else "Assistant"
            context_lines.append(f"{role_label}: {msg.content}")
        return "\n".join(context_lines)

    def clear_session(self, session_id: str):
        if session_id in self.conversations:
            del self.conversations[session_id]

memory_service = MemoryService()