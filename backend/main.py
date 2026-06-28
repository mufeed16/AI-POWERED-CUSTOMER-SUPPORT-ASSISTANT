import logging
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from .models.schemas import ChatRequest, ChatResponse, Message
from .services.chat_service import chat_service

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

app = FastAPI(title="Customer Support Assistant API", description="Customer support with local Ollama LLM", version="1.0.0")

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

@app.get("/")
async def root():
    return {"status": "healthy", "service": "Customer Support Assistant API", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    from .services.ollama_service import ollama_service
    ollama_status = "connected" if ollama_service.is_available() else "disconnected"
    return {"status": "healthy", "ollama": ollama_status, "model": ollama_service.model}

@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    try:
        logger.info(f"Received chat request: {request.message[:100]}...")
        history_dicts = [{"role": msg.role, "content": msg.content, "ui_type": msg.ui_type, "data": msg.data} for msg in request.conversation_history]
        result = chat_service.process_message(request.message, history_dicts)
        logger.info(f"Response intent: {result['intent']}, ui_type: {result['ui_type']}")
        return ChatResponse(intent=result["intent"], tool_called=result["tool_called"], ui_type=result["ui_type"], message=result["message"], data=result["data"])
    except Exception as e:
        logger.error(f"Error processing chat request: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(status_code=500, content={"error": "Internal server error", "detail": str(exc)})