from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional

class Message(BaseModel):
    role: str
    content: str
    ui_type: Optional[str] = None
    data: Optional[Dict[str, Any]] = None

class ChatRequest(BaseModel):
    message: str
    conversation_history: List[Message] = []

class ToolData(BaseModel):
    items: Optional[List[Dict[str, Any]]] = None
    tracking_id: Optional[str] = None
    status: Optional[str] = None
    message: Optional[str] = None
    form_fields: Optional[List[Dict[str, str]]] = None

class ChatResponse(BaseModel):
    intent: str
    tool_called: str
    ui_type: str
    message: str
    data: Dict[str, Any] = {}

class ErrorResponse(BaseModel):
    error: str
    detail: Optional[str] = None