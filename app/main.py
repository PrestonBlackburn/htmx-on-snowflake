from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
templates = Jinja2Templates(directory="app/templates")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Update with your frontend's origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# static files
app.mount("/static", StaticFiles(directory="app/static"), name="static")

@app.get("/", response_class=HTMLResponse)
async def root(request: Request):
    context = {"request": request, "title": "HTMX Snowflake App"}
    response = templates.TemplateResponse("pages/index.html", context)
    return response


@app.post("/chat", response_class=HTMLResponse)
async def chat(request: Request, message: str = Form(...)):
    # example chat response
    user_context = {"message": message}
    user_input = templates.get_template(
        "htmx/user_message_fragment.html"
    ).render(user_context)

    response_context = {"cortex_response": f"echo: {message}"}
    cortex_response = templates.get_template(
        "htmx/cortex_message_fragment.html"
    ).render(response_context)

    html_response = HTMLResponse(user_input + cortex_response)
    
    return html_response


@app.get("/health")
async def health_check():
    return {"status": "ok"}